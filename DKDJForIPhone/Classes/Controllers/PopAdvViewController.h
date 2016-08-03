//
//  PopAdvViewController.h
//  HMBL
//
//  Created by ihangjing on 14-1-8.
//
//

#import <UIKit/UIKit.h>
#import "ImageScrollViewControl.h"
@interface PopAdvViewController : UIViewController<ImageScrollViewControlDelegate>
{
    NSTimer *timer;
}
@property (nonatomic, retain)ImageScrollViewControl *ScrollView;
@property (nonatomic, retain) NSMutableArray *advArry;
-(PopAdvViewController *)initWitchArry:(NSMutableArray *)arry;
@end
