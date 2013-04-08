//
//  AuthService.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/1/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "AuthService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "KeychainItemWrapper.h"

#pragma mark * Private interace


@interface AuthService()

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic, strong)   MSTable *accountsTable;
@property (nonatomic)           BOOL shouldRetryAuth;
@property (nonatomic, strong)   NSString *keychainName;

@end


@implementation AuthService

static AuthService *singletonInstance;

+ (AuthService*)getInstance{
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(AuthService *) init
{
    self = [super init];
    if (self) {
        // Initialize the Mobile Service client with your URL and key
        self.client = [MSClient clientWithApplicationURLString:@"https://myauthdemo.azure-mobile.net/"
                                                    withApplicationKey:@"HZatbbcDTUXflXkUFIlkcqeFxPMppl54"];

        self.client = [self.client clientwithFilter:self];

        self.keychainName = @"keychain";
        [self loadAuthInfo];
        
        // Create an MSTable instance to allow us to work with the TodoItem table
        self.table = [_client getTable:@"AuthData"];
        self.accountsTable = [_client getTable:@"Accounts"];

    }
    
    return self;
}

- (void) getAuthDataOnSuccess:(CompletionWithStringBlock) completion {
    [self.table readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        [self logErrorIfNotNil:error];
        //NSLog(items);
        
        NSString *user = [NSString stringWithFormat:@"username: %@", [[items objectAtIndex:0] objectForKey:@"UserName"]];
        completion(user);
    }];
}

- (void) registerAccount:(NSDictionary *) item
              completion:(CompletionWithStringBlock) completion {
    [self.accountsTable insert:item completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        if (error) {
            completion([error localizedDescription]);
            return;
        } else {
            MSUser *user = [[MSUser alloc] initWithUserId:[item valueForKey:@"userId"]];
            user.mobileServiceAuthenticationToken = [item valueForKey:@"token"];
            self.client.currentUser = user;
            completion(@"SUCCESS");
        }
    }];
}

- (void) loginAccount:(NSDictionary *) item
              completion:(CompletionWithStringBlock) completion {
    NSDictionary *params = @{ @"login" : @"true"};
    
    
    [self.accountsTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        if (error) {
            completion([error localizedDescription]);
            return;
        } else {
            //TODO: store login info to keychain / shared prefs
            
            MSUser *user = [[MSUser alloc] initWithUserId:[item valueForKey:@"userId"]];
            user.mobileServiceAuthenticationToken = [item valueForKey:@"token"];
            self.client.currentUser = user;
            [self saveAuthInfo];
            completion(@"SUCCESS");
        }
    }];
}
- (void) testForced401:(BOOL)shouldRetry withCompletion:(CompletionWithStringBlock) completion {
    
    MSTable *badAuthTable = [_client getTable:@"BadAuth"];
    NSDictionary *item = @{ @"data" : @"data"};

    self.shouldRetryAuth = shouldRetry;
    
    [badAuthTable insert:item completion:^(NSDictionary *item, NSError *error) {

        [self logErrorIfNotNil:error];
        
        completion(@"Retried auth success");
    }];
    
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}



- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse
{
    // Increment the busy counter before sending the request
    //[self busy:YES];
    onNext(request, ^(NSHTTPURLResponse *response, NSData *data, NSError *error){
        [self filterResponse:response
                     forData:data
                   withError:error
                  forRequest:request
                      onNext:onNext
                  onResponse:onResponse];
    });
}

- (void) filterResponse: (NSHTTPURLResponse *) response
                forData: (NSData *) data
              withError: (NSError *) error
             forRequest:(NSURLRequest *) request
                 onNext:(MSFilterNextBlock) onNext
             onResponse: (MSFilterResponseBlock) onResponse
{
    if (response.statusCode == 401) {
        
        //we're forcing custom auth to relogin from the root for now
        if (self.shouldRetryAuth && ![self.authProvider isEqualToString:@"Custom"]) {
            // do login
            [self.client loginWithProvider:self.authProvider onController:[[[[UIApplication sharedApplication] delegate] window] rootViewController] animated:YES completion:^(MSUser *user, NSError *error) {
                if (error && error.code == -9001) {
                    // user cancelled authentication - return the original response
                    //[self busy:NO];
                    //onResponse(response, data, error);
                    //Log them out here too
                    [self triggerLogout];
                    return;
                }
                //TODO: Store their login information to Keychain / prefs again
                [self saveAuthInfo];
                NSMutableURLRequest *newRequest = [request mutableCopy];
                [newRequest setValue:self.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
                newRequest = [self addQueryStringParamToRequest:newRequest];
                //[newRequest setURL:[newRequest URL]]
                onNext(newRequest, ^(NSHTTPURLResponse *innerResponse, NSData *innerData, NSError *innerError){
                    [self filterResponse:innerResponse
                                 forData:innerData
                               withError:innerError
                              forRequest:request
                                  onNext:onNext
                              onResponse:onResponse];
                });
            }];
        } else {
            //This fetches the current view controller and executes the
            //logout segue 
            [self triggerLogout];
            //What's interesting here is that even if we're currently in a modal (Deep Modal) this will fetch the top most VC from the NAV (in this demo that would be the loggedInVC) and execute it's logoutSegue.  This still works even though the modal is showing
        }
    }
    else {
        //[self busy:NO];
        onResponse(response, data, error);
    }
}

-(void)triggerLogout {
    [self killAuthInfo];
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *navVC = (UINavigationController *)rootVC;
    UIViewController *topVC = navVC.topViewController;
    [topVC performSegueWithIdentifier:@"logoutSegue" sender:self];
}

-(NSMutableURLRequest *)addQueryStringParamToRequest:(NSMutableURLRequest *)request {
    
    NSMutableString *absoluteURLString = [[[request URL] absoluteString] mutableCopy];
    NSString *newQuery = @"?bypass=true";
    [absoluteURLString appendString:newQuery];
    [request setURL:[NSURL URLWithString:absoluteURLString]];    
    return request;
}

- (void)saveAuthInfo {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:self.keychainName accessGroup:nil];

    [keychain setObject:self.client.currentUser.userId forKey:(__bridge id)kSecAttrService];
//        [keychain setObject:self.client.currentUser.userId forKey:(__bridge id)@"userid"];
    [keychain setObject:self.client.currentUser.mobileServiceAuthenticationToken forKey:(__bridge id)kSecAttrAccount];
}

- (void)loadAuthInfo {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:self.keychainName accessGroup:nil];
    
    if ([keychain objectForKey:(__bridge id)kSecAttrService]) {
        self.client.currentUser = [[MSUser alloc] initWithUserId:[keychain objectForKey:(__bridge id)kSecAttrService]];
        self.client.currentUser.mobileServiceAuthenticationToken = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    }
}

- (void)killAuthInfo {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:self.keychainName accessGroup:nil];
    [keychain resetKeychainItem];
}

@end
