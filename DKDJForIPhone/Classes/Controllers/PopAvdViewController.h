//
//  PopAvdViewController.h
//  IBogu
//
//  Created by ihangjing on 13-10-19.
//
//

#import "HJViewController.h"

@interface PopAvdViewController : HJViewController
{
    NSString *Title;
    NSString *Content;
    NSString *Picture;
    int Time;
    NSTimer *timer;
}
-(id)initWithPopAvdName:(NSString *)title picture:(NSString *)picturePath content:(NSString *)des time:(int)timesec;
@end
