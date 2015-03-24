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

@interface ECQRCapture () <ZBarReaderViewDelegate>{;
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
    //生成视图
    self.readerView = [[ZBarReaderView alloc] init];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    // NSLog(@"initscanner frame height: %f",frame.size.height);
    [self.readerView setFrame:frame];
    self.readerView.readerDelegate = self;
    
    //控制按钮
    UIView* controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.readerView.frame.size.height - 44, self.readerView.frame.size.width, 44)];
    [controlBar setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.7]];
    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(64, 0, 64, 44)];
    UIButton* activeButton = [[UIButton alloc] initWithFrame:CGRectMake(192, 0, 64, 44)];
    cancelButton.tintColor = [UIColor whiteColor];
    activeButton.tintColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [activeButton setTitle:@"确定" forState:UIControlStateNormal];
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
    [self.readerView stop];
    [self.readerView removeFromSuperview];
    [[[[ECAppUtil shareInstance] getNowController] navigationController] setNavigationBarHidden:NO];  //显示actionbar
}

// 显示扫描器
- (void) displayScanner
{
    UIView* rootView = [[[[[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers] lastObject] view];
    [rootView addSubview:self.readerView];
    [self.readerView start];
}
#pragma mark- dill scan result
//处理扫描结果
- (void) didScanResult:(NSString *)result
{
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
