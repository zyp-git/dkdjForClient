//
//  SearchOnMapViewController.m
//  ShanShi
//
//  Created by ihangjing on 15/3/3.
//
//

#import "SearchOnMapViewController.h"
#import "CityListViewController.h"
#import "MapCityModel.h"
@interface SearchOnMapViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchOnMapViewController
@synthesize pointAnnotation;//长击地图添加标注

- (void)viewDidLoad {
    [super viewDidLoad];
    //zyp地图
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    if (!isShowPoint) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        
        UISearchBar* searchbar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthLFL, 25)];
        searchbar.delegate = self;
        searchbar.searchBarStyle = UISearchBarStyleMinimal;
        searchbar.barStyle=UIBarStyleDefault;
        searchbar.keyboardType= UIKeyboardTypeDefault;
        searchbar.barTintColor=[UIColor whiteColor];
        searchbar.tintColor=[UIColor whiteColor];
        searchbar.placeholder=@"输入商家名称";
        self.navigationItem.titleView =searchbar;
        searchbar.showsCancelButton=YES;
        for (id searchbuttons in searchbar.subviews[0].subviews)
        {
            NSLog(@"%@",searchbuttons);
            if ([searchbuttons isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                cancelButton.enabled = YES;
                [cancelButton setTitle:@"搜索"  forState:UIControlStateNormal];//文字
                break;
            }
        }
        UITextField *searchField = [searchbar valueForKey:@"_searchField"];
        searchField.backgroundColor=[UIColor whiteColor];
        searchField.textColor = [UIColor blackColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        

        
    }

    [self initBaiduMap];
    // Do any additional setup after loading the view.
}

-(id)initWithLat:(double)lat lon:(double)lon addr:(NSString *)addr isShowPoint:(BOOL)showPoint{

    if (self= [super init]) {
        self.pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = lat;
        coor.longitude = lon;
        self.pointAnnotation.coordinate = coor;
        self.pointAnnotation.title = @"";
        self.pointAnnotation.subtitle = addr;
        isShowPoint = showPoint;
        isSearch = showPoint;
    }
    return self;
}

-(id)initWithUserAddr:(UserAddressMode *)addr isSearch:(BOOL)search
{
    self = [super init];
    if (self) {
        userAddressModel = addr;
        isSearch = search;
    }
    return self;
}

-(void)goBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (isSearch) {
        if (isShowPoint) {
            [_mapView addAnnotation:self.pointAnnotation];
            _mapView.centerCoordinate = self.pointAnnotation.coordinate;
        }
//        else if (userAddressModel != nil && userAddressModel.lat != nil && userAddressModel.lon != nil && userAddressModel.address != nil) {
//            self.pointAnnotation = [[BMKPointAnnotation alloc]init];
//            CLLocationCoordinate2D coor;
//            coor.latitude = [userAddressModel.lat doubleValue];;
//            coor.longitude = [userAddressModel.lon doubleValue];;
//            self.pointAnnotation.coordinate = coor;
//            self.pointAnnotation.title = @"";
//            self.pointAnnotation.subtitle = userAddressModel.address;
//            [_mapView addAnnotation:self.pointAnnotation];
//            _mapView.centerCoordinate = self.pointAnnotation.coordinate;
//        }
        else{
            CLLocationCoordinate2D coor;
            coor.latitude = app.useLocation.lat;;
            coor.longitude = app.useLocation.lon;
            _mapView.centerCoordinate = coor;
            _mapView.showsUserLocation = NO;//显示定位图层
            _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态(这里为跟随)
            _mapView.showsUserLocation = YES;//显示定位图层
            [self locationUpdate:nil];
        }
        
    }else{
        CLLocationCoordinate2D coor;
        coor.latitude = app.useLocation.lat;;
        coor.longitude = app.useLocation.lon;
        _mapView.centerCoordinate = coor;
        _mapView.showsUserLocation = NO;//显示定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态(这里为跟随)
        _mapView.showsUserLocation = YES;//显示定位图层
        [self locationUpdate:nil];
    }
    _mapView.zoomLevel = 16.0;
    
    if (app.useLocation != nil) {
        [self.btnCity setTitle:app.useLocation.cityName forState:UIControlStateNormal];
    }
    
    
}
-(void)locationUpdate:(id)sender{
    [_mapView updateLocationData:app.myLocation.UserLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)gotoCity:(UIButton *)btn{
    CityListViewController *viewController = [[CityListViewController alloc] initWithReturn];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController] ;
    [self presentViewController:navController animated:YES completion:nil];
}
#pragma mark 百度地图初始化相关
-(void)initBaiduMap
{
    //添加地图视图
    
    _mapView = [[BMKMapView alloc] init];//WithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height-350)];
    _mapView.frame=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_mapView];
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    
    if (_isOrderAddress) {
        _mapView.frame=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height-350);
        _mapPin=[[UIImageView alloc]initWithFrame:CGRectMake(_mapView.center.x-10, _mapView.center.y-32, 20, 32)];
        _mapPin.image=[UIImage imageNamed:@"dingwei"];
        //    _mapPin.backgroundColor=[UIColor redColor];
        //    NSLog(@"%@",_mapPin);
        [self.view addSubview:_mapPin];
        [self.view bringSubviewToFront:_mapPin];
        
        UITableView * tabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-350, self.view.frame.size.width, 350-63)];
        self.cityTableview=tabelView;
        tabelView.delegate=self;
        tabelView.dataSource=self;
        [self.view addSubview:tabelView];
    }
    
    if (_locService==nil) {
       
        _locService = [[BMKLocationService alloc]init];
        //[_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    //去掉精度圈
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
}

#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
  
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
//        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = YES;
    return annotationView;
}

- (void) mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    if (!isShowPoint) {
        [self startGeoCode:coordinate];
    }
}
- (void) mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{//单击标注淡出的泡泡
    if (!isShowPoint) {
        if (isSearch) {
            if ([view.annotation.title compare:CustomLocalizedString(@"search_map_my", @"我的位置")] == NSOrderedSame) {
                userAddressModel.lat = [NSString stringWithFormat:@"%f", app.myLocation.lat ];
                userAddressModel.lon = [NSString stringWithFormat:@"%f", app.myLocation.lon ];
                userAddressModel.address = app.myLocation.addressDetail;
            }else{
                userAddressModel.lat = [NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude ];
                userAddressModel.lon = [NSString stringWithFormat:@"%f", view.annotation.coordinate.longitude ];
                userAddressModel.address = view.annotation.subtitle;
            }
        }else{
            if ([view.annotation.title compare:CustomLocalizedString(@"search_map_my", @"我的位置")] == NSOrderedSame) {
                app.useLocation = [[MyLocationModel alloc] initCopy:app.myLocation];
            }else{
                [app.useLocation setAnno:view.annotation];
            }
            
            NSNotification* notification = [NSNotification notificationWithName:@"MyLocationUpdate" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        [self goBack];
    }
}
#pragma mark 百度地图地址编码
//接收正向编码结果

-(void)startGeoCode:(CLLocationCoordinate2D)pt{
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
        [_progressHUD show:YES];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark BMKGeoCodeSearchDelegate


//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (error==BMK_SEARCH_NO_ERROR) {

            [self.cityDataArr removeAllObjects];
            for(BMKPoiInfo *poiInfo in result.poiList){
                
                MapCityModel *model=[[MapCityModel alloc]init];
                model.name=poiInfo.name;
                model.address=poiInfo.address;
                model.pt=poiInfo.pt;
                
                [self.cityDataArr addObject:model];
                [self.cityTableview reloadData];
            }
        }else{
            
            NSLog(@"BMKSearchErrorCode: %u",error);
        }
        for (MapCityModel *model in self.cityDataArr) {
            NSLog(@"%@",model.name);
        }
//        if (!isSearch) {
//            [_mapView removeAnnotation:self.pointAnnotation];
//            if (app.searchLocation == nil) {
//                app.searchLocation = [[MyLocationModel alloc] initWithSearch:result];
//            }else{
//                [app.searchLocation setSearch:result];
//            }
//            self.pointAnnotation = [[BMKPointAnnotation alloc]init];
//            CLLocationCoordinate2D coor;
//            coor.latitude = app.searchLocation.lat;
//            coor.longitude = app.searchLocation.lon;
//            self.pointAnnotation.coordinate = coor;
//            self.pointAnnotation.title = @"";
//            self.pointAnnotation.subtitle = app.searchLocation.addressDetail;
//            [_mapView addAnnotation:self.pointAnnotation];
//        }
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];

}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    
    if (_searcher==nil) {
        //初始化地理编码类
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_searcher reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = @"";
            item.subtitle = poi.address;
            [_mapView addAnnotation:item];
            if(i == 0){
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

- (void) onGetPoiDetailResult:(BMKPoiSearch *)earcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    if (errorCode == BMK_SEARCH_NO_ERROR) {
    }
}


- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (error != nil){
        NSLog(@"locate failed: %@", [error localizedDescription]);
    }
    else {
        NSLog(@"locate failed");
    }
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}


-(NSMutableArray *)cityDataArr
{
    if (_cityDataArr==nil)
    {
        _cityDataArr=[NSMutableArray arrayWithCapacity:0];
    }
    
    return _cityDataArr;
}
#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView * iv=[[UIImageView alloc]initWithFrame:RectMake_LFL(8, (50-17)/2, 13, 17)];
        iv.image=[UIImage imageNamed:@"icon_dingwei"];
        [cell.contentView addSubview:iv];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(28, 8, 355, 20)];
        label.font=[UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        label.tag=1;
        
        label=[[UILabel alloc]initWithFrame:RectMake_LFL(28, 28, 355, 15)];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [cell.contentView addSubview:label];
        label.tag=2;
    }
    
    MapCityModel* model=self.cityDataArr[indexPath.row];
    UILabel * label=(UILabel*)[cell.contentView viewWithTag:1];
    label.text=model.name;
    
   
    UILabel * addressLabel=(UILabel*)[cell.contentView viewWithTag:2];
    addressLabel.text=model.address;
    
    if (indexPath.row==0) {
        label.textColor=app.sysTitleColor;
        addressLabel.textColor=app.sysTitleColor;
    }else{
        label.textColor=[UIColor blackColor];
        addressLabel.textColor=[UIColor grayColor];
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MapCityModel* model=self.cityDataArr[indexPath.row];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(SearchOnMapViewController:withLocation:)]) {
        [self.delegate SearchOnMapViewController:self withLocation:[NSString stringWithFormat:@"%@|%@",model.address,model.name]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetMaxY(RectMake_LFL(0, 0, 0, 50));
}

#pragma mark 设置cell分割线做对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.cityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cityTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.cityTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.cityTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    NSString *keyString = searchBar.text;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= app.useLocation.cityName;
    citySearchOption.keyword = keyString;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag){
        NSLog(@"城市内检索发送成功");
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
        [_progressHUD show:YES];
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarSearchButtonClicked:searchBar];
    
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}


@end
