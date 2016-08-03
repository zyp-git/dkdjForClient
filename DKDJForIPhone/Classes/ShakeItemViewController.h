//
//  ShakeItemViewController.h
//  IBogu
//
//  Created by ihangjing on 13-10-18.
//
//

#import "HJViewController.h"

@interface ShakeItemViewController : HJViewController<UIGestureRecognizerDelegate>
{
    UILabel *namLable;
    UILabel *pricLable;
    UIImageView *imageView;
}

@property (nonatomic, retain)UILabel *namLable;
@property (nonatomic, retain)UILabel *pricLable;
@property (nonatomic, retain)UIImageView *imageView;

@end
