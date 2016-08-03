//
//  IntroModel.h
//  TSYP
//
//  Created by wulin on 13-6-3.
//
//

#import <Foundation/Foundation.h>

@interface AdvModel : NSObject
@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic,) BOOL   isDowload;//是否需要下载
@property (nonatomic, retain) NSString *imageNetPath;
@property (nonatomic, retain) NSString *imageLocalPath;
@property (nonatomic, assign) int advType;//广告类型 0商品 ，1·公告
@property (nonatomic, assign) int dataID;//编号

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText;
-(id)initWithShopAdvDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;

-(void)setImg:(NSString *)imagePath Default:(NSString*)name;
@end
