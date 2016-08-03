//
//  MyLocationModel.h
//  CCWM
//
//  Created by ihangjing on 15/2/3.
//
//

#import <Foundation/Foundation.h>
#import "BMKUserLocation.h"
#import "BMKGeocodeType.h"
#import "BMKAnnotation.h"
@interface MyLocationModel : NSObject
{
    
}
@property(nonatomic, assign) double lat;//用户经纬度
@property(nonatomic, assign) double lon;
@property(nonatomic, assign) double cityLat;//城市经纬度
@property(nonatomic, assign) double cityLon;
@property(nonatomic, retain)BMKUserLocation *UserLocation;//百度地图用户经纬度
@property(nonatomic, retain) NSString *addressDetail;//详细地址
@property(nonatomic, retain) NSString *cityName;//城市名称
@property(nonatomic, retain) NSString *cityID;//城市编号
@property(nonatomic, retain) NSString *street;//街道名称
-(id)initCopy:(MyLocationModel *)location;
-(id)initWithUserLocation:(BMKUserLocation *)location;
-(id)initWithSearch:(BMKReverseGeoCodeResult *)search;

-(void)setUserLocation:(BMKUserLocation *)location;
-(void)setSearch:(BMKReverseGeoCodeResult *)search;
-(void)setAnno:(id <BMKAnnotation>)anno;
@end
