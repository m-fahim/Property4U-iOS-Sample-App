//
//  Utilities.h
//  Glober
//
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject
{

}

+ (BOOL)validateEmailWithString:(NSString*)email;

+ (BOOL)connected;

+(void)resetView:(float)yOrigin myView:(UIView*)myView;


@end
