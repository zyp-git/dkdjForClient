//
//  UserAddressDetail.m
//  SYW
//
//  Created by wulin on 13-8-29.
//
//

#import "UserAddressDetail.h"

@implementation UserAddressDetail

#define NUMBERS @"0123456789"

@synthesize name;
@synthesize address;
@synthesize phone;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Override父类的layoutSubviews方法
- (void)layoutSubviews {
    [super layoutSubviews];     // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    
    for (UIView* view in self.subviews) {
        // 搜索AlertView底部的按钮，然后将其位置下移
        // IOS5以前按钮类是UIButton, IOS5里该按钮类是UIThreePartButton
        if ([view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = self.address.frame.origin.y + self.address.frame.size.height + 7;
            view.frame = btnBounds;
        }
    }
    
    // 定义AlertView的大小
    CGRect bounds = self.frame;
    bounds.size.height = 260;
    self.frame = bounds;
}

-(id)initWithUserName:(NSString *)name UserAddress:(NSString *)address UserPhone:(NSString *)phone  Title:(NSString *)title delegate:(id)delegate
{
    self = [super initWithTitle:title message:@"" delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"删除", nil];
    
    if (self != nil) {
        
        self.name = [[UITextField alloc] initWithFrame:CGRectMake(22, 45, 240, 36)];
        self.name.placeholder = @"请输入收货人姓名";
        self.name.secureTextEntry = NO;
        self.name.text = name;
        self.name.backgroundColor = [UIColor whiteColor];
        self.name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.name];
        self.phone = [[UITextField alloc] initWithFrame:CGRectMake(22, 90, 240, 36)];
        self.phone.placeholder = @"请输入收货人联系电话";
        self.phone.secureTextEntry = NO;
        self.phone.text = phone;
        self.phone.delegate = self;
        self.phone.keyboardType = UIKeyboardTypeNumberPad;
        self.phone.backgroundColor = [UIColor whiteColor];
        self.phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.phone];
        self.address = [[UITextField alloc] initWithFrame:CGRectMake(22, 135, 240, 36)];
        self.address.placeholder = @"请输入收货地址";
        self.address.secureTextEntry = NO;
        self.address.text = address;
        self.address.backgroundColor = [UIColor whiteColor];
        self.address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.address];
    }
    return self;
}

-(id)initDefault:(id)delegate
{
    self = [super initWithTitle:@"新增地址" message:@"" delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    if (self != nil) {
        
        self.name = [[UITextField alloc] initWithFrame:CGRectMake(22, 45, 240, 36)];
        self.name.placeholder = @"请输入收货人姓名";
        self.name.secureTextEntry = NO;
        self.name.backgroundColor = [UIColor whiteColor];
        self.name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.name];
        self.phone = [[UITextField alloc] initWithFrame:CGRectMake(22, 90, 240, 36)];
        self.phone.placeholder = @"请输入收货人联系电话";
        self.phone.secureTextEntry = NO;
        self.phone.delegate = self;
        self.phone.keyboardType = UIKeyboardTypeNumberPad;
        self.phone.backgroundColor = [UIColor whiteColor];
        self.phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.phone];
        self.address = [[UITextField alloc] initWithFrame:CGRectMake(22, 135, 240, 36)];
        self.address.placeholder = @"请输入收货地址";
        self.address.secureTextEntry = NO;
        self.address.backgroundColor = [UIColor whiteColor];
        self.address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.address];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // return NO to not change text
    
    
        NSCharacterSet*cs;
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if(!basicTest) {
            
            
            return NO;
        }
    
    return YES;
}

-(void)dealloc
{
    
    [name release];
    [phone release];
    [address release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
