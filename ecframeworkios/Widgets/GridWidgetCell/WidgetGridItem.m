//
//  WidgetGridItem.m
//  ECDemoFrameWork
//
//  Created by EC on 9/17/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "WidgetGridItem.h"
#import "NSStringExtends.h"
#import "NSDictionaryExtends.h"
#import "ECImageUtil.h"

#import "ECViewUtil.h"
#import "Constants.h"
#import "UIColorExtends.h"

@implementation WidgetGridItem

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self setViewId:@"widget_grid_item"];
        [self addSubview:_title];
        [self addSubview:_image];
        [self setAutoresizesSubviews:YES];
        //does not work , i don't know why ...
        [_title setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_image setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self setBackgroundColor:[UIColor colorWithHexString:@"#50D7D8D8"]];
    }
    return self;
}

- (void) setData:(NSDictionary*)dataDic{
    if ([dataDic isEmpty])
        return;
    _dataDic = dataDic;
    NSString* title = [dataDic objectForKey:@"title"];
    NSString* imageName = [dataDic objectForKey:@"image_cover"];
    if (title && ![title isEmpty]) {
        [_title setText:title];
    }else{
        [_title setHidden:YES];
        [_image setFrame:self.bounds];
    }
    
    if (imageName && ![imageName isEmpty]) {
        NSString* imageUrl = [ECImageUtil getFitImageWholeUrl:imageName];
        if (![imageUrl isEmpty]) {
            [_image setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"general_default_image.png"] fitHeight:NO];
        }
    }else{
        [_image setImage:[UIImage imageNamed:@"general_default_image.png"]];
    }
}
- (void) setRatioHToW:(float)ratioHToW{
    [_title addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    [_image addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    CGRect frame = _image.frame;
    frame.size.height = frame.size.width*ratioHToW;
    frame.origin.y = 0;
    _image.frame = frame;
}

- (void) setRatioHToW:(float)ratioHToW cellColumn:(int)cellColumn cellPadding:(float)cellPadding{
    float cellWidth = (validWidth()-cellPadding*(cellColumn+1))/cellColumn;
    float cellHeight = cellWidth*ratioHToW;
    CGRect frame = _image.frame;
    frame.size.width = cellWidth;
    frame.size.height = frame.size.width*ratioHToW;
    frame.origin.y = 0;
    _image.frame = frame;
    
    
    NSString* title = [_dataDic objectForKey:@"title"];
    //    NSString* subTitle = [_dataDic objectForKey:@"abstracts"];
    //    NSString* imageName = [_dataDic objectForKey:@"image_cover"];
    if (title && ![title isEmpty]) {
        frame = _title.frame;
        frame.size.width = cellWidth-20;
        frame.origin.y = _image.frame.size.height+5;
        _title.frame = frame;
        cellHeight += 30;
    }
    frame = self.frame;
    frame.size.width = cellWidth;
    frame.size.height = cellHeight;
    self.frame = frame;
}

//--------------  for frame  -------------------
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    ECLog(@"WidgetGridItem......observeValueForKeyPath ......");
    if ([keyPath isEqualToString:@"frame"]) {
        [self reFrameNext:object];
    }
}

- (void) reFrameNext:(UIView*)view{
    UIView* nextView = nil;
    NSArray* views = [self subviews];
    for (UIView* tempView in views) {
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
        frame.origin.y = view.frame.origin.y + view.frame.size.height+5;
        nextView.frame = frame;
        
        ECLog(@"%@ --- %@",[view class],[nextView class]);
        ECLog(@"nextView %@",nextView);
        return;
    }

}

@end
