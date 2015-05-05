//
//  ECItemNewsWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECItemNewsWidget.h"
#import "NSStringExtends.h"
#import "UIImageView+Size.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "NSDictionaryExtends.h"
#import "ECImageUtil.h"
#import "UIView+Size.h"
#import "ECViewUtil.h"

@interface ECItemNewsWidget () 

@end

@implementation ECItemNewsWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECItemNewsWidget";
    }
    if (self.layoutName == nil || [self.controlId isEmpty]) {
        self.controlId = @"item_news_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"item_news_widget"];
        [self addSubview:_title];
        [self addSubview:_subTitle];
        [self addSubview:_image];
        [self addSubview:_content];
        for (UIView* tempView in [_container subviews]) {
            [self addSubview:tempView];
        }
        for (UIView* tempView in [self views]) {
            [tempView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        }
        //add event for widget
         _image.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onClick:)];
        [_image addGestureRecognizer:singleTouch];

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
    NSString* title = [self.dataDic objectForKey:@"title"];
    NSString* subTitle = [self.dataDic objectForKey:@"abstracts"];
    NSString* imageName = [self.dataDic objectForKey:@"image_cover"];
    NSString* content = [self.dataDic objectForKey:@"content"];
    if ([title isEmpty]) {
        [_title removeFromSuperview];
    }else{
        if (![_title isDescendantOfView:self]) 
            [self addSubview:_title];
        [_title setText:title];
    }
    
    if ([subTitle isEmpty]) {
        [_subTitle removeFromSuperview];
    }else{
        if (![_subTitle isDescendantOfView:self])
            [self addSubview:_subTitle];
        [_subTitle setText:subTitle];
    }
    
    if ([imageName isEmpty]) {
        [_title removeFromSuperview];
    }else{
        if (![_image isDescendantOfView:self])
            [self addSubview:_image];
        
        NSString* imageUrl = [ECImageUtil getFitImageWholeUrl:imageName];
        if (![imageUrl isEmpty]) {
            [_image setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"general_default_image.png"] fitHeight:YES];
        }
    }
    
    if ([content isEmpty]) {
        [_content removeFromSuperview];
    }else{
        if (![_content isDescendantOfView:self])
            [self addSubview:_content];

        [_content setText:content];
        [self resizeContent];
    }
    [self reFrameNext:_title];
    
}

//------------- handle event  ------------------
- (void)setOnClickDelegate:(id<OnClickDelegate>)clickDelegate{
    [self setClickDelegate:clickDelegate];
}

-(void)onClick:(UITapGestureRecognizer*) gesture{
    ECLog(@"%@ onclick",NSStringFromClass([self class]));
    if (_clickDelegate != nil) {
        if ([_clickDelegate respondsToSelector:@selector(onClick:)]) {
             [_clickDelegate onClick:gesture.view];
        }
    }
}


//--------------  for frame  -------------------
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    ECLog(@"......observeValueForKeyPath ......");
    if ([keyPath isEqualToString:@"frame"]) {
        [self reFrameNext:object];
    }
}

- (void) reFrameNext:(UIView*)view{
    UIView* nextView = nil;
    NSArray* views = [self subviews];
    for (UIView* tempView in views) {
//        if (tempView.frame.origin.y > view.frame.origin.y) {
//            nextView = tempView;
//            break;
//        }
        if(tempView.frame.origin.y <= view.frame.origin.y)
            continue;
        if (nextView == nil) {
            nextView = tempView;
            continue;
        }
        //获取靠的最近的那个
        float tdistance = fabsf(tempView.frame.origin.y - view.frame.origin.y);
        float ndistance = fabsf(nextView.frame.origin.y - view.frame.origin.y);
        if (tdistance < ndistance) {
            nextView = tempView;
        }
    }
    if (nextView != nil) {
        CGRect frame = nextView.frame;
        frame.origin.y = view.frame.origin.y + view.frame.size.height+8;
        nextView.frame = frame;
        ECLog(@"%@ --- %@",[view class],[nextView class]);
        return;
    }
    [self sizeToFit];
}

- (void) resizeContent{
    if (_image.frame.origin.y < _content.frame.origin.y) {
        CGRect frame = _content.frame;
        frame.size.height = [ECViewUtil textViewHeightForAttributedText:_content.attributedText andWidth:frame.size.width];
        frame.origin.y = _image.frame.origin.y + _image.frame.size.height+8;
        _content.frame = frame;
    }
}



- (void) resizeContainer{
    /**
    NSArray* views = [_container subviews];
    UIView* view = nil;
    int i = 0;
    for (UIView* tempView in views) {
        ECLog(@"view = %@ -----------------------------------%d",tempView,i);
        i++;
        if (view == nil) 
            view = tempView;
        if (tempView.frame.origin.y > view.frame.origin.y) 
            view = tempView;
    }
    float height = view.frame.origin.y+view.frame.size.height+80;
    CGRect frame = _container.frame;
    frame.size.height = self.frame.size.height;
    _container.frame = frame;
    
    [_container setContentSize:CGSizeMake(_container.contentSize.width, height)];
    ECLog(@"container ContentSize height  = %f",_container.contentSize.height);
    */
}


@end
