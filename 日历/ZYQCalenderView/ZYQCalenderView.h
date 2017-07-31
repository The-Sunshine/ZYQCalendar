//
//  ZYQCalenderView.h
//  日历
//
//  Created by zyq on 2017/6/5.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZYQCollectionViewStyle) {
    ZYQCollectionViewVertical,
    ZYQCollectionViewHorizon,
};


@interface ZYQCalenderView : UIView

/** collectionView高度 */
@property (nonatomic,assign) CGFloat collectionHeight;

/** 选中的cell背景颜色 */
@property (nonatomic,strong) UIColor  * selectBGColor;

/** 定义枚举类型 */
@property (nonatomic,assign) NSInteger collectionStyle;

@end
