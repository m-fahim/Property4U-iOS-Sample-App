//
//  Configuration.m
//  Property4U
//
//  Created by mfahim on 05/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.CompanyName = [decoder decodeObjectForKey:@"configCompanyName"];
        self.ShortTitle = [decoder decodeObjectForKey:@"configShortTitle"];
        self.Tagline = [decoder decodeObjectForKey:@"configTagline"];
        self.WebsiteURL = [decoder decodeObjectForKey:@"configWebsiteURL"];
        self.Email = [decoder decodeObjectForKey:@"configEmail"];
        self.PublicPhoneNo = [decoder decodeObjectForKey:@"configPublicPhoneNo"];
        self.OfficeAddress = [decoder decodeObjectForKey:@"configOfficeAddress"];
        self.LogoPath = [decoder decodeObjectForKey:@"configLogoPath"];
        self.Favicon = [decoder decodeObjectForKey:@"configFavicon"];
        self.ThemeColor = [decoder decodeObjectForKey:@"configThemeColor"];
        self.PropertyRenewal = [decoder decodeObjectForKey:@"configPropertyRenewal"];
        self.RenewalCost = [decoder decodeObjectForKey:@"configRenewalCost"];
        self.TimeZoneId = [decoder decodeObjectForKey:@"configTimeZoneId"];
        self.CompanyDescription = [decoder decodeObjectForKey:@"configCompanyDescription"];
        self.FacebookAppId = [decoder decodeObjectForKey:@"configFacebookAppId"];
        self.GoogleClientId = [decoder decodeObjectForKey:@"configGoogleClientId"];
        self.FacebookURL = [decoder decodeObjectForKey:@"configFacebookURL"];
        self.TwitterURL = [decoder decodeObjectForKey:@"configTwitterURL"];
        self.LinkedInURL = [decoder decodeObjectForKey:@"configLinkedInURL"];
        self.DribbbleURL = [decoder decodeObjectForKey:@"configDribbbleURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.CompanyName forKey:@"configCompanyName"];
    [encoder encodeObject:self.ShortTitle forKey:@"configShortTitle"];
    [encoder encodeObject:self.Tagline forKey:@"configTagline"];
    [encoder encodeObject:self.WebsiteURL forKey:@"configWebsiteURL"];
    [encoder encodeObject:self.Email forKey:@"configEmail"];
    [encoder encodeObject:self.PublicPhoneNo forKey:@"configPublicPhoneNo"];
    [encoder encodeObject:self.OfficeAddress forKey:@"configOfficeAddress"];
    [encoder encodeObject:self.LogoPath forKey:@"configLogoPath"];
    [encoder encodeObject:self.Favicon forKey:@"configFavicon"];
    [encoder encodeObject:self.ThemeColor forKey:@"configThemeColor"];
    [encoder encodeObject:self.PropertyRenewal forKey:@"configPropertyRenewal"];
    [encoder encodeObject:self.RenewalCost forKey:@"configRenewalCost"];
    [encoder encodeObject:self.TimeZoneId forKey:@"configTimeZoneId"];
    [encoder encodeObject:self.CompanyDescription forKey:@"configCompanyDescription"];
    [encoder encodeObject:self.FacebookAppId forKey:@"configFacebookAppId"];
    [encoder encodeObject:self.GoogleClientId forKey:@"configGoogleClientId"];
    [encoder encodeObject:self.FacebookURL forKey:@"configFacebookURL"];
    [encoder encodeObject:self.TwitterURL forKey:@"configTwitterURL"];
    [encoder encodeObject:self.LinkedInURL forKey:@"configLinkedInURL"];
    [encoder encodeObject:self.DribbbleURL forKey:@"configDribbbleURL"];
}

-(NSString *) CompanyName{return CompanyName;}
-(NSString *) ShortTitle{return ShortTitle;}
-(NSString *) Tagline{return Tagline;}
-(NSString *) WebsiteURL{return WebsiteURL;}
-(NSString *) Email{return Email;}
-(NSString *) PublicPhoneNo{return PublicPhoneNo;}
-(NSString *) OfficeAddress{return OfficeAddress;}
-(NSString *) LogoPath{return LogoPath;}
-(NSString *) Favicon{return Favicon;}
-(NSString *) ThemeColor{return ThemeColor;}
-(NSString *) PropertyRenewal{return PropertyRenewal;}
-(NSString *) RenewalCost{return RenewalCost;}
-(NSString *) TimeZoneId{return TimeZoneId;}
-(NSString *) CompanyDescription{return CompanyDescription;}
-(NSString *) FacebookAppId{return FacebookAppId;}
-(NSString *) GoogleClientId{return GoogleClientId;}
-(NSString *) FacebookURL{return FacebookURL;}
-(NSString *) TwitterURL{return TwitterURL;}
-(NSString *) LinkedInURL{return LinkedInURL;}
-(NSString *) DribbbleURL{return DribbbleURL;}

-(void) setCompanyName:(NSString *) theCompanyName{
    CompanyName = theCompanyName;
}
-(void) setShortTitle:(NSString *) theShortTitle{
    ShortTitle = theShortTitle;
}
-(void) setTagline:(NSString *) theTagline{
    Tagline = theTagline;
}
-(void) setWebsiteURL:(NSString *) theWebsiteURL{
    WebsiteURL = theWebsiteURL;
}
-(void) setEmail:(NSString *) theEmail{
    Email = theEmail;
}
-(void) setPublicPhoneNo:(NSString *) thePublicPhoneNo{
    PublicPhoneNo = thePublicPhoneNo;
}
-(void) setOfficeAddress:(NSString *) theOfficeAddress{
    OfficeAddress = theOfficeAddress;
}
-(void) setLogoPath:(NSString *) theLogoPath{
    LogoPath = theLogoPath;
}
-(void) setFavicon:(NSString *) theFavicon{
    Favicon = theFavicon;
}
-(void) setThemeColor:(NSString *) theThemeColor{
    ThemeColor = theThemeColor;
}
-(void) setPropertyRenewal:(NSString *) thePropertyRenewal{
    PropertyRenewal = thePropertyRenewal;
}
-(void) setRenewalCost:(NSString *) theRenewalCost{
    RenewalCost = theRenewalCost;
}
-(void) setTimeZoneId:(NSString *) theTimeZoneId{
    TimeZoneId = theTimeZoneId;
}
-(void) setCompanyDescription:(NSString *) theCompanyDescription{
    CompanyDescription = theCompanyDescription;
}
-(void) setFacebookAppId:(NSString *) theFacebookAppId{
    FacebookAppId = theFacebookAppId;
}
-(void) setGoogleClientId:(NSString *) theGoogleClientId{
    GoogleClientId = theGoogleClientId;
}
-(void) setFacebookURL:(NSString *) theFacebookURL{
    FacebookURL = theFacebookURL;
}
-(void) setTwitterURL:(NSString *) theTwitterURL{
    TwitterURL = theTwitterURL;
}
-(void) setLinkedInURL:(NSString *) theLinkedInURL{
    LinkedInURL = theLinkedInURL;
}
-(void) setDribbbleURL:(NSString *) theDribbbleURL{
    DribbbleURL = theDribbbleURL;
}

@end
