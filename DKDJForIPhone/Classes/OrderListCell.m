//
//  OrderListCell.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/6.
//
//

#import "OrderListCell.h"
#import "FoodInOrderModelFix.h"
#import "UserCommentTalbeViewController.h"
#import "UIImageView+WebCache.h"

@implementation OrderListCell{
    UIImageView * iconView;
}

+(OrderListCell *)cellFinishWithTableView:(UITableView *)tableView{
    OrderListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFinish"];
    if (!cell) {
        cell=[[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFinish"];
        
    }
    return cell;
}
+(OrderListCell  *)cellProcessWithTableView:(UITableView *)tableView{
    
    OrderListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellProcess"];
    if (!cell) {
        cell=[[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellProcess"];

    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier  isEqualToString: @"cellProcess"]) {
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
            
            UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 90, 375, 10)];
            line.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
            [self.contentView addSubview:line];
            
            //商家icon
            iconView=[[UIImageView alloc]initWithFrame:RectMake_LFL(10, 10, 95, 70)];
            [self.contentView  addSubview:iconView];
            
            UILabel * shopNameLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(115, 10, 180, 17)];
            shopNameLabel.font=[UIFont boldSystemFontOfSize:17];
            shopNameLabel.tag=1;
            [self.contentView addSubview:shopNameLabel];
            
            //时间
            UILabel *timeLable = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 13, 100, 12)];
            timeLable.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            timeLable.textAlignment = NSTextAlignmentRight;
            timeLable.font = [UIFont systemFontOfSize:11];
            timeLable.tag = 3;
            [self.contentView addSubview:timeLable];
            
            //价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 35.5, 100, 15)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = [UIFont systemFontOfSize:16];
            priceLabel.textColor = [UIColor colorWithRed:254/255.0 green:98/255.0 blue:102/255.0 alpha:1.0];
            priceLabel.tag = 2;
            [self.contentView addSubview:priceLabel];
            
            
            
            //订单状态
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 60.5, 100, 12)];
            statusLabel.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
            statusLabel.textAlignment = NSTextAlignmentRight;
            statusLabel.font = [UIFont systemFontOfSize:13];
            statusLabel.tag = 4;
            [self.contentView addSubview:statusLabel];
            
            //菜名
            UIView * foodNameView=[[UIView alloc]initWithFrame:RectMake_LFL(115, 33, 75, 60)];
            foodNameView.tag=5;
            [self.contentView addSubview:foodNameView];
        }else{
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
            
            UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 90, 375, 0.6)];
            line.backgroundColor=[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1];
            [self.contentView addSubview:line];
            
            //商家icon
            iconView=[[UIImageView alloc]initWithFrame:RectMake_LFL(10, 10, 95, 70)];
            [self.contentView  addSubview:iconView];
            //店名
            UILabel * shopNameLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(115, 10, 180, 17)];
            shopNameLabel.font=[UIFont boldSystemFontOfSize:17];
            shopNameLabel.tag=1;
            [self.contentView addSubview:shopNameLabel];
            
            //时间
            UILabel *timeLable = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 13, 100, 12)];
            timeLable.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            timeLable.textAlignment = NSTextAlignmentRight;
            timeLable.font = [UIFont systemFontOfSize:11];
            timeLable.tag = 3;
            [self.contentView addSubview:timeLable];
            
            //价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 35.5, 100, 15)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = [UIFont systemFontOfSize:16];
//            priceLabel.textColor = [UIColor colorWithRed:254/255.0 green:98/255.0 blue:102/255.0 alpha:1.0];
            priceLabel.tag = 2;
            [self.contentView addSubview:priceLabel];
            
            
            
            //订单状态
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 60.5, 100, 12)];
            statusLabel.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
            statusLabel.textAlignment = NSTextAlignmentRight;
            statusLabel.font = [UIFont systemFontOfSize:13];
            statusLabel.tag = 4;
            [self.contentView addSubview:statusLabel];
            
            //菜名
            UIView * foodNameView=[[UIView alloc]initWithFrame:RectMake_LFL(115, 33, 75, 60)];
            foodNameView.tag=5;
            [self.contentView addSubview:foodNameView];
            
            line=[[UIView alloc]initWithFrame:RectMake_LFL(375/2, 90, 0.6, 40)];
            line.backgroundColor=[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1];
            [self.contentView addSubview:line];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=RectMake_LFL(0, 90, 375, 40);
            [btn setTitle:@"提交订单，并评价" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goToCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
            line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 130,375, 10)];
            line.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
            [self.contentView addSubview:line];
            
            line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 130,375, 0.5)];
            line.backgroundColor=[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1];
            [self.contentView addSubview:line];
        }
    }
    return self;
}
-(void)goToCommentBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(OrderListCell:gotoComment:)]) {
        [self.delegate OrderListCell:self gotoComment:nil];
    }
}
-(void)setOrderModel:(Order4ListModel *)orderModel{
    _orderModel=orderModel;
    
    UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:1];
    nameLabel.text = [NSString stringWithFormat:@"%@", orderModel.ShopName];
    
    UILabel *statusLabel = (UILabel *)[self.contentView viewWithTag:4];
    if (orderModel.payState==0) {
        statusLabel.text =@"未支付";
    }else{
        switch (orderModel.Sendtate) {
            case 0:
                if (orderModel.State==2) {
                    statusLabel.text =orderModel.isShopSet ==0 ? @"订单已提交":orderModel.isShopSet ==0 ?@"商家已接单":@"订单被取消";
                }else{
                    statusLabel.text =orderModel.State == 7 ? @"正在匹配骑手" : orderModel.State == 4 ? @"订单被取消" : orderModel.State ==3 ?@"完成订单":@"未知情况的订单";
                }
                break;
            case 1:
                statusLabel.text= @"骑手去商家取货";
                break;
            case 2:
                statusLabel.text= @"已取货，配送中";
                break;
            case 3:
                statusLabel.text= @"已送达";
                break;
            default:
                break;
        }
    }

    
    [iconView sd_setImageWithURL:[NSURL URLWithString:orderModel.TogoPic] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    UILabel *intr = (UILabel *)[self.contentView viewWithTag:3];
    intr.text = [NSString stringWithFormat:@"%@", [orderModel.OrderTime substringWithRange:NSMakeRange(5, 11)]];
    
    UILabel * priceLabel = (UILabel *)[self.contentView viewWithTag:2];
    
    NSMutableAttributedString * aStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"总计：%@", orderModel.TotalMoney]];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254.0/255.0 green:98.0/255.0 blue:120.0/255.0 alpha:1] range:NSMakeRange(3, aStr.length-3)];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    priceLabel.attributedText =aStr;
    
    UIView * view=(UIView *)[self.contentView viewWithTag:5];
    for (UILabel * label in view.subviews) {
        [label removeFromSuperview];
    }
    CGFloat y=0,y2=0;
    for (FoodInOrderModelFix * model in orderModel.foodsArr) {
        UILabel * label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:12];
        [view addSubview:label];
        label.text= [NSString stringWithFormat:@"%@ x%d",model.foodname,model.foodCount];
        if (y<=CGRectGetMaxY(RectMake_LFL(0, 0, 0, 17*3))) {
            label.frame=RectMake_LFL(0, y, 75, 17);
        }else{
            label.frame=RectMake_LFL(70, y2, 75, 17);
            
            if (y2>=CGRectGetMaxY(RectMake_LFL(0, 0, 0, 17*2))) {
                label.text=@"等商品";
                break;
            }
            y2+=17;
        }
        y+=17;
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
