//
//  DynamicViewController.m
//  Property4U
//
//  Created by mfahim on 02/04/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "DynamicViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"

@interface DynamicViewController (){
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    // Define keys
    NSString *title;
    NSString *price;
    NSString *date;
    NSString *status;
}

@end

@implementation DynamicViewController

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
    
    [self.typeToolbar setTitle:[NSString stringWithFormat:@"%@", self.typeController]];
    
    // Checking for App Configurations
    Configuration *configSettings = [self loadCustomObjectWithKey:@"configCoreSettings"];
    
    if (configSettings != nil) {
        
        UINavigationBar *p4UMenuBarView = (UINavigationBar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
    }
    
    // Assign value to keys to for json parsing
    if([self.typeController isEqualToString:@"Requests"]){
        title = @"Title";
        price = @"VisitingTime";
        date = @"VisitingDate";
        status = @"RequestStatus";
        
    }else if([self.typeController isEqualToString:@"Bids"]){
        title = @"Title";
        price = @"Price";
        date = @"BidOn";
        status = @"RequestStatus";
        
    }else if([self.typeController isEqualToString:@"Reviews"]){
        title = @"Name";
        price = @"Description";
        date = @"ReviewOn";
        status = @"Rating";
        
    }else if([self.typeController isEqualToString:@"Feedbacks"]){
        title = @"Title";
        price = @"Description";
        date = @"FeedbackOn";
        status = @"For";
        
    }else if([self.typeController isEqualToString:@"Biddings"]){
        title = @"Title";
        price = @"StartDate";
        date = @"EndDate";
        status = @"BiddingStatus";
        
    }else if([self.typeController isEqualToString:@"Responses"]){
        title = @"Title";
        price = @"StartDate";
        date = @"EndDate";
        status = @"BiddingStatus";
        
    }else if([self.typeController isEqualToString:@"Orders"]){
        title = @"Title";
        price = @"StartDate";
        date = @"EndDate";
        status = @"BiddingStatus";
        
    }
    else if([self.typeController isEqualToString:@"Photos"]){
        title = @"PhotoTitle";
        price = @"Extension";
        date = @"UploadedOn";
        status = @"AltText";
        
    }else if([self.typeController isEqualToString:@"Features"]){
        title = @"Title";
        price = @"Description";
        date = @"ImageIcon";
        status = @"LastEdit";
        
    }
    
    
    myObject = [[NSMutableArray alloc] init];
    NSString *dynTypeAPI = [NSString stringWithFormat:@"http://property4u.somee.com/api/%@", self.typeAPI];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dynTypeAPI]];
    
    
    // create the Method "GET" or "POST"
    [request setHTTPMethod:@"GET"];
    
    // Getting token from UserDefaults
    NSString *savedToken = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userTokenP4U"];
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", savedToken];
    [request setValue:authValue  forHTTPHeaderField:@"Authorization "];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    if (result != nil)
    {
        NSString *resSrt = [[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding];
        if(resSrt)
        {
            // DO YOUR WORK HERE
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                              result options:NSJSONReadingMutableContainers error:nil];
            
            @try {
                // Try something
                
                
                for (NSDictionary *dataDict in jsonObjects) {
                    NSString *title_data = [dataDict objectForKey:title];
                    NSString *date_data = [dataDict objectForKey:date];
                    NSString *price_data = [dataDict objectForKey:price];
                    NSString *status_data = [dataDict objectForKey:status];
                    
                    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  title_data, title,
                                  //icon_data, icon,
                                  price_data, price,
                                  date_data, date,
                                  status_data, status,
                                  nil];
                    [myObject addObject:dictionary];
                    
                }
            }
            @catch (NSException * e) {
                // Getting token from UserDefaults
                NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"userTokenP4U"];
                if (savedValue != nil) {
                    // Setting token to UserDefaults
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTokenP4U"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                // Navigiate to ViewController - Login
                LoginViewController *lvc = (LoginViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                [self presentViewController:lvc animated:YES completion:nil];
                
            }
            @finally {
                // Added to show finally works as well
                
            }
            
        }
    }else{
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:
              UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    NSMutableString *titleD;
    titleD = [NSMutableString stringWithFormat:@"%@",
            [tmpDict objectForKeyedSubscript:title]];
    
    NSMutableString *priceD;
    priceD = [NSMutableString stringWithFormat:@"%@ ",
              [tmpDict objectForKey:price]];
    
    NSMutableString *dateD;
    dateD = [NSMutableString stringWithFormat:@"%@ ",
              [tmpDict objectForKey:date]];
    
    NSMutableString *statusD;
    statusD = [NSMutableString stringWithFormat:@"%@ ",
             [tmpDict objectForKey:status]];
    UIImage *img;
    
    if([self.typeController isEqualToString:@"Photos"]){
        NSString* myURLString = [NSString stringWithFormat:@"http://property4u.somee.com/Content/Uploads/Properties/Small/%@", [tmpDict objectForKey:title]];
        NSURL *url = [NSURL URLWithString:myURLString];
    
        NSData *data = [NSData dataWithContentsOfURL:url];
    
        img = [[UIImage alloc]initWithData:data];
    }
    
    // Icon Sets for Dynamic Controller
    UIImageView *dynamicTypeImageView = (UIImageView *)[cell viewWithTag:120];
    if([self.typeController isEqualToString:@"Bids"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"BULLHORNN.png"];
    }
    else if([self.typeController isEqualToString:@"Requests"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Reply.png"];
    }else if([self.typeController isEqualToString:@"Feedbacks"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Feedback.png"];
    }else if([self.typeController isEqualToString:@"Reviews"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Star.png"];
    }else if([self.typeController isEqualToString:@"Biddings"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Bidding.png"];
    }else if([self.typeController isEqualToString:@"Responses"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Reply.png"];
    }else if([self.typeController isEqualToString:@"Orders"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Order.png"];
    }else if([self.typeController isEqualToString:@"Features"]){
        dynamicTypeImageView.image = [UIImage imageNamed:@"Features.png"];
    }else if([self.typeController isEqualToString:@"Photos"]){
        dynamicTypeImageView.image = img;
    }
    else{
        dynamicTypeImageView.image = [UIImage imageNamed:@"home.png"];
    }
    
    UILabel *dynamicTitleLabel = (UILabel *)[cell viewWithTag:121];
    dynamicTitleLabel.text = titleD;
    
    if ([self.typeController isEqualToString:@"Bids"]) {
        
        UILabel *dynamicTypePriceLabel = (UILabel *)[cell viewWithTag:122];
        dynamicTypePriceLabel.text = [NSString stringWithFormat:@"$%@",priceD];
    }
    else{
        
        UILabel *dynamicTypePriceLabel = (UILabel *)[cell viewWithTag:122];
        dynamicTypePriceLabel.text = priceD;
    }
    
    if (![self.typeController isEqualToString:@"Requests"]) {
        UILabel *dynamicTypeDateLabel = (UILabel *)[cell viewWithTag:123];
        dynamicTypeDateLabel.text = dateD;
    }
    
    if ([self.typeController isEqualToString:@"Feedback"]) {
        UIButton *dynamicTypeStatusButton = (UIButton *)[cell viewWithTag:124];
        [dynamicTypeStatusButton setTitle:[self getFeedbackStatus:statusD ] forState:UIControlStateNormal] ;
    } else if ([self.typeController isEqualToString:@"Biddings"]) {
        UIButton *dynamicTypeStatusButton = (UIButton *)[cell viewWithTag:124];
        [dynamicTypeStatusButton setTitle:[self getBiddingStatus:statusD ] forState:UIControlStateNormal] ;
    } else if ([self.typeController isEqualToString:@"Requests"]) {
        UIButton *dynamicTypeStatusButton = (UIButton *)[cell viewWithTag:124];
        [dynamicTypeStatusButton setTitle:[self getRequestStatus:statusD ] forState:UIControlStateNormal] ;
    }
    else if ([self.typeController isEqualToString:@"Responses"]) {
        UIButton *dynamicTypeStatusButton = (UIButton *)[cell viewWithTag:124];
        [dynamicTypeStatusButton setTitle:[self getResponseStatus:statusD ] forState:UIControlStateNormal] ;
    }
    else if ([self.typeController isEqualToString:@"Orders"]) {
        UIButton *dynamicTypeStatusButton = (UIButton *)[cell viewWithTag:124];
        [dynamicTypeStatusButton setTitle:[self getOrderStatus:statusD ] forState:UIControlStateNormal] ;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] + 70;
}

- (IBAction)menuBtnS:(id)sender {
    // Navigiate to ViewController - Main Menu
    MenuViewController *lvc = (MenuViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    [self presentViewController:lvc animated:YES completion:nil];
}

- (IBAction)menuBtnNewProperty:(id)sender {
    
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

// Get Request Status Value from Key
- (NSString *)getRequestStatus:(NSString *)key {
    NSInteger intKey = [key intValue];
    switch (intKey) {
        case 0:
            return @"Pending";
            break;
        case 1:
            return @"Process";
            break;
        case 2:
            return @"Accepted";
            break;
        case 3:
            return @"Rejected";
            break;
            
        default:
            break;
    }
    return @"none";
}

// Get Feedback Status Value from Key
- (NSString *)getFeedbackStatus:(NSString *)key {
    NSInteger intKey = [key intValue];
    switch (intKey) {
        case 1:
            return @"Flag";
            break;
        case 2:
            return @"Feedback";
            break;
            
        default:
            break;
    }
    return @"none";
}

// Get Bidding Status Value from Key
- (NSString *)getBiddingStatus:(NSString *)key {
    NSInteger intKey = [key intValue];
    switch (intKey) {
        case 0:
            return @"UpComing";
            break;
        case 1:
            return @"Active";
            break;
        case 2:
            return @"Closed";
            break;
        case 3:
            return @"Blocked";
            break;
            
        default:
            break;
    }
    return @"none";
}

// Get Order Status Value from Key
- (NSString *)getOrderStatus:(NSString *)key {
    NSInteger intKey = [key intValue];
    switch (intKey) {
        case 0:
            return @"Pending";
            break;
        case 1:
            return @"Process";
            break;
        case 2:
            return @"Approved";
            break;
        case 3:
            return @"Rejected";
            break;
        case 4:
            return @"Expired";
            break;
        default:
            break;
    }
    return @"none";
}

// Get Response Status Value from Key
- (NSString *)getResponseStatus:(NSString *)key {
    NSInteger intKey = [key intValue];
    switch (intKey) {
        case 0:
            return @"Agree";
            break;
        case 1:
            return @"Disagree";
            break;
            
        default:
            break;
    }
    return @"none";
}

@end
