//
//  RegisterViewController.m
//  Property4U
//
//  Created by mfahim on 11/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

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
    
    _userRegisterProgress.hidden = TRUE;
    
	// Do any additional setup after loading the view.
    
    // Checking for App Configurations
    Configuration *configSettings = [self loadCustomObjectWithKey:@"configCoreSettings"];
    if (configSettings == nil) {
        [self checkConfigurations];
    }else{
        NSString* myURLString = [NSString stringWithFormat:@"http://property4u.somee.com/Content/Uploads/Assets/%@", configSettings.LogoPath];
        NSURL *url = [NSURL URLWithString:myURLString];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        UIImage *img = [[UIImage alloc]initWithData:data];
        UIImageView *p4UImageView = (UIImageView *)[self.view viewWithTag:109];
        p4UImageView.image = img/*[UIImage imageNamed:imageFile]*/;
        
        UIToolbar *p4UMenuBarView = (UIToolbar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
        
        // Get Copyright Year iOS
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *currentYearString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *copyright = [[NSString stringWithFormat:@"© %@ %@", currentYearString, configSettings.CompanyName] uppercaseString];
        
        UINavigationBar *p4UCopyrightView = (UINavigationBar *)[self.view viewWithTag:112];
        p4UCopyrightView.topItem.title = copyright;
    }
    _registerPasswordTxF.delegate = self;
    _confirmPasswordTxF.delegate = self;
    _emailTxF.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    if (textField.tag==0)
    {
        [_registerPasswordTxF becomeFirstResponder];
    }
    else if (textField.tag==1)
    {
        [_confirmPasswordTxF becomeFirstResponder];
    }
    else
    {
        [Utilities resetView:0 myView:self.view];
        [textField resignFirstResponder];
    }
    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==2)
    {
        [Utilities resetView:-40 myView:self.view];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Utilities resetView:0 myView:self.view];
    [self.view endEditing:YES];
}

- (IBAction)registerUserBtnAct:(id)sender {
    
    
    if (![Utilities connected])
    {
        [self.view makeToast:@"Internet connection in not available." duration:1 position:@"center"];
        return;
    }
    if ([_emailTxF.text length]<=0) {
        [self.view makeToast:@"Please provide Email address." duration:1 position:@"center"];
        return;
    }
    if ([_confirmPasswordTxF.text length]<=0) {
        [self.view makeToast:@"Please provide password." duration:1 position:@"center"];
        return;
    }
    if ([_confirmPasswordTxF.text length]<=0) {
        [self.view makeToast:@"Please provide confirm password." duration:1 position:@"center"];
        return;
    }
    
    if (![Utilities validateEmailWithString:_emailTxF.text]) {
        [self.view makeToast:@"Email address is not valid." duration:1 position:@"center"];
        return;
    }
    
    // Show Login Progress on Page Load
    [_userRegisterProgress startAnimating];
    _userRegisterProgress.hidden = FALSE;
    
    // Disable Login Button
    _userRegister.enabled = NO;
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.property4u.somee.com/api/Account/Register"]];
    
    
    // create the Method "GET" or "POST"
    
    [request setHTTPMethod:@"POST"];
    
    // P4U Set Json Header  Properties
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //Pass The String to server
    NSString *userUpdate =[NSString stringWithFormat:@"Email=%@&Password=%@&ConfirmPassword=%@",_emailTxF.text, _registerPasswordTxF.text, _confirmPasswordTxF.text];
    
    //userUP = [userUpdate stringByAppendingString:@"username=%@"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[data1 length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    // initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
}

- (IBAction)loginUserVC:(id)sender {
    
    // Navigiate to ViewController - Login
    LoginViewController *lvc = (LoginViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:lvc animated:YES completion:nil];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    if(code == 200){
            // Navigiate to ViewController - Main Menu
            LoginViewController *lvc = (LoginViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            [self presentViewController:lvc animated:NO completion:nil];
        
        
    }else{
        // Enable Login Button
        _userRegister.enabled = YES;
    }
    
    // Hide Login Progress on Page Load
    [_userRegisterProgress stopAnimating];
    _userRegisterProgress.hidden = TRUE;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [self.receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if ([self.receivedData length] > 0) {
        
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
        // NSMutableString for appendString - list of Errors
        NSMutableString *message = [[NSMutableString alloc]init];
        [message appendString:[responseDict objectForKey:@"Message"]];
        NSDictionary *modelStateErrors = [responseDict objectForKey:@"ModelState"];
        
        // Parse Value From Round Brackets (); Array of NSDictionary
        for (NSString *modelStateErrorKey in [modelStateErrors allKeys]) {
            NSArray *modelValue = [modelStateErrors valueForKey:modelStateErrorKey];
            NSString *modeValueStr = [modelValue objectAtIndex:0];
            [message appendString:[NSString stringWithFormat:@"\n • %@",modeValueStr]];
      }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Information"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        // Enable Login Button
        _userRegister.enabled = YES;
        
    }

}

-(IBAction)checkConfigurations{
    // Check User Role - Main Menu
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://property4u.somee.com/api/Configurations/GetConfiguration"]];
    
    
    // create the Method "GET" or "POST"
    
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    // Show loading activity indicator in UIAlertView when user already logged in.
    UIAlertView *loadingUserDataAlertView = [[UIAlertView alloc] initWithTitle:@"Configurations..."
                                                                       message:@"\n\n"
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:nil];
    
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.center = CGPointMake(160, 240);
    // Activity Indicator Custom Size using CGAffineTransformMakeScale
    loading.transform = CGAffineTransformMakeScale(2.1, 2.1);
    loading.hidden = NO;
    // Making Activity Indicator Visible in AlertView
    [loadingUserDataAlertView setValue:loading forKey:@"accessoryView"];
    //loading.center = self.view.center;
    [loadingUserDataAlertView addSubview:loading];
    [loadingUserDataAlertView bringSubviewToFront:loading];
    [loading startAnimating];
    
    [loadingUserDataAlertView show];
    
    // Got Response from Configurations API
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 404){
        
        NSError *errorJson=nil;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&errorJson];
        
        Configuration *config = [[Configuration alloc]init];
        config.CompanyName = [responseDict objectForKey:@"CompanyName"];
        config.ShortTitle = [responseDict objectForKey:@"ShortTitle"];
        config.Tagline = [responseDict objectForKey:@"Tagline"];
        config.WebsiteURL = [responseDict objectForKey:@"WebsiteURL"];
        config.Email = [responseDict objectForKey:@"Email"];
        config.PublicPhoneNo = [responseDict objectForKey:@"PublicPhoneNo"];
        config.OfficeAddress = [responseDict objectForKey:@"OfficeAddress"];
        config.LogoPath = [responseDict objectForKey:@"LogoPath"];
        config.Favicon = [responseDict objectForKey:@"Favicon"];
        config.ThemeColor = [responseDict objectForKey:@"ThemeColor"];
        config.PropertyRenewal = [responseDict objectForKey:@"PropertyRenewal"];
        config.RenewalCost = [responseDict objectForKey:@"RenewalCost"];
        config.TimeZoneId = [responseDict objectForKey:@"TimeZoneId"];
        config.CompanyDescription = [responseDict objectForKey:@"CompanyDescription"];
        config.FacebookAppId = [responseDict objectForKey:@"FacebookAppId"];
        config.GoogleClientId = [responseDict objectForKey:@"GoogleClientId"];
        config.FacebookURL = [responseDict objectForKey:@"FacebookURL"];
        config.TwitterURL = [responseDict objectForKey:@"TwitterURL"];
        config.LinkedInURL = [responseDict objectForKey:@"LinkedInURL"];
        config.DribbbleURL = [responseDict objectForKey:@"DribbbleURL"];
        
        
        // Get Congfiguration and place it to UserConfigurations using Configuration: NSObject  class
        [self saveCustomObject:config key:@"configCoreSettings"];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:@"Unable to load app Configurations."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        // Enable Login Button
        _userRegister.enabled = YES;
        
        
    }
    
    [loadingUserDataAlertView dismissWithClickedButtonIndex:0 animated:YES];
    loadingUserDataAlertView.hidden = TRUE;
    
}

// Write to NSUserDefaults
- (void)saveCustomObject:(Configuration *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

// Read from NSUserDefaults
- (Configuration *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Configuration *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// Get ThemeColor from ID
-(UIColor *) getThemeColorFID:(NSInteger) theThemeColorFID{
    
    switch (theThemeColorFID) {
        case 0:
            return [self colorWithHexString:@"008299" ];
            break;
        case 1:
            return [self colorWithHexString:@"4285f4" ];
            break;
        case 2:
            return [self colorWithHexString:@"944e98" ];
            break;
        case 3:
            return [self colorWithHexString:@"a9a9a9" ];
            break;
        case 4:
            return [self colorWithHexString:@"d34836" ];
            break;
        case 5:
            return [self colorWithHexString:@"ef9244" ];
            break;
        case 6:
            return [self colorWithHexString:@"25ae5c" ];
            break;
        case 7:
            return [self colorWithHexString:@"338fff" ];
            break;
        default:
            return [self colorWithHexString:@"BDBDBD" ];
            break;
    }
    
}
@end
