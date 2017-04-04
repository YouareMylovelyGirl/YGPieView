//
//  describeView.h
//  Pie
//
//  Created by 阳光 on 2017/3/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DesPositionType) {
    kPositionTypeHorizontal = 0, //横向排列
    kPositionTypeVertical //竖向排列
};
@interface DescribeView : UIView

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



/**
 *  创建描述控件
 *
 *  @param describeArr 描述信息
 *  @param colorArr    颜色
 *  @param scaleArr    百分比
 *
 *  @return self 创建不必设置frame
 */
- (instancetype)describeInPieView:(NSArray *)describeArr withColorArr:(NSArray *)colorArr withScaleArr:(NSArray *)scaleArr;
@end
