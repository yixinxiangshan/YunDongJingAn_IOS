//
//  ECNewsViewController.m
//  IOSProjectTemplate
//
//  Created by 单徐梅 on 15/9/3.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//


#import "ECNewsViewController.h"
#import "NSStringExtends.h"
#import "UCUIControlEventProtocol.h"
//#import "ECEventRouter.h"

@interface ECNewsViewController ()

@end

@implementation ECNewsViewController

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
    
    // Do any additional setup after loading the view.
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewsLayout" owner:self options:nil] lastObject];
    self.view = view;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchUpInside:(UIControl *)sender
{
    //ECLog(@"touch up in side : ID = %@",sender.ID);
    //ECLog(@"URL : %@",sender.url);
    NSString *page;
    NSString *params = nil;

    if([sender.ID intValue] == 0 )
        page = sender.url;
    else
    {
        page = @"page_tab_news_list";
        params = [NSString stringWithFormat: @"{\"sort_id\": %@}", sender.ID];
    }
    
    [ECPageUtil openNewPage:page params:params];
}

@end