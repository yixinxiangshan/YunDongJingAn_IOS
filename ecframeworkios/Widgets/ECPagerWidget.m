//
//  ECPagerWidget.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 10/29/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECPagerWidget.h"
#import "ECPageUtil.h"
#import "ECAppDelegate.h"
#import "ECHostViewController.h"
#import "ECBaseViewController.h"
#import "NSStringExtends.h"

@interface ECPagerWidget ()<ContentDelegate>

@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic) ECHostViewController *tabHost;
@property (nonatomic) NSInteger nowTab;

@end

@implementation ECPagerWidget

- (id) initWithConfigDic:(NSDictionary *)configDic pageContext:(ECBaseViewController *)pageContext
{
    
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    //    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    // 设置宽度320
    CGRect frame = self.frame;
    frame.size.width = 320;
    [self setFrame:frame];
    [self parsingConfigDic];
    return self;
}

- (void) setdata
{
    //    self.dataDic
    if (self) {
        ECHostViewController *cvc =  [[ECHostViewController alloc] initPagers:[self.dataDic[@"pagerCount"] intValue]];
        cvc.contentDelegate = self;
        [self addSubview:cvc.view];
        [cvc selectTabAtIndex: [self.dataDic[@"pagerCount"] intValue] / 2 - 1 + [self.dataDic[@"offset"] intValue]];
        [self.pageContext addChildViewController:cvc];
        self.tabHost = cvc;
    }
    //    NSLog(@"setData.......");
    [super setdata];
}

//刷新接口，暂时只负责翻页
- (void) refreshWidgetData:(id)dataDic{
    NSDictionary *newDataDic = [dataDic isKindOfClass:[NSString class]] ? [dataDic JSONValue] : dataDic;
    [self.tabHost selectTabAtIndex:[self.dataDic[@"pagerCount"] intValue] / 2 - 1 + [newDataDic[@"offset"] intValue]];
    
}


#pragma mark ContentDelegate
-(UIViewController *) getContentView:(NSUInteger)index{
    NSInteger start = [self.dataDic[@"pagerCount"] intValue] / 2 - 1 + [self.dataDic[@"offset"] intValue];
    NSInteger offset = index - start;
    // NSLog(@"getContentView1.......%@ ",[NSString stringWithFormat:@"%@?offset=%i",self.dataDic[@"itemPageName"],index]);
    ECBaseViewController* ctrl = nil;
    ctrl = [ECPageUtil initPage:[NSString stringWithFormat:@"%@?offset=%li",self.dataDic[@"itemPageName"],(long)offset]  params:nil];
    ctrl.parentView = self.pageContext.view;
    return ctrl;
}

-(void) didChangeTabToIndex:(NSUInteger)index{
    // NSLog(@"pagerWidget didChangeTabToIndex %lu",(unsigned long)index);
    if (self.nowTab != index ) {
        self.nowTab = index;
        NSInteger start = [self.dataDic[@"pagerCount"] intValue] / 2 - 1 + [self.dataDic[@"offset"] intValue];
        NSInteger offset = index - start;
        // NSLog(@"pagerWidget didChangeTabToIndex : %@" ,@{@"position":[NSNumber numberWithInteger:offset]});
        [self.pageContext dispatchJSEvetn:@"onPageSelected" withParams:@{@"position":[NSNumber numberWithInteger:offset]}];
    }
}
@end


