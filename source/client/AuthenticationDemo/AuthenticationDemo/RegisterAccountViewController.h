//
//  RegisterAccountViewController.h
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/2/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "ViewController.h"

@interface RegisterAccountViewController : UIViewController <UITextFieldDelegate>
- (IBAction)tappedRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirm;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end
