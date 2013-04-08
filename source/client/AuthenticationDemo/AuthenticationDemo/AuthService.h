//
//  AuthService.h
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/1/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

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

- (void) registerAccount:(NSDictionary *) item
      completion:(CompletionWithStringBlock) completion;

- (void) loginAccount:(NSDictionary *) item
              completion:(CompletionWithStringBlock) completion;

- (void) testForced401:(BOOL)shouldRetry withCompletion:(CompletionWithStringBlock) completion;

- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse;

- (void)saveAuthInfo;

- (void)loadAuthInfo;

- (void)killAuthInfo;

@end
