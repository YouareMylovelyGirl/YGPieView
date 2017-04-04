//
//  describeView.m
//  Pie
//
//  Created by 阳光 on 2017/3/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "DescribeView.h"

@implementation DescribeView 
{
    //展示视图宽
    CGFloat _viewWidth;
    //展示视图高
    CGFloat _viewHeight;
    //最大按钮宽度
    CGFloat _maxButtonWidth;
    //按钮高度
    CGFloat _buttonHeight;
    
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _labelFont = 9;
        _desButtonAndLabelMargin = 5;
        _rowMargin = 5;
        _colMargin = 5;
        _breakLineNumber = 3;
        _positionStyle = kPositionTypeHorizontal;
        
    }
    return self;
}

#pragma mark - 创建描述控件
- (instancetype)describeInPieView:(NSArray<NSString *> *)describeArr withColorArr:(NSArray *)colorArr withScaleArr:(NSArray<NSNumber *> *)scaleArr
{
    //容错: 数组元素显示不匹配将 直接return
    if (colorArr.count < scaleArr.count || colorArr.count < describeArr.count || describeArr.count < scaleArr.count || scaleArr.count < describeArr.count) {
        return nil;
    }
    
    //返回数组中最大字符串长度
    CGFloat maxLabelWidth;
    if (self.maxLabelWidth < 0.001) {
        maxLabelWidth = [self returnMaxWidth:describeArr];
    } else {
        maxLabelWidth = self.maxLabelWidth;
    }
    
    
    for (int i = 0; i < describeArr.count; i++) {
        [self setUpButtonWithDesArr:scaleArr colorArr:colorArr index:i];
    }
    
    
    if (describeArr.count == scaleArr.count) {
        
        switch (self.positionStyle) {
            case kPositionTypeVertical: // 竖向排列
            {
                
                for (int i = 0; i < describeArr.count; i++) {
                    
                    //避免重赋值_viewHeight 和 _viewWidth
                    if (_viewHeight == 0.0) {
                        //显示View的高度
                        _viewHeight = _buttonHeight;
                        
                        //显示View宽度
                        _viewWidth = _maxButtonWidth + maxLabelWidth + _desButtonAndLabelMargin;
                        
                        
                        //竖向排布frame计算
                        if (scaleArr.count <= _breakLineNumber) {
                            CGRect showViewWidth = self.frame;
                            showViewWidth.size.width = _viewWidth;
                            showViewWidth.size.height = (scaleArr.count - 1) * _rowMargin + scaleArr.count * _viewHeight;
                            self.frame = showViewWidth;
                            
                        } else {
                            if (scaleArr.count % _breakLineNumber == 0) {
                                CGRect showViewWidth = self.frame;
                                showViewWidth.size.height = (scaleArr.count / _breakLineNumber) * _viewHeight + ((scaleArr.count / _breakLineNumber) - 1) * _rowMargin;
                                showViewWidth.size.width = (_colMargin * _breakLineNumber - 1)  + _breakLineNumber * _viewWidth;
                                self.frame = showViewWidth;
                            } else {
                                CGRect showViewWidth = self.frame;
                                showViewWidth.size.width = ((scaleArr.count / _breakLineNumber) + 1) * _viewWidth + ((scaleArr.count / _breakLineNumber)) * _colMargin;
                                showViewWidth.size.height = (_colMargin * (_breakLineNumber - 1)) + _breakLineNumber * _viewHeight;
                                self.frame = showViewWidth;
                                
                            }
                        }
                    }
                    
                    //View 的x值
                    NSUInteger col = i / _breakLineNumber;
                    CGFloat viewX = col * (_viewWidth + _colMargin);
                    
                    //View 的y值
                    NSUInteger row = i % _breakLineNumber;
                    CGFloat viewY = row * (_viewHeight + _rowMargin);
                    //创建按钮显示
                    UIButton * vScaleBtn =  [self setUpButtonWithDesArr:scaleArr colorArr:colorArr index:i];
                    
                    //创建文本详细显示
                    UILabel *vDesLabel = [self setUpLabelWithDescribeArr:describeArr index:i maxWidth:maxLabelWidth];
                    
                    //创建底层View
                    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, _viewWidth, _viewHeight)];
                    //                    showView.backgroundColor = [UIColor redColor];
                    [showView addSubview:vDesLabel];
                    [showView addSubview:vScaleBtn];
                    [self addSubview:showView];
                }
                
                
            }
                break;
                //横向排布
            case kPositionTypeHorizontal:
            {
                
                for (int i = 0; i < describeArr.count; i++) {
                    
                    //避免重赋值_viewHeight
                    if (_viewHeight == 0.0) {
                        //显示View的高度
                        _viewHeight = _buttonHeight;
                        
                        //显示View宽度
                        _viewWidth = _maxButtonWidth + maxLabelWidth + _desButtonAndLabelMargin;
                        
                        //横向排布布局
                        if (scaleArr.count <= _breakLineNumber) {
                            CGRect showViewWidth = self.frame;
                            showViewWidth.size.width = _colMargin * (scaleArr.count - 1) + scaleArr.count * _viewWidth;
                            showViewWidth.size.height = _viewHeight;
                            self.frame = showViewWidth;
                            
                        } else {
                            if (scaleArr.count % _breakLineNumber == 0) {
                                CGRect showViewWidth = self.frame;
                                showViewWidth.size.height = (scaleArr.count / _breakLineNumber) * _viewHeight + ((scaleArr.count / _breakLineNumber) - 1) * _rowMargin;
                                showViewWidth.size.width = (_colMargin * _breakLineNumber - 1)  + _breakLineNumber * _viewWidth;
                                self.frame = showViewWidth;
                            } else {
                                CGRect showViewWidth = self.frame;
                                showViewWidth.size.height = ((scaleArr.count / _breakLineNumber) + 1) * _viewHeight + ((scaleArr.count / _breakLineNumber)) * _rowMargin;
                                showViewWidth.size.width = (_colMargin * (_breakLineNumber - 1)) + _breakLineNumber * _viewWidth;
                                self.frame = showViewWidth;
                            }
                        }
                    }
                    
                    //View 的x值
                    NSUInteger col = i % _breakLineNumber;
                    CGFloat viewX = col * (_viewWidth + _colMargin);
                    
                    //View 的y值
                    NSUInteger row = i / _breakLineNumber;
                    CGFloat viewY = row * (_viewHeight + _rowMargin);
                    
                    //创建按钮显示
                    UIButton *hScaleBtn = [self setUpButtonWithDesArr:scaleArr colorArr:colorArr index:i];
                    
                    
                    
                    //创建文本按钮
                    UILabel *hDesLabel = [self setUpLabelWithDescribeArr:describeArr index:i maxWidth:maxLabelWidth];
                    
                    //创建底层View
                    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, _viewWidth, _viewHeight)];
                    [showView addSubview:hDesLabel];
                    [showView addSubview:hScaleBtn];
                    [self addSubview:showView];
                }
            }
                break;
        }
    }
    return self;
}


#pragma mark - 创建按钮显示
- (UIButton *)setUpButtonWithDesArr:(NSArray *)scaleArr colorArr:(NSArray *)colorArr index:(int)i
{
    //创建按钮
    UIButton *scaleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    scaleBtn.enabled = NO;
    
    //设置按钮圆角 颜色 边框
    scaleBtn.layer.cornerRadius = (int)(_labelFont / 2);
    scaleBtn.layer.borderWidth = 1;
    scaleBtn.layer.borderColor = ((UIColor *)colorArr[i]).CGColor;
    
    //设置按钮显示文字 大小 字体 颜色
    [scaleBtn setTitle:[NSString stringWithFormat:@" %.1lf%% ", [scaleArr[i] floatValue] * 100] forState:UIControlStateNormal];
    [scaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    scaleBtn.titleLabel.font = [UIFont systemFontOfSize:_labelFont];
    //    [scaleBtn setBackgroundColor:colorArr[i]];
    
    //按钮自适应宽高
    [scaleBtn sizeToFit];
    //将按钮中文字遍历进数组
    NSMutableArray *widthArr = [NSMutableArray array];
    for (int i = 0; i < scaleArr.count; i++) {
        NSString *titleLabel = scaleBtn.titleLabel.text;
        [widthArr addObject:titleLabel];
    }
    
    //获取按钮最大宽度
    _maxButtonWidth = [self returnMaxWidth:widthArr];
    //获取按钮高度
    _buttonHeight = scaleBtn.frame.size.height;
    
    
    return scaleBtn;
}

#pragma mark - 创建描述Label
- (UILabel *)setUpLabelWithDescribeArr:(NSArray *)describeArr index:(int)i maxWidth:(float)maxWidth
{
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(_maxButtonWidth + _desButtonAndLabelMargin, 0, maxWidth, _viewHeight)];
    //    desLabel.backgroundColor = [UIColor grayColor];
    desLabel.text = describeArr[i];
    desLabel.font = [UIFont systemFontOfSize:_labelFont];
    return desLabel;
}

#pragma mark - 返回数组中最大值
- (float)returnMaxWidth:(NSArray *)numberArr
{
    NSMutableArray *mTextArr = [NSMutableArray array];
    for (int i = 0; i < numberArr.count; i++) {
        
        CGRect frame = [numberArr[i] boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_labelFont]} context:nil];
        double width = frame.size.width;
        [mTextArr addObject:[NSNumber numberWithFloat:width]];
    }
    return [[mTextArr valueForKeyPath:@"@max.intValue"] floatValue] + 1;
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
