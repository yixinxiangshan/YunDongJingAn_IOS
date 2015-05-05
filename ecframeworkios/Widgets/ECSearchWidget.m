//
//  ECSearchWidget.m
//  ECIOSProject
//
//  Created by cheng on 14-1-15.
//  Copyright (c) 2014年 ecloud. All rights reserved.
//

#import "ECSearchWidget.h"
#import "NSStringExtends.h"
#import "ECJSUtil.h"
#import "ECBaseViewController.h"

@interface ECSearchWidget () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar* searchBar;

@end

@implementation ECSearchWidget
- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext
{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECTabWidget";
    }
    if (self.controlId == nil || [self.controlId isEmpty]) {
        self.controlId  = @"tab_widget";
    }
    if (self) {
        [self setViewId:@"tab_widget"];
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        
        self.searchBar.delegate = self;
        [self addSubview:_searchBar];
        [self setFrame:_searchBar.frame];
    }
    [self parsingConfigDic];
    return self;
}

- (void) setdata
{
    [super setdata];
}
#pragma mark-
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* jsString = [NSString stringWithFormat:@"%@.onQueryText(\"{\\\"controlId\\\" : \\\"%@\\\", \\\"queryText\\\": \\\"%@\\\"}\")", self.controlId, self.self.controlId, self.searchBar.text];
    [[ECJSUtil shareInstance] runJS:jsString];
    
    //page_widget_onSubmit
    [self.pageContext dispatchJSEvetn:[self.controlId stringByAppendingString:@".onSubmit"] withParams:@{@"queryString":self.searchBar.text}];
    
    //隐藏键盘
    [self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

@end
