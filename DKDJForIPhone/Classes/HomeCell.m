//
//  HomeCell.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/5/28.
//
//

#import "HomeCell.h"
#import "HJLabel.h"
#import "UIImageView+WebCache.h"
@implementation HomeCell{
    NSArray* hConstraintArray;
    NSArray* vConstraintArray;
    UIImageView *ico;
    UILabel *nameLabel;
    UILabel *priceLabel1;
    UILabel *timeLabel;
    UILabel *distanceLabel;
    UIView *tagView;
    NSMutableArray <UILabel *>* tagLabelArr;
    NSMutableArray <UIImageView *>* tagImageViewArr;
    UILabel * tagCountLable;
    UIButton *tagBtn;
    UIImageView * stateImageView;
    bool  isOpen;
    UILabel * openStatusLabel;
}
//static bool isOpen=NO;
+(HomeCell *)HomeCellWithTableView:(UITableView *)tableView
{
    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellTableIdentifier"];
    if ( cell == nil ) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTableIdentifier"];
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeConstraints:self.contentView.constraints];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIView *topView = [[UIView alloc] init];
        topView.tag = 110;
        topView.frame=RectMake_LFL(10, 10, 95, 70);
        [self.contentView addSubview:topView];
        
        ico = [[UIImageView alloc] init ];
        ico.frame=RectMake_LFL(0, 0, 100, 70);
        ico.tag = 1;
        [topView addSubview:ico];
        
        openStatusLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(0,70-15, 100,15)];
        openStatusLabel.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:216.0/255.0 blue:226.0/255.0 alpha:0.45];
        openStatusLabel.text = @"商 家 休 息 中";
        openStatusLabel.font=[UIFont systemFontOfSize:11];
        openStatusLabel.textAlignment=NSTextAlignmentCenter;
        
        CGFloat Y=10;
        CGFloat X=95+10+10;
        //1. 名称

        nameLabel = [[UILabel alloc] init];
        nameLabel.frame=RectMake_LFL(X, Y, 225, 14);
        nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode =  NSLineBreakByCharWrapping;//自动换行
        nameLabel.numberOfLines = 1;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 3;
        
        [self.contentView addSubview: nameLabel];
        Y+=14+3;
        
//        //五星评分
//        UIView * starView=[[UIView alloc]init];
//        [starView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        starView.frame=RectMake_LFL(X ,Y, 225, 14);
//        for (int i=0; i<5; i++) {
//            UIImageView * starImageView=[[UIImageView alloc]init];
//            starImageView.frame=RectMake_LFL(10*i, 0, 10, 10);
//            starImageView.image=[UIImage imageNamed:@"icon_star"];
//            [starView addSubview:starImageView];
//        }
//        [self.contentView addSubview:starView];
//        Y+=10+5;

        //2.配送费
        priceLabel1 = [[UILabel alloc] init];
        priceLabel1.frame=RectMake_LFL(X, Y, 200, 11);
        priceLabel1.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        priceLabel1.textAlignment = NSTextAlignmentLeft;
        priceLabel1.lineBreakMode = NSLineBreakByCharWrapping;//自动换行
        priceLabel1.numberOfLines = 1;
        priceLabel1.font = [UIFont systemFontOfSize:12];
        
        priceLabel1.tag = 71;
        [self.contentView addSubview: priceLabel1];
        
        Y+=10;
        
        //商家标签
        tagView = [[UIView alloc] init];
        
        [self.contentView addSubview:tagView];
        
        tagView.frame=RectMake_LFL(X, Y, 375-X, 60);

        [tagView addSubview:tagBtn];
        
        tagLabelArr=[NSMutableArray array];
        tagImageViewArr=[NSMutableArray array];
        CGFloat space=5,lableW=100,imageW=11, height=11;
        CGFloat totalW=space*2+lableW+imageW;
        
        for (int i=0; i<6; i++) {
            UIImageView * imageView=[[UIImageView alloc]init];
            [tagView addSubview:imageView];
            [tagImageViewArr addObject:imageView];
            
            UILabel * label=[[UILabel alloc]init];
            label.font=[UIFont systemFontOfSize:11];
            label.textColor=[UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0];
            
            [tagLabelArr addObject:label];
            [tagView addSubview:label];
            imageView.frame=RectMake_LFL((i%2)*totalW,5+ (height+2)*(i/2), height, height);
            label.frame=RectMake_LFL(12+totalW*(i%2),5+ (height+2)*(i/2) ,lableW, height);
            
        }

        
        //距离
        distanceLabel = [[HJLabel alloc] init];
        distanceLabel.frame=RectMake_LFL(375-90, 20, 80, 8);
        distanceLabel.textColor=[UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0];
        distanceLabel.lineBreakMode = NSLineBreakByCharWrapping;//自动换行
        distanceLabel.numberOfLines = 1;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        distanceLabel.font = [UIFont systemFontOfSize:10];
        distanceLabel.tag = 8;
        [self.contentView addSubview: distanceLabel];
        
        
        //配送时间
        
        timeLabel =[[UILabel alloc]init];
        timeLabel.frame=RectMake_LFL(375-90, 20+8+5, 80, 8);
        timeLabel.textColor=[UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0];
        timeLabel.lineBreakMode = NSLineBreakByCharWrapping;//自动换行
        //        timeLabel.backgroundColor = [UIColor redColor];
        timeLabel.numberOfLines = 1;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.tag = 7;
        [self.contentView addSubview: timeLabel];
        
        UIView * view=[[UIView alloc]init];
        _lineView=view;
        _lineView.frame=RectMake_LFL(0,90, 375, 10);
        _lineView.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        [self.contentView addSubview:_lineView];
        self.lineView=_lineView;
        
    }
    return self;
}
-(void)setFShop4ListModel:(FShop4ListModel *)FShop4ListModel{
    if (FShop4ListModel) {
        _FShop4ListModel=FShop4ListModel;

        [ico sd_setImageWithURL:[NSURL URLWithString:FShop4ListModel.icon] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
//        NSLog(@"%@",FShop4ListModel.icon);
        nameLabel.text=FShop4ListModel.shopname;
        priceLabel1.text= [NSString stringWithFormat:/*@"配送费:%.2f元 起送金额:%.2f元"*/CustomLocalizedString(@"shop_detail_send_free_1", @"配送费:%.2f元|起送金额:%.2f元"), FShop4ListModel.Sendmoney, FShop4ListModel.startMoney];
        timeLabel.text =@"40分钟";
        distanceLabel.text =[NSString stringWithFormat:@"%.2f km",FShop4ListModel.distance];
        
//        NSLog(@"%@",distanceLabel);

        int i=0;
        
        for (ShopTagMode *tagModel in self.FShop4ListModel.shopTagList) {
            if (i<self.FShop4ListModel.shopTagList.count) {
                UILabel *label=tagLabelArr[i];
                label.text=tagModel.Title.length >=10? [tagModel.Title substringWithRange:NSMakeRange(0, 8)] : tagModel.Title;
                [tagImageViewArr[i] sd_setImageWithURL:[NSURL URLWithString:tagModel.Picture] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
            }
            i++;
        }
        if (self.FShop4ListModel.status==0) {
            [ico addSubview:openStatusLabel];
        }else{
            [openStatusLabel removeFromSuperview];
        }
        
    }
}
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//}
//-(void)layoutSubviews{
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
