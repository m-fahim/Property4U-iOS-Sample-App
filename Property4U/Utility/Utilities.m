//
//  Utilities.m
//  Glober
//
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"


@implementation Utilities


+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);//0
}
+(void)resetView:(float)yOrigin myView:(UIView*)myView
{
    CGRect viewFrame = myView.frame;
    if (yOrigin==0 && viewFrame.origin.y!=0)
    {
        viewFrame.origin.y=yOrigin;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [myView setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else if(yOrigin>0 ||yOrigin<0)
    {
        viewFrame.origin.y=yOrigin;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [myView setFrame:viewFrame];
        [UIView commitAnimations];
    }
    
    
}

@end
