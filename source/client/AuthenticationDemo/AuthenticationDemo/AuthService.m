//
//  AuthService.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/1/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "AuthService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#pragma mark * Private interace


@interface AuthService()

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic, strong)   MSTable *accountsTable;

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
            MSUser *user = [[MSUser alloc] initWithUserId:[item valueForKey:@"userId"]];
            user.mobileServiceAuthenticationToken = [item valueForKey:@"token"];
            self.client.currentUser = user;
            completion(@"SUCCESS");
        }
    }];
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}


@end
