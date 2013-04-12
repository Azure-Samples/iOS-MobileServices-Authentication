/*
 Copyright 2013 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#pragma mark * Block Definitions


typedef void (^CompletionBlock) ();
typedef void (^CompletionWithStringBlock) (NSString *string);
typedef void (^CompletionWithIndexBlock) (NSUInteger index);

@interface AuthService : NSObject <MSFilter>

+(AuthService*) getInstance;

@property (nonatomic, strong)   NSString *authProvider;
@property (nonatomic, strong)   MSClient *client;

- (void) getAuthDataOnSuccess:(CompletionWithStringBlock) completion;

/**
 * Handles registering a custom auth account
 */
- (void) registerAccount:(NSDictionary *) item
      completion:(CompletionWithStringBlock) completion;

/**
 * Logins in a user using their custom auth account
 */
- (void) loginAccount:(NSDictionary *) item
              completion:(CompletionWithStringBlock) completion;

/**
 * Calls a server side method that will by deftault return a 401
 * The retry parameter indicates if we should retry it after making the user
 * relogin.
 */
- (void) testForced401:(BOOL)shouldRetry withCompletion:(CompletionWithStringBlock) completion;

- (void)saveAuthInfo;

- (void)loadAuthInfo;

- (void)killAuthInfo;

- (void) handleRequest:(NSURLRequest *)request
                  next:(MSFilterNextBlock)onNext
              response:(MSFilterResponseBlock)onResponse;

@end
