//
//  DeepModalViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/3/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "DeepModalViewController.h"
#import "AuthService.h"

@interface DeepModalViewController ()

@end

@implementation DeepModalViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapped401:(id)sender {
    AuthService *authService = [AuthService getInstance];
    [authService testForced401:NO withCompletion:^(NSString *string) {
        NSLog(@"This should never happen");
    }];
}
@end
