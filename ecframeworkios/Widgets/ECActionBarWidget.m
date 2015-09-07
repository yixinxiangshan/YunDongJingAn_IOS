//
//  ECActionBarWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/17/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECActionBarWidget.h"
#import "ECAppUtil.h"
#import "Constants.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "ECImageUtil.h"
#import "UIView+Size.h"
#import "UIImageView+Size.h"
#import "UIImage+Color.h"
#import "UIColorExtends.h"
#import "UIImage+Resource.h"
#import "ECPageUtil.h"

#define TAG "ECActionBarWidget"
#define imageFormat @".png"
#define Default_Home_Icon @""
#define Default_Seprator_line @""
#define CustomButton_width 44

@interface ECActionBarWidget ()
@property BOOL withActionBar;
@property BOOL withHomeItem;
@property (strong, nonatomic) NSString* homeIcon;
@property (strong, nonatomic) NSString* actionBarBg;
@property (strong, nonatomic) NSString* navTitle;
@property (strong, nonatomic) NSString* subTitle;
@property (strong, nonatomic) NSString* menuResName;
@property BOOL withHomeAsUp;

@property (strong, nonatomic) NSArray* menuList;
@property (strong, nonatomic) NSDictionary* navTagData;
@property (strong, nonatomic) NSArray* navTagList;

@property (strong, nonatomic) UIButton* navPopMenu;
@property (strong, nonatomic) NSMutableArray*  popMenu;

@property (strong, nonatomic) ECBaseViewController* nowController;
@property (strong, nonatomic) UINavigationController* navController;
@end
@implementation ECActionBarWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    if (pageContext.actionBar) {
        self = pageContext.actionBar;
    }else{
        self = [super initWithConfigDic:configDic pageContext:pageContext];
        pageContext.actionBar = self;
    }
    [self parsingConfigDic];
    
    return self;
}

- (void) setdata
{
    [super setdata];
    // ECLog(@"ECActionBarWidget setdata : %@" , self.configDic);
    _withActionBar = [[self.dataDic objectForKey:@"withActionBar"] boolValue];
    
    _withHomeItem = [[self.dataDic objectForKey:@"withHomeItem"] boolValue];
    _homeIcon = [self.dataDic objectForKey:@"homeIcon"];
    _actionBarBg = [self.dataDic objectForKey:@"actionBarBg"];
    _navTitle = _navTitle ? _navTitle :[self.dataDic objectForKey:@"title"];
    _subTitle = [self.dataDic objectForKey:@"subTitle"];
    _menuResName = [self.dataDic objectForKey:@"menuResName"];
    _withHomeAsUp = [[self.dataDic objectForKey:@"withHomeAsUp"] boolValue];
    
    NSDictionary* menuItemsData = [self.dataDic objectForKey:@"menuItemsData"];
    if (menuItemsData) {
        _menuList = [menuItemsData objectForKey:@"menuList"];
    }
    _navTagData = [self.dataDic objectForKey:@"navTagData"];
    if (_navTagData) {
        _navTagList = [_navTagData objectForKey:@"navTagList"];
    }
    [self updateActionBar];
}
- (void) updateActionBar
{
    
    //    UIColor *titleColor = [self.dataDic[@"titleColor"] length] ? [UIColor colorWithHexString:self.dataDic[@"titleColor"]] : [UIColor colorWithRed:0.15 green:0.09 blue:0.08 alpha:1.00];
    UIColor *titleColor = [self.dataDic[@"titleColor"] length] ? [UIColor colorWithHexString:self.dataDic[@"titleColor"]] : [UIColor colorWithHexString:@"#000000"];
    _nowController.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:titleColor,UITextAttributeFont:[UIFont systemFontOfSize:17]};
    
    _nowController = [[ECAppUtil shareInstance] getNowController];
    _navController = [_nowController navigationController];

    //    ECLog(@"set navigationbar ... %@",_navController);
    //设置是否隐藏,
    [_navController setNavigationBarHidden:!_withActionBar];
    //设置title
    //ECLog(@"ECActionBarWidget updateActionBar width1: %@" , _navTitle);
    [self setTitle:_navTitle];
    //设置背景
    [_navController.navigationBar setBackgroundImage:[self parseBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    if (ISIOS7) {
        [_nowController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }else{
        //TODO: 兼容ios6 及以下版本，若_actionBarBg传入的是图片名（非 #aabbcc格式）则出错
        UIColor* color = [_actionBarBg hasPrefix:@"#"] > 0 ? [UIColor colorWithHexString:_actionBarBg] : nil;
        if (!color) {
            color = [UIColor colorWithRed:0.95 green:0.96 blue:0.95 alpha:1.00];
        }
        if (color) {
            [_nowController.navigationController.navigationBar setTintColor:color];
        }
    }
    //设置返回铵钮图片
    [self setHomeIcon:_homeIcon];
    //    设置返回按钮事件

    [self setRightItemView];
    
    [super sizeToFit];
}

/**
 * private method
 */
- (void) setRightItemView
{
    if (!_rightItemView && (_navTagList || _menuList)) {
        _rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        
        //        if (_navTagList && _navTagList.count > 0) {
        //            NSString* defaultTitle = [[_navTagList objectAtIndex:[[_navTagData objectForKey:@"selectedItem"] integerValue]] objectForKey:@"title"];
        //            _navPopMenu = [self customButton:nil highLightImage:nil title:defaultTitle clickTitle:nil action:@selector(popMenu:)];
        //            [_rightItemView addSubview:_navPopMenu];
        //        }
        if (_menuList != nil && _menuList.count > 0) {
            
            for (int i = 0 ; i < _menuList.count ; i ++) {
                NSDictionary* itemConfig = [_menuList objectAtIndex:i];
                NSString* iconName = [NSString stringWithFormat:@"%@",[itemConfig objectForKey:@"iconName"]];
                UIImage *iconImage = [UIImage imageWithPath:iconName];
                NSString *showAsAction = [itemConfig objectForKey:@"showAsAction"];
                
                if (!iconImage) {
                    //                    ECLog(@"image for name %@ is not exist .",iconName);
                    iconImage = [ECImageUtil imageWithUIColor:[UIColor grayColor]];
                }
                if(_menuList.count == 1 && [showAsAction isEqual:@"always" ])
                {
                    //show the icon on the navigation bar
                    ECButton* button = [self customButton:iconImage highLightImage:nil title:nil clickTitle:nil action:@selector(goToMe:)];
                    //button.title = @"";
                    button.viewId = [itemConfig objectForKey:@"clickTag"];
                    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                    _nowController.navigationItem.rightBarButtonItem = barButtonItem;
                }
                else
                {
                    ECButton* menuListItem = [self customButton:iconImage highLightImage:nil title:[itemConfig objectForKey:@"title"] clickTitle:nil action:@selector(menuListItemClicked:)];
                    menuListItem.title = [itemConfig objectForKey:@"title"];
                    menuListItem.viewId = [itemConfig objectForKey:@"itemId"];
                    menuListItem.tag = i;
                    [_rightItemView addSubview:menuListItem];
                }
            }
            //            NSString* defaultTitle = [[_navTagList objectAtIndex:[[_navTagData objectForKey:@"selectedItem"] integerValue]] objectForKey:@"title"];
            //            _navPopMenu = [self customButton:[UIImage imageWithPath:@"webview/images/icon/default/widget_actionbar_button_overflow.png"] highLightImage:nil title:nil clickTitle:nil action:@selector(popMenu:)];
            //            [_rightItemView addSubview:_navPopMenu];
            //            设置带颜色的btn
            if(_menuList.count > 1)
            {
                UIImage *menuImage=[UIImage imageWithPath:@"webview/images/icon/default/widget_actionbar_button_overflow.png"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.bounds = CGRectMake( 0, 0, menuImage.size.width, menuImage.size.height );
                [button setImage:menuImage forState:UIControlStateNormal];
                [button addTarget:self action:@selector(popMenu:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                //            barbtn.image=menuImage;
                _nowController.navigationItem.rightBarButtonItem = barButtonItem;
            }
        }
    }
    if (_rightItemView.subviews.count == 0) {
        _rightItemView = nil;
        //        return;
    }
    
    [self updateRightItemViewSize];
    //    _nowController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightItemView];
    
}
- (void) setHomeIcon:(NSString *)homeIcon
{
    //先清除，再更新
    _nowController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
    if (!_homeButton) {
        UIImage* image ;
        if (_homeIcon) {
            image = [UIImage imageWithPath:_homeIcon];
        }else{
            image = [UIImage imageWithPath:Default_Home_Icon];
        }
        if (image) {
            _homeButton = [self customButton:image highLightImage:nil title:nil clickTitle:nil action:@selector(onHomButtonClick:)];
        }
        if (_homeButton) {
            _homeButton.title = @"";
            _homeButton.viewId = @"home";
        }
    }
    if (_homeButton) {
        _nowController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_homeButton];
        // 添加左侧划返回前一页面
        _nowController.navigationItem.backBarButtonItem = _nowController.navigationItem.leftBarButtonItem;
        _nowController.navigationController.interactivePopGestureRecognizer.delegate = _nowController;
        // _nowController.navigationItem.leftBarButtonItem = backButton;
        // _nowController.navigationController.interactivePopGestureRecognizer.delegate = self;
        // _nowController.navigationController.interactivePopGestureRecognizer.enabled = YES;

    }else{
        //返回按扭
        //        ECLog(@"set back button");
        UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
        back.style = UIBarButtonItemStyleBordered;
        
        [back setBackButtonBackgroundImage:[self parseBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        //        UIColor *titleColor = [self.dataDic[@"titleColor"] length] ? [UIColor colorWithHexString:self.dataDic[@"titleColor"]] : [UIColor colorWithRed:0.15 green:0.09 blue:0.08 alpha:1.00];
        UIColor *titleColor = [self.dataDic[@"titleColor"] length] ? [UIColor colorWithHexString:self.dataDic[@"titleColor"]] : [UIColor colorWithHexString:@"#ffffff"];
        [back setTitleTextAttributes:@{UITextAttributeTextColor:titleColor,UITextAttributeFont:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
        
        back.title = @"返回";
        
        _nowController.navigationItem.backBarButtonItem = back;
    }
}

#pragma home button
- (void) onHomButtonClick:(ECButton *)sender
{
    // NSString* result = @"";
    BOOL hasCustomEvent = [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"ActionBar.%@",kOnBackClick] withParams:nil];
    if (!hasCustomEvent) {
        [ECPageUtil closeNowPage:@""];
        // [_nowController.navigationController popViewControllerAnimated:YES];
    }
}
- (void) goToMe:(ECButton *)sender
{
    //ECLog(@"go to me... %@", sender.viewId);
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"ActionBar.%@",kOnItemClick] withParams:sender.viewId];
}
#pragma popMenu
- (void) popMenu:(ECButton *)sender
{
    if (!_popMenu) {
        _popMenu = [NSMutableArray new];
        for (int position = 0; position < _menuList.count; position ++) {
            NSDictionary* item = [_menuList objectAtIndex:position];
            
            KxMenuItem* menuItem = [KxMenuItem menuItem:[item valueForKey:@"title"]
                                                  image:[UIImage imageWithPath:[item valueForKey:@"iconName"]]
                                                 target:self
                                                 config:item
                                                 action:@selector(popMenuItemClicked:)
                                    ];
            menuItem.viewId = [item objectForKey:@"title"];
            menuItem.position = [NSString stringWithFormat:@"%i",position];
            [_popMenu addObject:menuItem];
        }
    }
    //    调整menu的位置，显示
    CGRect frame = sender.frame;
    frame.origin.y += 20;
    [KxMenu showMenuInView:_navController.view
                  fromRect:frame
                 menuItems:_popMenu
     ];
}
- (void) popMenuItemClicked:(KxMenuItem *)sender
{
    //    ECLog(@"Pop menu item '%@' clicked ... ",sender.title);
    [self setPopMenuButtonTitle:sender.title];
    [self onNavItemClick:sender];
}
- (void) resetPopMenu
{
    [KxMenu dismissMenu];
}
#pragma menuListItemClicked
- (void) menuListItemClicked:(ECButton *)sender
{
    //    ECLog(@"Menu list item%li clicked ... ",(long)sender.tag);
    [self resetPopMenu];
    if ([sender.viewId contain:@"custom"]) {
        [self onCustomItemClick:sender];
        return;
    }
    [self onOptionItemClick:sender];
}

#pragma handle event delegate
- (void)setOnOptionItemClickDelegate:(id<OptionItemClickDelegate>)optionItemClickDelegate
{
    [self setOptionItemClickDelegate:optionItemClickDelegate];
}
- (void)setOnNavItemClickDelegate:(id<NavItemClickDelegate>)navItemClickDelegate
{
    [self setNavItemClickDelegate:navItemClickDelegate];
}
- (void)setOnCustomItemClickDelegate:(id<CustomItemClickDelegate>)customItemClickDelegate
{
    [self setCustomItemClickDelegate:customItemClickDelegate];
}

- (void)setOnOptionItemClickDelegate:(id<OptionItemClickDelegate>)optionItemClickDelegate viewId:(NSString *)viewId
{
    [self setSpeEventDelegate:optionItemClickDelegate viewId:viewId];
}
- (void)setOnNavItemClickDelegate:(id<NavItemClickDelegate>)navItemClickDelegate viewId:(NSString *)viewId
{
    [self setSpeEventDelegate:navItemClickDelegate viewId:viewId];
}
- (void)setOnCustomItemClickDelegate:(id<CustomItemClickDelegate>)customItemClickDelegate viewId:(NSString *)viewId
{
    [self setSpeEventDelegate:customItemClickDelegate viewId:viewId];
}

- (void) setSpeEventDelegate:(id)speEventDelegate viewId:(NSString *)viewId
{
    _speEventDelegate = !_speEventDelegate ? [NSMutableDictionary new] : _speEventDelegate;
    [_speEventDelegate setObject:speEventDelegate forKey:viewId];
}
- (void) onOptionItemClick:(ECButton *)menuItem
{
//    NSString *jsString = [NSString stringWithFormat:@"%@.onOptionItemClick(\"{\\\"controlId\\\":\\\"%@\\\",\\\"itemId\\\":\\\"%@\\\",\\\"position\\\":\\\"%@\\\"}\")",self.controlId,self.controlId,menuItem.viewId,menuItem.position];
//    [[ECJSUtil shareInstance] runJS:jsString];
    
    //JSEvent   参数为 itemId(viewId)
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"ActionBar.%@",kOnItemClick] withParams:menuItem.viewId];
    
    return;
    
    id speEventDelegate = [_speEventDelegate objectForKey:menuItem.viewId];
    ECOptionItemClickDelegate* delegate = speEventDelegate ? speEventDelegate : _optionItemClickDelegate;
    
    if (delegate != nil) {
        if ([delegate respondsToSelector:@selector(onItemClick:)]) {
            [delegate onItemClick:menuItem];
            //            ECLog(@"%@ onOptionItemClick",NSStringFromClass([self class]));
        }
    }
}

//菜单的item点击事件处理
- (void) onNavItemClick:(KxMenuItem *)item
{
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",@"ActionBar",kOnItemClick]
                                withParams:item.viewId];
//                           withParams:@{@"position":[NSNumber numberWithInteger:[item.position intValue] ]}];
}
- (void) onCustomItemClick:(ECButton *)item
{
    id speEventDelegate = [_speEventDelegate objectForKey:item.viewId];
    ECCustomItemClickDelegate* delegate = speEventDelegate ? speEventDelegate : _customItemClickDelegate;
    
    if (delegate != nil) {
        if ([delegate respondsToSelector:@selector(onItemClick:)]) {
            [delegate onItemClick:item];
            //            ECLog(@"%@ onCustomItemClick",NSStringFromClass([self class]));
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (ECButton *) customButton:(UIImage *)image highLightImage:(UIImage *)highLightImage title:(NSString *)title clickTitle:(NSString *)clickTitle action:(SEL)selector
{
    ECButton* button = [[ECButton alloc] initWithFrame:CGRectMake(0, 0, CustomButton_width, 33)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0 , -20 , 0 , 0);
    //    [button setBackgroundColor:[UIColor redColor]];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        if (highLightImage) {
            [button setImage:highLightImage forState:UIControlStateHighlighted];
        }
    }
    
    if (title) {
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button sizeToFit];
        [button setFrame:CGRectMake(0, 0, button.frame.size.width, 33)];
        if (clickTitle) {
            [button setTitle:clickTitle forState:UIControlStateHighlighted];
        }
    }
    
    if (selector) {
        if ([self respondsToSelector:selector]) {
            [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return button;
}
- (void) updateRightItemViewSize
{
    CGRect frame = CGRectMake(0, 0, 0, 44);
    for (UIView* view in [_rightItemView subviews]) {
        [view sizeToFit];
        [view setFrame:CGRectMake(frame.size.width, 0, view.frame.size.width > CustomButton_width ? view.frame.size.width : CustomButton_width, 44)];
        frame.size.width += view.frame.size.width + 2;
    }
    [_rightItemView setFrame:frame];
}
- (void) setPopMenuButtonTitle:(NSString *)title
{
    NSString* temp = _navPopMenu.titleLabel.text;
    [_navPopMenu setTitle:title forState:UIControlStateNormal];
    
    if (title.length != temp.length) {
        [self updateRightItemViewSize];
    }
}
#pragma mark- set method title
- (void)setTitle:(NSString *)title
{
    _nowController.navigationItem.title = title;
    _navTitle = title;
}
- (NSString *)title
{
    return _navTitle;
}
#pragma mark- private util
- (UIImage *) parseBackgroundImage
{
    UIImage* image;
    
    if ([_actionBarBg isEmpty] || !_actionBarBg) {
        //        image =  [UIImage imageWithColor:[UIColor colorWithRed:0.95 green:0.96 blue:0.95 alpha:1.00] size:CGSizeMake(1, 44)];
        image =  [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(1, 44)];
        return image;
    }
    
    image = [UIImage imageWithPath:_actionBarBg];
    if (image) {
        return image;
    }
    
    if ([_actionBarBg contain:@"#"]) {
        UIColor* color = [UIColor colorWithHexString:_actionBarBg];
        image = [ECImageUtil imageWithUIColor:color];
    }
    return image;
}
@end

