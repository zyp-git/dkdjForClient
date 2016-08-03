//
//  NewsViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "HJViewController.h"

@interface NewsViewController : HJViewController
{
    UILabel *titleLable1;
    UILabel *contentLable;
    UIFont *contentFond;
    UITapGestureRecognizer *backClick;
    NSString *name;
    NSString *content;
    UIScrollView *scrollView;
    int viewHeight;
}


-(NewsViewController *)initWitchName:(NSString *)title content:(NSString *)Content;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *content;
@end
