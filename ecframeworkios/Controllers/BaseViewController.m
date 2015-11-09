//
//  BaseViewController.m
//  YHMapDemo
//
//  Created by 单徐梅 on 15/10/2.
//
//

#import "BaseViewController.h"
//#import "Extends.h"
#import "ECViewUtil.h"
#import <UIKit/UIGeometry.h>
//#import "DisplayUtil.h"
#import "ECNetManager.h"
#import "ECJsonUtil.h"

#define TAG "BaseViewController"


@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ECLog(@"ECBaseViewController viewDidLoad : ");
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 读取配置文件
    _configName = @"ECLeDongDiTuConfig";
    //[self.url.params objectForKey:@"configName"];
    _instanceName = _configName;
    _isShowContent = YES;
    if (nil == _configName || [@"" isEqualToString:_configName]) {
        NSLog(@"%@ 参数传递错误：缺少config项",NSStringFromClass([self class]));
        return;
    }else{
        NSURL *PlistURL = [[NSBundle mainBundle] URLForResource:_configName withExtension:@"plist"];
        self.configs =  [NSDictionary dictionaryWithContentsOfURL:PlistURL];
        
        ECLog(@"%s configs: %@",TAG,self.configs);
        
        self.styles = [self.configs objectForKey:@"style"];
        self.navTitle = [self.configs objectForKey:@"navTitle"];
        self.netDataRelevant = [self.configs objectForKey:@"netDataRelevant"];
        //self.isNeedLogin = [(NSNumber*)[self.configs objectForKey:@"isNeedLogin"] boolValue];
    }
    if (nil == self.configs || self.configs == NULL) {
        
        //[[ECClearApp shareInstance] exitApp:@"程序错误" message:@"退出程序：参数传递错误！"];
    }
    
    if (nil != [self.query objectForKey:@"navTitle"]) {
        self.navTitle = [self.query objectForKey:@"navTitle"];
    }
    if (nil != self.navTitle) {
        self.navigationItem.title = self.navTitle;
    }
    if (nil != [[self.configs objectForKey:@"style" ] objectForKey:@"hasNavigationBar"])
    {
        if ([@"NO" isEqual:[[self.configs objectForKey:@"style" ] objectForKey:@"hasNavigationBar"]]) {
            NSLog(@"nav ctrl hidden.");
            [self.navigationController setNavigationBarHidden:YES];
        }else
        {
            NSLog(@"nav ctrl show.");
            [self.navigationController setNavigationBarHidden:NO];
        }
        
    }
    
    //设置背景
    if (nil != [[self.configs objectForKey:@"style"] objectForKey:@"viewBg"] && ![[[self.configs objectForKey:@"style"] objectForKey:@"viewBg"] isEqual:@""]) {
        
        [self setViewBackgroud:self.view withImage:[UIImage imageNamed:[[self.configs objectForKey:@"style"] objectForKey:@"viewBg"]]];
    }else{
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    //NavigationBar backGround
    [self.navigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground.png"] forBarMetrics:UIBarMetricsDefault];
    
    //适应iOS7 的样式，设置 Controller.view 属性，不延伸到 statusbar及navigationBar 下面；
    if ( ISIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        //[self.navigator.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigator.navigationBar setTintColor:nil];
        
    }else{
        [self.navigator.navigationBar setTintColor:[UIColor colorWithRed:0.53 green:0.15 blue:0.18 alpha:1.00]];
    }
    
    //返回按扭
    ECLog(@"set back button");
    UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
    back.style = UIBarButtonItemStyleBordered;
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void) viewWillAppear:(BOOL)animated{
//    if (self.isNeedLogin) {
//        if (nil == [ECKeyChain userName] || [@"" isEqualToString:[ECKeyChain userName]]) {
//            [self addNeedLoginView];
//            _isShowContent = NO;
//        }else{
//            [_needLoginView removeFromSuperview];
//            _isShowContent = YES;
//        }
//    }
    _isShowContent = YES;

    if (nil != [[self.configs objectForKey:@"style" ] objectForKey:@"hasNavigationBar"])
    {
        if ([@"NO" isEqual:[[self.configs objectForKey:@"style" ] objectForKey:@"hasNavigationBar"]]) {
            if (![self.navigationController isNavigationBarHidden]) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
            
        }else
        {
            if ([self.navigationController isNavigationBarHidden]) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                //NavigationBar backGround
                [self.navigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground.png"] forBarMetrics:UIBarMetricsDefault];
            }
            
        }
        
    }
}

#pragma mark - 网络请求失败
- (void)webRequestFailed:(NSNotification*)request{
    [self removeLoading];
    NSDictionary* jsonData = request.userInfo;
    NSString *reponseString=[NSString stringWithFormat:@"json error data is %@", jsonData];
    ECLog(@"%s responseString:%@",TAG,reponseString);
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"获取信息失败" message:@"网络不给力!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}
#pragma mark - 网络请求成功
- (void)requestFindished:(NSNotification*)request{
    
    NSDictionary* jsonData = request.userInfo;
    NSString *reponseString=[NSString stringWithFormat:@"json data is %@", jsonData];
    
    ECLog(@"%s responseString:%@",TAG,reponseString);
    if ([reponseString rangeOfString:@"\"error\""].location != NSNotFound || [reponseString rangeOfString:@"\"Error\""].location != NSNotFound || [reponseString rangeOfString:@"\"error_num\""].location != NSNotFound) {
        //        [[ECSpecRequest shareInstance] showError:reponseString];
        NSLog(@"response error:%@",reponseString);
    }
    else{
        //NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:jsonData];
        NSData *myData = [ECJsonUtil dataWithDic:jsonData];
        [self handleRequestData:myData];
    }
    // 处理完成后 移除加载框
    [self removeLoading];
    
}

- (void)handleRequestData:(NSData*)data{
    ECLog(@"%s Start Handling Data From Request...",TAG);
}

#pragma mark - 显示弹出框
- (void)showLoading:(NSString*)message{
    if ([ECNetManager networdEnabled]) {
        //[ECPopViewUtil showLoading:message view:self.view];
        [ECViewUtil showLoadingDialog:nil loadingMessage:message cancelAble:NO];
    }
}
- (void)removeLoading{
    //[ECLoadingBezelActivityView removeViewAnimated:YES];
    [ECViewUtil closeLoadingDialog];
}

#pragma mark - 退出程序
//- (void)exitApp{
//    [[ECClearApp shareInstance] exitAppForNet];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setViewBackgroud:(UIView *)view withImage:(UIImage *)backgroudImage
{
    UIGraphicsBeginImageContext(view.frame.size);
    [backgroudImage drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}
@end

