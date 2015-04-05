//
//  MenuViewController.m
//  Property4U
//
//  Created by mfahim on 20/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "PropertiesViewController.h"
#import "DynamicViewController.h"

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface MenuViewController (){
        NSArray *devArray;
        NSArray *adminArray;
        NSArray *agentArray;
        NSArray *memberArray;
        NSArray *currentRoleArray;
        NSString *selectedString;
        NSString *UserRole;
}

@end

@implementation MenuViewController


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
    // Checking for App Configurations
    Configuration *configSettings = [self loadCustomObjectWithKey:@"configCoreSettings"];
    
    if (configSettings != nil) {
        
        UINavigationBar *p4UMenuBarView = (UINavigationBar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
    }

    
    devArray = [[NSArray alloc] initWithObjects:@"", @"API",nil];
    adminArray = [[NSArray alloc] initWithObjects:@"", @"Configurations", @"Roles", @"Users", @"Ads", @"Orders", @"Types", @"SubTypes", @"Properties",nil];
    agentArray = [[NSArray alloc] initWithObjects:@"", @"Properties", @"Biddings", @"Responses", @"Orders", @"Reviews", @"Photos", @"Features",nil];
    memberArray = [[NSArray alloc] initWithObjects:@"", @"Properties", @"Bids", @"Requests", @"Feedbacks", @"Map" ,nil];
    
    [super viewDidLoad];
    
    
    // Check User Role - Main Menu
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://property4u.somee.com/api/Account/UserRoles"]];
    
    
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
            
            // Store User Roles in Dynamic NSMutableArray
            NSMutableArray *roleNames = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dataDict in jsonObjects) {
                NSString *roleName = [dataDict objectForKey:@"Name"];
                [roleNames addObject:roleName];
            }
            
            NSString *mainRole = [roleNames objectAtIndex:0];
            // Setting User Role To Pass it - To Menu Selected ViewController
            UserRole = [NSString stringWithFormat:@"%@",mainRole];
            
            if ([mainRole isEqualToString:@"Admin"]) {
                currentRoleArray = [[NSArray alloc] initWithArray:adminArray];
            }
            else if ([mainRole isEqualToString:@"Agent"]) {
                currentRoleArray = [[NSArray alloc] initWithArray:agentArray];
            }
            else if ([mainRole isEqualToString:@"Member"]) {
                currentRoleArray = [[NSArray alloc] initWithArray:memberArray];
            }
            else if ([mainRole isEqualToString:@"Developer"]) {
                currentRoleArray = [[NSArray alloc] initWithArray:devArray];
            }
        }
    }
    
    [tableData reloadData]; //optional only if the data is loaded after the view
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [currentRoleArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:
              UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Remove Table Cell Separator line from top and bottom
    tableView.separatorColor = [UIColor clearColor];
    
    UILabel *menuItemLabel = (UILabel *)[cell viewWithTag:103];
    menuItemLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [currentRoleArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] + 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedString = [currentRoleArray objectAtIndex:indexPath.row];
    
    // Custom Switch for NSString - Menu Selection To Other ViewController
    SWITCH(selectedString){
        CASE(@"Map"){
            MapViewController *mvc = (MapViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
            [self presentViewController:mvc animated:YES completion:nil];
            break;
        }
        CASE(@"Properties"){
            PropertiesViewController *mvc = (PropertiesViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"propertiesViewController"];
            mvc.userRolePropertiesVC = UserRole;
            [self presentViewController:mvc animated:YES completion:nil];
            break;
        }
        CASE(@"Requests"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Requests";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Bids"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Bids";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Reviews"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Reviews";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Feedbacks"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Feedbacks";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Biddings"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Biddings";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Responses"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Responses";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Orders"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Orders";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Photos"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Photos";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        CASE(@"Features"){
            DynamicViewController *dvc = (DynamicViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"dynamicViewController"];
            dvc.typeController = @"Features";
            dvc.typeAPI = [NSString stringWithFormat:@"%@/Get%@",dvc.typeController, dvc.typeController];
            [self presentViewController:dvc animated:YES completion:nil];
            break;
        }
        DEFAULT{
                break;
        }
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        //Do something with selectedString here
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeBtn:(id)sender {
    // Navigiate to ViewController - Main Menu
    HomeViewController *lvc = (HomeViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
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