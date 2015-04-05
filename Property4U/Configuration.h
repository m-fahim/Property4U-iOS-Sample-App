//
//  Configuration.h
//  Property4U
//
//  Created by mfahim on 05/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject{
    NSString *CompanyName;
    NSString *ShortTitle;
    NSString *Tagline;
    NSString *WebsiteURL;
    NSString *Email;
    NSString *PublicPhoneNo;
    NSString *OfficeAddress;
    NSString *LogoPath;
    NSString *Favicon;
    NSString *ThemeColor;
    NSString *PropertyRenewal;
    NSString *RenewalCost;
    NSString *TimeZoneId;
    NSString *CompanyDescription;
    NSString *FacebookAppId;
    NSString *GoogleClientId;
    NSString *FacebookURL;
    NSString *TwitterURL;
    NSString *LinkedInURL;
    NSString *DribbbleURL;
}

-(void) setCompanyName:(NSString *) theCompanyName;
-(void) setShortTitle:(NSString *) theShortTitle;
-(void) setTagline:(NSString *) theTagline;
-(void) setWebsiteURL:(NSString *) theWebsiteURL;
-(void) setEmail:(NSString *) theEmail;
-(void) setPublicPhoneNo:(NSString *) thePublicPhoneNo;
-(void) setOfficeAddress:(NSString *) theOfficeAddress;
-(void) setLogoPath:(NSString *) theLogoPath;
-(void) setFavicon:(NSString *) theFavicon;
-(void) setThemeColor:(NSString *) theThemeColor;
-(void) setPropertyRenewal:(NSString *) thePropertyRenewal;
-(void) setRenewalCost:(NSString *) theRenewalCost;
-(void) setTimeZoneId:(NSString *) theTimeZoneId;
-(void) setCompanyDescription:(NSString *) theCompanyDescription;
-(void) setFacebookAppId:(NSString *) theFacebookAppId;
-(void) setGoogleClientId:(NSString *) theGoogleClientId;
-(void) setFacebookURL:(NSString *) theFacebookURL;
-(void) setTwitterURL:(NSString *) theTwitterURL;
-(void) setLinkedInURL:(NSString *) theLinkedInURL;
-(void) setDribbbleURL:(NSString *) theDribbbleURL;

-(NSString *) CompanyName;
-(NSString *) ShortTitle;
-(NSString *) Tagline;
-(NSString *) WebsiteURL;
-(NSString *) Email;
-(NSString *) PublicPhoneNo;
-(NSString *) OfficeAddress;
-(NSString *) LogoPath;
-(NSString *) Favicon;
-(NSString *) ThemeColor;
-(NSString *) PropertyRenewal;
-(NSString *) RenewalCost;
-(NSString *) TimeZoneId;
-(NSString *) CompanyDescription;
-(NSString *) FacebookAppId;
-(NSString *) GoogleClientId;
-(NSString *) FacebookURL;
-(NSString *) TwitterURL;
-(NSString *) LinkedInURL;
-(NSString *) DribbbleURL;

-(id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder ;

@end
