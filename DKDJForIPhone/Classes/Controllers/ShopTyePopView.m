//
//  ShopTyePopView.m
//  GZGJ
//
//  Created by ihangjing on 14/11/6.
//
//

#import "ShopTyePopView.h"

@implementation ShopTyePopView
static NSString *CellTableIdentifier = @"CellTableIdentifier";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(ShopTyePopView *) initinitWithView:(UIView *)view WithArry:(NSMutableArray *)ary
{
    self = [super initWithView:view];
    if (self) {
        dataArry = ary;
        dataTable = [[UITableView alloc] initWithFrame:CGRectMake(120, 0, 200, view.frame.size.height)];
        dataTable.delegate = self;
        dataTable.dataSource = self;
        dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
        
        dataTable.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
        //dataTable.backgroundColor = [UIColor whiteColor];
        dataTable.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:dataTable];
        
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [dataTable release];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArry count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
        
        
        
        UIImageView *typeIco = [[UIImageView alloc] init];
        [typeIco setTranslatesAutoresizingMaskIntoConstraints:NO];
        typeIco.image = [UIImage imageNamed:@"detail_ico.png"];
        [cell.contentView addSubview:typeIco];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
        nameLabel.numberOfLines = 1;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.tag = 3;
        
        [cell.contentView addSubview: nameLabel];
        
        UIImageView *line1 = [[UIImageView alloc] init];
        [line1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        line1.backgroundColor = [UIColor whiteColor];
        line1.tag = 4;
        [cell.contentView addSubview:line1];
        
        
        
        NSDictionary *dict1 = NSDictionaryOfVariableBindings(typeIco, nameLabel, line1);
        NSDictionary *metrics = @{@"hPadding":@25, @"vPadding":@5, @"linePadding":@0,@"nameTopPadding":@15,@"typeIcoWigth":@15,@"nameRightPadding":@-0};
        NSString *vfl = @"H:|-hPadding-[nameLabel]";
        NSString *vfl1 = @"H:[typeIco(typeIcoWigth)]-15-|";
        NSString *vfl2 = @"V:[line1(1)]-3-|";
        NSString *vfl3 = @"H:|-linePadding-[line1]-linePadding-|";
        NSString *vfl4 = @"V:|-nameTopPadding-[nameLabel(15)]";
        
        
        NSString *vfl5 = @"V:|-20-[typeIco(typeIcoWigth)]";
        
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
        [line1 release];
        [typeIco release];
        [nameLabel release];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    ShopTypeModel *model = [dataArry objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
    nameLabel.text = model.typeName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self close:(int)indexPath.row];
}
@end
