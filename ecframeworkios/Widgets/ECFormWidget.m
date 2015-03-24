//
//  ECFormWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 12/10/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECFormWidget.h"
#import "NSStringExtends.h"
#import "UIImageView+Size.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "NSDictionaryExtends.h"
#import "ECImageUtil.h"
#import "UIView+Size.h"
#import "ECViewUtil.h"
#import "NSArrayExtends.h"
#import "UIColorExtends.h"
#import "ECPopupSelView.h"
#import "ECJsonUtil.h"
#import "ECButton.h"
#import "ECJSUtil.h"
#import "ECNetRequest.h"
#import "ECViewUtil.h"
#import "ECViews.h"
#import "UIImageView+Size.h"
#import "ECImageUtil.h"
#import "ECPageUtil.h"
#import "UIImage+Resource.h"

#import "ECFormWidgetCellVote.h"
#import "ECFormWidgetCellUploads.h"
#import "ECFormWidgetCellSelect.h"
#import "ECTextViewPlaceHolder.h"


@interface ECFormWidget () <UITextViewDelegate,UITextFieldDelegate,ECECPopupSelectedDelegate,SystemImagePickerDelegate>
@property (nonatomic, strong) NSMutableArray* inputTypeArray;
@property (nonatomic, strong) NSMutableArray* viewArray;
@property (nonatomic, strong) NSMutableDictionary* formData;
@property (nonatomic, strong) NSMutableDictionary* formElement;
//@property (nonatomic, strong) UIScrollView* scrollView;


@property (nonatomic, strong) NSString* textInputBackgroud;
@end

@implementation ECFormWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if ([self.controlId isEmpty]) {
        self.controlId = @"form_widget";
    }
    if (self) {
        [self setViewId:@"form_widget"];
        //        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, validWidth(), 0)];
        _viewArray = [NSMutableArray new];
    }
    
    if (_formElement == nil) {
        _formElement = [NSMutableDictionary new];
    }
    
    [self parsingConfigDic];
    return self;
}

- (void) setdata{
    [super setdata];
    if ([self.dataDic isEmpty]) {
        [self removeFromSuperview];
        ECLog(@"error item widget data is nil");
        return ;
    }
    NSArray* viewConfigs = [self.dataDic objectForKey:@"input_list"];
    if (viewConfigs == nil || [viewConfigs isEmpty]) {
        ECLog(@"Error: form 为空表单");
        return;
    }
    _inputTypeArray = [[NSMutableArray alloc] initWithArray:viewConfigs];
    int i = 0;
    for (NSDictionary* viewConfig in _inputTypeArray) {
        [self addViewWithTypt:viewConfig count:i];
        i++;
    }
    NSString* btSubmit =[self.dataDic objectForKey:@"button_submit"];
    NSString* btCancel =[self.dataDic objectForKey:@"button_cancel"];
    NSMutableDictionary* btDic = [NSMutableDictionary new];
    if (btSubmit != nil && ![btSubmit isEmpty] && btCancel != nil && ![btCancel isEmpty]) {
        [btDic setObject:@"bothBt" forKey:@"default_layout"];
        [btDic setObject:[NSString stringWithFormat:@"%@,%@",btSubmit,btCancel] forKey:@"text"];
    }else if (btSubmit != nil && ![btSubmit isEmpty]){
        [btDic setObject:@"submitBt" forKey:@"default_layout"];
        [btDic setObject:[self.dataDic objectForKey:@"button_submit"] forKey:@"text"];
    }else if (btCancel != nil && ![btCancel isEmpty]){
        NSMutableDictionary* btDic = [NSMutableDictionary new];
        [btDic setObject:@"cancelBt" forKey:@"default_layout"];
        [btDic setObject:[self.dataDic objectForKey:@"button_submit"] forKey:@"text"];
    }
    [self addViewWithTypt:btDic count:i];
    i++;
    
}

- (void) addViewWithTypt:(NSDictionary *)dic count:(NSInteger) count{
    if (!dic) {
        return;
    }
    NSLog(@"formWidget inputs : %@",dic);
    NSArray* array = [[NSArray alloc] initWithObjects:@"text", @"password", @"number", @"textarea", @"bothBt", @"submitBt", @"cancelBt", @"radio",@"select",@"select2",@"upload",@"uploads",@"vote",@"tag_textarea",nil];
    NSString* type = [dic objectForKey:@"default_layout"];
    if ([dic objectForKey:@"name"] && [dic objectForKey:@"default_value"]) {
        [self saveFormData:[dic objectForKey:@"name"] value:[dic objectForKey:@"default_value"]];
    }
    if (![array containsObject:type]) {
        return;
    }
    ECLog(@"self width = %f",self.frame.size.width);
    ECView* view = [[ECView alloc] init];
    [view setViewId:@"widget_form_input_content"];
    CGFloat x = 10;
    CGFloat y = 8;
    for (int i=0; i<self.viewArray.count; i++) {
        UIView* tempView = [self.viewArray objectAtIndex:i];
        y += tempView.frame.size.height;
        y += 16;
        ECLog(@"i = %d , y = %f",i,y);
    }
    CGFloat width = self.frame.size.width - 20.0f;
    NSString* textType = @"text,password,number";
    NSString* btType = @"bothBt,submitBt,cancelBt";
    NSString* voteType = @"vote";
    
    NSString* defaultValue = [dic objectForKey:@"default_value"];
    NSString* backgroundWords = [dic objectForKey:@"background_wrods"];
    NSString* desWords = [dic objectForKey:@"des_wrods"];
    
    if ([textType rangeOfString:type].location != NSNotFound) {
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 36)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setPlaceholder:[dic objectForKey:@"background_wrods"]];
        if ([type isEqualToString:@"number"]) {
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
        }else if ([type isEqualToString:@"password"]){
            textField.secureTextEntry = YES;
        }
        if (defaultValue != nil && ![defaultValue isEmpty]) {
            [textField setText:defaultValue];
        }
        [textField setTag:count];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setDelegate:self];
        [view setFrame:CGRectMake(x, y, width, 36)];
        [view addSubview:textField];
        
        if ([_textInputBackgroud isEqualToString:@"widget_form_input_style_null"]) {
            [textField setBorderStyle:UITextBorderStyleNone];
            [textField setBackground:[ECImageUtil imageWithUIColor:[UIColor clearColor]]];
        }
    }
    else if ([type isEqualToString:@"textarea"]){
        //设置带placeholder的textarea
        ECTextViewPlaceHolder* textView = [[ECTextViewPlaceHolder alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
        if (defaultValue != nil && ![defaultValue isEmpty]) {
            [textView setText:defaultValue];
        }
        if (backgroundWords != nil && ![backgroundWords isEmpty]) {
            [textView setPlaceholder:backgroundWords];
        }
        [textView setTag:count];
        [textView setDelegate:self];
        // 设置下面的label
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 125, width-10, 30)];
        label.text = desWords;
        label.numberOfLines = 0;
        label.font = [label.font fontWithSize:12];
        label.tag = count;
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        // 设置父view
        [view setFrame:CGRectMake(x, y, width, 120+label.frame.size.height)];
        [view addSubview:textView];
        [view addSubview:label];
        
        
    }
    else if ([type rangeOfString:@"radio"].location != NSNotFound) {
        NSArray* array = (NSArray*)[[dic objectForKey:@"selectlist" ] objectForKey:@"options"];
        NSMutableArray* items = [NSMutableArray new];
        for (id dic in array) {
            [items addObject:[dic objectForKey:@"text"]];
        }
        UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:items];
        [segment setTag:count];
        [segment addTarget:self action:@selector(segmentControlValuechange:) forControlEvents:UIControlEventValueChanged];
        [segment setSelectedSegmentIndex:0];
        [segment setFrame:CGRectMake(0, 0, width, 44)];
        
        [view setFrame:CGRectMake(x, y, width, 44)];
        [view addSubview:segment];
    }
    else if ([type isEqualToString:@"tag_textarea"]) {
        //设置带placeholder的textarea
        ECTextViewPlaceHolder* textView = [[ECTextViewPlaceHolder alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
        if (defaultValue != nil && ![defaultValue isEmpty]) {
            [textView setText:defaultValue];
        }
        if (backgroundWords != nil && ![backgroundWords isEmpty]) {
            [textView setPlaceholder:backgroundWords];
        }
        [textView setTag:count];
        textView.tag = count;
        [textView setDelegate:self];
        NSString* elementKey = [[_inputTypeArray objectAtIndex:[textView tag]] objectForKey:@"input_id"];
        [_formElement setObject:textView forKey:elementKey];
        
        // 设置tag
        NSArray* array = (NSArray*)[[dic objectForKey:@"selectlist" ] objectForKey:@"options"];
        NSMutableArray* items = [NSMutableArray new];
        for (id dic in array) {
            [items addObject:[dic objectForKey:@"text"]];
        }
        UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:items];
        [segment addTarget:self action:@selector(textAreaSegmentControlValuechange:) forControlEvents:UIControlEventValueChanged];
        //        [segment setSelectedSegmentIndex:0];
        segment.tag = count;
        [segment setFrame:CGRectMake(5, 125, width - 10, 44)];
        
        // 设置下面的label
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 130 + 44, width - 10, 30)];
        label.text = desWords;
        label.numberOfLines = 0;
        label.font = [label.font fontWithSize:12];
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        
        // 设置父view
        [view setFrame:CGRectMake(x, y, width, 120 + 44 + label.frame.size.height)];
        [view addSubview:textView];
        [view addSubview:segment];
        [view addSubview:label];
    }
    else if ([type rangeOfString:@"select"].location != NSNotFound){
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, width-40, 30)];
        //TODO: 处理默认值，暂时使用background_wrods
        label.text= [dic objectForKey:@"background_wrods"];
        label.tag = count;
        UITapGestureRecognizer* singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(showPopupSelector:)];
        [label addGestureRecognizer:singleTouch];
        [label setUserInteractionEnabled:YES];
        
        UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageWithPath:@"more.png"]];
        [arrow setFrame:CGRectMake(width-20.0f, 12, 10, 15)];
        
        [view setFrame:CGRectMake(x, y, width, 40)];
        [view addSubview:label];
        [view addSubview:arrow];
        
        [self setShadowAndCorlor:view];
    }else if ([type rangeOfString:@"upload"].location != NSNotFound){
        if ([type isEqualToString:@"uploads"]) {
            ECFormWidgetCellUploads* uploadsView = [[ECFormWidgetCellUploads alloc] initWithDefault:[defaultValue componentsSeparatedByString:@","] DoneBlock:^(NSArray *imageFiles) {
                //TODO:需实现上传图片所需的操做//imageFiles 中为已上传到服务器的图片地址
                NSString *imageKey = [dic objectForKey:@"name"];
                for (NSString *imageName in imageFiles) {
                    [self saveFormData:[imageKey stringByReplacingOccurrencesOfString:@"uploads" withString:[NSString randomCallID]] value:imageName];
                };
            }];
            
            [view setFrame:CGRectMake(x, y, width, 76)];
            [view addSubview:uploadsView];
        }else{
            ECButton* imageButton = [ECButton buttonWithType:UIButtonTypeCustom];
            [imageButton setViewId:@"widget_form_camera"];
            imageButton.frame = CGRectMake(width/2 -36, 2, 72, 72);
            [imageButton setTag:count];
            if (defaultValue != nil && ![defaultValue isEmpty]) {
                //显示默认图片
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:defaultValue]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        [imageButton setBackgroundImage:image forState:UIControlStateNormal];
                    }
                }];
                //                [manager downloadWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:defaultValue]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
                //
                //                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                //                    if (image) {
                //                        [imageButton setBackgroundImage:image forState:UIControlStateNormal];
                //                    }
                //                }];
            }else {
                [imageButton setBackgroundImage:[UIImage imageWithPath:@"widget_form_upload_camera.png"] forState:UIControlStateNormal];
            }
            [imageButton addTarget:self action:@selector(getSysImage:) forControlEvents:UIControlEventTouchUpInside];
            [view setFrame:CGRectMake(x, y, width, 76)];
            [view addSubview:imageButton];
            
        }
        
        [self setShadowAndCorlor:view];
    }
    else if ([btType rangeOfString:type].location != NSNotFound){
        ECButton* button = [ECButton buttonWithType:UIButtonTypeCustom];
        if ([type rangeOfString:@"bothBt"].location == NSNotFound) {
            button.frame = CGRectMake(0, 0, width, 44);
            [button setTitle:[dic objectForKey:@"text"] forState:UIControlStateNormal];
            [button setViewId:type];
            [button setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_green.png"] forState:UIControlStateNormal];
            //            [button setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_green_press.png"] forState:UIControlStateHighlighted];
        }else{
            button.frame = CGRectMake(0, 0, width/2-5, 44);
            ECButton* button2 = [ECButton buttonWithType:UIButtonTypeRoundedRect];
            button2.frame = CGRectMake(width/2+5,0 , width/2-5, 44);
            NSArray* ss = [[dic objectForKey:@"text"] componentsSeparatedByString:@","];
            [button setTitle:[ss objectAtIndex:0] forState:UIControlStateNormal];
            [button setViewId:@"submitBt"];
            [button setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_green_small.png"] forState:UIControlStateNormal];
            //            [button setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_green_small_press.png"] forState:UIControlStateHighlighted];
            [button2 setTitle:[ss objectAtIndex:1] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setViewId:@"cancelBt"];
            [button2 setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_red_small.png"] forState:UIControlStateNormal];
            //            [button2 setBackgroundImage:[UIImage imageWithPath:@"gen_btn_plain_red_small_press.png"] forState:UIControlStateHighlighted];
            [view addSubview:button2];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view setFrame:CGRectMake(x, y, width, 44)];
        [view addSubview:button];
    }
    else if ([voteType rangeOfString:type].location != NSNotFound){
        ECFormWidgetCellVote* voteView = [[ECFormWidgetCellVote alloc] initWithVoteDoneBlock:^(NSInteger vote) {
            [self saveFormData:[dic objectForKey:@"name"] value:[NSString stringWithFormat:@"%i",vote]];
        }];
        [view setFrame:CGRectMake(x, y, width, voteView.frame.size.height)];
        [view addSubview:voteView];
    }
    
    
    [self.viewArray addObject:view];
    [self addSubview:view];
}
//
- (void)showPopupSelector:(UITapGestureRecognizer*)sender{
    UILabel* label = (UILabel*)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [[sender.view superview] setBackgroundColor:[UIColor lightGrayColor]];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [[sender.view superview] setBackgroundColor:[UIColor clearColor]];
        NSDictionary* itemDic = [self.inputTypeArray objectAtIndex:label.tag];
        
        if ([[itemDic objectForKey:@"default_layout"] isEqualToString:@"select2"]) {
            //多级选择菜单
            ECFormWidgetCellSelect* selectView = [[ECFormWidgetCellSelect alloc] initWith:itemDic
                                                                          selectDoneBlock:^(NSDictionary *dataSource, NSArray *position) {
                                                                              //将数据添加进表单的方法
                                                                              NSDictionary *itemSelected = [self valueForPosition:position in:dataSource];
                                                                              if (itemSelected) {
                                                                                  [self saveFormData:[itemDic objectForKey:@"name"] value:[itemSelected objectForKey:@"value"]];
                                                                              }
                                                                              
                                                                              //更新界面
                                                                              NSString *text = [itemSelected objectForKey:@"text"];
                                                                              label.text = text;
                                                                          }];
            [selectView setDataKey:@"options" titleKey:@"text" valueKey:@"value"];
            [selectView setTitle:[itemDic objectForKey:@"text"]];
            [selectView show];
            return;
        }
        
        // [[itemDic objectForKey:@"default_layout"] isEqualToString:@"select"] 一级选择菜单
        
        ECPopupSelView* popupSelView = [[ECPopupSelView alloc] initWithData:itemDic];
        [popupSelView setTitle:[itemDic objectForKey:@"background_wrods"]];
        popupSelView.selectedDelegate = self;
        [popupSelView setShowView:label];
        [popupSelView show];
    }
    
}
- (void)saveFormData:(NSString*)key value:(NSString*)value{
    if (_formData ==nil) {
        _formData = [NSMutableDictionary new];
    }
    if (!value) {
        return;
    }
    [_formData setObject:value forKey:key];
    [self putParam:@"formData" value:[ECJsonUtil stringWithDic:_formData]];
}

//设置视图样式
- (void)setShadowAndCorlor:(UIView*)view{
    //设置圆角
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0f;
    
    //设置 边框
    view.layer.borderColor = [UIColor colorWithHexString:@"#7C7C7C"].CGColor;
    view.layer.borderWidth = 0.5;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSDictionary* dic = [_inputTypeArray objectAtIndex:[textField tag]];
    [self saveFormData:[dic objectForKey:@"name"] value:textField.text];
}
#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSDictionary* dic = [_inputTypeArray objectAtIndex:[textView tag]];
    [self saveFormData:[dic objectForKey:@"name"] value:textView.text];
}
#pragma mark -segment change method
- (void)textAreaSegmentControlValuechange:(UISegmentedControl* ) segmentCtrl{
    NSDictionary* dic = [_inputTypeArray objectAtIndex:[segmentCtrl tag]];
    NSString* value = [[[[dic objectForKey:@"selectlist"] objectForKey:@"options"] objectAtIndex:segmentCtrl.selectedSegmentIndex] objectForKey:@"text"];
    ECTextViewPlaceHolder* textview = [_formElement objectForKey:[[_inputTypeArray objectAtIndex:[segmentCtrl tag]] objectForKey:@"input_id"]];
    [textview setText:value];
    [self textFieldDidEndEditing:textview];
};
#pragma mark -segment change method
- (void)segmentControlValuechange:(UISegmentedControl* ) segmentCtrl{
    NSDictionary* dic = [_inputTypeArray objectAtIndex:[segmentCtrl tag]];
    NSString* value = [[[[dic objectForKey:@"selectlist"] objectForKey:@"options"] objectAtIndex:segmentCtrl.selectedSegmentIndex] objectForKey:@"text"];
    [self saveFormData:[dic objectForKey:@"name"] value:value];
};
#pragma mark -ECECPopupSelectedDelegate
- (void)selectedItemValue:(NSDictionary*)dic{
    ECLog(@"selectedItemValue = %@",dic);
    NSString* key = [[dic allKeys] firstObject];
    [self saveFormData:key value:[dic objectForKey:key]];
}
#pragma mark -button click
- (void)buttonClick:(ECButton*)button{
    NSString* viewId = button.viewId;
    if ([viewId isEqualToString:@"submitBt"] && [self submitForm:viewId]) {
        return;
    }
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onButtonClick(\"{\\\"controlId\\\":\\\"%@\\\",\\\"viewId\\\":\\\"%@\\\"}\")",self.controlId,self.controlId,viewId];
    //    if ([[[ECJSUtil shareInstance] runJS:jsString] isEqualToString:@"true"]) {
    //        return;
    //    }
    //TODO: 支持原来的事件处理
}

#pragma mark -Image button click
- (void) getSysImage:(ECButton*)button{
    [ECViewUtil openImagePiker:self];
}
#pragma mark -
- (void)getImageFile:(NSString*)filePath image:(UIImage *)image{
    if ([filePath isEmpty]) {
        return ;
    }
    ECLog(@"filePath = %@",filePath);
    ECButton* button = (ECButton*)[ECViewUtil findViewById:@"widget_form_camera" view:self];
    NSDictionary* dic = [_inputTypeArray objectAtIndex:button.tag];
    [self saveFormData:[dic objectForKey:@"name"] value:[NSString stringWithFormat:@"file://%@",filePath]];
    //    UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    [button setBackgroundImage:image forState:UIControlStateNormal];
}
- (BOOL) submitForm:(NSString*)viewId{
    [self endEditing:YES];
    NSString* jsString = [NSString stringWithFormat:@"%@.onSubmit(\"{\\\"controlId\\\":\\\"%@\\\",\\\"viewId\\\":\\\"%@\\\"}\")",self.controlId,self.controlId,viewId];
    NSString* jsResult =[[ECJSUtil shareInstance] runJS:jsString];
    if (jsResult == nil ||[jsResult isEqualToString:@"true"] ) {
        NSDictionary* formData = [ECJsonUtil objectWithJsonString:[self getParam:@"formData"]];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:formData];
        if ([[self.dataDic objectForKey:@"method"] isEmpty]) {
            return NO;
        }
        [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,@"onSubmit"] withParams:formData];
        
        //formData 有空值则不提交
        //        NSEnumerator *enumerator = [formData objectEnumerator];
        //        id obj;
        //        while (obj = [enumerator nextObject]) {
        //            if (!obj || [obj isEqualToString:@""]) {
        //
        //                return YES;
        //            }
        //        }
        
        [params setObject:[self.dataDic objectForKey:@"method"] forKey:@"method"];
        [[ECNetRequest newInstance] postNetRequest:@"formwidget.submitForm"
                                            params:params
                                          delegate:self
                                  finishedSelector:@selector(netRequestFinished:)
                                      failSelector:@selector(netRequestFinished:)
                                          useCache:false];
        return NO;
    }
    return YES;
}

#pragma mark - net request resopnse
- (void) netRequestFinished:(NSNotification *) noti
{
    [self removeObserver];
    NSDictionary* dataDic = noti.userInfo;
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onSubmitSuccess(%@)",[self controlId],[ECJsonUtil stringWithDic:dataDic]];
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onSubmitSuccess(\"%@\")",[self controlId],[[ECJsonUtil stringWithDic:dataDic] transfer]];
    //    if ([[[ECJSUtil shareInstance] runJS:jsString] boolValue]) {
    //        return;
    //    }
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,@"onSubmitSuccess"] withParams:noti.userInfo];
    [ECPageUtil closeNowPage:nil];
}
- (void) netRequestFailed:(NSNotification *) noti
{
    [self removeObserver];
    NSDictionary* dataDic = noti.userInfo;
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onSubmitFailed(\"%@\")",[self controlId],[[ECJsonUtil stringWithDic:dataDic] transfer]];
    //    if ([[[ECJSUtil shareInstance] runJS:jsString] boolValue]) {
    //        return;
    //    }
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,@"onSubmitFailed"] withParams:noti.userInfo];
    [ECPageUtil closeNowPage:nil];
}
- (void) removeObserver{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"formwidget.submitForm.finished" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"formwidget.submitForm.failed" object:nil];
}

#pragma mark-
- (void) setTextInputBackgroudS:(NSString *)textInputBackgroud
{
    self.textInputBackgroud = textInputBackgroud;
}

#pragma mark-
- (id) valueForPosition:(NSArray *)positions in:(NSDictionary *)dataSource
{
    NSInteger currentIndex = [[positions firstObject] integerValue];
    NSArray *currentDataItems = [dataSource objectForKey:@"options"];
    id nextDataSource = currentIndex < currentDataItems.count ? [currentDataItems objectAtIndex:currentIndex] : nil;
    
    if (positions.count == 1) {
        return nextDataSource;
    }
    
    //递规
    NSMutableArray *nextPositions = [NSMutableArray arrayWithArray:positions];
    [nextPositions removeObjectAtIndex:0];
    //若nextPosition 或都 nextDataSource 为空，则返回nil
    if (!nextDataSource || nextPositions.count == 0) {
        return nil;
    }
    return [self valueForPosition:nextPositions in:nextDataSource];
}
@end
