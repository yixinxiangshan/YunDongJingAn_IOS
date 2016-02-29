//
//  ECQRCapture.m
//  NowMarry
//
//  Created by cheng on 13-12-6.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECQRCapture.h"
#import "ZBarSDK.h"
#import "ECAppUtil.h"

#define SCANVIEW_EdgeTop 104.0
#define SCANVIEW_EdgeLeft 50.0

#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度

@interface ECQRCapture () <ZBarReaderViewDelegate, ZBarReaderDelegate>{
    UIView *_QrCodeline;
    NSTimer *_timer;
    
    //设置扫描画面
    UIView *_scanView;
}

@property (nonatomic, copy) QRCaptureBlock resultCallBack;
@property (strong, nonatomic) ZBarReaderView* readerView;

//  Scanner 启动时，传入action，action执行结束后，置空
@property (strong, nonatomic) NSDictionary* query;
@end

@implementation ECQRCapture

- (id) init
{
    return [[self class] shareInstance];
}

+ (id) shareInstance
{
    static ECQRCapture* scanner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [[ECQRCapture alloc] initScanner];
    });
    return scanner;
}

- (id) initScanner
{
    //生成扫描视图
    [self setScanView];
    //生成视图
    self.readerView = [[ZBarReaderView alloc] init];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    //NSLog(@"init scanner frame height: %f, %f",frame.size.height, frame.size.width);
    [self.readerView setFrame:frame];
    [self.readerView addSubview:_scanView];
    self.readerView.readerDelegate = self;
    //关闭闪光灯
    self.readerView.torchMode = 0;
    self.readerView.allowsPinchZoom = NO;
    self.readerView.tracksSymbols = NO;
    
    //控制按钮
    UIView* controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.readerView.frame.size.height - 44, self.readerView.frame.size.width, 44)];
    [controlBar setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.7]];
    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(64, 0, 64, 44)];
    UIButton* activeButton = [[UIButton alloc] initWithFrame:CGRectMake(192, 0, 64, 44)];
    cancelButton.tintColor = [UIColor whiteColor];
    activeButton.tintColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    //[activeButton setTitle:@"确定" forState:UIControlStateNormal];
    [controlBar addSubview:cancelButton];
    //    [controlBar addSubview:activeButton];
    [cancelButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    //    [activeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.readerView addSubview:controlBar];
    return self;
}
+ (void) start:(QRCaptureBlock)block
{
    [[[[ECAppUtil shareInstance] getNowController] navigationController] setNavigationBarHidden:YES];  //隐藏actionbar
    ECQRCapture* scanner = [[self class] shareInstance];
    scanner.resultCallBack = block;
    [[self class] start];
}
+ (void) start
{
    
    ECQRCapture* scanner = [[self class] shareInstance];
    
    [scanner displayScanner];
    
}
- (void) done
{
    [self cancel];
}
- (void) cancel
{
    [self stopTimer];
    [self.readerView stop];
    [self.readerView removeFromSuperview];
    [[[[ECAppUtil shareInstance] getNowController] navigationController] setNavigationBarHidden:NO];  //显示actionbar
}

// 显示扫描器
- (void) displayScanner
{
    
    UIView* rootView = [[[[[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers] lastObject] view];
//    self.readerView.alpha = 0.0;
    [rootView addSubview:self.readerView];
    //二维码识别设置
    ZBarImageScanner *scanner = self.readerView.scanner;
    [scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    //扫描区域计算
//    CGRect scanMaskRect =CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, [[UIScreen mainScreen] bounds].size.width-2*SCANVIEW_EdgeLeft,[[UIScreen mainScreen] bounds].size.width-2*SCANVIEW_EdgeLeft);
//    self.readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.readerView.bounds];
    [self createTimer];
    [self.readerView start];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

//二维码的横线移动
- (void)moveUpAndDownLine
{
    int screen_width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat Y=_QrCodeline.frame.origin.y;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (screen_width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, screen_width-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }else if(SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, screen_width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, screen_width-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }
}

- (void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}


//二维码的扫描区域
- (void)setScanView
{
    int screen_width = [[UIScreen mainScreen] bounds].size.width;
    int screen_height = [[UIScreen mainScreen] bounds].size.height;
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, screen_width, screen_height)];
    _scanView.backgroundColor=[UIColor clearColor];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screen_width, SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,screen_width-2*SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, screen_width-2*SCANVIEW_EdgeLeft,screen_width-2*SCANVIEW_EdgeLeft)];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView.layer.borderColor=[UIColor greenColor].CGColor;
    scanCropView.layer.borderWidth=2.0;
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(screen_width-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,screen_width-2*SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,screen_width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,screen_width, screen_height-44)];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,5, screen_width,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,screen_width, 100.0)];
    darkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:DARKCOLOR_ALPHA];
    [downView addSubview:darkView];
    //用于开关灯操作的button
//    UIButton *openButton=[[UIButtonalloc] initWithFrame:CGRectMake(10,20, 300.0, 40.0)];
//    [openButtonsetTitle:@"开启闪光灯" forState:UIControlStateNormal];
//    [openButton setTitleColor:[UIColorwhiteColor] forState:UIControlStateNormal];
//    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//    openButton.backgroundColor=[UIColorgetThemeColor];
//    openButton.titleLabel.font=[UIFontsystemFontOfSize:22.0];
//    [openButton addTarget:selfaction:@selector(openLight)forControlEvents:UIControlEventTouchUpInside];
//    [darkViewaddSubview:openButton];
    //画中间的基准线
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, screen_width-2*SCANVIEW_EdgeLeft,2)];
    _QrCodeline.backgroundColor = [UIColor greenColor];
    [_scanView addSubview:_QrCodeline];
}

#pragma mark- dill scan result
//处理扫描结果
- (void) didScanResult:(NSString *)result
{
    NSLog(@"get result and quit ... %@", result);
    self.resultCallBack(result);
    [self cancel];
}

#pragma  mark- zbarReaderView delegate
- (void) readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for(ZBarSymbol *sym in symbols) {
        [self didScanResult:sym.data];
        break;
    }
}

@end
