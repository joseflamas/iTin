//
//  FourSquareVenueHandler.m
//  IlistTableViewTest
//
//  Created by Mac on 6/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "FourSquareVenueHandler.h"


static NSString * const FS_CLIENT_ID          = @"&client_id=SPGLWMGNTEMMFSISXC2KLBYFOFGQLXRPEDGIITVJ1ZLRWJ4Z";
static NSString * const FS_CLIENT_SECRET      = @"&client_secret=EWMHMB5HBAH0LMURC2QCUJB2GEMS5QH24VK2OY3QI0RGSKUG";
static NSString * const FS_VENUES_SEARCH_URL  = @"https://api.foursquare.com/v2/venues/search?";
static NSString * const FS_VENUES_EXPLORE_URL = @"https://api.foursquare.com/v2/venues/explore?";
static NSString * const FS_VERSION_PARAMETER  = @"&v=20150601";
static NSString * const FS_MODE_PARAMETER     = @"&m=foursquare";//@"&m=swarm";
static NSString * const FS_LIMIT_PARAMETER    = @"&limit=10";
static NSString * const FS_QUERY_PARAMETER    = @"&query=";      //&query=sushi
static NSString * const FS_SECTION_PARAMETER  = @"&section=";    //&section=food, drinks, coffee, shops, arts, outdoors, sights, trending
static NSString * const FS_LL_PARAMETER       = @"&ll=";         //&ll=40.7,-74
static NSString * const FS_NEAR_PARAMETER     = @"&near=";       //&near=Chicago,%20IL


@implementation FourSquareVenueHandler

//Only Lat and Lon
+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andReturn:( void(^)(NSData * data) )complete
{
    
    NSString *strLatLon = [NSString stringWithFormat:@"&ll=%@,%@", latitude, longitude ];
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingData" object:nil userInfo:nil];
    dispatch_sync(dispatch_queue_create("FSJSONData", nil),
                   ^{
                       
                       NSString *queryString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                                FS_VENUES_SEARCH_URL,
                                                FS_VERSION_PARAMETER,
                                                FS_MODE_PARAMETER,
                                                FS_CLIENT_ID,
                                                FS_CLIENT_SECRET,
                                                FS_LIMIT_PARAMETER,
                                                strLatLon
                                                ];
                       
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryString]];
                       complete(data);
                       
                   });
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataReceived" object:nil userInfo:nil];
}

//Lat, Lon and Query
+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andQuery:(NSString *)query andReturn:( void(^)(NSData * data) )complete
{
    NSString *strLatLon   = [NSString stringWithFormat:@"&ll=%@,%@", latitude, longitude ];
    NSString *strQuery    = [NSString stringWithFormat:@"&query=%@", query ];
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingData" object:nil userInfo:nil];
//    dispatch_sync(dispatch_queue_create("FSJSONData", nil),
//                   ^{
    
                       NSString *queryString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                                                FS_VENUES_SEARCH_URL,
                                                FS_VERSION_PARAMETER,
                                                FS_MODE_PARAMETER,
                                                FS_CLIENT_ID,
                                                FS_CLIENT_SECRET,
                                                FS_LIMIT_PARAMETER,
                                                strLatLon,
                                                strQuery
                                                ];
                       
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryString]];
                       complete(data);
                       
//                   });
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataReceived" object:nil userInfo:nil];
    
}

//Lat, Lon, Query and Section
+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andQuery:(NSString *)query andSection:(NSString *)section andReturn:( void(^)(NSData * data) )complete
{
    NSString *strLatLon   = [NSString stringWithFormat:@"&ll=%@,%@", latitude, longitude ];
    NSString *strQuery    = [NSString stringWithFormat:@"&query=%@", query ];
    NSString *strSection  = [NSString stringWithFormat:@"&section=%@", section ];
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingData" object:nil userInfo:nil];
    dispatch_sync(dispatch_queue_create("FSJSONData", nil),
                   ^{
                       
                       NSString *queryString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                                FS_VENUES_SEARCH_URL,
                                                FS_VERSION_PARAMETER,
                                                FS_MODE_PARAMETER,
                                                FS_CLIENT_ID,
                                                FS_CLIENT_SECRET,
                                                FS_LIMIT_PARAMETER,
                                                strLatLon,
                                                strQuery,
                                                strSection
                                                ];
                       
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryString]];
                       complete(data);
                       
                   });
    
    //Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataReceived" object:nil userInfo:nil];
}


@end
