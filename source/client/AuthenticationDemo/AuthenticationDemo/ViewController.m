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

#import "ViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AuthService.h"

@interface ViewController ()

@property (strong, nonatomic) AuthService *authService;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.authService = [AuthService getInstance];
    
    if (self.authService.client.currentUser.userId) {
        [self performSegueWithIdentifier:@"loggedInSegue" sender:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginWithProvider:(NSString *)provider
{
    //Save the provider in case we need to reauthorize them
    self.authService.authProvider = provider;
    MSLoginController *controller =
    [self.authService.client
     loginViewControllerWithProvider:provider
     completion:^(MSUser *user, NSError *error) {         
         if (error) {
             NSLog(@"Authentication Error: %@", error);
             // Note that error.code == -1503 indicates
             // that the user cancelled the dialog
         } else {
             [self.authService saveAuthInfo];
             [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
         }
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)tappedFacebook:(id)sender {
    [self loginWithProvider:@"facebook"];
}

- (IBAction)tappedGoogle:(id)sender {
    [self loginWithProvider:@"google"];
}

- (IBAction)tappedMicrosoft:(id)sender {
    [self loginWithProvider:@"microsoftaccount"];
}

- (IBAction)tappedTwitter:(id)sender {
    [self loginWithProvider:@"twitter"];    
}

-(IBAction)logout:(UIStoryboardSegue *)segue {
    [self.authService killAuthInfo];
    [self.authService.client logout];
}
@end
