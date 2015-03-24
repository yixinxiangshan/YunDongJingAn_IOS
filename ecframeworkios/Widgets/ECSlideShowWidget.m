//
//  ECSlideShowWidget.m
//  NowMarry
//
//  Created by cheng on 13-12-13.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECSlideShowWidget.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "ECImageUtil.h"
#import "ECImageView.h"


#define  WIDTH  90
#define  HEIGHT  90
#define  margin 10
#define  startX (self.frame.size.width - 3 * WIDTH - 2 * margin) * 0.5
#define  startY 15

@interface ECSlideShowWidget ()

//@property (strong, nonatomic) FGalleryViewController* imageGallery;

@property (strong, nonatomic) NSMutableArray* dataList;
@property (strong, nonatomic) NSMutableArray* photos;

@property (nonatomic) BOOL hasShow;

@end

@implementation ECSlideShowWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECSlideShowWidget";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"slide_show_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"slide_show_widget"];
    }
    [self parsingConfigDic];
    return self;
}

- (void) setdata{
    [super setdata];
    _dataList = [NSMutableArray arrayWithArray:[self.dataDic objectForKey:@"itemList"]];
    
    UIImage *placeholder = [UIImage imageNamed:@"general_default_image.png"];
    for (int i = 0; i< _dataList.count; i++) {
        ECImageView *imageView = [[ECImageView alloc] init];
//        [imageView setBackgroundColor:[UIColor redColor]];
        [self addSubview:imageView];
        
        // 计算位置
        int row = i/3;
        int column = i%3;
        CGFloat x = startX + column * (WIDTH + margin);
        CGFloat y = startY + row * (HEIGHT + margin);
        imageView.frame = CGRectMake(x, y, WIDTH, HEIGHT);
        
        // 下载图片
//        [imageView setImageURLStr:[ECImageUtil getSImageWholeUrl:[_dataList[i] objectForKey:@"image"]] placeholder:placeholder];
        [imageView setImageWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:[_dataList[i] objectForKey:@"image"]]] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!_photos) {
                _photos = [NSMutableArray new];
            }
            
            // 替换为中等尺寸图片
            NSString *url = [ECImageUtil getImageWholeUrl:[_dataList[i] objectForKey:@"image"]];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
            [_photos addObject:photo];
            
            if (!_hasShow && _photos.count == _dataList.count) {
                _hasShow = YES;
                [self showImageBrowser:0];
            }
        }];
        
        // 事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }

    [self sizeToFit];
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [self showImageBrowser:tap.view.tag];
}

- (void) showImageBrowser:(NSInteger)location
{
    MJPhotoBrowser* _browser = [[MJPhotoBrowser alloc] init];
    _browser.currentPhotoIndex = location; // 弹出相册时显示的第一张图片是？
    _browser.photos = _photos; // 设置所有的图片
    [_browser show];

}

- (void) sizeToFit
{
    [super sizeToFit];
}
#pragma mark- page event
- (void) pageEventWith:(NSString *)eventName
{
    if ([eventName isEqualToString:@"viewWillApper"]) {
        
    }else if ([eventName isEqualToString:@"viewWillDisappear"]){
        
    }
}
@end
