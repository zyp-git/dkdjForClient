//
//  ImageScrollViewControlDelegate.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//


#import <Foundation/Foundation.h>
#import "CachedDownloadManager.h"

@protocol ImageScrollViewControlDelegate <NSObject>
-(void)clickViewGetModel:(NSObject *)model Type:(int)type;
@end


