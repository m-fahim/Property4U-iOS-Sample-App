//
//  MapViewController.h
//  Property4U
//
//  Created by mfahim on 02/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapViewItem;

- (IBAction)homeBtn:(id)sender;

@end
