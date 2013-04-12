
function read(query, user, request) {
    var result = {
        id: query.id,
        identities: user.getIdentities(),
        userName: ''
    };
    
   var sep = user.userId.indexOf(':');
   var provider = user.userId.substring(0, sep).toLowerCase();
   if (provider == 'custom') {
       var userId = user.userId.substring(sep + 1);
       var accounts = tables.getTable('accounts');
       accounts.where({ id : userId }).read({
           success: function(results) {
               var account = results[0];
               result.UserName = account.username;
               request.respond(200, [result]);
               return;
           }
       });
       return;
   }
    var url;
    var identities = user.getIdentities();
    if (identities.google) {
        var googleAccessToken = identities.google.accessToken;
        url = 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=' + googleAccessToken;
    } else if (identities.facebook) {
        var fbAccessToken = identities.facebook.accessToken;
        url = 'https://graph.facebook.com/me?access_token=' + fbAccessToken;
    } else if (identities.microsoft) {
        var liveAccessToken = identities.microsoft.accessToken;
        url = 'https://apis.live.net/v5.0/me/?method=GET&access_token=' + liveAccessToken;
    } else if (identities.twitter) {
        var userId = user.userId;
        var twitterId = userId.substring(userId.indexOf(':') + 1);
        url = 'https://api.twitter.com/1/users/show/' + twitterId + '.json';
    }

     if (url) {
        var requestCallback = function (err, resp, body) {
            if (err || resp.statusCode !== 200) {
                console.error('Error sending data to the provider: ', err);
                request.respond(statusCodes.INTERNAL_SERVER_ERROR, body);
            } else {
                try {
                    var userData = JSON.parse(body);
                    if (userData.name != null)
                        result.UserName = userData.name;
                    else
                        result.UserName = "can't get username";
                    request.respond(200, [result]);
                } catch (ex) {
                    console.error('Error parsing response from the provider API: ', ex);
                    request.respond(statusCodes.INTERNAL_SERVER_ERROR, ex);
                }
            }
        }
        var req = require('request');
        var reqOptions = {
            uri: url,
            headers: { Accept: "application/json" }
        };
        req(reqOptions, requestCallback);
    } else {
        // Insert with default user name
        request.execute();
    }
}