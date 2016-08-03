//
//  MyLocationModel.m
//  CCWM
//
//  Created by ihangjing on 15/2/3.
//
//

#import "MyLocationModel.h"
#import "BMKPoiSearchType.h"
@implementation MyLocationModel
@synthesize lat;//用户经纬度
@synthesize lon;
@synthesize cityLat;//城市经纬度
@synthesize cityLon;
@synthesize UserLocation;//百度地图用户经纬度
@synthesize addressDetail;//详细地址
@synthesize cityName;//城市名称
@synthesize cityID;//城市编号
@synthesize street;//街道名称
-(id)initCopy:(MyLocationModel *)location
{
    self = [super init];
    if (self) {
        self.lat = location.lat;
        self.lon = location.lon;
        self.cityLat = location.cityLat;
        self.cityLon = location.cityLon;
        self.UserLocation = location.UserLocation;
        self.addressDetail = location.addressDetail;
        self.cityName = location.cityName;
        self.cityID = location.cityID;
        self.street = location.street;
    }
    return self;
}
-(id)initWithUserLocation:(BMKUserLocation *)location
{
    self = [super init];
    if (self) {
        
        [self setUserLocation:location];
    
    }
    return self;
}
-(id)initWithSearch:(BMKReverseGeoCodeResult *)search
{
    self = [super init];
    if (self) {
        [self setSearch:search];
    }
    return self;
}

-(void)setUserLocation:(BMKUserLocation *)location
{
    UserLocation = location;//这里可能会有问题
    self.lat = location.location.coordinate.latitude;
    self.lon = location.location.coordinate.longitude;

}
-(void)setSearch:(BMKReverseGeoCodeResult *)search
{
    if ([search.poiList count] > 0) {
        
        
        self.lat = search.location.latitude;
        self.lon = search.location.longitude;
        self.addressDetail = search.address;
        
        BMKPoiInfo *info = [search.poiList objectAtIndex:0];
        self.cityName = info.city;
        
    }
    
}
-(void)setAnno:(id <BMKAnnotation>)anno
{
    self.lat = anno.coordinate.latitude;
    self.lon = anno.coordinate.longitude;
    self.addressDetail = anno.subtitle;
    
}

-(void)dealloc
{
    [self.cityID release];
    [self.cityName release];
    [self.addressDetail release];
    [self.street release];
    [self.UserLocation release];
    [super dealloc];
}

@end
