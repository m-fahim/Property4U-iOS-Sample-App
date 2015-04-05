//
//  MapViewController.m
//  Property4U
//
//  Created by mfahim on 02/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "MapViewController.h"
#import "HomeViewController.h"
#import "MapLocation.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
        
        UINavigationBar *p4UMenuBarView = (UINavigationBar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
    }
    
    CLLocationManager *userlocationManager = [[CLLocationManager alloc] init];
    userlocationManager = [[CLLocationManager alloc] init];
    userlocationManager.distanceFilter = kCLDistanceFilterNone;
    userlocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [userlocationManager startUpdatingLocation];
    
    float userlatitude = userlocationManager.location.coordinate.latitude;
    float userlongitude = userlocationManager.location.coordinate.longitude;
    
//    // Zoom into user current location.
//    MKCoordinateSpan span = MKCoordinateSpanMake(userlatitude,userlongitude);
//    CLLocationCoordinate2D coordinate = {36, 90};
//    MKCoordinateRegion region = {coordinate, span};
//    MKCoordinateRegion regionThatFits = [self.mapViewItem regionThatFits:region];
//    [self.mapViewItem setRegion:regionThatFits animated:YES];
    
    NSString *requestURl = [NSString stringWithFormat:@"http://property4u.somee.com/api/Properties/GetFindNearByProperties?longitude=%f&latitude=%f",userlongitude ,userlatitude];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURl]];
    
    
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
                    // Map JSON Array Coordinates into a Map View
                    for(NSDictionary *location in jsonObjects){
                        
                        NSNumber *latitude  = [location objectForKey:@"Latitude"];
                        NSNumber *longitude = [location objectForKey:@"Longitude"];
                        NSString *name = [location objectForKey:@"Name"];
                        NSString *area = [location objectForKey:@"AreaName"];
                        
                        CLLocationCoordinate2D coordinate;
                        coordinate.latitude = [latitude doubleValue];
                        coordinate.longitude = [longitude doubleValue];
                        MapLocation *annotation = [[MapLocation alloc] initWithCoordinates:coordinate placeName:@"Start" description:@""];
                        annotation.title = name;
                        annotation.subtitle = area;
                        
                        [self.mapViewItem addAnnotation:annotation];
                    }
                
            }
            @catch (NSException * e) {
                
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
