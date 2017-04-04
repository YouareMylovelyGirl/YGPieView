//
//  bigBackgroundView.h
//  Pie
//
//  Created by 阳光 on 2017/3/30.
//  Copyright © 2017年 YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieViews.h"
#import "DescribeView.h"
@interface BigBackgroundView : UIView


/*---------------------------------饼图相关------------------------------------------*/

/** 传入百分比数组 */
@property(nonatomic, strong) NSArray *scaleArr;

/** 颜色数组 */
@property(nonatomic, strong) NSArray *colorArr;

/** 线宽 默认 20          当线宽大于等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat lineWidth;

/** 饼图半径  默认35       当线宽小于等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat pieViewRadius;

/*---------------------------------------------------------------------------------*/

/*------------------------------详细描述相关-----------------------------------------*/
/** 横竖向排列 默认竖向排列*/
@property(nonatomic, assign) DesPositionType positionStyle;

/** 按钮和label 字体大小 默认大小9 */
@property(nonatomic, assign) int labelFont  ;

/** 控件内部按钮 和 label 空隙 默认5 */
@property(nonatomic, assign) CGFloat desButtonAndLabelMargin;

/** 控件之间的行高 默认5 */
@property(nonatomic, assign) CGFloat rowMargin;

/** 折行 默认3 */
@property(nonatomic, assign) int breakLineNumber;

/** label最大宽度 默认有多宽显示多宽*/
@property(nonatomic, assign) CGFloat maxLabelWidth;

/** view视图之间的间隔 默认5*/
@property(nonatomic, assign) CGFloat colMargin;

/** 详细描述数组 */
@property(nonatomic, strong) NSArray *describeArr;


/*---------------------------------------------------------------------------------*/


/**
 *  传入控件的内边距 创建整体控件
 *
 *  @param pieViewInset      饼图的内边距(相对于最近控件)
 *  @param describeViewInset 描述控件的内边距(相对于最近控件)
 *
 *  @return self 创建是不需要设置frame, 如设置 宽高传入(0, 0)即可
 */
- (instancetype)bigViewWithPieViewEdgeInset:(UIEdgeInsets)pieViewInset DescribeViewEdgeInset:(UIEdgeInsets)describeViewInset;

@end
