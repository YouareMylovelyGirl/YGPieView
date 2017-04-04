//
//  bigBackgroundView.m
//  Pie
//
//  Created by 阳光 on 2017/3/30.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "BigBackgroundView.h"

@interface BigBackgroundView ()
/** 基础视图 */
@property(nonatomic, strong) UIView *basePieView;
/** pieView */
@property(nonatomic, strong) PieViews *pieView;
/** desView */
@property(nonatomic, strong) DescribeView *desView;
@end

@implementation BigBackgroundView
{
    //饼图和描述视图之间的间隔
    CGFloat _pieViewAndDesViewMargin;
    //饼图内边距
    UIEdgeInsets _pieViewInset;
    //描述视图内边距
    UIEdgeInsets _desViewInset;
}
#pragma mark - 初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        _pieViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _desViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        /*----------------*/
        self.labelFont = 9;
        self.desButtonAndLabelMargin = 5;
        self.rowMargin = 5;
        self.colMargin = 5;
        self.breakLineNumber = 3;
        self.positionStyle = kPositionTypeHorizontal;
        /*----------------*/
        self.lineWidth = 20.0f;
        self.pieViewRadius = 35.0f;
        
    }
    return self;
}

#pragma mark - 创建控件
- (instancetype)bigViewWithPieViewEdgeInset:(UIEdgeInsets)pieViewInset DescribeViewEdgeInset:(UIEdgeInsets)describeViewInset
{
    //容错: 数组元素显示不匹配将 直接return
    if (self.colorArr.count < self.scaleArr.count || self.colorArr.count < self.describeArr.count || self.describeArr.count < self.scaleArr.count || self.scaleArr.count < self.describeArr.count) {
        return nil;
    }
//    self.backgroundColor = [UIColor grayColor];
    
    [self setUpPieViewAndDesView];
    
    _pieViewInset = pieViewInset;
    _desViewInset = describeViewInset;
    
    
    //间隔距离
    _pieViewAndDesViewMargin = fabs(_pieViewInset.right)  ;
    
    //设置desView在bigView中的位置
    CGRect desViewFrame = _desView.frame;
    desViewFrame.origin.x = fabs(_pieViewInset.left) + self.basePieView.frame.size.width + _pieViewAndDesViewMargin;
    desViewFrame.origin.y = fabs(_desViewInset.top) ;
    _desView.frame = desViewFrame;
    
    //设置pieView在bigView中的位置
    CGRect basePieViewFrame = self.basePieView.frame;
    basePieViewFrame.origin.x = fabs(_pieViewInset.left) ;
    basePieViewFrame.origin.y = fabs(_pieViewInset.top) ;
    self.basePieView.frame = basePieViewFrame;
    
    
    //根据pieView 和 desView 计算bigView的宽 和 高
    CGRect bigViewFrame = self.frame;
    if (self.basePieView.frame.size.height > self.desView.frame.size.height) {
        bigViewFrame.size.height = fabs(_pieViewInset.top) + self.basePieView.frame.size.height + fabs(_pieViewInset.bottom);
        bigViewFrame.size.width = fabs(_pieViewInset.left) + self.basePieView.frame.size.width + _pieViewAndDesViewMargin + _desView.frame.size.width + fabs(_desViewInset.right);
        self.frame = bigViewFrame;
        
        //当pieView的高度 大于 desView的高度  desView 居中与PieView
        CGPoint desViewCenter = _desView.center;
        desViewCenter.y = self.basePieView.center.y;
        self.desView.center = desViewCenter;
        
    } else {
        bigViewFrame.size.height = fabs(_desViewInset.top) + _desView.frame.size.height + fabs(_desViewInset.bottom);
        bigViewFrame.size.width = fabs(_pieViewInset.left) + self.basePieView.frame.size.width + _pieViewAndDesViewMargin + _desView.frame.size.width + fabs(_desViewInset.right);
        self.frame = bigViewFrame;
        
        //当pieView的高度 小于 desView的高度PieView 居中与 desView
        CGPoint basePieViewCenter = self.basePieView.center;
        basePieViewCenter.y = self.desView.center.y;
        self.basePieView.center = basePieViewCenter;
    }
    return self;
}


#pragma mark - 创建pieView 和  desView
- (void)setUpPieViewAndDesView
{
    /*
     self.lineWidth = 20.0f;
     self.pieViewRadius = 35.0f;
     */
    

    
    self.pieView = [[PieViews alloc] init];
    
    self.pieView.scaleArr = self.scaleArr;
    self.pieView.colorArr = self.colorArr;
    self.pieView.pieViewRadius = self.pieViewRadius;
    self.pieView.lineWidth = self.lineWidth;
    
    //调用changeScaleArrayToPieViewArray: 设置百分比数组
    self.pieView.scaleArr = [_pieView changeScaleArrayToPieViewArray:self.scaleArr];
    [self.pieView PieViewMaker];
    
    self.basePieView = [[UIView alloc] initWithFrame:self.pieView.frame];
    [self.basePieView addSubview:_pieView];
    [self addSubview:_basePieView];
    
    
    
    /*
     _labelFont = 9;
     _desButtonAndLabelMargin = 5;
     _rowMargin = 5;
     _colMargin = 5;
     _breakLineNumber = 3;
     _positionStyle = kPositionTypeHorizontal;
     */
    self.desView = [[DescribeView alloc] init];
    self.desView.labelFont = self.labelFont;
    self.desView.desButtonAndLabelMargin = self.desButtonAndLabelMargin;
    self.desView.rowMargin = self.rowMargin;
    self.desView.colMargin = self.colMargin;
    self.desView.breakLineNumber = self.breakLineNumber;
    self.desView.positionStyle = self.positionStyle;
    self.desView.maxLabelWidth = self.maxLabelWidth;
    
    self.desView.positionStyle = kPositionTypeVertical;
    [self.desView describeInPieView:self.describeArr withColorArr:self.colorArr withScaleArr:self.scaleArr];
    [self addSubview:self.desView];
}



@end
