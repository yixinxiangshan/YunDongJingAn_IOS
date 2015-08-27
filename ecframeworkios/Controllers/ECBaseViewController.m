//
//  ECBaseViewController.m
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseViewController.h"
#import "ECPageUtil.h"
#import "ECAppUtil.h"
#import "Constants.h"
#import "ECBaseWidget.h"
#import "Constants.h"
#import "ECJSUtil.h"
#import "ECJsonUtil.h"
#import "ECViewUtil.h"
#import "NSStringExtends.h"
#import "UIImage+Resize.h"
#import "NSArrayExtends.h"
#import "NSDictionaryExtends.h"

#import "NSObjectExtends.h"
#import "Toast+UIView.h"

#import "ECJSAPI.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface ECBaseViewController () <UIGestureRecognizerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString* paramsString;
@property (nonatomic, strong) UITapGestureRecognizer* singleTouchInView;
@property (nonatomic, strong) UIActionSheet* imagePickerActionSheet;
@property (nonatomic, strong) id<SystemImagePickerDelegate> imagePickerDelegate;
@property (nonatomic, assign) int contentViewHeight;
@end

@implementation ECBaseViewController

-(id) initWithPageName:(NSString*)pageName{
    return [self initWithPageName:pageName params:nil];
}
-(id) initWithPageName:(NSString*)pageName params:(NSString*)paramsString{
    return [self initWithPageName:pageName params:paramsString parentView:nil];
}
//适用于tab、channel等控件初始化子页面时使用
-(id) initWithPageName:(NSString*)pageName params:(NSString*)paramsString parentView:(UIView*)parentView{
    // 标记一下页面还没有初始化完成
    self.isCreated = NO;
    //    pagename是个url，path部分用于寻找page，其他部分是参数
    NSURL *url = [NSURL URLWithString:pageName];
    for (NSString *keyValuePair in [[url query] componentsSeparatedByString:@"&"]){
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        [self putParam:[pairComponents objectAtIndex:0] value:[pairComponents objectAtIndex:1]];
    }
    NSString* pageConfigString = [ECPageUtil loadConfigString:[url path]];
    NSString* pageNibName = [ECPageUtil getPageNibName:pageConfigString];
    //    ECLog(@"initWithPageName step one ...");
    if (pageNibName) {
        self = [super initWithNibName:pageNibName bundle:nil];
    }else{
        self = [super initWithNibName:@"PageLayoutDefault" bundle:nil];
    }
    if (self) {
        _pageName = [url path];
        _pageConfigSTring = pageConfigString;
        //        self.pageId = [pageConfigString JSONValue][@"page_id"];
        // ECLog(@"initWithPageName pageid: %@",pageName);
        self.pageId = pageName;
        _parentView = parentView;
        _paramsString = paramsString && paramsString.length > 2 ? paramsString : @"{}";
        
        //        ECLog(@"initWithPageName _pageName : %@ ; _pageConfigSTring : %@ ; self.pageId : %@ ; _paramsString : %@",_pageName,_pageConfigSTring ,[pageConfigString JSONValue][@"page_id"],_paramsString);
        //初始化 mMap
        if (!_mMap) {
            self.mMap = [NSMutableDictionary dictionaryWithDictionary:[_paramsString JSONValue]];
        }else{
            [_mMap addEntriesFromDictionary:[_paramsString JSONValue]];
        }
        if (ISIOS7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    // ECLog(@"%@ initWithPageName ..." , self.pageId);
    if (_parentView != nil) {
        [_parentView addSubview:[self view]];
    }
    return self;
}

-(void) putParam:(NSString*)key value:(NSString*)value{
    if (!_mMap) {
        _mMap = [NSMutableDictionary new];
    }
    if (key && value) {
        //ECLog(@"%@ putParam : key = %@ , value class = %@",self,key,[value class]);
        [_mMap setObject:value forKey:key];
    }
}

- (NSString*)getParam:(NSString*)key{
    if (!_mMap) {
        return nil;
    }
    return [_mMap objectForKey:key];
}

- (void) putWidget:(NSString*)controlId widget:(ECBaseWidget*)widget{
    // NSLog(@"~~~~~~~~~~~~~~~~~~~putwidget %@: %@ ;  %@ ;  %@" , self.id , self.jsContext ,controlId , widget);
    
    if (!_mMap) {
        _mMap = [NSMutableDictionary new];
    }
    if (controlId && widget) {
        [_mMap setObject:widget forKey:widget.id];
    }
    
    // NSLog(@"putwidget result : %@" , _mMap);
}
- (ECBaseWidget*)getWidget:(NSString*)controlId{
    id widget = [_mMap objectForKey:[[NSString alloc] initWithFormat:@"%@_%@" , self.id,controlId ]];
    if ([widget isKindOfClass:[ECBaseWidget class]]) {
        return widget;
    }
    return nil;
}

- (void) resizeScrollContainer{
    
    NSArray* views = [self.view subviews];
    
    //    ECLog(@"ECBaseViewController resizeScrollContainer  = %@ -----------------------------------",views);
    UIView* view = nil;
    int i = 0;
    for (UIView* tempView in views) {
        // ECLog(@"view = %@ -----------------------------------%d",tempView,i);
        i++;
        if (view == nil)
            view = tempView;
        if (tempView.frame.origin.y > view.frame.origin.y)
            view = tempView;
    }
    float height = view.frame.origin.y+view.frame.size.height+80;
    
    //    CGRect frame = _container.frame;
    //    frame.size.height = self.frame.size.height;
    //    _container.frame = frame;
    
    [(UIScrollView*)self.view setContentSize:CGSizeMake(((UIScrollView*)self.view).contentSize.width, height)];
    ECLog(@"((UIScrollView*)self.view) ContentSize height  = %f",((UIScrollView*)self.view).contentSize.height);
}

#pragma mark- attr set , override
- (void) setPageId:(NSString *)pageId
{
    _pageId = pageId;
    self.id = pageId;
}

#pragma mark- life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // NSLog(@"start page ...................................................................... %@", self.id);
    //ECLog(@"viewDidLoad : %@ " , self.pageId);
    
    CGRect rootViewFrame = [UIScreen mainScreen].bounds;
    [self.view setFrame:rootViewFrame];
    // NSLog(@"ECBaseViewController viewDidLoad %@" ,_parentView);
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];

    // 设置宽度320
    //    CGRect frame = self.view.frame;
    //    frame.size.width = 320;
    //    [self.view setFrame:frame];
    if (_parentView != nil) {
        CGRect frame = self.view.frame;
        frame.size.width = _parentView.frame.size.width;
        frame.size.height = _parentView.frame.size.height;
        self.view.frame = frame;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _singleTouchInView=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(touchedInView:)];
    _singleTouchInView.delegate = self;
    
    //init pageJSEvent
    self.pageJSEvent = [NSMutableDictionary new];
    // init jsContext
    self.waitBeforeLoadView = NO;
    self.jsContext = [[ECJSContext alloc] initWithParent:self];
    NSString *filePath = [NSString stringWithFormat:@"%@/config/%@",[NSString appConfigPath],[self.pageName stringByAppendingString:@".js"]];
    NSString *jsString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    //流处理  安全问题 待解决。
    if (EC_ENCRYPT_ON) {
        NSFileHandle *inFile;
        inFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData* data = [inFile readDataToEndOfFile];
        //加密
        NSString* aPassword = AES_KEY;
        NSError *error;
        //        NSData *encryptedData = [RNEncryptor encryptData:data
        //                                            withSettings:kRNCryptorAES256Settings
        //                                                password:aPassword
        //                                                   error:&error];
        //        NSLog(@"%@",[[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding]);
        //        解密
        data = [RNDecryptor decryptData:data
                           withPassword:aPassword
                                  error:&error];
        //        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [_jsContext evaluateScript: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        [inFile closeFile];
    }
    else{
        
        [_jsContext evaluateScript:jsString ? jsString : @""];
    }
    
    
    [[ECAppUtil shareInstance] setOnPageStarted:self];
    [ECPageUtil putPageParams:_paramsString];
    
    [ECPageUtil initPage:self pageConfigString:_pageConfigSTring];
    self.isWidgetInit = NO;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateActionBar];
    [self callWidgetWithMethodName:@"viewWillApper"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ECAppUtil shareInstance] setOnPageStarted:self];
    
    //触发页面 onPageResume 事件
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onPageResume(\"{\\\"pageId\\\":\\\"%@\\\"}\")",self.pageId,self.pageId];
    //    [[ECJSUtil shareInstance] runJS:jsString];
    
    //    ECLog(@"%@   viewDidAppear........",self.pageId);
    //    NSString* stringFromClosedCtrl = [[ECAppUtil shareInstance] getParam:@"close_page_success_js"];
    //    if (stringFromClosedCtrl && ![stringFromClosedCtrl isEmpty]) {
    //        [[ECJSUtil shareInstance] runJS:stringFromClosedCtrl];
    //
    //        [[ECAppUtil shareInstance] putParam:nil value:@"close_page_success_js"];
    //    }
    if (!_isWidgetInit) {
        [ECPageUtil getPageData:[ECJsonUtil objectWithJsonString:_pageConfigSTring] pageContext:self];
    }
    
    [self callWidgetWithMethodName:@"viewDidAppear"];
    
    if ( self.isCreated == NO) {
        //单通道 js 接口 onCreate
        [self dispatchLifeCircleEvetn:kOnPageCreated];
        self.isCreated = YES;
    }
    
    //单通道 js 接口 onResume
    [self dispatchLifeCircleEvetn:kOnPageResume];
}
- (void)viewWillDisappear:(BOOL)animated{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound && [[[ECAppUtil shareInstance] controllers] containsObject:self]) {
        // NSLog(@"View controller was popped");
        [[ECAppUtil shareInstance] setOnPageDestroyed:self];
    }
    [self callWidgetWithMethodName:@"viewWillDisappear"];
}
- (void) viewDidDisappear:(BOOL)animated
{
    // NSLog(@"end page ...................................................................... %@", self.id);
    [self callWidgetWithMethodName:@"viewDidDisappear"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark- update ActionBar
- (void) updateActionBar
{
    //    ECLog(@"updateActionBar");
    
    if (self.actionBar) {
        [self.actionBar updateActionBar];
    }else{
        //        [[ECAppUtil shareInstance] getNowController].navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        //        [[ECAppUtil shareInstance] getNowController].navigationItem.title = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UPDATEACTIONBAR object:self];
}

- (void)openImagePiker:(id<SystemImagePickerDelegate>) imagePickerDelegate{
    _imagePickerDelegate = imagePickerDelegate;
    _imagePickerActionSheet =  [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_imagePickerActionSheet showInView:[[[ECAppUtil shareInstance] nowPageContext] view]];
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 1:  //打开本地相册
            [self openImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
    }
}

- (void)openImagePickerWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    
    [[[ECAppUtil shareInstance] nowPageContext] presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image fitToWidth:640.f];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        
        //图片保存的路径
        //这里将图片放在沙盒的tmp文件夹中
        NSString * tmpPath = [NSString appTmpPath];
        
        
        //文件管理器
        
        
        NSString* imageName = [NSString stringWithFormat:@"%@.png",[NSString randomCallID]];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",tmpPath,  imageName];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        //得到选择后沙盒中图片的完整路径
        
        if (_imagePickerDelegate && [_imagePickerDelegate respondsToSelector:@selector(getImageFile:image:)]) {
            [_imagePickerDelegate getImageFile:filePath image:image];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -- control the location of input textfield
- (void)keyboardWillShow:(NSNotification *)aNotification {
    if ([self isEqual:[[ECAppUtil shareInstance] nowPageContext]]) {
        ECLog(@"keyboardWillShow");
        [self animateTextField:aNotification up:YES];
        [self.view addGestureRecognizer:_singleTouchInView];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    if ([self isEqual:[[ECAppUtil shareInstance] nowPageContext]]) {
        [self animateTextField:aNotification up:NO];
        [self.view removeGestureRecognizer:_singleTouchInView];
    }
}

- (void) animateTextField: (NSNotification*) aNotification up: (BOOL) up
{
    
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    const int movementDistance = keyboardSize.height; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    UIView* contentView = [ECViewUtil findViewById:@"activity_item_container_llayout" view:[[[ECAppUtil shareInstance] nowPageContext] view]];
    if (_contentViewHeight<=0) {
        _contentViewHeight = contentView.frame.size.height;
    }
    //TODO: 这可能是个坑哦, 计算当前容器的contentSize
    if ([contentView isKindOfClass:[UIScrollView class]] && [(UIScrollView*)contentView contentSize].height <= 0) {
        [(UIScrollView*)contentView setContentSize:CGSizeMake([(UIScrollView*)contentView contentSize].width, _contentViewHeight)];
    }
    CGFloat yValue = _contentViewHeight;
    if (up) {
        yValue = _contentViewHeight - movementDistance;
    }
    ECLog(@"%@ contentsize = %f",contentView,[(UIScrollView*)contentView contentSize].height);
    CGRect frame = contentView.frame;
    frame.size.height = yValue;
    contentView.frame = frame;
    [UIView commitAnimations];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        if (![touch.view conformsToProtocol:@protocol(UITextInput)]) {
            [self.view endEditing:YES];
        }
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}
- (void) touchedInView:(UITapGestureRecognizer*) gestureRecognizer{
    [self.view endEditing:YES];
}
#pragma mark- call widget's view translate method
- (void) callWidgetWithMethodName:(NSString *)methodName
{
    SEL selector = NSSelectorFromString(@"pageEventWith:");
    id key;
    NSEnumerator* enumrator = [self.mMap keyEnumerator];
    while (key = [enumrator nextObject]) {
        ECBaseWidget* widget = [self.mMap objectForKey:key];
        if ([widget respondsToSelector:selector]) {
            [widget performSelector:selector withObject:methodName];
        }
    }
}
@end

@implementation ECBaseViewController (ECJSSimpleAPI)

- (void)pageWait
{
    self.waitBeforeLoadView = YES;
    [self.view makeToastActivity];
}
- (void)pageResumeWait
{
    if (self.waitBeforeLoadView) {
        self.waitBeforeLoadView = NO;
        [ECPageUtil initPage:self pageConfigString:_pageConfigSTring];
        if (!_isWidgetInit) {
            [ECPageUtil getPageData:[ECJsonUtil objectWithJsonString:_pageConfigSTring] pageContext:self];
        }
    }
    [self.view hideToastActivity];
}

- (void) dispatchLifeCircleEvetn:(NSString *)eventName
{
    //    NSDictionary *event = self.pageJSEvent[eventName];
    //    [ECJSAPI dispatch_page_on_event:event];
    [self dispatchJSEvetn:eventName withParams:nil];
}

- (BOOL)dispatchJSEvetn:(NSString *)eventName withParams:(id)params
{
    NSDictionary *event = self.pageJSEvent[eventName];
    if (event) {
        [ECJSAPI dispatch_page_on_event:event withParams:params];
        return YES;
    }
    return NO;
}
- (void)putWidgetData:(id)data withWidgetId:(NSString *)widgetId
{
    //    NSString *dataString;
    //    if ([data isKindOfClass:[NSString class]]) {
    //        dataString = data;
    //    }else{
    //        dataString = [data JSONString];
    //    }
    [self putParam:[widgetId stringByAppendingString:@"__data"] value:data];
}

- (id)getWidgetData:(NSString *)widgetId
{
    return [self getParam:[widgetId stringByAppendingString:@"__data"]];
}



@end