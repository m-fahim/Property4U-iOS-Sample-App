//
//  ViewController.h
//  Property4U
//
//  Created by mfahim on 18/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "Utilities.h"
#import "Toast+UIView.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *passwordTxF;
@property (weak, nonatomic) IBOutlet UITextField *usenameTxF;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *userLoginProgress;
@property (weak, nonatomic) IBOutlet UIButton *userLogin;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
- (IBAction)loginUserBtnAct:(id)sender;
- (IBAction)checkConfigurations;
- (IBAction)registerUserVC:(id)sender;

- (void)saveCustomObject:(Configuration *)object key:(NSString *)key ;
- (Configuration *)loadCustomObjectWithKey:(NSString *)key;

@end
