//
//  ZYQReusableView.m
//  日历
//
//  Created by bjzyzl on 2017/8/1.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import "ZYQReusableView.h"

@implementation ZYQReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    _dateLabel = label;
}
@end
