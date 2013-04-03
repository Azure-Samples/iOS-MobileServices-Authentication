//
//  DeepViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/3/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "DeepViewController.h"

@interface DeepViewController ()

@end

@implementation DeepViewController

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

- (IBAction)tappedLogout:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self popTest];
        
}

- (void) popTest {
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    UIViewController *root = [nav.viewControllers objectAtIndex:0];
    [root performSelector:@selector(logout)];
//    [root performSelector:@selector(logout) withObject:nil afterDelay:0.1];
}
@end
