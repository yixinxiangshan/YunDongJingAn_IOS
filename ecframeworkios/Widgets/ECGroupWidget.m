//
//  ECGroupWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 10/24/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECGroupWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "ECWidgetUtil.h"
#import "ECNetUtil.h"
#import "ECReflectionUtil.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ECGroupItemClickDelegate.h"
#import "ECGroupWidgetCell.h"
#import "ECJSUtil.h"

@interface ECGroupWidget ()
@property (nonatomic, strong) NSArray* groupList;
@property (nonatomic, strong) id<OnGroupItemClickDelegate> groupItemClickDelegate;
@end

@implementation ECGroupWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName ==nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECGroupWidget";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"group_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"group_widget"];
        [self addSubview:_groupView];
        
        [_groupView setAutoresizingMask:UIViewAutoresizingNone];
    }
    [self parsingConfigDic];
    [self setBackgroundColor:[UIColor blueColor]];
    
    return self;
}

- (void) setdata{
    [super setdata];
    _groupList = [NSMutableArray arrayWithArray:[self.dataDic objectForKey:@"groupList"]];
    [_groupView reloadData];
    [self sizeToFit];
    
}

- (void) refreshWidgetData:(NSDictionary*)dataDic{
    [super refreshWidgetData:dataDic];
}

-(void)setOnGroupItemClickDelegate:(ECGroupItemClickDelegate*)groupItemClickDelegate{
    _groupItemClickDelegate = groupItemClickDelegate;
}

-(void)setOnGroupItemClickDelegate:(ECGroupItemClickDelegate*)groupItemClickDelegate viewId:(NSString*)viewId{
    if (groupItemClickDelegate!=nil && viewId != nil) {
        if (self.mMap == nil)
            self.mMap = [NSMutableDictionary new];
        [self.mMap setObject:groupItemClickDelegate forKey:[NSString stringWithFormat:@"groupClickListener%@",viewId]];
    }
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary* tableItem = [_groupList objectAtIndex:section];
    NSArray* tableList = [tableItem objectForKey:@"tableList"];
    return [tableList count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     NSDictionary* tableItem = [_groupList objectAtIndex:section];
    return [tableItem valueForKey:@"sectionTitle"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return [_groupList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* itemDic = [[[self.groupList objectAtIndex:indexPath.section] objectForKey:@"tableList"] objectAtIndex:indexPath.row];
    if ([itemDic objectForKey:@"customView"] == nil || [[itemDic objectForKey:@"customView"] isEmpty]) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDictionary* tableItem = [_groupList objectAtIndex:indexPath.section];
        NSArray* tableList = [tableItem objectForKey:@"tableList"];
        NSDictionary* dataItem = [tableList objectAtIndex:indexPath.row];
        cell.textLabel.text = [dataItem objectForKey:@"title"];
        return cell;
    }else{
        NSString* customView = [[itemDic objectForKey:@"customView"] toCamelCase:YES];
//        [tableView registerNib:[UINib nibWithNibName:customView bundle:nil] forCellReuseIdentifier:customView];
        ECGroupWidgetCell* cell = (ECGroupWidgetCell*)[tableView dequeueReusableCellWithIdentifier:customView];
        [cell setData:itemDic];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* itemDic = [[[self.groupList objectAtIndex:indexPath.section] objectForKey:@"tableList"] objectAtIndex:indexPath.row];
    if ([itemDic objectForKey:@"customView"] == nil || [[itemDic objectForKey:@"customView"] isEmpty]) {
        return 44.0f;
    }
    NSString* customView = [[itemDic objectForKey:@"customView"] toCamelCase:YES];
    [tableView registerNib:[UINib nibWithNibName:customView bundle:nil] forCellReuseIdentifier:customView];
    ECGroupWidgetCell* cell = (ECGroupWidgetCell*)[tableView dequeueReusableCellWithIdentifier:customView];
    return [cell frame].size.height;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* jsString = [NSString stringWithFormat:@"%@.onGroupItemClick(\"{'controlId':'%@','groupId':'%li','position':'%li'}\")",self.controlId,self.controlId,(long)indexPath.section,(long)indexPath.row];
    if ([[[ECJSUtil shareInstance] runJS:jsString] boolValue]) {
        return;
    }
    id<OnGroupItemClickDelegate> groupItemClickDelegate = nil;
    groupItemClickDelegate = [self.mMap objectForKey:[NSString stringWithFormat:@"groupClickListener%ld:%ld",(long)indexPath.section,(long)indexPath.row]];
    if (groupItemClickDelegate!=nil && [groupItemClickDelegate respondsToSelector:@selector(onClick:position:)]) {
        [groupItemClickDelegate onClick:[NSString stringWithFormat:@"%ld",(long)indexPath.section] position:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        return;
    }
    groupItemClickDelegate = [self.mMap objectForKey:[NSString stringWithFormat:@"groupClickListener%ld",(long)indexPath.section]];
    if (groupItemClickDelegate!=nil && [groupItemClickDelegate respondsToSelector:@selector(onClick:position:)]) {
        [groupItemClickDelegate onClick:[NSString stringWithFormat:@"%ld",(long)indexPath.section] position:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        return;
    }
    if (_groupItemClickDelegate!=nil && [_groupItemClickDelegate respondsToSelector:@selector(onClick:position:)]) {
        [_groupItemClickDelegate onClick:[NSString stringWithFormat:@"%ld",(long)indexPath.section] position:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
}

@end
