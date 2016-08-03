//
//  FoodAttrModel.h
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject{

}
@property(nonatomic) int dataID;
@property (nonatomic, retain)NSString *name;//电影名称
@property (nonatomic, retain)NSString *ico;
@property (nonatomic)int Sort;//0热映 1 近期上映 2 优惠活动
@property(nonatomic, retain)NSString *TimeStart;
@property(nonatomic, retain)UIImage *image;//原价
@property (nonatomic, retain)NSString *picPath;
@property (nonatomic) int Star;//星级

- (MovieModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end
