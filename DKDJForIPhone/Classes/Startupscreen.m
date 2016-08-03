//
//  Startupscreen.m
//  IBogu
//
//  Created by ihangjing on 13-10-18.
//
//

#import "Startupscreen.h"

@interface Startupscreen ()

@end

@implementation Startupscreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *bak = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 168.0f, 240.0f, 92.0f)];//408 156
    bak.image = [UIImage imageNamed:@"start_text.png"];
    self.view = bak;
    
    
}


@end
