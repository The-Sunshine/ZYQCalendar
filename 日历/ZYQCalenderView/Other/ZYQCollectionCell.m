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
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - 20) / 7 - 10;
    UILabel * date = [[UILabel alloc]init];
    date.frame = (CGRect){ 5, 5, cellWidth, cellWidth};
    date.textAlignment = NSTextAlignmentCenter;
    date.font = [UIFont systemFontOfSize:13];
    [self addSubview:date];
    _dateLabel = date;
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, 0, cellWidth + 10, 0.3);
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    _line = line;
}
@end
