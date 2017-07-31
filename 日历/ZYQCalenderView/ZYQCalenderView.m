//
//  ZYQCalenderView.m
//  日历
//
//  Created by zyq on 2017/6/5.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import "ZYQCalenderView.h"
#import "ZYQCalenderTool.h"

#define cellWidth ([UIScreen mainScreen].bounds.size.width - 20) / 7
#define MSW ([UIScreen mainScreen].bounds.size.width)
#define MSH ([UIScreen mainScreen].bounds.size.height)

static NSString * cellID = @"cell";

@interface ZYQCalenderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation ZYQCalenderView
{
    UIButton    * _lastButton;
    UIButton    * _nextButton;
    UIImageView * _imageView;
    UIColor     * _color;
    NSIndexPath * _indexPath;
    NSInteger     _page;
    UILabel     * _dateLabel;
    CGFloat       _collectionHeight;
    
}

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self initialization];
    [self initUI];

    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialization];
    [self initUI];
}

#pragma mark - initialization
-(void)initialization
{
    _page = 0;
    _collectionHeight = cellWidth * 6;
    _selectBGColor = [UIColor yellowColor];
    _collectionStyle = ZYQCollectionViewHorizon;
}

#pragma mark - layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect dateLabelRect = (CGRect){ self.center.x - 50, 0, 100, 30};
    
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        _lastButton.frame = (CGRect){ self.center.x - 140, 0, 60, 30};
        
        _dateLabel.frame = dateLabelRect;
        
        _nextButton.frame = (CGRect){ self.center.x + 50 + 30, 0, 60, 30};
        
        _imageView.frame = CGRectMake(0, dateLabelRect.size.height + dateLabelRect.origin.y, MSW, 30);
        
        _collectionView.frame = (CGRect){10, dateLabelRect.size.height + dateLabelRect.origin.y + _imageView.frame.size.height, MSW - 20, _collectionHeight};
    }else
    {
        _imageView.frame = CGRectMake(0, 0, MSW, 30);
        
        _collectionView.frame = (CGRect){10, _imageView.frame.size.height, MSW - 20, self.frame.size.height - _imageView.frame.size.height};
    }
}

#pragma mark - initUI
-(void)initUI
{
    UIButton * lastButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastButton.tag = 100;
    [lastButton addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
    [lastButton setTitle:@"上一月" forState:UIControlStateNormal];
    [self addSubview:lastButton];
    _lastButton = lastButton;
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.tag = 101;
    [nextButton addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"下一月" forState:UIControlStateNormal];
    [self addSubview:nextButton];
    _nextButton = nextButton;
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:_page]]];
    dateLabel.textColor = [UIColor blackColor];
    [self addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"1.png"];
    [self addSubview:imageView];
    _imageView = imageView;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - clickEvent
-(void)monthClick:(UIButton *)button
{
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_indexPath];
    cell.backgroundColor = _color;
    
    if (button.tag == 100) {
        
        _page --;
    }else
    {
        _page ++;
    }
    
    [_collectionView reloadData];
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page]]; // 当月天数
    
    NSInteger labelCount = -[ZYQCalenderTool getWeeklyOrdinality:0 Page:_page] + 1; //上月n天
    
    if (labelCount + currentDay > 35) {
        
        _collectionHeight = cellWidth * 6;
        return 42;
    }else if (labelCount + currentDay == 28)
    {
        _collectionHeight = cellWidth * 4;
        return 28;
    }else
    {
        _collectionHeight = cellWidth * 5;
        return 35;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    for (UILabel * label in cell.contentView.subviews) {
        
        [label removeFromSuperview];
    }
    
    UILabel * date = [[UILabel alloc]init];
    date.frame = (CGRect){ 0, 0, cellWidth, cellWidth};
    date.textAlignment = NSTextAlignmentCenter;
    date.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:date];
    
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        NSInteger labelCount = 0;
        
        // 获取本月一日星期几 根据i值
        labelCount = [ZYQCalenderTool getWeeklyOrdinality:indexPath.row Page:_page];
        
        //本月天数
        NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page]];
        
        if (labelCount < 1) {
            
            //上月天数
            NSInteger lastCount = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page - 1]];
            labelCount = labelCount + lastCount;
        }
        else if (labelCount > currentDay)
        {
            labelCount = labelCount - currentDay;
        }
        else
        {
            date.textColor = [UIColor blackColor];
        }
        
        date.text = [NSString stringWithFormat:@"%ld",labelCount];
    }else
    {
        
    }
    return cell;
}

#pragma mark - collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        return 1;
    }else
    {
        return 0;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
 
    if (indexPath == _indexPath) {
        
        cell.backgroundColor = _color;
        _indexPath = nil;
        return;
    }
    _color = cell.backgroundColor;
    _indexPath = indexPath;
    cell.backgroundColor = _selectBGColor;
  
    NSInteger labelCount = 0;

    // 获取本月一日星期几 根据i值
    labelCount = [ZYQCalenderTool getWeeklyOrdinality:indexPath.row Page:_page];
    
    //本月天数
    NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page]];
    
    NSInteger lastCount = 0;
   
    if (labelCount < 1) {
        
        //上月天数
        lastCount = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page - 1]];
        labelCount = labelCount + lastCount;
        
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:_page - 1]]];
    }
    else if (labelCount > currentDay)
    {
        // 下月
        labelCount = labelCount - currentDay;
        
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:_page + 1]]];
        
    }else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:_page]]];
    }
  
    //替换日
    if ([NSString stringWithFormat:@"%ld",labelCount].length == 1) {
        
        _dateLabel.text = [_dateLabel.text stringByReplacingCharactersInRange:NSMakeRange(_dateLabel.text.length - 2, 2) withString:[NSString stringWithFormat:@"0%ld",labelCount]];
    }else
    {
        _dateLabel.text = [_dateLabel.text stringByReplacingCharactersInRange:NSMakeRange(_dateLabel.text.length - 2, 2) withString:[NSString stringWithFormat:@"%ld",labelCount]];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = _color;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(cellWidth, cellWidth);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
@end
