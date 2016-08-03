//
//  MapSearch.h
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "HJViewController.h"
#import "TwitterClient.h"

@interface MapSearchViewController : HJViewController<BMKMapViewDelegate> {
	
    BMKMapView* mapView;
    NSMutableArray*     shops;
    TwitterClient*      twitterClient;
    NSString*           shopid;
    
}

@property (nonatomic, retain) IBOutlet BMKMapView* mapView;
@property (nonatomic, retain) NSMutableArray *shops;
@property (nonatomic, retain) NSString *shopid;

//-(void)showOnMap;

@end
