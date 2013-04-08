//
//  CustomLoginViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/2/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "CustomLoginViewController.h"
#import "AuthService.h"

@interface CustomLoginViewController ()
@property (strong, nonatomic) AuthService *authService;
@end

@implementation CustomLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedLogin:(id)sender {
    NSDictionary *item = @{ @"username" : self.txtUsername.text,
                            @"password" : self.txtPassword.text
                            };
    
    [self.authService loginAccount:item completion:^(NSString *string) {
        if ([string isEqualToString:@"SUCCESS"]) {

            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"customAuthSegue" sender:self];            
        } else {
            self.lblInfo.text = string;
        }
        
    }];
}

- (IBAction)tappedRegister:(id)sender {
}

- (IBAction)tappedForgotUsernamePassword:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return self.parentViewController;
}

@end
