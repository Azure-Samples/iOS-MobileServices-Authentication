var crypto = require('crypto');
var iterations = 1000;
var bytes = 32;
var aud = "Custom";
var masterKey = "YourMobileServiceMasterKey";
 
function insert(item, user, request) {
	var accounts = tables.getTable('accounts');
	if (request.parameters.login) {
		// this is a login attempt
		accounts.where({ username : item.username }).read({
			success: function(results) {
				if (results.length === 0) {
					request.respond(401, "Incorrect username or password");
				}
				else {
					var account = results[0];
					hash(item.password, account.salt, function(err, h) {
						var incoming = h;
						if (slowEquals(incoming, account.password)) {
							var expiry = new Date().setUTCDate(new Date().getUTCDate() + 30);
							var userId = aud + ":" + account.id;
							request.respond(200, {
								userId: userId,
								token: zumoJwt(expiry, aud, userId, masterKey) 
							});
						}
						else {
							request.respond(401, "Incorrect username or password");
						}
					});
				}
			}
		});
	}
	else {
		// account creation - check username does not already exist
        if (!item.username.match(/^[a-zA-Z0-9]{5,}$/)) {
            request.respond(400, "Invalid username (at least 4 chars, alphanumeric only)");
            return;
        }
        else if (item.password.length < 7) {
            request.respond(400, "Invalid password (least 7 chars required)");
            return;
        }
		accounts.where({ username : item.username}).read({
			success: function(results) {
				if (results.length > 0) {
					request.respond(400, "Username already exists");
					return;
				}
				else {
					// Add your own validation - what fields do you require to 
					// add a unique salt to the item
					item.salt = new Buffer(crypto.randomBytes(bytes)).toString('base64');
					// hash the password
					hash(item.password, item.salt, function(err, h) {
						item.password = h;
						request.execute({
							success: function () {
								// We don't want the salt or the password going back to the client
								delete item.password;
								delete item.salt;
                                var userId = aud + ":" + item.id;
                                item.userId = userId;
                                var expiry = new Date().setUTCDate(new Date().getUTCDate() + 30);
                                item.token = zumoJwt(expiry, aud, userId, masterKey);
//                                item.user: { userId : userId };
//								item.token: zumoJwt(expiry, aud, userId, masterKey); 
								request.respond();
							}
						});
					});
				}
			}
		});
	}
}
 
function hash(text, salt, callback) {
	crypto.pbkdf2(text, salt, iterations, bytes, function(err, derivedKey){
		if (err) { callback(err); }
		else {
			var h = new Buffer(derivedKey).toString('base64');
			callback(null, h);
		}
	});
}
 
function slowEquals(a, b) {
	var diff = a.length ^ b.length;
    for (var i = 0; i < a.length && i < b.length; i++) {
        diff |= (a[i] ^ b[i]);
	}
    return diff === 0;
}
 
function zumoJwt(expiryDate, aud, userId, masterKey) {
 
	var crypto = require('crypto');
 
	function base64(input) {
		return new Buffer(input, 'utf8').toString('base64');
	}
 
	function urlFriendly(b64) {
		return b64.replace(/\+/g, '-').replace(/\//g, '_').replace(new RegExp("=", "g"), '');
	}
 
	function signature(input) {
		var key = crypto.createHash('sha256').update(masterKey + "JWTSig").digest('binary');
		var str = crypto.createHmac('sha256', key).update(input).digest('base64');
		return urlFriendly(str);
	}
 
	var s1 = '{"alg":"HS256","typ":"JWT","kid":0}';
	var j2 = {
		"exp":expiryDate.valueOf() / 1000,
		"iss":"urn:microsoft:windows-azure:zumo",
		"ver":1,
		"aud":aud,
		"uid":userId 
	};
	var s2 = JSON.stringify(j2);
	var b1 = urlFriendly(base64(s1));
	var b2 = urlFriendly(base64(s2));
	var b3 = signature(b1 + "." + b2);
	return [b1,b2,b3].join(".");
}