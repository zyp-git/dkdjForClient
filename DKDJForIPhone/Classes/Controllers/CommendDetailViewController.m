//
//  CommendDetailViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "CommendDetailViewController.h"

@interface CommendDetailViewController ()
@end

@implementation CommendDetailViewController{
    NSMutableArray* starArr1;
    NSMutableArray* starArr2;
    NSMutableArray* starArr3;
    NSMutableArray <UILabel *>* starCountLabelArr;
    NSMutableArray * starBackViewArr;
}

//zyp评论页面

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.title=@"评论";
    self.edgesForExtendedLayout =UIRectEdgeNone;
    
    starArr1=[NSMutableArray array];
    starArr2=[NSMutableArray array];
    starArr3=[NSMutableArray array];
    
    starCountLabelArr=[NSMutableArray array];;
    starBackViewArr=[NSMutableArray array];
    
    NSArray * textArr=[NSArray arrayWithObjects:@"配送评价",@"商品质量",@"味道评价", nil];
    
    for (int i=0; i<3; i++) {
        UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 10+i*50, 375, 40)];
        [self.view addSubview:view];
        view.tag=i;
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 70, 40)];
        label.text=textArr[i];
        [view addSubview:label];
        
        UIView * starBackView=[[UIView alloc]initWithFrame:CGRectMake(75, 10, 150, 20)];
        starBackView.tag=i;
        [starBackViewArr addObject:starBackView];
        [view addSubview:starBackView];

        for (int j=0; j<5; j++) {
            UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(25+j*25, 0, 20, 20)];
            imgView.image=[UIImage imageNamed:@"ratingbar_empty"];
            [starBackView addSubview:imgView];
            NSMutableArray *arr= i==0 ? starArr1 :i==1 ? starArr2: starArr3;
            [arr addObject:imgView];
            imgView.tag=i;
        }
        label=[[UILabel alloc]initWithFrame:RectMake_LFL(210, 0, 100, 40)];
        label.textColor=app.sysTitleColor;
        [view addSubview:label];
        [starCountLabelArr addObject:label];
    }
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(10, 150, 100, 30)];
    commentLabel.text = @"撰写评论：";
    commentLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview: commentLabel];

    commentValue = [[UITextField alloc] initWithFrame:RectMake_LFL(0, 180, 375, 100)];
    commentValue.placeholder = @"\t\t来点评一下吧！(30字以内)";
    commentValue.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
    commentValue.backgroundColor=[UIColor whiteColor];
    commentValue.font = [UIFont systemFontOfSize:14];
    [self.view addSubview: commentValue];

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49-64 ,[UIScreen mainScreen].bounds.size.width , 49)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btn setTitle:@"提交评论" forState:UIControlStateNormal];
    btn.backgroundColor=app.sysTitleColor;
    [btn addTarget:self action:@selector(updataComment:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];

    app.commentSucess = 0;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch=[touches anyObject];
    //建立一个触摸原点，并给出有效范围
    UIView *view = [touch view];
    NSLog(@"%ld",(long)view.tag);
    CGPoint touchPiont= [touch locationInView:starBackViewArr[view.tag]];
    
    
    if ((touchPiont.x >0)&& (touchPiont.x<150)&&(touchPiont.y >0)&& (touchPiont.y <20)){
        int starCount=((int)touchPiont.x)/25;
        NSString * str= starCount<3 ? @"差评": starCount<4 ? @"中评" :@"好评";
        starCountLabelArr[view.tag].text=[NSString stringWithFormat:@"%d星 %@",starCount,str];
        
        NSMutableArray *arr= view.tag==0 ? starArr1 : view.tag==1 ? starArr2: starArr3;
        for (UIImageView * imgView in arr) {
            imgView.image= imgView.frame.origin.x>touchPiont.x ?[UIImage imageNamed:@"ratingbar_empty"]:[UIImage imageNamed:@"ratingbar_filled"];
        }
    }
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch=[touches anyObject];
    //建立一个触摸原点，并给出有效范围
    UIView *view = [touch view];
    NSLog(@"%ld",(long)view.tag);
    CGPoint touchPiont= [touch locationInView:starBackViewArr[view.tag]];
    
    
    if ((touchPiont.x >0)&& (touchPiont.x<150)&&(touchPiont.y >0)&& (touchPiont.y <20)){
        int starCount=((int)touchPiont.x)/25;
        NSString * str= starCount<3 ? @"差评": starCount<4 ? @"中评" :@"好评";
        starCountLabelArr[view.tag].text=[NSString stringWithFormat:@"%d星 %@",starCount,str];
        
        NSMutableArray *arr= view.tag==0 ? starArr1 : view.tag==1 ? starArr2: starArr3;
        for (UIImageView * imgView in arr) {
            imgView.image= imgView.frame.origin.x>touchPiont.x ?[UIImage imageNamed:@"ratingbar_empty"]:[UIImage imageNamed:@"ratingbar_filled"];
        }
    }
   
}



-(CommendDetailViewController *)initWithFood:(FoodInOrderModelFix *)food orderID:(NSString *)orderid{
    if (self= [super init]) {
        foodModel = food;
        orderID = orderid;

    }
    return self;
}

-(void)updataComment:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduserid = [defaults objectForKey:@"userid"];
    NSString *udName = [defaults objectForKey:@"username"];
    
    NSMutableArray <NSString *>* arr=[NSMutableArray array];
    for (UILabel * label in starCountLabelArr) {
        NSString * str;
        if (label.text) {
            str=[label.text substringToIndex:1];
        }else{
            str=@"0";
        }
        [arr addObject:str];
    }
    
    NSString *value = [NSString stringWithFormat:@"{\"UserID\":\"%@\",\"TogoID\":\"%@\",\"Comment\":\"%@\",\"ServiceGrade\":\"%d\",\"FlavorGrade\":\"%d\",\"SpeedGrade\":\"%d\",\"UserName\":\"%@\",\"foodname\":\"%@\",\"orderid\":\"%@\",\"point\":\"5\"}", uduserid, foodModel.foodid, commentValue.text,[arr[0] intValue], [arr[1] intValue], [arr[2] intValue], udName, foodModel.foodname, orderID];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:value, @"ordermodel",uduserid, @"userid", udName, @"username", foodModel.foodid, @"shopid", nil];
    NSLog(@"%@",param);
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(commendReceive:obj:)];
    
    [twitterClient updataCommentFood:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];

}

- (void)commendReceive:(TwitterClient*)client obj:(NSObject*)obj{
    NSLog(@"foodsDidReceive");
    twitterClient = nil;
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
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
    int state = [[dic objectForKey:@"state"] intValue];
    self.commandID = [dic objectForKey:@"dataid"];
    if (state == 1) {
        if (self.myICO) {
            [self upImage];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"评论成功，感谢您对我们的支持！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;
            [alert show];
            [btnComment removeFromSuperview];
            foodModel.isComment = 1;
            app.commentSucess = 1;
        }
        
    }else{
        NSString *msg = [dic objectForKey:@"msg"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self goToBack];
}
-(void)goToBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1:
            
        case 4:
            if (buttonIndex == 0) {
                imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                imagePicker.allowsEditing = YES;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else if(buttonIndex == 1){
                imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                imagePicker.allowsEditing = YES;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}
#pragma mark 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark 保存图片到document

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark 从文档目录下获取Documents路径

- (NSString *)documentFolderPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
#pragma mark UIImagePicker
//用户选中图片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSURL *imageURL = [info valueForKey:@"UIImagePickerControllerReferenceURL"];
    
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:[imageURL query]];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:@"UTF-8"];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:@"UTF-8"];
            [pairs setObject:value forKey:key];
        }
    }
    self.imgExt = [pairs objectForKey:@"ext"];
    if (self.imgExt == nil || self.imgExt.length < 1) {
        self.imgExt = @"jpg";
    }
    
    
    self.myICO = [self imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 330.0)];
    userICON.image = self.myICO;
    // [self imageUpload:self.myICO];
    [self saveImage:self.myICO WithName:@"salesImageBig.jpg"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)upImage
{
    if (twitterClient == nil) {
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(upImageFinish:obj:)];
        
        [twitterClient Upload:self.myICO type:@"3" dataID:self.commandID imageExtName:self.imgExt];
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"图片上传中...";
        [_progressHUD show:YES];
        
        
    }
}

-(void)upImageFinish:(TwitterClient*)sender obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    
    if (state == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"评论成功，感谢您对我们的支持！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
        [btnComment removeFromSuperview];
        foodModel.isComment = 1;
        app.commentSucess = 1;
        //self.myICONet = [dic objectForKey:@"pic"];
        //self.myICOPath = [imageDowload addTask:self.uduserid url:self.myICONet showImage:nil defaultImg:nil indexInGroup:1 Goup:1];
        //[self setImg:self.myICOPath Default:@"暂无图片"];
        //[imageDowload startTask];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"评论成功，但是图片上传失败，感谢您对我们的支持！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
        [btnComment removeFromSuperview];
        foodModel.isComment = 1;
        app.commentSucess = 1;
        return;
    }

}
// 用户选择取消
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
