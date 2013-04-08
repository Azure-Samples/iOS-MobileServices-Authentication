//
//  ViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 3/29/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

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
    
//    if (self.authService.client.currentUser.userId) {
//        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
//    }
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"VC:Viewdidappear");
    if (self.authService.client.currentUser.userId) {
//        [self performSelector:@selector(moveOn) withObject:self afterDelay:0.1];
        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    }
}

-(void)moveOn {
        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];    
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
    UINavigationController *controller =
    [self.authService.client
     loginViewControllerWithProvider:provider
     completion:^(MSUser *user, NSError *error) {
         
         
         if (error) {
             NSLog(@"Authentication Error: %@", error);
             // Note that error.code == -1503 indicates
             // that the user cancelled the dialog
         } else {
             // No error, so load the data
//             [self.todoService refreshDataOnSuccess:^{
//                 [self.tableView reloadData];
//             }];
             //Todo: store login info to keychain / prfs
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
    for (NSHTTPCookie *value in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:value];
    }
}
@end
