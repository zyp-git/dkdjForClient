//
//  HJListViewPop.m
//  JYBE
//
//  Created by ihangjing on 15/4/2.
//
//

#import "HJListViewPop.h"
#import "ShopTypeModel.h"
#define TABLE_ITEM_HEIGHT 37;
@implementation HJListViewPop

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//zyp 类型表
-(HJListViewPop *)initWithView:(UIView *)view childViewPosition:(CGPoint)point aryValue:(NSMutableArray *)ary showType:(int)Type  popType:(int)pType
{
    self = [super initWithView:view];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        dataAry = ary;
        showType = Type;
        popType = pType;
        float heigth =CGRectGetMaxY(RectMake_LFL(0, 0, 0, dataAry.count*37));
        if (heigth > 400) {
            heigth = 400;
        }
        
        if (showType == 1) {
            dataTable = [[UITableView alloc] initWithFrame:RectMake_LFL(point.x, point.y, 375, heigth)];//(point.x, point.y, 160, heigth)];
            dataTable.tag = 1;
            dataTable.delegate = self;
            dataTable.dataSource = self;
            dataTable.backgroundColor = [UIColor whiteColor];
            dataTable.backgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
            
            dataTable1 = [[UITableView alloc] initWithFrame:RectMake_LFL(point.x + 160, point.y, 160, heigth)];
            dataTable1.tag = 2;
            dataTable1.delegate = self;
            dataTable1.dataSource = self;
            dataTable1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            dataTable1.backgroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
            dataTable1.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
            [self addSubview:dataTable1];
        }else{
            dataTable = [[UITableView alloc] initWithFrame:RectMake_LFL(point.x, point.y, 375, heigth)];
            dataTable.tag = 1;
            dataTable.delegate = self;
            dataTable.dataSource = self;
            dataTable.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            dataTable.backgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
        }
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:RectMake_LFL(0.0, heigth+94, 375 , 18)];
        imgView.image = [UIImage imageNamed:@"btn_dropdown_packup"];
        [self addSubview:dataTable];
        
        [self addSubview:imgView];
    }
    
    return self;
}
-(void)setDataArry2:(NSMutableArray *)ary
{
    dataAry1 = ary;
    [dataTable1 reloadData];
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return dataAry.count;
    }else{
        return dataAry1.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        
        
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier];
            if (showType == 1) {
                UILabel *label = [[UILabel alloc] initWithFrame:RectMake_LFL(15.0, 0.0, 300, 35)];
                label.tag = 1;
                label.font = [UIFont systemFontOfSize:15.0];
                [cell.contentView addSubview:label];
                UIImageView *line = [[UIImageView alloc] initWithFrame:RectMake_LFL(0.0, 36, 375, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [cell.contentView addSubview:line];

                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                if (tableView.tag == 1) {
                    cell.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                }else{
                    cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                }
            }else{
                UILabel *label = [[UILabel alloc] initWithFrame:RectMake_LFL(15.0, 0.0, 300, 35)];
                label.tag = 1;
                label.font = [UIFont systemFontOfSize:15.0];
                [cell.contentView addSubview:label];
                UIImageView *line = [[UIImageView alloc] initWithFrame:RectMake_LFL(0.0, 36, 375, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [cell.contentView addSubview:line];
                
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                if (tableView.tag == 1) {
                    cell.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                }else{
                    cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                }
            }
            
            
            
        }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if (popType == 0) {
        ShopTypeModel *model;// = [dataAry objectAtIndex:indexPath.row];
        if (tableView.tag == 1) {
            model = [dataAry objectAtIndex:indexPath.row];
        }else{
            model = [dataAry1 objectAtIndex:indexPath.row];
        }
        label.text = model.typeName;
    }else{
        label.text = [dataAry objectAtIndex:indexPath.row];
    }
    
    return cell;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGRectGetMaxY(RectMake_LFL(0, 0, 0, 37));
    
}



//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super _close:((int)tableView.tag - 1) index:(int)indexPath.row];
    
    
}

#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[deleteDic removeObjectForKey:[self.activitys objectAtIndex:indexPath.row]];
    
}

@end
