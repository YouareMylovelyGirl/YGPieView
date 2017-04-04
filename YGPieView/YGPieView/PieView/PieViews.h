//
//  PieViews.h
//  Pie
//
//  Created by 阳光 on 2017/3/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PieViews : UIView
/** 传入百分比数组 */
@property(nonatomic, strong) NSArray *scaleArr;

/** 颜色数组 */
@property(nonatomic, strong) NSArray *colorArr;

/** 线宽 默认 20          当线宽等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat lineWidth;

/** 饼图半径  默认35       当线宽等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat pieViewRadius;



/**
 *  一 传入的百分比数组, 返回转换为饼图使用的数组
 *
 *  @param scaleArr 百分比数组
 *
 *  @return pieView可用数组
 */
- (NSArray *)changeScaleArrayToPieViewArray:(NSArray *)scaleArr;


/**
 *  二 创建饼图方法
 *
 *  @return self 不必设置frame
 */
- (instancetype)PieViewMaker;
@end
