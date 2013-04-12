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


- (void)didReceiveMemoryWarning {
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
