//
//  ListViewCellNull.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/28/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellNull.h"

@implementation ListViewCellNull

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    // NSLog(@"listviewcellline centerTitle initWithStyle");
    return self;
}

- (void)awakeFromNib
{
    // NSLog(@"listviewcellline centerTitle awakeFromNib");
    
}

- (void)setData:(NSDictionary *)data
{
    [super setData:data];
    
}

+ (CGFloat)heightForData:(NSDictionary *)data {
    return 0;
}
@end
