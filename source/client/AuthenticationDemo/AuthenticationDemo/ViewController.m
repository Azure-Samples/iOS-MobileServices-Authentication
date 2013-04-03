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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginWithProvider:(NSString *)provider
{
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

- (void)logout {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)reset:(UIStoryboardSegue *)segue {
    
}
@end
