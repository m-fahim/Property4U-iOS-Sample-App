//
//  HomeViewController.m
//  Property4U
//
//  Created by mfahim on 18/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "Configuration.h"

@interface HomeViewController ()
{
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    // Define keys
    NSString *title;
    NSString *thumbnail;
    NSString *author;
    NSArray *properties;
}

@end

@implementation HomeViewController

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
    title = @"Title";
    thumbnail = @"Path";
    author = @"Price";
    
    myObject = [[NSMutableArray alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://property4u.somee.com/api/Properties/GetPopularProperties"]];
    
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
                     NSString *title_data = [dataDict objectForKey:@"Title"];
                     
                     NSString *thumbnail_data = @"no-photo.jpg";
                     NSMutableArray *thumbnail_data_array = [dataDict objectForKey:@"Photos"];
                     for (NSDictionary *dataDictArr in thumbnail_data_array) {
                         thumbnail_data = [dataDictArr objectForKey:@"PhotoTitle"];
                     }
                     NSString *author_data = [dataDict objectForKey:@"Price"];
                     
                     dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
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
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = img/*[UIImage imageNamed:imageFile]*/;
    
    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:101];
    recipeNameLabel.text = text;
    
    UILabel *recipeDetailLabel = (UILabel *)[cell viewWithTag:102];
    recipeDetailLabel.text = detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] + 70;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogout:(id)sender {
    
    // Getting token from UserDefaults
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userTokenP4U"];
    if (savedValue != nil) {
        // Setting token to UserDefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTokenP4U"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Navigiate to ViewController - Login
        LoginViewController *lvc = (LoginViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:lvc animated:YES completion:nil];
        
    }
}

- (IBAction)menuBtnS:(id)sender {
    // Navigiate to ViewController - Main Menu
    MenuViewController *lvc = (MenuViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
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
