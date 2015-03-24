//
//  ECDebugViewController.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 3/18/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECDebugViewController.h"
#import "ECCoreData.h"

@interface ECDebugViewController ()
@property (weak, nonatomic) IBOutlet UITextView *baseURL;
@property (weak, nonatomic) IBOutlet UITextField *project;

- (IBAction)go:(id)sender;

- (IBAction)testButton:(id)sender;
- (IBAction)getCache:(id)sender;
@end

@implementation ECDebugViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    
    NSString *configURL = [NSString stringWithFormat:@"%@?project=%@",_baseURL.text,_project.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:configURL forKey:@"IOSProjectTemplateConfigURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    exit(0);
}

- (IBAction)testButton:(id)sender {
    
   
    
    [[ECCoreDataSupport sharedInstance] putCachesWithContent:[_baseURL.text dataUsingEncoding:NSUTF8StringEncoding] md5:_project.text sort1:@"test" sort2:nil timeout:0.1];
}

- (IBAction)getCache:(id)sender {
    NSData *data = [[[ECCoreDataSupport sharedInstance] getCachesWithMd5:_project.text sort1:@"test" sort2:nil]  firstObject];
    
    NSLog(@"test data : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
@end
