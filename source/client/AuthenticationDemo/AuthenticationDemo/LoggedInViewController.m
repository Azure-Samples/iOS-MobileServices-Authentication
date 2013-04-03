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

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedLogout:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    UIViewController *root = [nav.viewControllers objectAtIndex:0];
    [root performSelector:@selector(logout) withObject:nil afterDelay:0.1];
}
@end
