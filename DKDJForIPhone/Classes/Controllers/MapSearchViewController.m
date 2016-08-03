//
//  MapSearch.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapSearchViewController.h"
#import "BMapKit.h"
#import "FShop4ListModel.h"
#import "ShopDetailViewController.h"

@implementation MapSearchViewController

@synthesize shops;
@synthesize mapView;
@synthesize shopid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置mapView的Delegate
	mapView.delegate = self;
    

    //设置显示级别
    mapView.zoomLevel = 17;
//    NSString *uaddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"uaddress"];
    double ulat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ulat"];
	double ulng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ulng"];
    
    //测试
    //ulat = 30.189053;
    //ulng = 120.163655;
    
    if(ulat > 0 && ulng > 0 )
    {
        CLLocationCoordinate2D coor;
        coor.latitude = ulat;
        coor.longitude = ulng;
        [self.mapView setCenterCoordinate:coor animated:YES];
        
        //显示当前用户的位置
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D ucoor;
        ucoor.latitude = ulat;
        ucoor.longitude = ulng;
        annotation.coordinate = ucoor;
        annotation.title = @"您的位置";
        
        [mapView addAnnotation:annotation];
    }
    else
    {
        //如无则进行查询
        mapView.showsUserLocation = YES;
    }
    
    [mapView setZoomLevel:16];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    shops = [[NSMutableArray array] retain];
    self.navigationItem.title = [NSString stringWithFormat:@"附近外卖演示", nil];
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%@",@"1"];
    
    
    
    NSString *lat = [[NSString alloc] initWithFormat:@"%f",ulat];
    NSString *lng = [[NSString alloc] initWithFormat:@"%f",ulng];

    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",lat,@"lat",lng,@"lng", nil];
    
    [twitterClient getShopListByLocationForMap:param];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
    //视图将要消失 
}

//用户位置更新后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation;
{
    //设定地图中心点坐标
    //-(void)setCenterCoordinate: (CLLocationCoordinate2D) coordinate animated: (BOOL) animated
    //参数：
    //coordinate - 要设定的地图中心点坐标，用经纬度表示
    //userLocation.title = @"您当前位置";
    //[self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //模拟器测试使用这个
    //lat=30.189053&lng=120.163655
    //CLLocationCoordinate2D coor;
    //coor.latitude = [@"30.189053" doubleValue];
	//coor.longitude = [@"120.163655" doubleValue];
    //[self.mapView setCenterCoordinate:coor animated:YES];
 
    //查询本地是否保存了地址，如有则直接显示 如需要更新点击UILabel 进入定位页面 手动点击刷新定位
    userLocation.title = @"您的位置";
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
}
/*
//当选中一个annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;
{
    NSLog(@"didSelectAnnotationView");
    
    NSString *title = [[NSString alloc] initWithFormat:@"%@",[view.annotation title]];
    
    if([title compare:@"您当前位置"] == NSOrderedSame)
    {
        return;
    }
    
    //TODO:更好的方法
    for(int i = 0 ; i < self.shops.count; i++ )
    {
        if([[[shops objectAtIndex:i] shopname] compare:title] == NSOrderedSame)
        {
            shopid =[[self.shops objectAtIndex:i] shopid];
            break;
        }
    }
    
    ShopDetailViewController *shopdetail = [[[ShopDetailViewController alloc] initWithShopId:shopid] autorelease];
    
    [self.navigationController pushViewController:shopdetail animated:true];
    
}
 */

//点击弹出的气泡时执行 进入商家详细页面
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    
    NSString *title = [[NSString alloc] initWithFormat:@"%@",[view.annotation title]];
    
    if([title compare:@"您的位置"] == NSOrderedSame)
    {
        return;
    }
    
    //TODO:更好的方法
    for(int i = 0 ; i < self.shops.count; i++ )
    {
        if([[[shops objectAtIndex:i] shopname] compare:title] == NSOrderedSame)
        {
            
            shopid = [NSString stringWithFormat:@"%d", [[self.shops objectAtIndex:i] shopid]];
            break;
        }
    }
    
    ShopDetailViewController *shopdetail = [[[ShopDetailViewController alloc] initWithShopId:shopid] autorelease];
    
    [self.navigationController pushViewController:shopdetail animated:true];
}

//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;
{
    
}

//获取附近商家列表
- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"shopsDidReceive......");

    [twitterClient release];
    twitterClient = nil;
    
    if (client.hasError) {
        NSLog(@"client.hasError");
        [client alert];
        return;
    }
    
    if (obj == nil)
    {
        NSLog(@"obj == nil");
        return;
    }
    
    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"total: %@",totalString);
    }
    
    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    
    // 将获取到的数据进行处理 形成列表 添加到地图中
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic];
        NSLog(@"ShopListViewController shopname: %@", model.shopname);
        
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        
        CLLocationCoordinate2D coor;
        coor.latitude = [model.Lat doubleValue];
        coor.longitude = [model.Lng doubleValue];
        
        item.coordinate = coor;
        item.title = model.shopname;
        
        
        [mapView addAnnotation:item];
        
        [item release];
        
        [shops addObject:model];
        [model release];
    }
    
    //[self showOnMap];
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];   
		newAnnotationView.pinColor = BMKPinAnnotationColorPurple;   
		newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
		return newAnnotationView;   
	}
	return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {

}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}

@end
