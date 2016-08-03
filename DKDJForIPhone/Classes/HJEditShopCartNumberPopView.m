//
//  HJEditShopCartNumberPopView.m
//  GZGJ
//
//  Created by ihangjing on 14-10-13.
//
//

#import "HJEditShopCartNumberPopView.h"
#import "CouponModel.h"
@implementation HJEditShopCartNumberPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HJEditShopCartNumberPopView *)initWithView:(UIView *)view FoodModel:(FoodModel *)food FShop4ListModel:(FShop4ListModel *)shop MyShopCart:(MyShopCart *)shopCart childViewPosition:(CGPoint)point index:(int)index
{
    [super initWithView:view];
    shopModel = shop;
    foodModel = food;
    myShopCart = shopCart;
    shopIndex = index;
    shopcard = [shopCart getShopCardInOrderModel:index];
    FoodAttrModel *model;
    if (self) {
        viewroundImage = [[UIImage imageNamed:@"more_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,13,10,13)];
        UIImageView *image;
        if ([shopcard.activity count] > 0) {
            image = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 226, 100.0)];
        }else{
            image = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 226, 50.0)];
        }
        
        image.image = viewroundImage;
        image.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        image.userInteractionEnabled = YES;//不设置这个，那么UIScrollView的子视图都无法获取到点击事件
        UIImage *normalImage1 = [UIImage imageNamed:@"detele_ico.png"];
        NSInteger retain = image.retainCount;
        
        UIButton *btnRemove = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 12.0, 30.0, 20.0)];
        [btnRemove  setBackgroundImage:normalImage1 forState:UIControlStateNormal];
        [btnRemove  setBackgroundImage:normalImage1 forState:UIControlStateHighlighted];
        [btnRemove addTarget:self action:@selector(removeFood:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:btnRemove];
        [btnRemove release];
        
        UIImage *hImage = [UIImage imageNamed:@"vertical_line.png"];
        UIImageView *ivHline = [[UIImageView alloc] initWithFrame:CGRectMake(55.0, 13.0, 1.0, 24.0)];
        ivHline.image = hImage;
        [image addSubview:ivHline];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(66, 15, 40, 15)];
        label.text = @"数量";
        label.textColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1.0];
        [image addSubview:label];
        [label release];
        
        UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(111, 12, 30, 25)];
        [minusButton setBackgroundImage: [UIImage imageNamed:@"number_minus.png"] forState:UIControlStateNormal];
        [minusButton setBackgroundImage:[UIImage imageNamed:@"number_minus.png"] forState:UIControlStateSelected];//设置选择状态
        
        //[minusButton setTitle:@"-" forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(minusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:minusButton];
        
        
        //4.
        numValue = [[UILabel alloc] initWithFrame:CGRectMake(141, 12, 30, 25)];
        //numValue.backgroundColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
        numValue.textAlignment = NSTextAlignmentCenter;
        //numValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"number_bg.png"]];
        [numValue setBackgroundColor:color];

        numValue.font = [UIFont boldSystemFontOfSize:12];
        numValue.textColor = [UIColor blackColor];
        
        
        model = [foodModel.attr objectAtIndex:0];
        numValue.text = [NSString stringWithFormat:@"%d", [myShopCart getFoodCountInAttrWitchShopID:foodModel.tid foodID:foodModel.foodid attrId:model.cid]];
        
        //[numValue setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"number_bg.png"]]];
        
        [image addSubview:numValue];
        
        //5. +
        UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(171, 12, 30, 25)];
        //plusButton.frame = CGRectMake(290, 0, 30, 25);
        //[plusButton setTitle:@"+" forState:UIControlStateNormal];
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateSelected];//设置选择状态
        
        [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:plusButton];
        
        
        //[minusButton set:numValue forKey:@"num"];
        [minusButton release];
        
        //[plusButton setValue:numValue forKey:@"num"];
        [plusButton release];
        
        
        
        retain = image.retainCount;
        retain = numValue.retainCount;
        retain = viewroundImage.retainCount;
        
        if ([shopcard.activity count] > 0) {
            //看是否有优惠券
            UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 45, 206, 2.0)];
            lineImageView.image = hImage;
            [image addSubview:lineImageView];
            [lineImageView release];
            
            UIImageView *ivTH = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 55.0, 30, 20)];
            ivTH.image = [UIImage imageNamed:@"tehui.png"];
            [image addSubview:ivTH];
            [ivTH release];
            
            cardValue = [[UILabel alloc] initWithFrame:CGRectMake(66, 52, 100, 25)];
            cardValue.backgroundColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
            cardValue.textAlignment = NSTextAlignmentCenter;
            //numValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            cardValue.font = [UIFont boldSystemFontOfSize:12];
            cardValue.textColor = [UIColor whiteColor];
            cardValue.text = @"暂不使用";
            [image addSubview:cardValue];
            if (model.card != nil) {
                cardValue.text = [NSString stringWithFormat:@"%.0f%@", model.card.point, model.card.name];
            }
            
            UIButton *listButton = [[UIButton alloc] initWithFrame:CGRectMake(171, 52, 30, 25)];
            //plusButton.frame = CGRectMake(290, 0, 30, 25);
            //[plusButton setTitle:@"+" forState:UIControlStateNormal];
            
            [listButton setBackgroundImage:[UIImage imageNamed:@"btn_list.png"] forState:UIControlStateNormal];
            [listButton setBackgroundImage:[UIImage imageNamed:@"btn_list_sel.png"] forState:UIControlStateSelected];//设置选择状态
            
            [listButton addTarget:self action:@selector(popListCard:) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:listButton];
            
            
            //[minusButton set:numValue forKey:@"num"];
            [listButton release];
        }
        
        [self addSubview:image];
        [image release];
    }
    return self;
}

-(void)minusFoodToOrder:(id)sender
{//减去
    //UIButton *btn = (UIButton *)sender;
    int n = [myShopCart delFoodAttr:foodModel attrIndex:0];
    numValue.text = [NSString stringWithFormat:@"%d", n];
    if (n == 0) {
        [self closeDialog];
    }
}

-(void)plusFoodToOrder:(id)sender
{//加入购物车
    //app.mShopModel
    //UIButton *btn = (UIButton *)sender;
    
    
    if (shopModel == nil) {
        shopModel = [[FShop4ListModel alloc] init];
    }
    shopModel.shopid = foodModel.tid;
    
    
    numValue.text = [NSString stringWithFormat:@"%d", [myShopCart  addFoodAttr:shopModel food:foodModel attrIndex:0]];
    //price.text = [NSString stringWithFormat:@"合计：￥%.2f元", [app.shopCart getFoodPrice:self.food]];
    //UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
    //tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",app.shopCart.foodCount];
}

-(void)popListCard:(id)sender
{//加入购物车
    //app.mShopModel
    //UIButton *btn = (UIButton *)sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请优惠券"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"暂不使用"];
    for (int i = 0; i < [shopcard.activity count]; i++) {
        CouponModel *model = [shopcard.activity objectAtIndex:i];
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%.0f%@", model.point, model.name]];
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];//IActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。平时可以这样使用showInView:self.view
    
    
}
#pragma mark actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    cardValue.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex > 0) {
        buttonIndex--;
        /*CouponModel *model = [shopcard.activity objectAtIndex:buttonIndex];
        [shopcard.userActivity addObject:model];
        [shopcard.activity removeObjectAtIndex:buttonIndex];*/
        [shopcard addFoodAttr:foodModel index:0 cardAry:shopcard.activity cardIndex:(int)buttonIndex];
    }else{
        //shopcard.cardID = @"";
        /*if ([shopcard.userActivity count] > 0) {
            buttonIndex = [shopcard.userActivity count] - 1;
            CouponModel *model = [shopcard.userActivity objectAtIndex:buttonIndex];
            [shopcard.activity addObject:model];
            [shopcard.activity removeObjectAtIndex:buttonIndex];
        }*/
        [shopcard removeFoodAttr:foodModel index:0 cardAry:shopcard.activity];
    }
}

-(void)removeFood:(id)sender{
    
}

-(void)dealloc{
    //[viewroundImage release];
    [numValue release];
    myShopCart = nil;
    shopModel = nil;
    foodModel = nil;
    [super dealloc];
}

@end
