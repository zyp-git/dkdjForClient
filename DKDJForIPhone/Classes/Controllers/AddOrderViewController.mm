//
//  AddOrderViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-18.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "AddOrderViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"

#import "UserAddressMode.h"
#import "LoginNewViewController.h"
#import "UserAddressDetailViewController.h"
#import "UserAddressListViewController.h"
#import "SelfStateModel.h"
#import "MyCouponListViewController.h"
#import "MyCouponModel.h"

@implementation AddOrderViewController
@synthesize cardid;
@synthesize shopcardid;
@synthesize tableView;

@synthesize ordermodel;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize shopid;
//@synthesize shopcartDict;
@synthesize shopcartLabel;
@synthesize orderTableView;

@synthesize ordertimeDatePicker = ordertimeDatePicker_;
@synthesize ordertime = ordertime_;
@synthesize keyboardToolbar = keyboardToolbar_;

@synthesize uduserid;

@synthesize pickerDistribution;
@synthesize pickerPayType;
@synthesize pickerOffline;
@synthesize pickerOnline;
@synthesize pickerCoupon;//是否优惠券
@synthesize address;//地址簿

@synthesize distributionArray;
@synthesize payTypeArray;
@synthesize offlineArray;
@synthesize couponArray;

@synthesize distribution;
@synthesize paytype1;
@synthesize paytype2;

@synthesize distribution_num;
@synthesize paytype1_num;
@synthesize paytype2_num;

@synthesize orderId;
@synthesize oaddresse;
@synthesize otel;
@synthesize ousername;
@synthesize sendTime;//送货时间
@synthesize payPassword;//支付密码
@synthesize nsRemark;//备注
@synthesize couponJSON;//优惠券json格式
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


#define ORDER_FIELD_TAG      8

#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80

#define kWaiting          @"正在生成交易信息,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

- (id)initWithShopId:(NSString*)ShopId
{
    
    //self.shopcartDict = [[NSMutableArray array] retain];
    
    self.shopid = ShopId;
    
    //self.shopcartDict = ShopCartDict;
    
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, 320, 480) style:UITableViewStyleGrouped];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    //[self.view addSubview:self.orderTableView];
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isDine) {
        orderType = 1;//订单类型，0 外卖 1现场点菜
    }else{
        orderType = 0;//订单类型，0 外卖 1现场点菜
    }
    payType = 0;//支付方式 0支付宝 1货到付款
    eatType = 0;//现场点菜类型 0现吃 1预定
    
    return  self;
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart
{
    /*sumCountSC = 0;
    sentmoney = [[NSUserDefaults standardUserDefaults] floatForKey:@"shopcartsentmoney"];

    sumPriceSC = (float)0.0 + sentmoney;
    
    FoodInOrderModel *fmodelSC;// = [[FoodInOrderModel alloc] init];
    
    //NSLog(@"keys : %d", self.shopcartDict.count);
    
    for (int i = 0; i < [app.shopCart count]; ++i)
    {   
        fmodelSC = [app.shopCart objectAtIndex:i];
        
        sumPriceSC = sumPriceSC + fmodelSC.price;
        sumCountSC = sumCountSC + fmodelSC.foodCount;
    }
    
    //@"已点：0份 合计：0.0元"
    self.shopcartLabel.text = [[NSString alloc] initWithFormat:@"   已点：%d份 配送费：%.2f元 合计：%.2f元", sumCountSC,sentmoney, sumPriceSC];*/
}

//未使用XIB文件，使用代码建立界面
-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduseridX = [defaults objectForKey:@"userid"];
    
    NSLog(@"islogin userid:%@", uduseridX);
    
    if([uduseridX intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
       LoginNewViewController  *LoginController = [[LoginNewViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

-(void)getStateList
{
    
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(stateDidReceive:obj:)];
    
    
    
    [twitterClient getSelfStateList];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
}





- (void)stateDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [twitterClient release];
    twitterClient = nil;
    
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    
    
    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodtypelist"];
    
    
    
    if ([ary count] > 0) {
        for (int i = 0; i < [ary count]; ++i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            SelfStateModel *model = [[SelfStateModel alloc] initWithJsonDictionary:dic];
            [stateList addObject:model];
            [model release];
        }
        
        [self.pickerOffline reloadAllComponents];
    }
    
    
    
}

-(void)getAddrList
{
   
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addressDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    
    //http://renrenzx.com/android/GetShopListByLocation.aspx?bid=2620&gettype=1&shoptype=&shopname=&lat=&lng=&pagesize=8&pageindex=1
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"pageindex",self.uduserid,@"userid",@"100",@"pagesize", nil];
    
    [twitterClient getUserAddressList:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];

}





- (void)addressDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [twitterClient release];
    twitterClient = nil;

    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    

    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    
    
    [self.address removeAllObjects];
    if ([ary count] > 0) {
        for (int i = 0; i < [ary count]; ++i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            UserAddressMode *model = [[UserAddressMode alloc] initWithJsonDictionary:dic];
            [self.address addObject:model];
            [model release];
        }
        app.reciverAddress = [self.address objectAtIndex:0];
        UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:1];
        
        textview4.text = [NSString stringWithFormat:@"%@, %@, %@", app.reciverAddress.address, app.reciverAddress.receiverName, app.reciverAddress.phone];
        [self.pickerCoupon reloadAllComponents];
    }
    [self getStateList];
    
    
}

-(void)save:(id)sender
{
    if( (![self IsLogin]) )
    {
        return;
    }
    

    [self submitOrder];
    //温馨提示：订单提交只需3至5秒机打单即入厨房，请确保您手机的畅通，这样有利于订餐更快送达。感谢您的惠顾！
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"订单提交只需3至5秒机打单即入厨房，请确保您手机的畅通，这样有利于订餐更快送达。感谢您的惠顾！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.delegate = self;
    alert.tag = 3;
    [alert show];
    [alert release];*/
    
}

-(void)submitOrder
{
    NSString* cutomername;
    NSString* time;
    float sendfree;
    sendfree = 0.0;
    
    
    
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:2];
    time = textview4.text;
    
    
    
    
    
    
    self.uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    cutomername = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    //判断是否位空
    if(app.reciverAddress.receiverName.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"收货人不对，请重新选择地址或者新增地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(app.reciverAddress.phone.length < 8)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"手机号码不对，请重新选择地址或者新增地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(app.reciverAddress.address.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"收货地址不对，请重新选择地址或者新增地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //NSString *remark = @"";
    //NSString *payPassword = @"";
    //UITextField *tfRemark;// = (UITextField *)[self.tableView viewWithTag:2];
    //UITextField *tfPayPassword = nil;// = (UITextField *)[self.tableView viewWithTag:2];
    /*int tag;
    if (orderType == CusterPicup) {//自取
        
        if (payType == PayInCusterAccount) {//账户扣款
            tfPayPassword = (UITextField *)[self.tableView viewWithTag:6];
            tag = 8;
            //
        }else{
            tag = 7;
        }
    }else{
        if (payType == PayInCusterAccount) {//账户扣款
            tfPayPassword = (UITextField *)[self.tableView viewWithTag:5];
            tag = 7;
        }else{
            tag = 6;
        }
    }
    if (UserCoupon == isCoupon) {//如果使用了优惠券
        tag += ([couponKeyList count] + 1);
    }
    tfRemark = (UITextField *)[self.tableView viewWithTag:tag];
    remark = tfRemark.text;
    if (remark == nil) {
        remark = @"";
    }*/
    if (payPasswordTag != -1) {
        if(self.payPassword.length < 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入正确的支付密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }else{
        self.payPassword = @"";
    }
    
    if(time.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请填写正确的送餐时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
//    NSString *deskNO = @"";
    int eattype = 1;
    
    
//    NSString *shopcartshopid = [[NSUserDefaults standardUserDefaults] stringForKey:@"shopcartshopid"];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-M-d HH:mm:ss"];
    
    NSLog(@"%@", [formatter stringFromDate:currentDate]);
    
    //NSString *orderTime = [formatter stringFromDate:currentDate];//@"2012-07-07 15:55:55";
    NSString *SentTime = time;
    
    
    
    //NSString *ulat = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulat"];
	//NSString *ulng = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulng"];
    
    NSString *cartlist =[[NSString alloc] initWithString:@""];
    
    //生成订单json格式数据
//    FoodModel *fmodelSC;// = [[FoodInOrderModel alloc] init];
    
    //float sumPriceSC = (float)0.0+sentmoney;
//    FoodAttrModel *attr;
    /*for (int i = 0; i < [app.shopCart.foodCount count]; ++i)
    {
        fmodelSC = [app.shopCart.foodArry objectAtIndex:i];
        
        if([fmodelSC.attr count] > 0)
        {
            //{"owername":"0.0","PId":"74513","PPrice":"15.0","PName":"红烧鸡翅1","Foodcurrentprice":"15.0","PNum":"1"}
            for (int j = 0; j < [fmodelSC.attr count]; j++) {
                attr = [fmodelSC.attr objectAtIndex:j];
                //{"owername":"0.0","Sid":"0","Funit":"","PId":1453,"PPrice":10,"sname":"小份","Remark":"","PName":"卤鸭肉饭","Foodcurrentprice":10,"material":"","PNum":1,"ReveVar1":0.5}
                NSString *cartitem=[NSString stringWithFormat:@"{\"PNum\":\"%d\",\"PId\":%d,\"PPrice\":%.2f,\"PName\":\"%@\",\"Foodcurrentprice\":%.2f,\"owername\":\"%@\",\"sname\":\"%@\",\"ReveVar1\":%.2f,\"Remark\":\"\",\"Funit\":\"\",\"Sid\":\"0\",\"material\":\"\"},",attr.count, fmodelSC.foodid, attr.price, fmodelSC.foodname, attr.price, @"0", attr.name, attr.pactFee];
                cartlist = [cartlist stringByAppendingString:cartitem];
            }
            
            
            //sumPriceSC = sumPriceSC + fmodelSC.foodCount*fmodelSC.price;
        }
    }*/
    
    NSLog(@"%@", cartlist);
    
//    NSString *tempCode = @"1";
    //NSString *PayPassword = @"PayPasswordValue";
//    NSString *bid = [[NSUserDefaults standardUserDefaults] stringForKey:@"BuildingId"];
    
    NSString *stateID;
    if (nSelectStateIndex == -1) {
        stateID = @"0";
    }else{
        SelfStateModel *state = [stateList objectAtIndex:nSelectStateIndex];
        stateID = state.stateID;
    }
    
    
    
    self.ordermodel = [NSString stringWithFormat:@"[{\"ShopCardIDs\":\"\",\"Oorderid\":0,\"ReveInt1\":\"%@\",\"PayPassword\":\"%@\",\"tempCode\":\"\",\"ordersource\":\"2\",\"Tel\":\"%@\",\"OrderType\":\"0\",\"Mobilephone\":\"%@\",\"UserID\":\"%@\",\"cartlist\":[%@],\"TogoId\":\"0\",\"UserName\":\"%@\",\"Address\":\"%@\",\"sendfree\":\"%.0f\",\"CustomerName\":\"%@\",\"Remark\":\"%@\",\"SentTime\":\"%@\",\"sendtype\":\"%d\",\"PayMode\":\"%d\",\"bid\":\"0\",\"ShopCardList\":[]}]", stateID,self.payPassword,app.reciverAddress.phone, app.reciverAddress.phone,uduserid, cartlist, app.reciverAddress.receiverName, app.reciverAddress.address, sentmoney, cutomername, self.nsRemark, SentTime, eattype, payType];
    if (isCoupon == UserCoupon) {
        if ([couponKeyList count] == 0) {
            //给出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"没有选择任何优惠券，无法提交订单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
            return;
        }//[{'CID':'16','Point':'50','cardnum':'','ckey':'1111-1111-1111-1126'}]
        [self.couponJSON release];
        self.couponJSON = nil;
        for(int i = 0; i < [couponKeyList count]; i++){
            MyCouponModel *model = [couponKeyList objectAtIndex:i];
            if (self.couponJSON == nil) {
                self.couponJSON = [NSString stringWithFormat:@"{\"CID\":\"%d\",\"Point\":\"%@\",\"cardnum\":\"\",\"ckey\":\"%@\"}", model.dataID, model.CValue, model.CKey];
            }else{
                self.couponJSON = [NSString stringWithFormat:@"%@,{\"CID\":\"%d\",\"Point\":\"%@\",\"cardnum\":\"\",\"ckey\":\"%@\"}", self.couponJSON,model.dataID, model.CValue, model.CKey];
            }
            
        }
        self.ordermodel = [NSString stringWithFormat:@"%@&Cardjson=[%@]", self.ordermodel, self.couponJSON];
        
    }
    
    //ordermodel = @"";
    
    self.ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"},]," withString:@"}],"];
    
    NSLog(@"%@", self.ordermodel);
    
    //保存当前订单信息
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:username forKey:@"orderusername"];
     [defaults setObject:tel forKey:@"ordertel"];
     [defaults setObject:address forKey:@"orderaddress"];
     [defaults synchronize];*/
    
    //根据选择的支付方式进入不同的界面  支付后再正式提交订单  保存订单信息
    
    if( [paytype1 isEqualToString:@"线上支付"])
    {
        if( [paytype2 isEqualToString:@"银联支付"])
        {
            //银联支付
            //直接提交订单 提交后进行支付宝支付
            //替换部分字符
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"cardpayvalue" withString:@"0"];
            //ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@CID" withString:@""];
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@ShopCardpay" withString:@"0"];
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@ShopCardIDs" withString:@""];
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@isUseShopCard" withString:@"0"];
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@isUseGiftCard" withString:@"0"];
            ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"PayPasswordValue" withString:@""];
            
            if (twitterClient) return;
            
            //联网提交订单
            twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
            
            [twitterClient SubmitOrder:self.ordermodel];
            
            _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            _progressHUD.dimBackground = YES;
            [self.view addSubview:_progressHUD];
            [self.view bringSubviewToFront:_progressHUD];
            _progressHUD.delegate = self;
            _progressHUD.labelText = @"提交中...";
            [_progressHUD show:YES];
        }
        else if ([paytype2 isEqualToString:@"礼品卡/店铺券支付"])
        {
            //礼品卡
            //进入礼品卡信息界面进行礼品卡填写
            
            PayByCardsViewController *viewController = [PayByCardsViewController alloc];
            
            viewController.title =@"礼品卡/店铺券支付";
            viewController.delegate = self;
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
            
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
    else
    {
        //线下付款 直接提交订单
        //替换部分字符
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"cardpayvalue" withString:@"0"];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@CID" withString:@""];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@ShopCardpay" withString:@"0"];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@ShopCardIDs" withString:@""];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@isUseShopCard" withString:@"0"];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"@isUseGiftCard" withString:@"0"];
        ordermodel = [ordermodel stringByReplacingOccurrencesOfString :@"PayPasswordValue" withString:@""];
        
        if (twitterClient) return;
        
        //联网提交订单
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
        [twitterClient SubmitOrder:self.ordermodel];
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"提交中...";
        [_progressHUD show:YES];
        
    }
}

//- (void) PayByCardViewControllerValueChanged:(NSString *)code cmoney:(NSString*)cmoney paypassword:(NSString*)paypassword
- (void) PayByCardsViewControllerValueChanged:(NSString *)upaypassword shopcardids:(NSString*)shopcardids cardids:(NSString*)cardids;
{
    //礼品卡支付界面返回
    //进行字符串替换 并提交订单
    //替换部分字符
    NSString * cardidsString = cardids;//礼品卡卡号
    NSString * shopcardidsString = shopcardids;//店铺券卡号
    NSString * paypasswordString = upaypassword;

    if([shopcardidsString isEqualToString:@"0"])
    {
        shopcardidsString = @"";
    }
    
    if([cardidsString isEqualToString:@"0"])
    {
        cardidsString = @"";
    }
    
    //self.cardid = cardidsString;
    //self.shopcardid = shopcardidsString;
    //self.paypassword = paypasswordString;
    
    NSLog(@"%@:%@:%@", cardidsString, shopcardidsString,paypasswordString);
    
    NSString * ordermodelfix = [[NSString alloc] initWithFormat:@"%@",self.ordermodel];
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"cardpayvalue" withString:@"0"];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@CID" withString:cardidsString];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@isUseGiftCard" withString:@"0"];
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@ShopCardpay" withString:@"0"];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@ShopCardIDs" withString:shopcardidsString];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@isUseShopCard" withString:@"0"];
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"PayPasswordValue" withString:paypasswordString];
    
    
    NSLog(@"%@", ordermodelfix);
    
    if (twitterClient)
    {
        twitterClient = nil;
        NSLog(@"twitterClient");
        //return;
    }
    
    //联网提交订单
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
    
    [twitterClient SubmitOrder:ordermodelfix];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"提交中...";
    [_progressHUD show:YES];
     
}

- (void)addorderDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    //修改 tabbar 的 badgeValue 底部导航右上角的数字
    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:3];
    tController.tabBarItem.badgeValue = nil;

    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    twitterClient = nil;
    //1. 获取信息
    NSDictionary *dic = (NSDictionary*)obj;
    //注意此处必须 用self.dic 不能直接使用dic 否则在其他函数中 self.dic是null
    
    NSString *state = [dic objectForKey:@"orderstate"];
    
    
    
    self.orderId = [dic objectForKey:@"orderid"];
    //测试
    //state = @"1";
    
    //{"orderid":"120925213201002220","orderstate":"1"}
    if(state != nil && [state compare:@"1"] == NSOrderedSame )
    {
        //清除购物车
        NSMutableDictionary * shopcartDictForSaveFile = [NSMutableDictionary dictionaryWithDictionary:[FileController loadShopCart]];
        [shopcartDictForSaveFile removeAllObjects];
        
        [FileController saveShopCart:shopcartDictForSaveFile];
        
        if( [paytype1 isEqualToString:@"线上支付"])
        {
            if( [paytype2 isEqualToString:@"银联支付"])
            {
                NSString* urlAddress = nil;
                
                //调用商户系统 生成订单xml下发到客户端
                
                urlAddress = [NSString stringWithFormat:@"http://renrenzx.com/unionpay/unionpaygettn.aspx?orderid=%@", orderId];
                
                NSLog(@"urlAddress:%@", urlAddress);
                
                NSURL* url = [NSURL URLWithString:urlAddress];
                NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
                NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                [urlConn start];
                [self showAlertWait];
            }
            else if( [paytype2 isEqualToString:@"余额支付"])// 暂无使用
            {

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"您的订单提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 1;
                [alert show];
                [alert release];
                UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
                tController.tabBarItem.badgeValue = @"0";
                [app.shopCart Clean];

                
            }
        }
        else
        {
            if (payType == 1) {
                //支付宝
            }
            NSString *msg;
            if (orderType == 0) {//送货
                msg = [NSString stringWithFormat:@"您的订单提交成功!\r\n我们将于[%@]时间给您送货！", self.sendTime];

            }else{//取货
                SelfStateModel *model = [stateList objectAtIndex:nSelectStateIndex];
                msg = [NSString stringWithFormat:@"您的订单提交成功!\r\n请您于[%@]到[%@]取货点取货", self.sendTime, model.stateName];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;
            [alert show];
            [alert release];
            UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
            tController.tabBarItem.badgeValue = @"0";
            [app.shopCart Clean];
 
            
            
        }
    }
    else
    {
        NSString *msg = [dic objectForKey:@"msg"];
        if (msg == nil) {
            msg = @"网络错误，请稍后再试";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    int code = (int)[rsp statusCode];
    if (code != 200)
    {
        [self hideAlert];
        [self showAlertMessage:kErrorNet];
        [connection cancel];
        [connection release];
        connection = nil;
    }
    else
    {
        if (mData != nil)
        {
            [mData release];
            mData = nil;
        }
        mData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"tn=%@",tn);
        //[UPPayPlugin startPay:tn sysProvide:nil spId:nil mode:@"00" viewController:self delegate:self];
        //mode  00 接入生产环境  01接入测试环境
    }
    [tn release];
    [connection release];
    connection = nil;
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideAlert];
    [self showAlertMessage:kErrorNet];
    [connection release];
    connection = nil;
    
    NSLog(@"didFailWithError");
}



//get mac
/*
- (NSString*)currentUID
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    NSString* noUID = @"";
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return noUID;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return noUID;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        return noUID;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return noUID;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
*/

#pragma mark - Alert

- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
    [aiv release];
    [mAlert release];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
    [mAlert release];
}

- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            //新增
            UserAddressDetail *newAddr = (UserAddressDetail *)alertView;
            self.ousername = [[newAddr name] text];
            self.otel = [[newAddr phone] text];
            self.oaddresse = [[newAddr address] text];
            if (self.otel.length < 8 || self.ousername.length < 2 || self.oaddresse.length < 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入正确的收货信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            [self editAddress:self.ousername userPhone:self.otel userAddress:self.oaddresse];
            
        }
        return;
    }
    if (alertView.tag == 1) {
        app.orderId = orderId;
        [app SetTab:3];
        
        [self.navigationController popViewControllerAnimated:YES];//返回上一界面
        return;
    }
    if (alertView.tag == 3) {
        [self submitOrder];
        return;
    }
    if (alertView.tag == 123) {
		NSString *URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    else
    {
        if( buttonIndex == 0 )
        {
            
            
        }
        else if( buttonIndex == 1 )
        {
            
        }
    }
}

-(void)editAddress:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address
{

    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(editAddressOK:obj:)];
    NSDictionary* param;
    
    param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid,@"userid",@"1", @"op", name, @"receiver", address, @"address", phone, @"mobilephone", phone, @"phone", nil];
        
    
    
    [twitterClient saveUserAddressList:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"处理中...";
    [_progressHUD show:YES];
}

-(void)editAddressOK:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [twitterClient release];
    twitterClient = nil;
   
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    int type = [[dic objectForKey:@"state"] intValue];
    if (type == 1) {
        app.reciverAddress.aID = [dic objectForKey:@"addressid"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"新增地址成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
            
        [alert release];
        
        [self getAddrList];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"更新数据失败！请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    
}

- (void)setOrderTime
{
    self.ordertime = self.ordertimeDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-M-d HH:mm:ss"];
    
    NSLog(@"%@", [formatter stringFromDate:self.ordertime]);
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:2];
    
    textview4.text = [formatter stringFromDate:self.ordertime];//[dateFormatter stringFromDate:self.ordertime];
    self.sendTime = textview4.text;
    [dateFormatter release];
}

- (void)ordertimeDatePickerChanged:(id)sender
{
    [self setOrderTime];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}

-(void)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    
    //UITableView *table = (UITableView *)[cell superview];
    
    NSIndexPath *textFieldIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    
    if (row >= RegeditViewNumberOfEditableRows)
    {
        row = 0;
    }
    
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex 
                                                         length:2];
    UITableViewCell *nextCell = [self.tableView
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isShowAddressList) {
        isShowAddressList = NO;
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:1];
        textField.text = [NSString stringWithFormat:@"%@, %@, %@", app.reciverAddress.address, app.reciverAddress.receiverName, app.reciverAddress.phone];
        textField = (UITextField *)[self.tableView viewWithTag:3];
        [textField becomeFirstResponder];
        
        
    }
    if (isShowNewAddress) {
        isShowNewAddress = NO;
        [self getAddrList];
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:2];
        [textField becomeFirstResponder];
    }
    
    if (isShowSelectCoupon) {
        isShowSelectCoupon = NO;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (is_iPhone5) {
        viewHeight = 468;
        orderTimePickY = 350;
    }else{
        viewHeight = 370;
        orderTimePickY = 270;
    }
    payPasswordTag = -1;
    COUPON_TAG = -1;
    nSelectStateIndex = -1;
    isShowAddressList = NO;
    isShowNewAddress = NO;
    isShowDatePick = NO;
    self.uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    [self getAddrList];
    self.address = [[NSMutableArray alloc] init];
    
    couponKeyList = [[NSMutableArray alloc] init];
    //NSArray *array = [[NSArray alloc] initWithObjects:@" 联系人:",@"  电话:", @"  地址:",@"送餐时间:",@"消费方式:",@"支付方式:",@"点菜方式:", @"桌子号:" ,@"备注:", nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight - 10)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    self.distributionArray = [[NSArray alloc] initWithObjects:@"送货上门",@"到店自提",nil];
    self.payTypeArray = [[NSArray alloc] initWithObjects:@"货到付款",@"支付宝", @"账户扣款", nil];
    self.offlineArray = [[NSArray alloc] initWithObjects:@"尽快送达",@"选择时间",nil];
    self.couponArray = [[NSArray alloc] initWithObjects:@"不使用",@"使用",nil];
    //self.onlineArray = [[NSArray alloc] initWithObjects:@"支付宝",@"货到付款",nil];
    
    CGRect pickerRect = CGRectMake(0,460, 320, 360);
    
    self.pickerDistribution = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerDistribution.frame = pickerRect;
    self.pickerDistribution.showsSelectionIndicator = YES;
    [self.pickerDistribution setBackgroundColor:[UIColor clearColor]];
    self.pickerDistribution.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerDistribution.delegate=self;
    self.pickerDistribution.tag = 1;
    [self.view addSubview:self.pickerDistribution];
    
    self.pickerPayType = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerPayType.frame = pickerRect;
    self.pickerPayType.showsSelectionIndicator = YES;
    [self.pickerPayType setBackgroundColor:[UIColor clearColor]];
    self.pickerPayType.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerPayType.delegate=self;
    self.pickerPayType.tag = 2;
    [self.view addSubview:self.pickerPayType];
    
    self.pickerOnline = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerOnline.frame = pickerRect;
    self.pickerOnline.showsSelectionIndicator = YES;
    [self.pickerOnline setBackgroundColor:[UIColor clearColor]];
    self.pickerOnline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerOnline.delegate=self;
    self.pickerOnline.tag = 3;
    [self.view addSubview:self.pickerOnline];
    
    self.pickerOffline = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerOffline.frame = pickerRect;
    self.pickerOffline.showsSelectionIndicator = YES;
    [self.pickerOffline setBackgroundColor:[UIColor clearColor]];
    self.pickerOffline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerOffline.delegate=self;
    self.pickerOffline.tag = 4;
    [self.view addSubview:self.pickerOffline];
    
    self.pickerCoupon = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerCoupon.frame = pickerRect;
    self.pickerCoupon.showsSelectionIndicator = YES;
    [self.pickerCoupon setBackgroundColor:[UIColor clearColor]];
    self.pickerCoupon.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerCoupon.delegate=self;
    self.pickerCoupon.tag = 5;
    [self.view addSubview:self.pickerCoupon];
    
    /*UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.shopcartLabel];*/
    
    
    /*
     NSArray *addresss = [[NSArray alloc] initWithObjects:@"学正街金沙居A座1826",@"费家塘路588号7号楼416",@"文三路90号东部软件园",@"多蓝氺岸碧海苑14栋1903",nil];
     self.addressArray = addresss;
     */
    
    
    if (orderType == 0) {
        self.fieldLabels = [[NSMutableArray alloc] initWithObjects:@"请选择地址",@"送餐时间:",@"配送方式:",@"支付方式:",@"优惠券:", @"备注:", nil];
    }else{
        self.fieldLabels = [[NSMutableArray alloc] initWithObjects:@"请选择地址",@"送餐时间:",@"点菜方式:", @"桌子号:" ,@"备注:", nil];
    }
    LineCount = [self.fieldLabels count];
    stateList = [[NSMutableArray alloc] init];
    //[array release];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    if (self.ordertimeDatePicker == nil) {
        self.ordertimeDatePicker = [[UIDatePicker alloc] init];
        [self.ordertimeDatePicker addTarget:self action:@selector(ordertimeDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        self.ordertimeDatePicker.frame = CGRectMake(0, viewHeight, 320, 240);
        //self.ordertimeDatePicker.datePickerMode = UIDatePickerModeTime ;//只显示时间//UIDatePickerModeDateAndTime;//日期和时间
        
        NSDate *currentDate = [NSDate date];
        
        //NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        //[dateComponents setYear:-18];
        
        //NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
        //[dateComponents release];
        
        NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:@"shopcartstatus"];
        NSTimeInterval  interval1 = 60*30; //30分钟

        if(status > 0 )//营业 当前时间顺延30分钟
        {
            interval1 = 60*30;
        }
        else//如果商家未营业则顺延24小时
        {
            interval1 = 24*60*60;
        }
        
        NSDate *rightdate = [currentDate initWithTimeIntervalSinceNow:+interval1];
        [self.ordertimeDatePicker setDate:rightdate animated:YES];
        
        NSTimeInterval  interval2 =24*60*60*7; //7:天数
        NSDate *maxdate = [currentDate initWithTimeIntervalSinceNow:+interval2];
        
        NSTimeInterval  interval3 =60*30; //30分钟后
        NSDate *mindate = [currentDate initWithTimeIntervalSinceNow:+interval3];
        
        [self.ordertimeDatePicker setMaximumDate:maxdate];
        [self.ordertimeDatePicker setMinimumDate:mindate];
       // [self.parentViewController.parentViewController.view addSubview:self.ordertimeDatePicker];
        // [app sharedDelegate].tabBarController.view addChildViewController:sele.ordertimeDatePicker
    }
    
    // Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"上一项", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"下一项", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    
    /*
    {
        UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
        NSDate *currentDate = [NSDate date];
        
        int status = [[NSUserDefaults standardUserDefaults] integerForKey:@"shopcartstatus"];
        NSTimeInterval  interval1 = 60*30; //30分钟
        
        if(status > 0 )//营业 当前时间顺延30分钟
        {
            interval1 = 60*30;
        }
        else//如果商家未营业则顺延24小时
        {
            interval1 = 24*60*60;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-M-d HH:mm:ss"];
        
        NSDate *rightdate = [currentDate initWithTimeIntervalSinceNow:+interval1];
        [self.ordertimeDatePicker setDate:rightdate animated:YES];
        textview4.text = [formatter stringFromDate:rightdate];
    }
    */
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self ordertimeDatePickerHide:nil];
}



- (void)ordertimeDatePickerHide:(id)sender
{
    
    //return;
    if (isShowDatePick) {
        isShowDatePick = NO;
        UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:3];
        textview4.inputAccessoryView = self.keyboardToolbar;
        textview4.inputView = self.pickerOffline;
        /*CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        self.ordertimeDatePicker.frame = CGRectMake(0, viewHeight, 320, 240);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];*/
    }
    
}

-(void)ordertimeDataPickerShow:(id)sender
{
    
    //return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    [self.parentViewController.parentViewController.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    self.ordertimeDatePicker.frame = CGRectMake(0, orderTimePickY, 320, 240);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];

    isShowDatePick = YES;
}
#pragma mark UIToolBar
- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        
        rect.origin.y = 0;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect.origin.y += 64;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == LineCount ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:2];
    
    if (tag == 2 && [textview4.text isEqualToString:@""]) {
        [self setOrderTime];
    }
}

- (void)previousField:(id)sender
{
    [self ordertimeDatePickerHide:nil];
    id firstResponder = [self getFirstResponder];
    if (sender != nil && [firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        //[firstResponder resignFirstResponder];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        //UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        //if (nextLabel) {
        //    [self resetLabelsColors];
        //    [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        //}
        [self checkSpecialFields:tag];
    }
}

- (void)nextField:(id)sender
{
    [self ordertimeDatePickerHide:nil];
    id firstResponder = [self getFirstResponder];
    if (sender != nil && [firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == LineCount ? LineCount : tag + 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        
        UITextField *nextField = (UITextField *)[self.tableView viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        //UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        //if (nextLabel) {
        //    [self resetLabelsColors];
        //    [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        //}
        [self checkSpecialFields:tag];
    }
}

- (id)getFirstResponder
{
    [self ordertimeDatePickerHide:nil];
    NSUInteger index = 0;
    while (index <= LineCount) {
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

- (void)resignKeyboard:(id)sender
{
    [self ordertimeDatePickerHide:nil];
    id firstResponder = [self getFirstResponder];
    
    if (sender != nil && [firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        
        CGRect rect;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
            self.view.frame = rect;
        }else{
            rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
            self.view.frame = rect;
        }
        
        //[self resetLabelsColors];
    }
    [self animateView:1];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    //self.pickerself.address = nil;
    //self.addressArray = nil;
}

- (void)dealloc {
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    if (twitterClient) {
        [twitterClient release];
        twitterClient = nil;
    }
    
    [self.textFieldBeingEdited release];
    [self.tempValues release];
    [self.fieldLabels release];
    [couponKeyList release];
    [couponList release];
    [self.sendTime release];
    //[orderTableView release];
    //[shopcartDict release];
    [self.shopid release];
    [self.shopcartLabel release];
    [self.pickerCoupon release];
    [self.distributionArray release];
    [self.payTypeArray release];
    [self.offlineArray release];
    [self.couponArray release];
    
    [self.pickerDistribution release];
    [self.pickerOffline release];
    [self.pickerOnline release];
    [self.pickerPayType release];
    [self.ousername release];
    [self.oaddresse release];
    [self.otel release];
    [self.address release];
    [stateList release];
    [addrID release];
    [backClick release];
    RELEASE_SAFELY(ordertimeDatePicker_);
    RELEASE_SAFELY(keyboardToolbar_);
    
    if (indicator) {
        [indicator release];
        indicator = nil;
    }
    
    [super dealloc];
}





-(void)goToNewAddr:(id)senser{
    if (!isShowNewAddress) {
        isShowNewAddress = YES;
        app.reciverAddress = nil;
        app.reciverAddress = [[UserAddressMode alloc] init];
        UserAddressDetailViewController *controller = [[[UserAddressDetailViewController alloc] initWithShopID:[NSString stringWithFormat:@"%d", app.mShopModel.shopid]] autorelease];
        //[controller setTitle:@"新增地址"];
        [self.navigationController pushViewController:controller animated:true];
    }
    
}

-(void)selectAddr:(id)senser{


    if ([address count] == 0) {
        [self goToNewAddr:nil];
        return;
    }
    if (!isShowAddressList) {
        isShowAddressList = YES;
        UserAddressListViewController *viewController = [[[UserAddressListViewController alloc] initWithArry:address] autorelease];
        
        [self.navigationController pushViewController:viewController animated:true];
    }
    
}

-(void)selectCoupon:(id)senser{

    
    
    if (!isShowSelectCoupon) {
        isShowSelectCoupon = YES;
        if (couponList == nil) {
            couponList = [[NSMutableArray alloc] init];
            loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
            app.couponPage = 1;
            app.couponTotal = 1;
            
        }
        MyCouponListViewController *viewController = [[[MyCouponListViewController alloc] initWithcHasMoney:app.shopCart.allPrice arry:couponList keyArry:couponKeyList UserID:self.uduserid LoadCell:loadCell] autorelease];
        
        [self.navigationController pushViewController:viewController animated:true];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //填充信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.ousername = [defaults objectForKey:@"orderusername"];
    self.otel = [defaults objectForKey:@"ordertel"];
    self.oaddresse = [defaults objectForKey:@"orderaddress"];
    /*if ([app.shopCart count] == 0) {
     [self.navigationController popViewControllerAnimated:YES];
     }*/
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self ordertimeDatePickerHide:nil];
}

#pragma mark UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    [self ordertimeDatePickerHide:nil];
    
    [self checkBarButton:textField.tag];
    [self animateView:textField.tag];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    //[textField resignFirstResponder];
    if (textField.tag == remarkTag) {
        self.nsRemark = textField.text;
    }else if(textField.tag == payPasswordTag){
        self.payPassword = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    
        //
    if (COUPON_TAG != -1 && textField.tag >= COUPON_TAG) {
        int row = textField.tag - COUPON_TAG;
        MyCouponModel *model = [couponKeyList objectAtIndex:row];
        model.isSelect = 0;
        [couponKeyList removeObjectAtIndex:row];
        [self.tableView reloadData];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)strin
{
    if (COUPON_TAG != -1 && textField.tag >= COUPON_TAG && textField.tag < COUPON_TAG + [couponKeyList count] + 1) {
        //
        if (range.length > 0) {
            int row =(int) textField.tag - (int)COUPON_TAG;
            MyCouponModel *model = [couponKeyList objectAtIndex:row];
            model.isSelect = 0;
            [couponKeyList removeObjectAtIndex:row];
            [self.tableView reloadData];
            
        }
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        LineCount = (int)[self.fieldLabels count];
        if (UserCoupon == isCoupon) {
            LineCount += ([couponKeyList count] + 1);
            return LineCount;
            
        }
        return LineCount;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
	return 10.0f;
}

//设置rowHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70.0f;
        }
    }
    if (indexPath.section == 1) {
        return 40.0f;
    }
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PresidentCellIdentifier = @"RegeditCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleDefault;
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];

    //生成cell
    //if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:style 
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
        if (indexPath.section == 1) {
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(110, 1, 110, 40)];
            [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            //label.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            
            //[label setTitle:@"提交订单" forState:UIControlStateNormal];
            [label setImage:[UIImage imageNamed:@"gp_submit.png"] forState:UIControlStateNormal];
            [label addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchDown];
            
            
            [cell.contentView addSubview:label];
            
            
            [label release];
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(10, 7, 75, 25)];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = RegeditViewLabelTag;
            label.font = [UIFont boldSystemFontOfSize:14];
            [label setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:label];
            [label release];
            
            
            UITextField *textField = [[UITextField alloc] initWithFrame:
                                      CGRectMake(90, 12, 200, 25)];
            textField.clearsOnBeginEditing = NO;
            [textField setDelegate:self];
            [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.textColor = [UIColor grayColor];
            textField.backgroundColor = [UIColor clearColor];
            //设置键盘完成按钮，相应的还有“Return”"GO""Google"等
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [cell.contentView addSubview:textField];
            
            if (indexPath.row == 0) {
                UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(230, 37, 80, 35)];
                [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
                //label.backgroundColor=[UIColor colorWithRed:169/255.0 green:118/255.0 blue:15/255.0 alpha:1.0];
                label.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                //[label setTitle:@"新增地址" forState:UIControlStateNormal];
                [label setImage:[UIImage imageNamed:@"new_addr.png"] forState:UIControlStateNormal];
                [label addTarget:self action:@selector(goToNewAddr:) forControlEvents:UIControlEventTouchDown];
                
                
                [cell.contentView addSubview:label];
                
                
                [label release];
            }
        }
        
        
    //}
    if (indexPath.section == 0) {
        //cell左侧填充内容
        //cell右侧填充内容
        UITextField *textField = nil;
        
        for (UIView *oneView in cell.contentView.subviews)
        {
            if ([oneView isMemberOfClass:[UITextField class]])
            {
                textField = (UITextField *)oneView;
            }
        }
        textField.tag = indexPath.row + 1;
        UILabel *label = (UILabel *)[cell viewWithTag:RegeditViewLabelTag];
        if (isCoupon == UserCoupon) {
            //int count = [couponKeyList count];
            
            if (indexPath.row >= rowStartCoupon && indexPath.row <= [couponKeyList count] + rowStartCoupon && [couponKeyList count] < 5) {
                //显示优惠券区域内
                int nrow = (int)indexPath.row - (int)rowStartCoupon;
                if (nrow + 1 < 5) {
                    COUPON_TAG = rowStartCoupon + 1;
                    label.text = [NSString stringWithFormat:@"优惠券%d:", nrow + 1];
                    if (nrow < [couponKeyList count]) {
                        textField.inputAccessoryView = self.keyboardToolbar;
                        textField.returnKeyType = UIReturnKeyDone;  
                        //textField.enabled = NO;
                        
                        textField.clearButtonMode = UITextFieldViewModeAlways;
                        textField.delegate = self;
                        MyCouponModel *model = [couponKeyList objectAtIndex:nrow];
                        textField.text = model.CKey;
                    }else{
                        //textField.enabled = NO;
                        textField.text = @"点击新增";
                        [textField addTarget:self action:@selector(selectCoupon:) forControlEvents:UIControlEventEditingDidBegin];
                    }
                }else{
                    textField.text = @"每次最多只能使用4张优惠券";
                }
                textField.tag = indexPath.row + 1;
                
                
                return cell;
                
                
            }else{
                if (row > rowStartCoupon) {
                    textField.placeholder = @"请输入备注";
                    textField.inputAccessoryView = self.keyboardToolbar;
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.text = self.nsRemark;
                    row = rowStartCoupon;
                    remarkTag = (int)textField.tag;
                    
                }
                label.text = [self.fieldLabels objectAtIndex:row];
            }
            
        }else{
            label.text = [self.fieldLabels objectAtIndex:row];
        }
        
        
        
        
        textField.delegate = self;
        
        //cell.hidden = NO;
        //@"选择地址:",@" 联系人:",@"  电话:", @"  地址:",@"送餐时间:"
        //NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
        switch (row) {
                
                
            case 0:
                textField.placeholder = @"请选择地址薄中的地址";//设置默认显示文本
                //textField.tag = 1;
                textField.text = [NSString stringWithFormat:@"%@, %@, %@", app.reciverAddress.address, app.reciverAddress.receiverName, app.reciverAddress.phone];
                [textField addTarget:self action:@selector(selectAddr:) forControlEvents:UIControlEventEditingDidBegin];
                break;
                
            case 1:
                textField.placeholder = @"选择时间，提前购买有优惠！";
                textField.text = self.sendTime;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                textField.inputView = self.ordertimeDatePicker;
                textField.delegate = self;
                break;
            case 2:
                textField.placeholder = @"选择配送方式";
                if (orderType == 0) {
                    textField.text = @"送货上门";
                }else{
                    textField.text = @"到店自提";
                }
                
                textField.inputView = self.pickerDistribution;
               
                textField.delegate = self;
                //textField.tag = 3;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                
                break;
                
            case 3:
                if (orderType == CusterPicup) {//自取
                    textField.placeholder = @"请选择取货点";
                    if ([stateList count] > 0) {
                        SelfStateModel *model = [stateList objectAtIndex:nSelectStateIndex];
                        textField.text = model.stateName;
                        //stateId = model.stateID;
                    }
                    textField.inputView = self.pickerOffline;
                    
                }else{
                    textField.placeholder = @"选择支付方式";
                    textField.inputView = self.pickerPayType;
                    textField.text = [self.payTypeArray objectAtIndex:payType];
                }
                textField.delegate = self;
                //textField.tag = 4;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                break;
            
            case 4:
                //textField.tag = 5;
                textField.delegate = self;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                [textField setSecureTextEntry:NO];
                if (orderType == CusterPicup) {//自取
                    textField.placeholder = @"选择支付方式";
                    textField.text = [self.payTypeArray objectAtIndex:payType];
                    textField.inputView = self.pickerPayType;
                }else{//送货
                    textField.inputView = nil;
                    textField.text = @"";
                    if (payType == PayInCusterAccount) {//账户扣款
                        payPasswordTag = (int)textField.tag;
                        textField.placeholder = @"请输入支付密码";
                        textField.text = self.payPassword;
                        [textField setSecureTextEntry:YES];
                    }else{
                        textField.inputView = self.pickerCoupon;
                        if (isCoupon == UserCoupon) {
                            textField.text = @"使用";
                        }else{
                            textField.text = @"不使用";
                        }
                        rowStartCoupon = 5;
                        
                    }
                    
                    
                }
                break;
            case 5:
               // textField.tag = 6;
                [textField setSecureTextEntry:NO];
                if (orderType == CusterPicup) {//自取
                    textField.inputView = nil;
                    textField.text = @"";
                    if (payType == PayInCusterAccount) {//账户扣款
                        payPasswordTag = (int)textField.tag;
                        textField.placeholder = @"请输入支付密码";
                        textField.text = self.payPassword;
                        [textField setSecureTextEntry:YES];
                    }else{
                        textField.inputView = self.pickerCoupon;
                        if (isCoupon == UserCoupon) {
                            textField.text = @"使用";
                        }else{
                            textField.text = @"不使用";
                        }
                        rowStartCoupon = 6;
                    }
                }else{//送货
                    textField.inputView = nil;
                    textField.text = @"";
                    if (payType == PayInCusterAccount) {//账户扣款
                        textField.inputView = self.pickerCoupon;
                        if (isCoupon == UserCoupon) {
                            textField.text = @"使用";
                        }else{
                            textField.text = @"不使用";
                        }
                        rowStartCoupon = 6;
                    }else{
                        remarkTag = (int)textField.tag;
                        textField.placeholder = @"请输入备注";
                        textField.text = self.nsRemark;
                        textField.returnKeyType = UIReturnKeyDone;
                        
                    }
                }
                textField.inputAccessoryView = self.keyboardToolbar;
                break;
            case 6:
                if (orderType == CusterPicup) {//自取
                    textField.inputView = nil;
                    textField.text = @"";
                    if (payType == PayInCusterAccount) {//账户扣款
                        textField.inputView = self.pickerCoupon;
                        if (isCoupon == UserCoupon) {
                            textField.text = @"使用";
                        }else{
                            textField.text = @"不使用";
                        }
                        rowStartCoupon = 7;
                    }else{
                        //选择优惠券
                        remarkTag = (int)textField.tag;
                        textField.placeholder = @"请输入备注";
                        textField.text = self.nsRemark;
                        textField.returnKeyType = UIReturnKeyDone;
                        
                    }
                }else{//送货
                    textField.inputView = nil;
                    textField.text = @"";
                    if (payType == PayInCusterAccount) {//账户扣款
                        remarkTag = (int)textField.tag;
                        textField.placeholder = @"请输入备注";
                        textField.text = self.nsRemark;
                        textField.returnKeyType = UIReturnKeyDone;
                    }else{
                        
                        
                        //选择优惠券
                        textField.inputView = self.pickerCoupon;
                        if (isCoupon == UserCoupon) {
                            textField.text = @"使用";
                        }else{
                            textField.text = @"不使用";
                        }
                        rowStartCoupon = 7;
                    }
                }
                
                
                //textField.tag = 7;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                break;
            case 7:
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                textField.placeholder = @"请输入备注";
                textField.text = self.nsRemark;
                remarkTag = (int)textField.tag;
                textField.returnKeyType = UIReturnKeyDone;
                break;
            default:
                break;
        }
        
        if (self.textFieldBeingEdited == textField)
        {
            self.textFieldBeingEdited = nil;
        }

    }
    
    
    //textField.tag = row;
    return cell;
        
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section == 0 && indexPath.row == 0 )
    {
        NSLog(@"------------didSelectRowAtIndexPath ");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //输入框点击行时不做任何处理
    if(indexPath.section == 0 )
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return self.distributionArray.count;
    }
    else if( pickerView.tag == 2)
    {
        return self.payTypeArray.count;
    }
    else if( pickerView.tag == 3)
    {
        return self.offlineArray.count;
    }
    else if( pickerView.tag == 4)
    {
        return [stateList count];
    }
    else if(pickerView.tag == 5)
    {
        return [self.couponArray count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return [self.distributionArray objectAtIndex:row];
    }
    else if( pickerView.tag == 2)
    {
        return [self.payTypeArray objectAtIndex:row];
    }
    else if( pickerView.tag == 3)
    {
        return [self.offlineArray objectAtIndex:row];
    }
    else if( pickerView.tag == 4)
    {
        if (stateList == nil || [stateList count] == 0) {
            return  nil;
        }
        SelfStateModel *model = [stateList objectAtIndex:row];
        return model.stateName;
    }
    else if(pickerView.tag == 5)
    {
        
        return [self.couponArray objectAtIndex:row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    [self ordertimeDatePickerHide:nil];
    if( pickerView.tag == 1)
    {//送货或者自提
       
        
        orderType = row;
        //self.fieldLabels = [[NSMutableArray alloc] initWithObjects:@"请选择地址",@"送餐时间:",@"配送方式:",@"支付方式:",@"优惠券",@"备注:", nil];
        if (orderType == CusterPicup) {//自取
            nSelectStateIndex = 0;
            [self.fieldLabels replaceObjectAtIndex:1 withObject:@"取货时间"];
            if (payType == PayInCusterAccount) {
                if ([self.fieldLabels count] < 8) {
                    [self.fieldLabels insertObject:@"取货点" atIndex:3];
                    rowStartCoupon++;
                }
            }else{
                if ([self.fieldLabels count] < 7) {
                    [self.fieldLabels insertObject:@"取货点" atIndex:3];
                    rowStartCoupon++;
                }
            }
            
            
        }else{//送货
            nSelectStateIndex = -1;
            [self.fieldLabels replaceObjectAtIndex:1 withObject:@"送货时间"];
            if (payType == PayInCusterAccount) {
                if ([self.fieldLabels count] > 7) {
                    [self.fieldLabels removeObjectAtIndex:3];
                    rowStartCoupon--;
                }
            }else{
                if ([self.fieldLabels count] > 5) {
                    [self.fieldLabels removeObjectAtIndex:3];
                    rowStartCoupon--;
                }
            }
            
        }
        //LineCount = [self.fieldLabels count];
        [self.tableView reloadData];
    }
    else if( pickerView.tag == 2)
    {//支付方式
        /*UITextField *textview6 = (UITextField *)[self.tableView viewWithTag:4];
        textview6.text = [self.payTypeArray objectAtIndex:row];*/
        payType = (int)row;
        if (orderType == CusterPicup) {//自取
            if (payType == PayInCusterAccount) {//账户扣款
                if ([self.fieldLabels count] < 8) {
                    [self.fieldLabels insertObject:@"支付密码" atIndex:5];
                    rowStartCoupon++;
                }
            }else{
                if ([self.fieldLabels count] > 7) {
                    payPasswordTag = -1;
                    [self.fieldLabels removeObjectAtIndex:5];
                    rowStartCoupon--;
                }
            }
        }else{//送货
            if (payType == PayInCusterAccount) {//账户扣款
                if ([self.fieldLabels count] < 7) {
                    [self.fieldLabels insertObject:@"支付密码" atIndex:4];
                    rowStartCoupon++;
                }
            }else{
                if ([self.fieldLabels count] > 6) {
                    payPasswordTag = -1;
                    [self.fieldLabels removeObjectAtIndex:4];
                    rowStartCoupon--;
                }
            }
            
        }
        //LineCount = [self.fieldLabels count];
        [self.tableView reloadData];
    }
    else if( pickerView.tag == 3)
    {
        //UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:7];
        //textview4.text = [onlineArray objectAtIndex:row];
    }
    else if( pickerView.tag == 4)
    {
        UITextField *textview6 = (UITextField *)[self.tableView viewWithTag:4];
        SelfStateModel *model = [stateList objectAtIndex:row];
        nSelectStateIndex = (int)row;
        textview6.text = model.stateName;
    }
    else if(pickerView.tag == 5)
    {
        
        
        isCoupon = (int)row;
        [self.tableView reloadData];
        if (isCoupon == UserCoupon) {
            if ([couponKeyList count] == 0) {
                [self selectCoupon:nil];
            }
        }else{
            COUPON_TAG = -1;
        }
        
    }

}


@end