//
//  OrderDetailViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "FoodInOrderModelFix.h"
#import "LoadCell.h"
#import "CommendDetailViewController.h"

@implementation OrderDetailViewController

@synthesize orderid;
//@synthesize ordersTableView;
@synthesize foods;
@synthesize dic;
@synthesize shopcartDict;
@synthesize stateString;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    shopcartDict = [NSMutableArray array];
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
}

-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callTell:(id)sener
{
    
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"拨打电话"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"拨打电话" otherButtonTitles:nil, nil,nil];
    menu.tag = 1;
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    //[menu showInView: self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", shopTel]];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        //记得添加到view上
        [self.view addSubview:callWebview];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", shopTel]]];
    }
}

//建筑物列表视图中切换到商家列表中时调用此函数
- (id)initWithOrderid:(NSString*)OrderId
{
    if (self = [super initWithNibName:@"OrderDetailView" bundle:nil]) {
        //self.navigationItem.title = @"订单详情";
    }
    
    self.orderid = OrderId;
        
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderDidReceive:obj:)];
        
    [twitterClient getOrderByOrderId:self.orderid];
        
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  

    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    return self;
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;  
}


- (void)orderDidReceive:(TwitterClient*)client obj:(NSObject*)obj{

    twitterClient = nil;
    
    if (client.hasError) {
        [client alert];
        return;
    }

    if (obj == nil)
    {
        return;
    }
    //NSString *json = [NSString stringWithFormat:@"%@", obj];// stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
                      
    //json = [json stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    //1. 获取信息
    self.dic = (NSDictionary*)obj;
    
    NSString *OrderID = [self.dic objectForKey:@"OrderID"];
    //shopTel = [self.dic objectForKey:@"togoPhone"];

    NSLog(@"OrderID----%@", OrderID);
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [self.dic objectForKey:@"foodlist"];
    
    if ([ary count] == 0) {
        NSLog(@"[ary count] == 0");
        return;
    }
    
    // 将获取到的数据进行处理 形成列表
    NSLog(@"[ary count] == %lu",(unsigned long)[ary count]);
    
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        FoodInOrderModelFix *model = [[FoodInOrderModelFix alloc] initWithDictionaryFix:dict];
        
        [shopcartDict addObject:model];
        
        NSLog(@"[shopcartDict count] :%lu",(unsigned long)[shopcartDict count]);

    }
    
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    [self.tableView reloadData];
    
    NSLog(@"tableView reloadData");
}

-(void)gotoComment:(id)sender{
    NSUInteger row;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    FoodInOrderModelFix *ordermodel = [self.shopcartDict objectAtIndex:row];
    UIViewController *viewController = [[CommendDetailViewController alloc] initWithFood:ordermodel orderID:self.orderid];
    
    [self.navigationController pushViewController:viewController animated:true];
}
-(void)gotoShare:(id)sender{
//    UIButton *btnShare = (UIButton *)sender;
//    int index = btnShare.tag - 1;
//    FoodInOrderModelFix *ordermodel = [self.shopcartDict objectAtIndex:index];
//    NSString *content = [NSString stringWithFormat:@"hi！我在花马巴黎：http://hmbl.cn，购买的%@，非常不错哦！来推荐你也来尝尝！http://hmbl.cn/ShowFood.aspx?id=%@", ordermodel.foodname, ordermodel.foodid];
//    NSString *url = [NSString stringWithFormat:@"http://hmbl.cn/ShowFood.aspx?id=%@", ordermodel.foodid];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row == [shopcartDict count]) {
    //    return loadCell;
    //}
    
    static NSString *PresidentCellIdentifier = @"OrderDetailCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];
    

    cell = [[UITableViewCell alloc] initWithStyle:style
                                       reuseIdentifier:PresidentCellIdentifier];
    if( self.dic == nil )
    {
        NSLog(@"self.dic == nil");
        return cell;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];

    NSLog(@"indexPath.section %ld",(long)indexPath.section);
    
    if( indexPath.section == 0 )
    {
        NSLog(@"row:%lu", (unsigned long)row);
        cell.detailTextLabel.text = @"";

        NSString *TotalPrice = [self.dic objectForKey:@"TotalPrice"];
        NSString *SendMoney = [self.dic objectForKey:@"sendmoney"];
        
        
        switch (row) {
            case 0:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"订单号:%@",[self.dic objectForKey:@"OrderID"]];
                //由于下面的菜单列表中有 detailTextLabel cell复用滚动后 菜单的价格信息会在这里显示，所以要进行清除
                break;
            /*case 1:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"餐馆名称:%@",[self.dic objectForKey:@"TogoName"]];
                break;*/
            case 1:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"下单时间:%@",[self.dic objectForKey:@"orderTime"]];
                break;
            case 2:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"折扣信息:%@",[self.dic objectForKey:@"discountmsy"]];
                break;
                
            case 3:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"优惠券支付:%@",[self.dic objectForKey:@"cardpay"]];
                break;
            case 4:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"餐品合计:¥%.2f",[TotalPrice floatValue]];
                break;
            case 5:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"送餐费:¥%.2f",[SendMoney floatValue]];
                break;
            case 6:
            {
                float allprice = [TotalPrice floatValue];
                float sendmoney = [SendMoney floatValue];
                int discount = [[self.dic objectForKey:@"discount"] intValue];
                float po = 1.0f;
                if (discount > 0) {
                    po = discount / 100.0f;
                }
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"订单总计:¥%.2f",(allprice+sendmoney)  * po];
                break;
            }
            case 7:
            {
                NSString *state = [[NSString alloc] initWithFormat:@"%@",[self.dic objectForKey:@"orderstr"]];
                
                NSLog(@"state:%@", state);
                
                //订单状态
                /*
                if( [state compare:@"1"] == NSOrderedSame )
                {
                    stateString = @"新增订单";
                }
                else if([state compare:@"1"] == NSOrderedSame )
                {
                    stateString = @"审核通过";
                }
                else if([state compare:@"4"] == NSOrderedSame )
                {
                    stateString = @"正在配送";
                }
                else if([state compare:@" 5"] == NSOrderedSame )
                {
                    stateString = @"处理成功";
                }
                else if([state compare:@"6"] == NSOrderedSame )
                {
                    stateString = @"订单取消";
                }
                */
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"状态:%@",state];
                break;
            }
            case 8:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"支付状态:%@",[self.dic objectForKey:@"paystate"]];
                break;
            case 9:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"支付方式:%@",[self.dic objectForKey:@"PayMode"]];
                break;
            case 10:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"网银支付:¥%.1f",[[self.dic objectForKey:@"alipaymoney"] floatValue]];
                break;
            case 11:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"礼品卡支付:¥%.1f",[[self.dic objectForKey:@"cardpay"] floatValue]];
                break;
            case 12:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"店铺券支付:¥%.1f",[[self.dic objectForKey:@"ShopCardpay"] floatValue]];
                break;
            case 13:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"配送方式:%@",[self.dic objectForKey:@"sendtype"]];
                break;
            default:
                break;
        }
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:1985];
        if (btn != nil) {
            [btn removeFromSuperview];
        }
    }
    else if( indexPath.section == 1 )
    {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.text = @"";
        /*{"TotalPrice":"25.00","UserName":"测试","Tel":"13750821675","State":"0","UserID":"222","foodlist":[],"TogoName":"测试商家1","orderTime":"2012-10-04 18:00:37","OrderType":"普通订单","usersn":"","sendtype":"商家配送 - 送货上门","timename":"送货时间","PayMode":"货到付款","paymoney":"0","paytime":"2012/10/4 18:00:37","paystate":"未支付","orderstr":"订单提交","TogoId":"6","Address":"廊坊 开发区东方大学城测试地址","sendmoney":"2","Packagefree":"0","OrderID":"121004180037002220","SentTime":"2012-10-05 18:44","Remark":" 少放辣椒 多放辣椒 不放香菜 不放姜"}
         */
        switch (row) {
            case 0:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"联系人:%@",[self.dic objectForKey:@"UserName"]];
                break;
            case 1:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"联系电话:%@",[self.dic objectForKey:@"Tel"]];
                break;
            case 2:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"送货地址:%@",[self.dic objectForKey:@"Address"]];
                break;
            case 3:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"取/送货点:%@",[self.dic objectForKey:@"sitename"]];
                break;
            case 4:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"送餐时间:%@",[self.dic objectForKey:@"SentTime"]];
                break;
            case 5:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"备注:%@",[self.dic objectForKey:@"Remark"]];
                break;
            default:
                break;
        }
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:1985];
        if (btn != nil) {
            [btn removeFromSuperview];
        }
    }
    else if( indexPath.section == 2 )
    {
        FoodInOrderModelFix *ordermodel = [self.shopcartDict objectAtIndex:indexPath.row];
        
        if( ordermodel == nil)
        {
            NSLog(@"ordermodel == nil");
            return nil;
        }
        
        NSLog(@"ordermodel id:%@", ordermodel.foodid);

        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = ordermodel.foodname;
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f元x%d份",ordermodel.price, ordermodel.foodCount];
        if (ordermodel.isComment == 0) {
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 50, 20)];
            label.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            [label setTitle:@"评论" forState:UIControlStateNormal];
            label.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            [label addTarget:self action:@selector(gotoComment:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:label];
            label.tag = 1985;

        }else{
            UIButton *btn = (UIButton *)[cell.contentView viewWithTag:1985];
            if (btn != nil) {
                [btn removeFromSuperview];
            }
        }
        
        UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(260, 20, 50, 20)];
        btnShare.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [btnShare setTitle:@"分享" forState:UIControlStateNormal];
        btnShare.backgroundColor=[UIColor colorWithRed:169/255.0 green:118/255.0 blue:15/255.0 alpha:1.0];
        [btnShare addTarget:self action:@selector(gotoShare:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnShare];
        btnShare.tag = indexPath.row + 1;

    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //输入框点击行时不做任何处理
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if(section == 0 )
    {
        return @"订单信息";
    }
    else if(section == 1 )
    {
        return @"收货信息";
    }
    else if(section == 2 )
    {
        return @"餐品详情";
    }
    
    return nil;
}

//设置rowHeight  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    if( indexPath.section == 0 )
    {
        return 30.f;
    }
    else if( indexPath.section == 1 )
    {
        return 30.f;
    }
    else if( indexPath.section == 2 )
    {
        return 40.f;
    }
    
    return 40.f;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( section == 0 )
    {
        return 7;
    }
    else if( section == 1 )
    {
        return 6;
    }
    else if( section == 2 )
    {
        NSLog(@"[shopcartDict count] :%lu",(unsigned long)[shopcartDict count]);
        return [shopcartDict count];
    }
    
    return 0;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
@end
