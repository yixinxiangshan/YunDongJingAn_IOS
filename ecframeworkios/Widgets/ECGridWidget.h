//
//  ECGridWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "ECBasePullRefreshWidget.h"
#import "ECItemClickDelegate.h"

typedef enum {
    Text_Connect = 0,
    Text_Contain ,
    Text_Seperate ,
}CellStyle;

@interface ECGridWidget : ECBasePullRefreshWidget

@property (weak, nonatomic) IBOutlet UICollectionView *gridview;

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

- (void)setOnItemClickDelegate:(id<OnItemClickDelegate>)itemClickDelegate;

@end
