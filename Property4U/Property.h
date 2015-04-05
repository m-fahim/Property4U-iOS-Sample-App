//
//  Property.h
//  Property4U
//
//  Created by mfahim on 30/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject{
        NSString *Title;
        NSString *Seller;
        NSString *Locality;
        NSString *Stories;
        NSString *FloorNo;
        NSString *Baths;
        NSString *Kitchens;
        NSString *DrawingRooms;
        NSString *DiningRooms;
        NSString *LivingRooms;
        NSString *NumberOfRooms;
        NSString *StoreRooms;
        NSString *ServantQuarters;
        NSString *CarSpaces;
        NSString *Build;
        NSString *Price;
        NSString *PublishOn;
        NSString *ImagePath;
        NSString *ID;
    }

    -(void) setTitle:(NSString *) theTitle;
    -(void) setSeller:(NSString *) theSeller;
    -(void) setLocality:(NSString *) theLocality;
    -(void) setStories:(NSString *) theStories;
    -(void) setFloorNo:(NSString *) theFloorNo;
    -(void) setBaths:(NSString *) theBaths;
    -(void) setKitchens:(NSString *) theKitchens;
    -(void) setDrawingRooms:(NSString *) theDrawingRooms;
    -(void) setDiningRooms:(NSString *) theDiningRooms;
    -(void) setLivingRooms:(NSString *) theLivingRooms;
    -(void) setNumberOfRooms:(NSString *) theNumberOfRooms;
    -(void) setStoreRooms:(NSString *) theStoreRooms;
    -(void) setServantQuarters:(NSString *) theServantQuarters;
    -(void) setCarSpaces:(NSString *) theCarSpaces;
    -(void) setBuild:(NSString *) theBuild;
    -(void) setPrice:(NSString *) thePrice;
    -(void) setPublishOn:(NSString *) thePublishOn;
    -(void) setImagePath:(NSString *) theImagePath;
    -(void) setID:(NSString *) theID;
    
    -(NSString *) Title;
    -(NSString *) Seller;
    -(NSString *) Locality;
    -(NSString *) Stories;
    -(NSString *) FloorNo;
    -(NSString *) Baths;
    -(NSString *) Kitchens;
    -(NSString *) DrawingRooms;
    -(NSString *) DiningRooms;
    -(NSString *) LivingRooms;
    -(NSString *) NumberOfRooms;
    -(NSString *) StoreRooms;
    -(NSString *) ServantQuarters;
    -(NSString *) CarSpaces;
    -(NSString *) Build;
    -(NSString *) Price;
    -(NSString *) PublishOn;
    -(NSString *) ImagePath;
    -(NSString *) ID;

    @end
