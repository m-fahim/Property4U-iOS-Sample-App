//
//  MapLocation.m
//  Property4U
//
//  Created by mfahim on 12/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    return self;
}

@end