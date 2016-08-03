//
//  UIAlertTableView.m
//  TSYP
//
//  Created by wulin on 13-6-13.
//
//

#import "UIAlertTableView.h"
#import "FoodAttrModel.h"
#define kTablePadding 8.0f

@interface UIAlertView (private)
- (void)layoutAnimated:(BOOL)fp;
@end
@protocol UpdateTableViewDelegate <NSObject>
-(void) updateShopCart:(FoodModel *)food;
-(void)updateShopCartWitchInOrderModel:(FoodInOrderModel *)food;
@end

@implementation UIAlertTableView

@synthesize dataSource;
@synthesize tableDelegate;
@synthesize updateDelegate;
@synthesize tableHeight;
@synthesize inTableView;
@synthesize lastIndexPath;
//@synthesize food;
//@synthesize shopCart;

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (updateDelegate != nil) {
        if (food != nil) {
            [updateDelegate updateShopCart:food];
        }else{
            [updateDelegate updateShopCartWitchInOrderModel:foodInOrder];
        }
    
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView//alertView已经呈现所调的函数（此时alertView还没消失）
{
    //[super willPresentAlertView:alertView];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - tableExtHeight / 2, self.frame.size.width, self.frame.size.height + tableExtHeight)];
    UIView *lowestView;
    int i = 0;
    while (![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]]) {
        lowestView = [self.subviews objectAtIndex:i];
        i++;
    }
    CGFloat tableWidth = 262.0f;
    inTableView.frame = CGRectMake(11.0f, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kTablePadding, tableWidth, tableHeight);
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y + tableExtHeight, v.frame.size.width, v.frame.size.height);
        }
    }
}
- (void)layoutAnimated:(BOOL)fp {
    [super layoutAnimated:fp];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - tableExtHeight / 2, self.frame.size.width, self.frame.size.height + tableExtHeight)];
    UIView *lowestView;
    int i = 0;
    while (![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]]) {
        lowestView = [self.subviews objectAtIndex:i];
        i++;
    }
    CGFloat tableWidth = 262.0f;
    inTableView.frame = CGRectMake(11.0f, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kTablePadding, tableWidth, tableHeight);
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y + tableExtHeight, v.frame.size.width, v.frame.size.height);
        }
    }
}
-(id)initWitchData:(FoodModel **)data updateTableView:(id)update{
    [super initWithTitle:@"菜品规格" message:nil delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil];
    food = *data;
    self.delegate = self;
    self.updateDelegate = update;
    //NSInteger i = [(*food).attr count];
    //shopCart = *shopcart;
    return self;
}

- (id)initWitchDataOfInOrderModel:(FoodInOrderModel **)data updateTableView:(id)update{
    [super initWithTitle:@"菜品规格" message:nil delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil];
    foodInOrder = *data;
    self.delegate = self;
    self.updateDelegate = update;
    return self;
}

- (void)show{
    //array = [[NSArray alloc] initWithObjects:@"test1", @"test2", @"test3", @"test4", nil];
    [self prepare];
    self.delegate = self;
    [super show];
}

- (void)prepare {
    if (tableHeight == 0) {
        tableHeight = 150.0f;
    }
    tableExtHeight = tableHeight + 2 * kTablePadding;
    inTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) style:UITableViewStylePlain];
    //inTableView.backgroundColor = [UIColor orangeColor];
    inTableView.delegate = self;
    inTableView.dataSource = self;
    [self insertSubview:inTableView atIndex:0];
    [self setNeedsLayout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (food != nil) {
        return [food.attr count];
    }
    return [foodInOrder.attr count];
    
}

-(void)updateTable{
    [self.inTableView reloadData];
}

-(void)minusFoodToOrder:(id)sender{
    NSInteger row = [self.inTableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    FoodAttrModel *model;
    if (food != nil) {
        model = [food.attr objectAtIndex:row];
        if (model.count == 0) {
            return;
        }
        food.count--;
        food.price = food.price - model.price;
    }else{
        model = [foodInOrder.attr objectAtIndex:row];
        if (model.count == 0) {
            return;
        }
        foodInOrder.foodCount--;
        foodInOrder.price = foodInOrder.price - model.price;
    }
    
    model.count--;
    

    [self updateTable];
}

-(void)plusFoodToOrder:(id)sender{
    //food
    NSInteger row = [self.inTableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    //FoodAttrModel *model = [food.attr objectAtIndex:row];
    FoodAttrModel *model;
    if (food != nil) {
        model = [food.attr objectAtIndex:row];
        food.count++;// = [[NSString alloc] initWithFormat:@"%d",[food.count intValue] + 1];
        food.price = food.price + model.price;
    }else{
        model = [foodInOrder.attr objectAtIndex:row];
        foodInOrder.foodCount++;
        foodInOrder.price = foodInOrder.price + model.price;
    }
    model.count++;
    
    [self updateTable];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //3. -
        
        CGRect nameLabelRect = CGRectMake(0, 0, 179, 40);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 4;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        UIButton *minusButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        //CGRect frame = cell.frame;
        //CGSize size = cell.frame.size;
        minusButton.frame = CGRectMake(180, 10, 27, 23);
        //frame = minusButton.frame;
        minusButton.tag = 2;
        [minusButton setBackgroundImage: [UIImage imageNamed:@"number_minus.png"] forState:UIControlStateNormal];
        [minusButton setBackgroundImage:[UIImage imageNamed:@"number_minus_sel.png"] forState:UIControlStateSelected];//设置选择状态
        
        //[minusButton setTitle:@"-" forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(minusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:minusButton];
        
        //4.
        CGRect numValueRect = CGRectMake(207, 10, 25, 23);
        UILabel *numValue = [[UILabel alloc] initWithFrame:
                             numValueRect];
        
        numValue.textAlignment = NSTextAlignmentLeft;
        numValue.font = [UIFont boldSystemFontOfSize:12];
        numValue.textColor = [UIColor grayColor];
        numValue.tag = 3;
        numValue.textAlignment = NSTextAlignmentCenter;
        
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"number_bg.png"]];
        [numValue setBackgroundColor:color];
        
        [cell.contentView addSubview:numValue];
        [numValue release];
        
        //5. +
        UIButton *plusButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        plusButton.frame = CGRectMake(232, 10, 27, 23);
        plusButton.tag = 1;
        //[plusButton setTitle:@"+" forState:UIControlStateNormal];
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus_sel.png"] forState:UIControlStateSelected];//设置选择状态
        
        [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:plusButton];
    }
    //NSUInteger row = [indexPath row];
    //NSUInteger oldRow = [lastIndexPath row];
    FoodAttrModel *model;
    if (food != nil) {
        model = [food.attr objectAtIndex:indexPath.row];
    }else{
        model = [foodInOrder.attr objectAtIndex:indexPath.row];
    }
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:4];
    nameLabel.text = [NSString stringWithFormat:@"%@(%.2f￥)", [model name], [model price]];
    
    UILabel *numValue = (UILabel *)[cell.contentView viewWithTag:3];
    numValue.text = [NSString stringWithFormat:@"%d", model.count];//model.count;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*int newRow = [indexPath row];
    int oldRow = [lastIndexPath row];
    if ((newRow == 0 && oldRow == 0) || (newRow != oldRow)){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = [indexPath retain];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
}

- (void)dealloc {
    [inTableView release];
    [super dealloc];
}

@end
