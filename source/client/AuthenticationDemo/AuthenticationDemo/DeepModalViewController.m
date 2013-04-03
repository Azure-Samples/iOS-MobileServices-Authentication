//
//  DeepModalViewController.m
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/3/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "DeepModalViewController.h"

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

- (IBAction)tappedLogout:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //[[[self presentingViewController] presentingViewController] dismissModalViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.presentedViewController.navigationController popToRootViewControllerAnimated:YES];
//        [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    UIViewController *root =self.view.window.rootViewController;
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        [root.navigationController performSelector:@selector(popToRootViewControllerAnimated) withObject:NO afterDelay:0.1];
////        [root.navigationController popToRootViewControllerAnimated:NO];
//    }];
    

    
//    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:^{
//        [self.presentingViewController.navigationController popToRootViewControllerAnimated:YES];
//        
//    }];
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    UIViewController *root = [nav.viewControllers objectAtIndex:0];
    [root performSelector:@selector(logout) withObject:nil afterDelay:0.1];
//    [self.view.window.rootViewController performSelector:@selector(logoutTest) withObject:nil afterDelay:0.1];

}
@end
