//
//  FourSquareVenueParser.m
//  IlistTableViewTest
//
//  Created by Mac on 6/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "FourSquareVenueParser.h"

@implementation FourSquareVenueParser

+(void)parsearInformaciondelosItems:(NSData *)dataItems alCompletar:( void(^)(NSArray* arrayItems))accionCompletar
{
    NSMutableArray *arrayofPlaces = [NSMutableArray new];
    NSDictionary *JSONresponse = [NSJSONSerialization JSONObjectWithData:dataItems options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog( @"%@", JSONresponse );
    
    for(NSDictionary *place in JSONresponse[@"response"][@"venues"])
    {
        
        DayActivity *act = [DayActivity new];
        
        NSArray *categories               = place[@"categories"];
        NSDictionary *icon                = categories[0][@"icon"];
        act.strActivityIconPrefix         = icon[@"prefix"];
        act.strActivityIconSuffix         = icon[@"suffix"];
        act.strActivityCategoryId         = categories[0][@"id"];
        act.strActivityCategoryName       = categories[0][@"name"];
        act.strActivityCategoryPluralName = categories[0][@"pluralName"];
        act.strActivityCategoryShortName  = categories[0][@"shortName"];
        act.strActivityId                 = place[@"id"];
        NSDictionary *Location            = place[@"location"];
        act.strActivityAddress            = Location[@"address"];
        act.strActivityCc                 = Location[@"cc"];
        act.strActivityCity               = Location[@"city"];
        act.strActivityCountry            = Location[@"country"];
        act.strActivityAddresscrossStreet = Location[@"crossStreet"];
        act.numActivityDistance           = [NSNumber numberWithInteger:[Location[@"distance"] integerValue]];
        act.arrActivityFormattedAddress   = Location[@"formattedAddress"];
        act.numActivityLatitude           = [NSNumber numberWithDouble:[Location[@"lat"] doubleValue]];
        act.numActivityLongitude          = [NSNumber numberWithDouble:[Location[@"lng"] doubleValue]];
        act.numActivityPostalCode         = [NSNumber numberWithInteger:[Location[@"postalCode"] integerValue]];
        act.strActivityState              = Location[@"state"];
        act.strActivityName               = place[@"name"];
        act.strActivityReferralId         = place[@"referralId"];
        
        [arrayofPlaces addObject:act];
        
    }
    
    accionCompletar(arrayofPlaces);
}

@end
