//
//  MapCityModel.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/24.
//
//

#import <Foundation/Foundation.h>

@interface MapCityModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *address;

@property (nonatomic,assign) CLLocationCoordinate2D pt;
@end
