//
//  ZYQCalenderView.m
//  日历
//
//  Created by zyq on 2017/6/5.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import "ZYQCalenderView.h"
#import "ZYQCalenderTool.h"
#import "ZYQReusableView.h"
#import "ZYQCollectionCell.h"

#define cellWidth ([UIScreen mainScreen].bounds.size.width - 20) / 7
#define MSW ([UIScreen mainScreen].bounds.size.width)
#define MSH ([UIScreen mainScreen].bounds.size.height)

static const NSInteger lastYear = 1;
static NSString * cellID = @"cell";
static NSString * reusableViewID = @"reusableViewID";

@interface ZYQCalenderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation ZYQCalenderView
{
    UIButton    * _lastButton;
    UIButton    * _nextButton;
    UIImageView * _imageView;
    UIColor     * _normalBGColor;
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
    self.backgroundColor = [UIColor whiteColor];
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
        
        _imageView.frame = CGRectMake(0, dateLabelRect.size.height + dateLabelRect.origin.y, MSW, 25);
        
        _collectionView.frame = (CGRect){10, dateLabelRect.size.height + dateLabelRect.origin.y + _imageView.frame.size.height, MSW - 20, _collectionHeight};
    }else
    {
        _imageView.frame = CGRectMake(0, 0, MSW, 25);
        
        [_collectionView registerClass:[ZYQReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID];

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
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[ZYQCollectionCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark - clickEvent
-(void)monthClick:(UIButton *)button
{
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_indexPath];
    cell.backgroundColor = _normalBGColor;
    
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
    NSInteger index = 0;
    
    if (_collectionStyle == ZYQCollectionViewHorizon){
        
        index = _page;
    }else
    {
        index = section;
    }
    
    NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:index]]; // 当月天数
    
    NSInteger labelCount = -[ZYQCalenderTool getWeeklyOrdinality:0 Page:index] + 1; //上月n天
    
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
    ZYQCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    for (UILabel * label in cell.contentView.subviews) {
        
        [label removeFromSuperview];
    }
    
    NSInteger labelCount = 0;
    
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        cell.line.hidden = YES;
        
        // 获取本月一日星期几 根据i值
        labelCount = [ZYQCalenderTool getWeeklyOrdinality:indexPath.row Page:_page];
        
        //本月天数
        NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page]];
        
        if (labelCount < 1) {
            
            cell.dateLabel.textColor = [UIColor lightGrayColor];

            //上月天数
            NSInteger lastCount = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:_page - 1]];
            labelCount = labelCount + lastCount;
        }
        else if (labelCount > currentDay)
        {
            cell.dateLabel.textColor = [UIColor lightGrayColor];

            labelCount = labelCount - currentDay;
        }
        else
        {
            cell.dateLabel.textColor = [UIColor blackColor];
        }
    }else
    {
        if (indexPath == _indexPath) {
            
            cell.backgroundColor = _selectBGColor;
        }else
        {
            cell.backgroundColor = _normalBGColor;
        }
        
        cell.dateLabel.textColor = [UIColor blackColor];

        // 获取本月一日星期几 根据indexPath.row
        labelCount = [ZYQCalenderTool getWeeklyOrdinality:indexPath.row Page:indexPath.section];
        
        //本月天数
        NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:indexPath.section]];
        
        // 同一个section 只显示当月日期
        if (labelCount > currentDay || labelCount == 0)
        {
            cell.hidden = YES;
        }else
        {
            cell.hidden = NO;
        }
    }
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld",labelCount];

    return cell;
}

#pragma mark - collectionViewDelegate
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ZYQReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID forIndexPath:indexPath];
        
        NSString * date = [ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:indexPath.section]];
        headerView.dateLabel.text = [date substringToIndex:7];
        
        if ([headerView.dateLabel.text isEqual:[_dateLabel.text substringToIndex:7]]) {
            
            headerView.dateLabel.textColor = [UIColor redColor];
        }else
        {
            headerView.dateLabel.textColor = [UIColor blackColor];
        }
        
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (_collectionStyle == ZYQCollectionViewHorizon)
    {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake( MSW, 40);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        return 1;
    }else
    {
        /** 12个月*（前n年+后n年) */
        return 12 * lastYear * 2;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath == _indexPath) {
        
        cell.backgroundColor = _normalBGColor;
        _indexPath = nil;
        return;
    }
    _normalBGColor = cell.backgroundColor;
    _indexPath = indexPath;
    cell.backgroundColor = _selectBGColor;
  
    NSInteger index = 0;
    if (_collectionStyle == ZYQCollectionViewHorizon) {
        
        index = _page;
    }else
    {
        index = indexPath.section;
    }
    
    NSInteger labelCount = 0;

    // 获取本月一日星期几 根据i值
    labelCount = [ZYQCalenderTool getWeeklyOrdinality:indexPath.row Page:index];
    
    //本月天数
    NSUInteger currentDay = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:index]];
    
    NSInteger lastCount = 0;
   
    if (labelCount < 1) {
        
        //上月天数
        lastCount = [ZYQCalenderTool getNumberOfDaysInMonth:[ZYQCalenderTool dayInThePreviousMonth:index - 1]];
        labelCount = labelCount + lastCount;
        
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:index - 1]]];
    }
    else if (labelCount > currentDay)
    {
        // 下月
        labelCount = labelCount - currentDay;
        
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:index + 1]]];
        
    }else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@",[ZYQCalenderTool getDate:[ZYQCalenderTool dayInThePreviousMonth:index]]];
    }
  
    //替换日
    if ([NSString stringWithFormat:@"%ld",labelCount].length == 1) {
        
        _dateLabel.text = [_dateLabel.text stringByReplacingCharactersInRange:NSMakeRange(_dateLabel.text.length - 2, 2) withString:[NSString stringWithFormat:@"0%ld",labelCount]];
    }else
    {
        _dateLabel.text = [_dateLabel.text stringByReplacingCharactersInRange:NSMakeRange(_dateLabel.text.length - 2, 2) withString:[NSString stringWithFormat:@"%ld",labelCount]];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(ZYQCalenderViewClick:)]) {
        
        [self.delegate ZYQCalenderViewClick:_dateLabel.text];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = _normalBGColor;
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
