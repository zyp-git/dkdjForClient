//
//  PopAdvModel.h
//  HMBL
//
//  Created by ihangjing on 14-1-8.
//
//

#import <UIKit/UIKit.h>

@interface PopAdvModel : NSObject
@property (nonatomic, retain)NSString *icon;//图片地址
@property (nonatomic, retain)NSString *dataID;//编号
@property (nonatomic, retain)UIImage *image;
@property (nonatomic, retain)NSString *picPath;//本地图片地址

-(PopAdvModel *)initWitchDic:(NSDictionary *)dic;
-(void)setImageWitchPath:(NSString *)path Default:(NSString *)def;
@end
