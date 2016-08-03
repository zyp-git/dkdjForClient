//
//  UserTimelineCell.h
//  TwitterFon
//
//  Created by kaz on 8/20/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MSG_TYPE_LOAD_MORE_SHOPS,
    MSG_TYPE_LOAD_MORE_GIFTS,
    MSG_TYPE_LOAD_MORE_ORDERS,
    MSG_TYPE_LOAD_MORE_FOODS,
	MSG_TYPE_LOADING,
	MSG_TYPE_SUBMIT,
    MSG_TYPE_LOAD_MORE_AREAS,
    MSG_TYPE_NO_MORE,
    MSG_TYPE_SEARCH_NET,
} loadCellType;

@interface LoadCell : UITableViewCell {
    UILabel*                    label;
    UIActivityIndicatorView*    spinner;
    loadCellType                type;
}

@property(nonatomic, readonly) UIActivityIndicatorView* spinner;
@property(nonatomic, assign) loadCellType type;

- (void)setType:(loadCellType)type;
-(loadCellType)getType;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@end
