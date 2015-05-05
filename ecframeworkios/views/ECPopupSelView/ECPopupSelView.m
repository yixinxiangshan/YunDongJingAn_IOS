//
//  ECPopupSelView.m
//  JingAnWeekly
//
//  Created by EC on 3/22/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "ECPopupSelView.h"
#import "Utils.h"
#import "ECViewUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation ECPopupSelView

- (id)initWithData:(NSDictionary*)dataSource{
    self = [self initWithFrame:CGRectMake(10, (validHeight()-272.0)/2.0f, validWidth()-40.0f, 272.0f)];
    _dataSource =  dataSource;
    _dataList = [[dataSource objectForKey:@"selectlist" ] objectForKey:@"options"];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}


- (void)defalutInit
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];
    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:_titleView];
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height-32.0f);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[_dataList objectAtIndex:indexPath.row] objectForKey:@"text"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = [[_dataList objectAtIndex:indexPath.row] objectForKey:@"text"];
    if (_selectedDelegate && [_selectedDelegate respondsToSelector:@selector(selectedItemValue:)]) {
        NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:text,[_dataSource objectForKey:@"name"], nil];
        [_selectedDelegate selectedItemValue:dic];
    }
    if (_showView != nil) {
        [_showView setText:text];
    }
    [self dismiss];
}



#pragma mark - show and dismiss
- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

@end
