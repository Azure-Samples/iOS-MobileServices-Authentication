//
//  LoggedInViewController.h
//  AuthenticationDemo
//
//  Created by Chris Risner on 4/1/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "ViewController.h"

@interface LoggedInViewController : ViewController
@property (weak, nonatomic) IBOutlet UILabel *lblUserId;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
- (IBAction)tapped401NoRetry:(id)sender;
- (IBAction)tapped401Retry:(id)sender;



@end
