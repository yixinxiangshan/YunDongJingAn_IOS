//
//  ECHostViewController.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 10/29/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECHostViewController.h"
#import "ECContentViewController.h"

@interface ECHostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic) NSInteger startIndex;

@end

@implementation ECHostViewController

-(id) initPagers:(NSInteger)pageCount{
    self.numberOfTabs = pageCount;
    self = [self init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"ECHostViewController viewDidLoad.......");
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //    [self performSelector:@selector(loadContent) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(loadContent) withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
//- (void)selectTabWithNumberFive {
//    [self selectTabAtIndex:100];
//}
- (void)loadContent {
    //    self.numberOfTabs = self.numberOfTabs;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    //    NSLog(@"ECHostViewController viewForTabAtIndex.......%i",index);
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = [NSString stringWithFormat:@"Tab #%i", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //    NSLog(@"ECHostViewController contentViewControllerForTabAtIndex.......%i",index);
    return [self.contentDelegate getContentView:index];
}



#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [self.contentDelegate didChangeTabToIndex:index];
    //    NSLog(@"ECHostViewController didChangeTabToIndex.......%i",index);
    // Do something useful
}
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    //    NSLog(@"valueForOption %i %i" ,option, self.startIndex);
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 0.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}


@end
