//
//  PropertiesViewController.m
//  Property4U
//
//  Created by mfahim on 20/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "PropertiesViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "PropertyDetailsViewController.h"
#import "Property.h"

@interface PropertiesViewController ()
{
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    // Define keys
    NSString *propertyDetails;
    NSString *title;
    NSString *thumbnail;
    NSString *author;
    NSArray *properties;
}

@end

@implementation PropertiesViewController

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
    
    self.userRolePropertiesVC = [NSString stringWithFormat:@"%@", self.userRolePropertiesVC];
    
    // Show Delete on Swipe TableView Cell
    tableData.allowsMultipleSelectionDuringEditing = YES;
    
    // Checking for App Configurations
    Configuration *configSettings = [self loadCustomObjectWithKey:@"configCoreSettings"];
    
    if (configSettings != nil) {
        
        UIToolbar *p4UMenuBarView = (UIToolbar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
    }
    
    // Make TableView Scrollable
    tableData.scrollEnabled = YES;
    CGRect cgRct = CGRectMake(0, 0, 320, 600);
    tableData = [[UITableView alloc] initWithFrame:cgRct style:UITableViewStyleGrouped];
    
	// Do any additional setup after loading the view.
    propertyDetails = @"Property";
    title = @"Title";
    thumbnail = @"Path";
    author = @"Price";
    
    myObject = [[NSMutableArray alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://property4u.somee.com/api/Properties/GetProperties"]];
    
    
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
                    
                    // Setting Property Details for passing it to propertiesDetails(propertyDT) on selection
                    Property *propertyDT = [[Property alloc]init];
                    propertyDT.ID = [dataDict objectForKey:@"ID"];
                    propertyDT.Title = [dataDict objectForKey:@"Title"];
                    propertyDT.Seller = [dataDict objectForKey:@"Seller"];
                    propertyDT.Stories = [dataDict objectForKey:@"Stories"];
                    propertyDT.FloorNo = [dataDict objectForKey:@"FloorNo"];
                    propertyDT.Baths = [dataDict objectForKey:@"Baths"];
                    propertyDT.Kitchens = [dataDict objectForKey:@"Kitchens"];
                    propertyDT.DrawingRooms = [dataDict objectForKey:@"DrawingRooms"];
                    propertyDT.DiningRooms = [dataDict objectForKey:@"DiningRooms"];
                    propertyDT.LivingRooms = [dataDict objectForKey:@"LivingRooms"];
                    propertyDT.NumberOfRooms = [dataDict objectForKey:@"NumberOfRooms"];
                    propertyDT.StoreRooms = [dataDict objectForKey:@"StoreRooms"];
                    propertyDT.ServantQuarters = [dataDict objectForKey:@"ServantQuarters"];
                    propertyDT.CarSpaces = [dataDict objectForKey:@"CarSpaces"];
                    propertyDT.Build = [dataDict objectForKey:@"Build"];
                    propertyDT.Price = [dataDict objectForKey:@"Price"];
                    propertyDT.PublishOn = [dataDict objectForKey:@"PublishOn"];
                    
                    NSString *title_data = [dataDict objectForKey:@"Title"];
                    NSString *thumbnail_data = @"no-photo.jpg";
                    propertyDT.ImagePath = thumbnail_data;
                    
                    NSMutableArray *thumbnail_data_array = [dataDict objectForKey:@"Photos"];
                    for (NSDictionary *dataDictArr in thumbnail_data_array) {
                        thumbnail_data = [dataDictArr objectForKey:@"PhotoTitle"];
                        propertyDT.ImagePath = thumbnail_data;
                    }
                    NSString *author_data = [dataDict objectForKey:@"Price"];
                    
                    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  propertyDT, propertyDetails,
                                  title_data, title,
                                  thumbnail_data, thumbnail,
                                  author_data,author,
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
    
    NSMutableString *text;
    //text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:title]];
    text = [NSMutableString stringWithFormat:@"%@",
            [tmpDict objectForKeyedSubscript:title]];
    
    NSMutableString *detail;
    detail = [NSMutableString stringWithFormat:@"$%@ ",
              [tmpDict objectForKey:author]];
    
    NSMutableString *images;
    images = [NSMutableString stringWithFormat:@"%@ ",
              [tmpDict objectForKey:thumbnail]];
    
    NSString* myURLString = [NSString stringWithFormat:@"http://property4u.somee.com/Content/Uploads/Properties/Small/%@", [tmpDict objectForKey:thumbnail]];
    NSURL *url = [NSURL URLWithString:myURLString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc]initWithData:data];
    
    // Display Property in the table cell
    UIImageView *propertyLImageView = (UIImageView *)[cell viewWithTag:100];
    propertyLImageView.image = img/*[UIImage imageNamed:imageFile]*/;
    
    UILabel *propertyLNameLabel = (UILabel *)[cell viewWithTag:101];
    propertyLNameLabel.text = text;
    
    UILabel *propertyLDetailLabel = (UILabel *)[cell viewWithTag:102];
    propertyLDetailLabel.text = detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] + 70;
}

// Get PropertyID From NSMutableArray myObject
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *selectedString = [myObject objectAtIndex:indexPath.row];
    Property *propertyDT = [selectedString valueForKey:propertyDetails];
    
    // Navigiate to PropertyDetailsViewController - Set Property ID
    PropertyDetailsViewController *pvc = (PropertyDetailsViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"propertiesDetailsViewController"];
    // Passing Property Details to propertiesDetails(propertyDT) on selection
    pvc.propertyDetailsV = propertyDT;
    // View Controller Custom Transition Style
    pvc.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
    [self presentViewController:pvc animated:YES completion:nil];
    
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if ([self.userRolePropertiesVC isEqualToString:@"Agent"]) {
        // Return YES if Role is Agent
        return YES;
    }else{
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
