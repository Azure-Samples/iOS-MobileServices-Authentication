//
//  CustomLoginViewController.h
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/2/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "ViewController.h"

@interface CustomLoginViewController : ViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)tappedCancel:(id)sender;
- (IBAction)tappedLogin:(id)sender;
- (IBAction)tappedRegister:(id)sender;
- (IBAction)tappedForgotUsernamePassword:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end
