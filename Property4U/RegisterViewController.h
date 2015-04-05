//
//  RegisterViewController.h
//  Property4U
//
//  Created by mfahim on 11/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Toast+UIView.h"

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTxF;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordTxF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxF;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *userRegisterProgress;
@property (weak, nonatomic) IBOutlet UIButton *userRegister;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (IBAction)registerUserBtnAct:(id)sender;
- (IBAction)loginUserVC:(id)sender;

@end
