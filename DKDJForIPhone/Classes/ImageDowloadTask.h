//
//  ImageDowloadTask.h
//  TSYP
//
//  Created by wulin on 13-6-5.
//
//

#import <Foundation/Foundation.h>

@interface ImageDowloadTask : NSObject{
}

@property (nonatomic, retain)NSString *URL;
@property (nonatomic, retain)UIImage *showImg;
@property (nonatomic, retain)NSString *locURL;
@property (nonatomic, assign)BOOL *dowload;
@property (nonatomic, retain)NSString *ID;
@property (nonatomic, retain)NSString *defaultPath;
@property (nonatomic, assign)int index;//在原数组中的索引
@property (nonatomic, assign) int groupType;//所在组标识
-(id)initWhichURLAndUI:(NSString *)url showImg:(UIImage *)showIm  dataID:(NSString *)dataID  defaultImg:(NSString *)path  indexInGroup:(int)indexInGroup group:(int)group;
@end
