//
//  FoodAttrModel.h
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import <Foundation/Foundation.h>

@interface GuidABCAttrModel : NSObject{

}
@property(nonatomic) int shopID;
@property (nonatomic, retain)NSString *shopName;
@property (nonatomic, retain) NSString *ico;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *image;
- (GuidABCAttrModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end
