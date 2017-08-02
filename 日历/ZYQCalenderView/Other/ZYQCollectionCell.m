//
//  ZYQCell.m
//  日历
//
//  Created by bjzyzl on 2017/8/1.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import "ZYQCollectionCell.h"

@implementation ZYQCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
  
    self = [super initWithFrame:frame];
    if (self) {

        [self initUI];
    }
    return self;
}

-(void)initUI
{
    UILabel * date = [[UILabel alloc]init];
    date.textAlignment = NSTextAlignmentCenter;
    date.font = [UIFont systemFontOfSize:13];
    date.layer.cornerRadius = 5;
    date.layer.masksToBounds = YES;
    [self addSubview:date];
    _dateLabel = date;
}
-(void)layoutSubviews
{
    _dateLabel.frame = (CGRect){ 0, 0, self.frame.size.width, self.frame.size.height};
}
@end
