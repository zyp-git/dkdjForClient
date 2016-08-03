//
//  ShopListViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 ihangjing.com. All rights reserved.
//

#import "UserAddressListViewController.h"
#import "LoadCell.h"
#import "ShopListCell.h"
#import "GiftDetailViewController.h"
#import "UserAddressMode.h"
#import "UserAddressDetail.h"
#import "UserAddressDetailViewController.h"
#import "HJPopViewNotice.h"
@implementation UserAddressListViewController{
    
    UIImageView* markImgView;
}

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

	}
    [self initPara];
	
	return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAddrList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    page = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的收货地址";

    UIBarButtonItem * backBtn=self.isFromOrder!=YES ?[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)]:[[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;

    isShowDeleteTable = NO;
    
    markImgView =[[UIImageView alloc]initWithFrame:RectMake_LFL(375-30, 46.5/2, 20, 20)];
    markImgView.image=[UIImage imageNamed:@"CheckMark选择"];
    
    self.tableView = [[UITableView alloc] initWithFrame:RectMake_LFL(0, 0, 375, 667)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 2;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    
    if (!isOutAddr) {
        UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithTitle:@"新增地址" style:UIBarButtonItemStyleDone target:self action:@selector(gotoNewAddr)];
        orderButton.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = orderButton;
    }
}

-(void)goToBack{
    if (self.isFromOrder) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(UserAddressListViewController:withModel:)]) {
            [self.delegate UserAddressListViewController:self withModel:self.address[indexPath.row]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//zyp 用户地址列表  新增地址按钮
-(void)gotoNewAddr{
    
    app.reciverAddress = nil;
    app.reciverAddress = [[UserAddressMode alloc] init];
    UserAddressDetailViewController *controller = [[UserAddressDetailViewController alloc] initDefault];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            //新增
            UserAddressDetail *newAddr = (UserAddressDetail *)alertView;
            self.userName = [[newAddr name] text];
            self.userPhone = [[newAddr phone] text];
            self.userAddr = [[newAddr address] text];
            if(self.userName.length < 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_reciver_empt", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (self.userAddr.length < 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_addr_empt", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (self.userPhone.length < 8) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_del_phone_error", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            [self editAddress:1 userName:self.userName userPhone:self.userPhone userAddress:self.userAddr uSex:nil];
            
        }
    }else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            //编辑
            UserAddressDetail *newAddr = (UserAddressDetail *)alertView;
            self.userName = [[newAddr name] text];
            self.userPhone = [[newAddr phone] text];
            self.userAddr = [[newAddr address] text];
            if(self.userName.length < 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_reciver_empt", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (self.userAddr.length < 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_addr_empt", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (self.userPhone.length < 8) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_del_phone_error", @"请输入正确的收货信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                return;
            }
            [self editAddress:0 userName:self.userName userPhone:self.userPhone userAddress:self.userAddr uSex:sexs];
        }else{
            //删除
            [self editAddress:-1 userName:nil userPhone:nil userAddress:nil uSex:nil];
        }
    }
}

-(void)editAddress:(int)type userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address uSex:(NSString*)sex{
    editType = type;
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(editAddressOK:obj:)];
    NSDictionary* param;
    if (type > -1) {
        if (type == 1) {//新增
            param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid,@"userid",@"1", @"op", name, @"receiver", address, @"address", phone, @"mobilephone", @" ", @"phone", nil];
        }else{//编辑
            param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid,@"userid",@"0", @"op", addressID, @"dataid", name, @"receiver", address, @"address", phone, @"mobilephone", sex, @"phone", nil];
        }
        
    }else{//删除
        param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid,@"userid",@"-1",@"op", addressID, @"dataid", nil];
    }
    
    
    [twitterClient saveUserAddressList:param];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
}

-(void)editAddressOK:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
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
        if (editType == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_edit_sucess", @"新增地址成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
        }else if(editType == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_edit_sucess", @"编辑地址成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
        }else{
            [self.address removeObjectAtIndex:row];
            if ([self.address count] == 0) {
                
                [self.tableView reloadData];
                
            }else{
                [self.tableView beginUpdates];
                NSMutableArray *newPath = [[NSMutableArray alloc] init];
                [newPath addObject:[NSIndexPath indexPathForRow:row inSection:0]];
                
                
                [self.tableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_list_del_sucess", @"删除地址成功") delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        page = 1;
        [self getAddrList];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_up_data_failed", @"更新数据失败！请稍后再试") delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    
    
}
// 经纬度 半径范围
- (id)initWithDefault
{
    [self initPara];
    self.address = [NSMutableArray array];
    isOutAddr = NO;
    return self;
}
// 
- (id)initWithArry:(NSMutableArray*)ary
{
    [self initPara];
    isOutAddr = YES;
    self.address = ary;
    
    return self;
}


-(void)updataUI{
    [self.tableView reloadData];
}

-(void)initPara
{
    //如果没有坐标 处理
    hasMore = false;
    page = 1;
    uaddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"uaddress"];
    shoptype = @"";
    istuan = @"0";
    shopname = @"";
    brandid = @"";
    isbrand = @"0";
    self.gTypeID = @"0";
    self.cTypeID = @"0";
    self.aid = @"0";
}


//商家分类列表中点击进入商家列表时调用此函数进行获取数据
- (id)initWithGiftType:(NSString*)giftType giftCType:(NSString*)giftCType
{
    [self initPara];
    
    self.gTypeID = giftType;
    self.cTypeID = giftCType;
    //self.navigationItem.title = shoptypename;

    [self getGiftList];
    
    return self;
}

-(void)getAddrList{

    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addressDidReceive:obj:)];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"pageindex",self.uduserid,@"userid",@"100",@"pagesize", nil];
    [twitterClient getUserAddressList:param];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_GIFTS];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;  
}  

- (void)addressDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }

    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = (int)[self.address count];//已经存在列表中的数量
    
    if (obj == nil){
        return;
    }

    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"total: %@",totalString);
        NSLog(@"page: %d",page);
    }

    
    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];

    if ([ary count] == 0) {
        hasMore = false;
    }
    //判断是否有下一页
    int totalpage = 1;//[totalString intValue];
    if( totalpage > page ){
        ++page;
        hasMore = true;
    }else{
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }
    //特别注意：此处如果设置未false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错 
    // 将获取到的数据进行处理 形成列表
    
    if (page == 1) {
       
        [self.address removeAllObjects];
        prevCount = 0;
    }
   
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        UserAddressMode *model = [[UserAddressMode alloc] initWithJsonDictionary:dic];
        [self.address addObject:model];
    }
    if (prevCount == 0) {
        //如果是第一页则直接加载表格 刚进来没有数据，获取后有数据时reload 显示数据
        [self.tableView reloadData];

    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[NSMutableArray alloc] init];
        //重新刷新表格显示数据
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];    
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isShowNotice"];
    if (value == nil || [value compare:@"1"] != NSOrderedSame)
    {
        HJPopViewNotice *pop = [[HJPopViewNotice alloc] initWithView:app.window];
        [pop showDialog];
        [defaults setObject:@"1" forKey:@"isShowNotice"];
        [defaults synchronize];
    }
    
}

- (void)viewDidUnload {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        twitterClient = nil;
    }
}


-(void)deleteAddress:(id)senser{
 
    UserAddressMode *AddressMode = [self.address objectAtIndex:row];
    if (app.reciverAddress != nil && [app.reciverAddress.buildingid compare:AddressMode.buildingid] == NSOrderedSame) {
        app.reciverAddress = nil;
    }
    addressID = AddressMode.aID;
    [self editAddress:-1 userName:nil userPhone:nil userAddress:nil uSex:nil];
}

-(void)editAddress:(id)senser{
    
    UserAddressMode *shopmodel = [self.address objectAtIndex:row];
    
    if( shopmodel == nil){
        return;
    }
    sexs = shopmodel.tel;
    addressID = shopmodel.aID;
    app.reciverAddress = shopmodel;
    UserAddressDetailViewController *controller = [[UserAddressDetailViewController alloc] initWithEdit];
    [self.navigationController pushViewController:controller animated:true];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//每个分类中包括多少行，由于只有一类，直接返回数组长度，如果对于多类别的，如年级的话，则可以返回每个年级中的班级数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.address count] == 0) {
        return 0;
    }

    return [self.address count];
    
}
//本函数用于显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//show load more cell
    if (indexPath.row == [self.address count]) {
            return loadCell;
    }
    else {
        
		static NSString *CellTableIdentifier = @"CellTableIdentifier";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier];
           
            
            
            UIView *cellFromView = [[UIView alloc] initWithFrame:RectMake_LFL(0, 0, 375, 66.5)];
            cellFromView.backgroundColor = [UIColor whiteColor];
            cellFromView.tag = 5;
            
            
            
            //1. 名称
            CGRect nameLabelRect = RectMake_LFL(10, 15, 375, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cellFromView addSubview: nameLabel];
            
            
            CGRect telLabelRect = RectMake_LFL(10,40, 375, 12);
            UILabel *telLabel = [[UILabel alloc] initWithFrame:
                                 telLabelRect];
            
            telLabel.textAlignment = NSTextAlignmentLeft;
            telLabel.font = [UIFont systemFontOfSize:14];
            telLabel.textColor = [UIColor lightGrayColor];
            telLabel.tag = 2;
            [cellFromView addSubview: telLabel];
 
            [cell.contentView addSubview:cellFromView];

            
            cell.selectionStyle = UITableViewCellSelectionStyleNone; 
           
		}
        UserAddressMode *shopmodel = [self.address objectAtIndex:indexPath.row];
        
        if( shopmodel == nil){
            return nil;
        }
        NSArray * array= [shopmodel.address componentsSeparatedByString:@"|"];
        UILabel *addressValue = (UILabel *)[cell.contentView viewWithTag:1];
        if (array.count==3) {
            addressValue.text = [[NSString alloc] initWithFormat:@"%@ %@",array[1],array[2]];
        }
        
        
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        
        nameLabel.text = [NSString stringWithFormat:@"%@\t%@", shopmodel.receiverName, shopmodel.phone];

        
        UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 66.5, 375, 0.6)];
        line.backgroundColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
        [cell.contentView addSubview:line];

        return cell;

    }
}
//每个行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGRectGetMaxY(RectMake_LFL(0, 0, 375, 66.5));
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isFromOrder) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView addSubview:markImgView];
    }else{
        
        app.reciverAddress = nil;
        app.reciverAddress=[self.address objectAtIndex:indexPath.row];

        UserAddressDetailViewController *controller = [[UserAddressDetailViewController alloc] initWithEdit];

        controller.model=[self.address objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:true];
    }
    
}

@end
