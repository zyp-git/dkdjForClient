//
//  resetUserInfoVC.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/13.
//
//

#import "resetUserInfoVC.h"
#import "UserInfoNewViewController.h"
#import "ChangePasswordViewController.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"
#import "UIImageView+WebCache.h"

#import "ImageDowloadTask.h"
@interface resetUserInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation resetUserInfoVC{
    UIImageView * iconImgView;
    UIView * preview;
    NSString * userID;
    MBProgressHUD* _progressHUD;
    TwitterClient* twitterClient;
}
-(void)goToBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人设置";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];

    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.edgesForExtendedLayout =UIRectEdgeNone;
    
    NSArray * textArr=[NSArray arrayWithObjects:@"更改头像",@"修改密码",@"基本信息", nil];
    for (int i=0; i<3; i++) {
        UIView * view =[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel * label=[[UILabel alloc]init];
        label.text=textArr[i];
        [view addSubview:label];
        
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_left"]];
        [view addSubview:imgView];
        if (i==0) {
            view.frame=RectMake_LFL(0, 10, 375, 70);
            label.frame=RectMake_LFL(10, 0, 100, 70);
            imgView.frame=RectMake_LFL(375-18, 55/2, 8, 15);
            iconImgView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375-70, 5, 60,60)];
            iconImgView.image=self.iconImg;
            iconImgView.layer.masksToBounds=YES;
            iconImgView.layer.cornerRadius=imgView.frame.size.width;
            [view addSubview:iconImgView];
        }else{
            view.frame=RectMake_LFL(0,40+i*50, 375, 40);
            label.frame=RectMake_LFL(10, 0, 100, 40);
            imgView.frame=RectMake_LFL(375-18, (40-15)/2, 8, 15);
        }
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        btn.frame=view.bounds;
        [view addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49-64, self.view.bounds.size.width, 49)];
    [btn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor=app.sysTitleColor;
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}
-(void)logOutBtnClick{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"userid"];
    [defaults setObject:@"" forKey:@"username"];
    
    [defaults synchronize];
    [self goToBack];
}
-(void)btnClicked:(UIButton *)btn{
    UIViewController * viewController;
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    imagePickerController.delegate=self;
    imagePickerController.allowsEditing = YES;
    switch (btn.tag) {
        case 0:{
            UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"本地图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction * aa3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addAction:aa1];
            [ac addAction:aa2];
            [ac addAction:aa3];
            [self presentViewController:ac animated:YES completion:nil];
            break;
        }
        case 1:
        {
            ChangePasswordViewController* viewController = [[ChangePasswordViewController alloc] initUserInfo:NO];
            viewController.isPayPassword=NO;
            [self.navigationController pushViewController:viewController animated:true];
            
            break;
        }
        
        case 2:
            viewController = [[UserInfoNewViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil ];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    
    self.iconImg=image;
    preview=[[UIView alloc]initWithFrame:RectMake_LFL(375/2, 667/2+150, 1, 1)];
    preview.backgroundColor=[UIColor clearColor];
    preview.alpha=0;
    
    [self.view addSubview:preview];
    UIImageView * imgView=[[UIImageView alloc]initWithImage:image];
    imgView.frame=RectMake_LFL(50, 0, 200, 200);
    imgView.layer.masksToBounds=YES;
    imgView.layer.cornerRadius=imgView.frame.size.width;
    [preview addSubview:imgView];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=RectMake_LFL((300-120)/3, 220, 60, 30);
    btn.tag=0;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(PreviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [preview addSubview:btn];
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=RectMake_LFL((300-120)/3*2+60, 220, 60, 30);
    btn.tag=1;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(PreviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [preview addSubview:btn];
    [UIView animateWithDuration:1 animations:^{
        preview.frame=RectMake_LFL(75/2, 367/2+150, 300, 300);
        preview.alpha=1;
    } completion:^(BOOL finished) {
        self.myICO = [self imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 330.0)];
       
    }];
}
#pragma mark 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
-(void)PreviewBtnClick:(UIButton *)btn{
    [preview removeFromSuperview];

    NSString * url= @"http://192.168.1.188/App/Android/UserIcon.ashx";
    
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //2.上传文件r

    UIImage * image=[UIImage imageNamed:@"1.jpg"];
    
    NSData *imageData=UIImageJPEGRepresentation(image, 1);


    NSDictionary *dict = @{@"userid":userID,@"ext":@"jpg"};
    NSLog(@"%@",dict);
    
    NSString * encodedStr=[imageData base64EncodedStringWithOptions:0];
    
    NSData * decodedImageData=[[NSData alloc]initWithBase64EncodedString:encodedStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数

        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpg" mimeType:@"application/x-www-form-urlencoded"];
        
        NSInputStream * stream=[NSInputStream inputStreamWithData:imageData];
        [formData appendPartWithInputStream:stream name:@"pic" fileName:@"pic.jpg"  length:decodedImageData.length mimeType:@"application/x-www-form-urlencoded"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        [iconImgView sd_setImageWithURL:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] placeholderImage:[UIImage imageNamed:@"test_Icon.png"]];
        NSLog(@"请求成功：%@", [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
    // 上传配置文件的模型
//    MHUploadParam *upload = [[MHUploadParam alloc] init];
//    upload.data           = decodedImageData;
//    upload.name = @"filename";
//
//
//    [MHNetworkManager uploadFileWithURL:url params:dict successBlock:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
//    } failureBlock:^(NSError *error) {
//        [MBProgressHUD showError:@"上传头像失败!" toView:self.view];
//    } uploadParam:upload showHUD:YES];

}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

-(void)updataUI:(int)type{
    if (self.iconImg) {
        iconImgView.image=self.iconImg;
    }
}
@end
