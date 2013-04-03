//
//  RegisterAccountViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/2/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "RegisterAccountViewController.h"
#import "AuthService.h"

@interface RegisterAccountViewController ()
@property (strong, nonatomic) AuthService *authService;

@end

@implementation RegisterAccountViewController

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

- (IBAction)tappedRegister:(id)sender {
    if ([self.txtUsername.text isEqualToString:@""] || [self.txtEmail.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""]) {
        self.lblInfo.text = @"You must enter all fields.";
        return;
    } else if (![self.txtPassword.text isEqualToString:self.txtConfirm.text]) {
        self.lblInfo.text = @"The passwords you've entered do not match.";
        return;
    }
    self.lblInfo.text = @"";
    NSDictionary *item = @{ @"username" : self.txtUsername.text,
                            @"password" : self.txtPassword.text,
                            @"email" : self.txtEmail.text };
    
    [self.authService registerAccount:item completion:^(NSString *string) {
        if ([string isEqualToString:@"SUCCESS"]) {
            [self performSegueWithIdentifier:@"customAuthSegue" sender:self];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.lblInfo.text = string;            
        }

    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}
@end
