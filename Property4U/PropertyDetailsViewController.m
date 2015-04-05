//
//  PropertyDetailsViewController.m
//  Property4U
//
//  Created by mfahim on 21/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "PropertyDetailsViewController.h"
#import "PropertiesViewController.h"

@interface PropertyDetailsViewController ()

@end

@implementation PropertyDetailsViewController

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
    
    [self.scrollViewDetails setScrollEnabled:YES ];
    self.scrollViewDetails.contentSize = CGSizeMake(100, 100);
    
    // Checking for App Configurations
    Configuration *configSettings = [self loadCustomObjectWithKey:@"configCoreSettings"];
    
    if (configSettings != nil) {
        
        UIToolbar *p4UMenuBarView = (UIToolbar *)[self.view viewWithTag:110];
        // Convert NSString ThemeColor to NSInteger and pass it to getThemeColorFID - Apply ThemeColor to ToolBar
        p4UMenuBarView.barTintColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
        
    }
    
    // Load all details from propertyDetailsV - PropertiesViewController
    self.propertyTitleFPage.title  = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Title];
    
    NSString* myURLString = [NSString stringWithFormat:@"http://property4u.somee.com/Content/Uploads/Properties/Medium/%@", [NSString stringWithFormat:@"%@",self.propertyDetailsV.ImagePath]];
    NSURL *url = [NSURL URLWithString:myURLString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc]initWithData:data];
    _propertyImageViewD.image = img;
    
    self.propertyTitleD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Title];
    self.propertyIDD.text = [NSString stringWithFormat:@"Property ID: %@",self.propertyDetailsV.ID];
    self.propertyPriceD.text = [NSString stringWithFormat:@"$%@",self.propertyDetailsV.Price];
    if (configSettings != nil) {
        self.propertyPriceD.textColor = [self getThemeColorFID:[configSettings.ThemeColor integerValue]];
    }
    self.sellerD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Seller];
    self.localityD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Locality];
    self.storiesD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Stories];
    self.floorD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.FloorNo];
    self.bathsD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Baths];
    self.kitchensD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Kitchens];
    self.drawingD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.DrawingRooms];
    self.diningD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.DiningRooms];
    self.livingD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.LivingRooms];
    self.roomsD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.NumberOfRooms];
    self.storeD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.StoreRooms];
    self.quartersD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.ServantQuarters];
    self.parkingD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.CarSpaces];
    self.buildD.text = [NSString stringWithFormat:@"%@",self.propertyDetailsV.Build];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)propertyListingsBtn:(id)sender {
    // Navigiate to PropertiesViewController - Property Listing
    PropertiesViewController *pvc = (PropertiesViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"propertiesViewController"];
    [self presentViewController:pvc animated:YES completion:nil];
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
