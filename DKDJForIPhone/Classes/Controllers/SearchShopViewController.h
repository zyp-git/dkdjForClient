//
//  SearchShop.h
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJViewController.h"
#import "TwitterClient.h"
#import "ShopTypeModel.h"
#import "HJTextField.h"
@interface SearchShopViewController : HJViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    TwitterClient *twitterClient1;
    
    UITableView *shoptypeTableView;
    int tableRowCount;
    HJTextField *search;
}

@end
