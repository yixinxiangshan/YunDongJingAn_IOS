//
//  ECBaseViewExtendController.m
//  XuHuiTiYuShengHuo
//
//  Created by cww on 13-7-3.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECBaseViewExtendController.h"

@interface PrivateButton : UIButton
@property (nonatomic, assign) NSDictionary* config;
@property (nonatomic, assign) CGRect superFrame;
@end

#define navigatorMenuItemWidth 44
#define navigationBarHeight 44
#define navigationBarWidth 320

@interface ECBaseViewExtendController ()
@property (strong, nonatomic) NSArray* menuDataFromServer;
@property int navigatorMenuCount;
@end

@implementation ECBaseViewExtendController

@synthesize navigatorMenuCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.buttonEnable = YES;
    
    [self setNavigatorMenu];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.buttonEnable = YES ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setNavigatorMenu
{
    //NSLog(@"%@  : set navigationBar menu",self.class);
    NSArray *navigatorMenuConfig = [[self.configs objectForKey:@"localData"] objectForKey:@"navigatorMenuList"];
    
    navigatorMenuCount = navigatorMenuConfig.count;
    
    //NSLog(@"nav menu cnt: %d", navigatorMenuCount);
    
    UIView* navigatorMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigatorMenuItemWidth*navigatorMenuCount, navigationBarHeight)];
    for (int i = 0; i < navigatorMenuCount; i ++) {
        UIView* menuItem = [self getNavigatorMenuItem:i config:[navigatorMenuConfig objectAtIndex:i]];
        [navigatorMenuView addSubview:menuItem];
    }
    // 加入 NavigationBar
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:navigatorMenuView];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}
-(void) setNavigatorMenu:(NSArray *)menuDataFromServer
{
    self.menuDataFromServer = menuDataFromServer;
    [self setNavigatorMenu];
}
-(UIView *)getNavigatorMenuItem:(int)position config:(NSDictionary *)config
{
    UIView* menuItem = [[UIView alloc] initWithFrame:CGRectMake(navigatorMenuItemWidth * position, 0, navigatorMenuItemWidth, navigationBarHeight)];
    //设置分割线
    if ([config valueForKey:@"divider"] != nil) {
        UIImageView* sepratorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[config valueForKey:@"divider"]]];
        [menuItem addSubview:sepratorLine];
    }
    
    //设置按钮
    PrivateButton* imageButton = [PrivateButton buttonWithType:UIButtonTypeCustom];
    UIImage* buttonImage = [UIImage imageNamed:[config valueForKey:@"icon"]];
    [imageButton setImage:buttonImage forState:UIControlStateNormal];
    [imageButton setFrame:CGRectMake(0, 0, navigatorMenuItemWidth, navigationBarHeight)];
    //config 与 superFrame 用于传递后面动作所需要的参数
    imageButton.config = config;
    imageButton.superFrame = CGRectMake(navigationBarWidth-navigatorMenuItemWidth*(navigatorMenuCount - position), 0, navigatorMenuItemWidth, 0);
    [imageButton addTarget:self action:@selector(navigatorMenuItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    [menuItem addSubview:imageButton];
    
    return menuItem;
}

-(void)navigatorMenuItemTouched:(PrivateButton*)sender
{
    
    if ([@"menuItem" isEqual:[sender.config objectForKey:@"type"]]){
        NSString* action = [sender.config valueForKey:@"action"];
        [self doAction:action];
    }else{
        [self popMenuList:sender];
    }
    
}
-(void) popMenuList:(PrivateButton *)sender
{
    NSMutableArray* menuItems = [NSMutableArray new];
    if ([@"menu" isEqual: [sender.config objectForKey:@"type"]]) {
        NSDictionary* configs = [sender.config objectForKey:@"content"];
        for (NSDictionary *config in configs) {
            [menuItems addObject:[KxMenuItem menuItem:[config valueForKey:@"name"]
                                                image:nil
                                               target:self
                                                param:[config valueForKey:@"action"]
                                               action:@selector(getAction:)]];    //@select:()   action为点击后需要执行的动作
        }
    }else if ([@"menuFromeServer" isEqual: [sender.config objectForKey:@"type"]]){
        if (self.menuDataFromServer == nil) {
            return;
        }
        NSDictionary* config = [sender.config objectForKey:@"menuadapter"];
        for (NSDictionary* content in self.menuDataFromServer) {
            [menuItems addObject:[KxMenuItem menuItem:[content valueForKey:[config valueForKey:@"titleKey"]]
                                                      image:nil
                                                     target:self
                                                      param:[NSString stringWithFormat:@"%@?requestId=%@",[config valueForKey:@"action"],[content valueForKey:[config valueForKey:@"idKey"]]]
                                                     action:@selector(getAction:)]];
        }
    }
        [KxMenu showMenuInView:self.view
                  fromRect:sender.superFrame
                 menuItems:menuItems];
}
-(void)getAction:(KxMenuItem *)sender
{
    [self doAction:sender.param];
}
//点击 menuItem 时，执行。action 为 URL ，例：ecct://listview?param=value
-(void) doAction:(NSString *)action
{
    //添加 如果页面有网络请求id ，则作为参数传出
    if (!self.buttonEnable) {
        NSLog(@"+++++++++++++");
        return;
    }
    if ([action rangeOfString:@"Id="].location == NSNotFound && [action rangeOfString:@"id="].location == NSNotFound) {
//        NSString* requestIdKey = [[self.configs objectForKey:@"netDataRelevant"] valueForKey:@"requestIdKey"];
        if ([action rangeOfString:@"?"].location != NSNotFound) {
            action = [NSString stringWithFormat:@"%@&requestId=%@",action,self.requestId];
        }else{
            action = [NSString stringWithFormat:@"%@?requestId=%@",action,self.requestId];
        }

    }
    NSLog(@"Action : %@",action);
    [[ECEventRouter shareInstance] doAction:action];
}
-(id)getValue:(NSDictionary *)data forKey:(NSString *)key
{
    if (key == nil || key == NULL || data == nil || data == NULL) {
        return nil;
    }
    NSLog(@"key: %@", key);
    NSInteger location = [key rangeOfString:@"."].location;
    //NSLog(@"key: %ld end", location);

    if (location == NSNotFound) {
        NSLog(@"NSNotFound.");
        return [data valueForKey:key];
    }else{
        NSLog(@"else NSNotFound.");

        NSString* forwardKey = [key substringToIndex:location];
        NSString* behandkey = [key substringFromIndex:location+1];
        //递归
        NSDictionary* subData = [data valueForKey:forwardKey];
        return [self getValue:subData forKey:behandkey];
    }
    return nil;
}


@end

@implementation PrivateButton


@end
