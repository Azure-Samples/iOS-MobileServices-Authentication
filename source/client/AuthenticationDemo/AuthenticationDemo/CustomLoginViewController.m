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
