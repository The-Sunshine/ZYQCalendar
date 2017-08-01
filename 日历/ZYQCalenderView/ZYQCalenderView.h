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

@protocol ZYQCalenderViewDelegate <NSObject>

-(void)ZYQCalenderViewClick:(NSString *)date;

@end
@interface ZYQCalenderView : UIView

/** collectionView高度 */
@property (nonatomic,assign) CGFloat collectionHeight;

/** 选中的cell背景颜色 */
@property (nonatomic,strong) UIColor  * selectBGColor;

/** 定义枚举类型 ZYQCollectionViewHorizon为默认类型 不需设置*/
@property (nonatomic,assign) NSInteger collectionStyle;

/** 代理 */
@property (nonatomic,weak) id<ZYQCalenderViewDelegate> delegate;


@end
