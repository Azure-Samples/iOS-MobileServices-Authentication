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

@interface AuthService : NSObject

+(AuthService*) getInstance;

@property (nonatomic, strong)   MSClient *client;

- (void) getAuthDataOnSuccess:(CompletionWithStringBlock) completion;

- (void) registerAccount:(NSDictionary *) item
      completion:(CompletionWithStringBlock) completion;

- (void) loginAccount:(NSDictionary *) item
              completion:(CompletionWithStringBlock) completion;

@end
