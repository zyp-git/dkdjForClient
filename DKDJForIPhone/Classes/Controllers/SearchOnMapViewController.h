//
//  SearchOnMapViewController.h
//  ShanShi
//
//  Created by ihangjing on 15/3/3.
//
//

#import "HJViewController.h"
#import "BMapKit.h"
#import "UserAddressMode.h"
@class SearchOnMapViewController;
@protocol SearchOnMapViewControllerDelegate <NSObject>

-(void)SearchOnMapViewController:(SearchOnMapViewController*)vc withLocation:(NSString *)locat;

@end

@interface SearchOnMapViewController : HJViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate, MBProgressHUDDelegate, BMKPoiSearchDelegate,UIScrollViewDelegate>
{
    BMKMapView * _mapView;
    BMKGeoCodeSearch *_searcher;//地址反编码
    BMKPoiSearch* _poisearch;//关键字检索
    UITapGestureRecognizer *backClick;
    MBProgressHUD *_progressHUD;
    BOOL isSearch;
    BOOL isShowPoint;
    UserAddressMode *userAddressModel;
    BMKLocationService *_locService;
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    UIImageView * _mapPin;
}
@property (weak,nonatomic) id<SearchOnMapViewControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * cityDataArr;
@property (nonatomic, retain) BMKPointAnnotation* pointAnnotation;//长击地图添加标注
@property (nonatomic, retain) UIButton* btnCity;//城市切换按钮
@property (weak,nonatomic) UITableView * cityTableview;
@property (assign,nonatomic) BOOL isOrderAddress;


-(id)initWithLat:(double)lat lon:(double)lon addr:(NSString *)addr isShowPoint:(BOOL)showPoint;
-(id)initWithUserAddr:(UserAddressMode *)addr isSearch:(BOOL)search;
@end
