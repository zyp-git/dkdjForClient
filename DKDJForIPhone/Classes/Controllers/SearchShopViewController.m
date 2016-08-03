//
//  SearchShop.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchShopViewController.h"
#import "ShopNewListViewController.h"
#import "HJButton.h"
@implementation SearchShopViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat height = 64;
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
//    backBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(searchClick:)];
//    backBtn.tintColor=[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = backBtn;
    
    
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
 

    UILabel * name = [[UILabel alloc] initWithFrame:RectMake_LFL(10, height, 355, 30)];
    name.text = @"分类查找";
    name.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:name];

    //self.view.backgroundColor = [UIColor whiteColor];
    height += 30;
    
    shoptypeTableView = [[UITableView alloc] initWithFrame:RectMake_LFL(0, height, 375, self.view.frame.size.height - height)];
    shoptypeTableView.backgroundColor = [UIColor clearColor];
    shoptypeTableView.dataSource = self;
    shoptypeTableView.delegate = self;
    shoptypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    shoptypeTableView.scrollEnabled = NO;
    [self.view addSubview:shoptypeTableView];
    
    if ([app.shopTypeArry count] == 0) {
        [self GetGuidShopTypeListData];
    }else{
        tableRowCount = (int)[app.shopTypeArry count] / 3;
        if ([app.shopTypeArry count] % 3 != 0) {
            tableRowCount++;
        }
    }

}
-(void)goToBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithKeywords:searchBar.text];
    [self.navigationController pushViewController:controller animated:true];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithKeywords:searchBar.text];
    [self.navigationController pushViewController:controller animated:true];
}
-(void)searchClick:(UIButton *) btn
{
    
    [search resignFirstResponder];
    
    if (search.text.length > 0) {
        
        ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithKeywords:search.text];
        
        [self.navigationController pushViewController:controller animated:true];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提示") message:CustomLocalizedString(@"search_notice", @"请输入关键字") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)shopStatusClick:(UIButton *)btn{
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithOpenType:((int)btn.tag - 1) shopType:@"0"];
    
    [self.navigationController pushViewController:controller animated:true];
}

-(void)shopTypeClick:(UIButton *)btn
{
    NSInteger row = btn.tag - 1;
    NSInteger n = [shoptypeTableView indexPathForCell:(UITableViewCell *)[[btn superview] superview] ].row;
    n *= 3;
    row += n;
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithOpenType:2 shopType:[NSString stringWithFormat:@"%d", ((ShopTypeModel *)[app.shopTypeArry objectAtIndex:row]).typeID]];
    
    [self.navigationController pushViewController:controller animated:true];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}



-(void)handleSearchForTerm:(NSString *)searchterm{
    

}

#pragma mark 获取商家分类
-(void) GetGuidShopTypeListData
{
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"1", @"pid",@"1", @"indexpage", @"100", @"pagesize",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    twitterClient1 = [[TwitterClient alloc] initWithTarget:self action:@selector(guidShopTypeDidReceive:obj:)];
    
    [twitterClient1 getShopTypeWithParams:param];

}

- (void)guidShopTypeDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    twitterClient1 = nil;
    
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

    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    

    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
//    int index = [app.shopTypeArry count];
    ShopTypeModel *model = [[ShopTypeModel alloc] init];
    model.typeName = CustomLocalizedString(@"public_all_type", @"全部分类");
    model.typeID = 0;
    [app.shopTypeArry addObject:model];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        model = [[ShopTypeModel alloc] initWithChildJsonDictionary:dic];
        /*model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.typeID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:-1];
         [model setImg:model.picPath Default:@"暂无图片"];*/
        
        [app.shopTypeArry addObject:model];
    }
    tableRowCount = (int )[app.shopTypeArry count] / 3;
    if ([app.shopTypeArry count] % 3 != 0) {
        tableRowCount++;
    }
    [shoptypeTableView reloadData];
    
    //[imageDownload startTask];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    
    return tableRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    {
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier];

            
            UIButton *btn = [[UIButton alloc] initWithFrame:RectMake_LFL(10, 0, 335/3, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
            btn.tag = 1;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shopTypeClick:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview: btn];
            
            UIButton *btn1 = [[UIButton alloc] initWithFrame:RectMake_LFL(20+335/3, 0.0, 335/3, 20)];
            [btn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
            btn1.tag = 2;
            btn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shopTypeClick:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview: btn1];
            
            UIButton *btn2 = [[UIButton alloc] initWithFrame:RectMake_LFL(30+335/3*2, 0.0, 335/3, 20)];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
            btn2.tag = 3;
            btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shopTypeClick:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview: btn2];
    
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
            cell.backgroundColor = [UIColor clearColor];
            
            
            
            
        }
        NSInteger row = indexPath.row * 3;
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:1];
        UIButton *btn1 = (UIButton *)[cell.contentView viewWithTag:2];
        UIButton *btn2 = (UIButton *)[cell.contentView viewWithTag:3];
        if (row < [app.shopTypeArry count]) {
            ShopTypeModel *foodmodel = [app.shopTypeArry objectAtIndex:row];
            [btn setHidden:NO];
           // btn.tag = row;
            [btn setTitle:foodmodel.typeName forState:UIControlStateNormal];
            row++;
            if (row < [app.shopTypeArry count]) {
                foodmodel = [app.shopTypeArry objectAtIndex:row];
                [btn1 setHidden:NO];
               //  btn1.tag = row;
                [btn1 setTitle:foodmodel.typeName forState:UIControlStateNormal];
                row++;
                if (row < [app.shopTypeArry count]) {
                    foodmodel = [app.shopTypeArry objectAtIndex:row];
                    [btn2 setHidden:NO];
                 //    btn2.tag = row;
                    [btn2 setTitle:foodmodel.typeName forState:UIControlStateNormal];
                    row++;
                }else{
                    [btn2 setHidden:YES];
                }
            }else{
                [btn1 setHidden:YES];
                [btn2 setHidden:YES];
            }
        }else{
            [btn setHidden:YES];
            [btn1 setHidden:YES];
            [btn2 setHidden:YES];
        }
        
        return cell;
        
        
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
}


@end
