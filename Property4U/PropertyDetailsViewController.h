//
//  PropertyDetailsViewController.h
//  Property4U
//
//  Created by mfahim on 21/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"

@interface PropertyDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *propertyTitleD;
@property (weak, nonatomic) IBOutlet UILabel *propertyIDD;
@property (weak, nonatomic) IBOutlet UILabel *propertyPriceD;
@property (weak, nonatomic) IBOutlet UIImageView *propertyImageViewD;
@property (weak, nonatomic) IBOutlet UILabel *sellerD;
@property (weak, nonatomic) IBOutlet UILabel *localityD;
@property (weak, nonatomic) IBOutlet UILabel *storiesD;
@property (weak, nonatomic) IBOutlet UILabel *floorD;
@property (weak, nonatomic) IBOutlet UILabel *bathsD;
@property (weak, nonatomic) IBOutlet UILabel *kitchensD;
@property (weak, nonatomic) IBOutlet UILabel *drawingD;
@property (weak, nonatomic) IBOutlet UILabel *diningD;
@property (weak, nonatomic) IBOutlet UILabel *livingD;
@property (weak, nonatomic) IBOutlet UILabel *roomsD;
@property (weak, nonatomic) IBOutlet UILabel *storeD;
@property (weak, nonatomic) IBOutlet UILabel *quartersD;
@property (weak, nonatomic) IBOutlet UILabel *parkingD;
@property (weak, nonatomic) IBOutlet UILabel *buildD;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *propertyTitleFPage;
@property (nonatomic, retain) Property * propertyDetailsV;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDetails;

- (IBAction)propertyListingsBtn:(id)sender;
@end
