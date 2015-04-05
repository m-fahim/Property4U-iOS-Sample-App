//
//  ViewController.m
//  Property4U
//
//  Created by mfahim on 18/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "Configuration.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

// Check Authentication on View Load
- (void)viewDidAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    
    // Getting token from UserDefaults
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userTokenP4U"];
    
    
    if (savedValue != nil) {
        
        // Show loading activity indicator in UIAlertView when user already logged in.
        UIAlertView *loadingUserDataAlertView = [[UIAlertView alloc] initWithTitle:@"Loading.."
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
        [loadingUserDataAlertView addSubview:loading];
        [loadingUserDataAlertView bringSubviewToFront:loading];
        [loading startAnimating];
        
        [loadingUserDataAlertView show];
        
        // Navigiate to ViewController - Main Menu
        HomeViewController *lvc = (HomeViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
        
        // Hide UIAlertView on Navigiate to ViewController - Main Menu
        [loadingUserDataAlertView dismissWithClickedButtonIndex:0 animated:YES];
        loadingUserDataAlertView.hidden = TRUE;
        
        [self presentViewController:lvc animated:YES completion:nil];
        
        
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _userLoginProgress.hidden = TRUE;
    
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
    _passwordTxF.delegate = self;
    _usenameTxF.delegate = self;
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
        [_passwordTxF becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self.view endEditing:YES];
}
- (IBAction)loginUserBtnAct:(id)sender {
    if (![Utilities connected])
    {
        [self.view makeToast:@"Internet connection in not available." duration:1 position:@"center"];
        return;
    }
    if ([_usenameTxF.text length]<=0) {
        [self.view makeToast:@"Please provide Email address." duration:1 position:@"center"];
        return;
    }
    if ([_passwordTxF.text length]<=0) {
        [self.view makeToast:@"Please provide password." duration:1 position:@"center"];
        return;
    }
    if (![Utilities validateEmailWithString:_usenameTxF.text]) {
        [self.view makeToast:@"Email address is not valid." duration:1 position:@"center"];
        return;
    }
    
    // Show Login Progress on Page Load
    [_userLoginProgress startAnimating];
    _userLoginProgress.hidden = FALSE;
    
    // Disable Login Button
    _userLogin.enabled = NO;
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.property4u.somee.com/Token"]];
    
    
    // create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    
    // P4U Set Json Header  Properties
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //Pass The String to server
    NSString *userUpdate =[NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",_usenameTxF.text,_passwordTxF.text];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[data1 length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
}


/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    if ([self.receivedData length] >0 /* && error == nil*/)
    {
        
        // DO YOUR WORK HERE
        NSString *resSrt = [[NSString alloc]initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        
        if(resSrt)
        {
            NSError *errorJson=nil;
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
            
            // Read Token and place it to UserDefaults
            NSString *token = [responseDict objectForKey:@"access_token"];
            
            if(token != nil){
                // Setting token to UserDefaults
                NSString *valueToSave = token;
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userTokenP4U"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                // Getting token from UserDefaults
                NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"userTokenP4U"];
                if (savedValue != nil) {
                    
                    // Navigiate to ViewController - Main Menu
                    HomeViewController *lvc = (HomeViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                    [self presentViewController:lvc animated:NO completion:nil];
                    
                }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Information"
                                                                message:@"You must provide correct username and password for login."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                // Enable Login Button
                _userLogin.enabled = YES;
                
                
            }
            
            // Hide Login Progress on Page Load
            [_userLoginProgress stopAnimating];
            _userLoginProgress.hidden = TRUE;
            
        }
        else
        {
            // Enable Login Button
            _userLogin.enabled = YES;
            
            // Hide Login Progress on Page Load
            [_userLoginProgress stopAnimating];
            _userLoginProgress.hidden = TRUE;
        }
        
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
        _userLogin.enabled = YES;
        
        
    }
    
    [loadingUserDataAlertView dismissWithClickedButtonIndex:0 animated:YES];
    loadingUserDataAlertView.hidden = TRUE;

    // Reload The ViewController With Configurations
    [self viewDidLoad];
}

- (IBAction)registerUserVC:(id)sender {
    // Navigiate to ViewController - Login
    RegisterViewController *lvc = (RegisterViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    // View Controller Custom Transition Style
    lvc.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
    [self presentViewController:lvc animated:YES completion:nil];
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

// Get UIColor from Hex Value
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
