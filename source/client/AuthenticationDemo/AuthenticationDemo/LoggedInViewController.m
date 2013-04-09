//
//  LoggedInViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/1/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "LoggedInViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AuthService.h"

@interface LoggedInViewController ()

@property (strong, nonatomic) AuthService *authService;

@end

@implementation LoggedInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.authService = [AuthService getInstance];
    
    self.lblUserId.text = self.authService.client.currentUser.userId;
    
    [self.authService getAuthDataOnSuccess:^(NSString *string) {
        self.lblInfo.text = string;
    }];
}

//-(void)viewDidAppear:(BOOL)animated {
//    //Overriding this method becuase otherwise the viewDidAppear is being
//    //called on the ViewController class for some reason
//}


- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapped401NoRetry:(id)sender {
    [self.authService testForced401:NO withCompletion:^(NSString *string) {
        self.lblInfo.text = @"This should never happen";
    }];
}

- (IBAction)tapped401Retry:(id)sender {
    [self.authService testForced401:YES withCompletion:^(NSString *string) {
        self.lblInfo.text = string;
    }];
}
@end
