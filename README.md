# 饼图模块, 详细模块控件封装
- 饼图封装分为三个控件.
    - 饼图控件
    - 描述控件
    - 饼图控件(左)描述控件(右)整合 

    ### 图为将两个控件包装好了以后的样子称为BigBackgroundView控件
    
![Snip20170404_1](http://olz5ctllw.bkt.clouddn.com/Snip20170404_1.png)

### BigBackgroundView控件:
####BigBackground控件中提供的方法

```objc
 /**
   *  传入控件的内边距 创建整体控件
   *
   *  @param pieViewInset      饼图的内边距(相对于最近控件)
   *  @param describeViewInset 描述控件的内边距(相对于最近控件)
   *
   *  @return self 创建是不需要设置frame, 如设置 宽高传入(0, 0)即可
   */
 - (instancetype)bigViewWithPieViewEdgeInset:(UIEdgeInsets)pieViewInset DescribeViewEdgeInset:(UIEdgeInsets)describeViewInset;
```

- 从方法可以看出只要传入pieView的内边距和传入描述控件内边距即可创建
    -  BigBackgroundView控件不需要初始化frame,因为整体宽高是由内部的两个控件共同决定的
    -  如果pieView的高度大于描述控件的高度, 描述控件居中.反之PieView居中
- 如果觉得BigBackgroundView控件的左右布局不够你的开发需求,我们可以将两个控件拆分开来逐个排布

####BigBackground中提供的属性
**PieView 和 DescribeView 的属性汇总 下面介绍这两个控件**

---

###PieView控件
####PieView中的属性
![Snip20170404_3](http://olz5ctllw.bkt.clouddn.com/Snip20170404_3.png)

```objc
/** 传入百分比数组 */
@property(nonatomic, strong) NSArray *scaleArr;

/** 颜色数组 */
@property(nonatomic, strong) NSArray *colorArr;

/** 线宽 默认 20          当线宽等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat lineWidth;

/** 饼图半径  默认35       当线宽等于饼图半径时候 空心变成实心   */
@property(nonatomic, assign) CGFloat pieViewRadius;
```  

> 属性 百分比数组
> 属性 颜色数组(可以多传颜色)
> 属性 线宽(饼图, 空心饼图)
> 属性 半径(和线宽配合使用)

####PieView中的方法
```objc
/**
 *  一 传入的百分比数组, 返回转换为饼图使用的数组
 *
 *  @param scaleArr 百分比数组
 *
 *  @return pieView可用数组
 */
- (NSArray *)changeScaleArrayToPieViewArray:(NSArray *)scaleArr;
```
- 第一步: 需要将服务器传进来的百分比数组进行加工, 需要适应PieView中使用的百分比数组
    - 解析: 饼图的绘制, 第一个百分比绘制结束的地方, 就是第二个绘制的开始, 以此类推..

```objc    
/**
 *  二 创建饼图方法
 *
 *  @return self 不必设置frame
 */
- (instancetype)PieViewMaker;
``` 
- 第二步: 饼图制造者, 直接调用此方法就可以绘制出饼图.不必设置frame, 只需要给出x, y 即可, 宽高 (0, 0)即可.
- 如果不主动设置饼图的半径和线宽属性, 则会初始化默认的饼图.属性中将默认数值已经列出
- 如果不传入数组, 传入数组数量不匹配, 控制器将不显示控件

---

###DescribeView控件
####DescribeView中属性
![Snip20170404_4](http://olz5ctllw.bkt.clouddn.com/Snip20170404_4.png)

```objc
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
```
> 属性 横向排布, 还是竖向排布
> 属性 字体的大小
> 属性 左边方块和文字之间的空隙
> 属性 行间距
> 属性 到第几行折返到下一行(行, 列公用属性)
> 属性 文字最大显示多宽(默认有多宽显示多宽, 服务器应该计算好宽度)
> 属性 列间距

####DescribeView中方法
```objc
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
```
- 传入描述信息数组, 颜色数组, 百分比数组, 将创建好一个描述控件
- 如果不设置描述控件属性则显示默认属性, 以上属性有列出
- 如果传入数组为空, 输入数组数量不一致, 控制器将不显示描述控件

##控件解析
###PieView解析
**应用`drawRect:`方法绘制**

- 进入PieView首先先应用`drawRect:`方法先绘制第一个圆
    - 因为如果服务器由于精度问题, 传入的百分比数组相加不为1, 有可能少, 有可能多. 我先绘制一个完整圆, 剩下的继续绘制, 到最后会空出一个位置, 正好最下面的整个员从空出的位置显示出来, 将位置补充完成, 解决服务器返回数据不准确问题

```objc
#pragma mark - 直接绘制 drawRect
- (void)drawRect:(CGRect)rect {
    if (self.colorArr.count < self.scaleArr.count) {
        return;
    }
    // 如果传入数组数量为零 则直接返回
    if (self.scaleArr.count == 0) {
        return;
    } else {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:_pieRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [self adjust:path];
        [path stroke];
    }
    
}
```
- 里面有两个容错
    - 一个是数组为零时候
    - 一个是颜色少于百分比数组的时候 

**百分比数组转换成饼图使用数组**

- 由于服务器返回数组为`@[@0.1, @0.2, @0.3, @0.4];`
- 而饼图需要的是第一个元素为起点, 第二个元素为终点; 第二个元素为起点, 第三个元素为终点...依次类推直到结束, 这样的数组

```objc
#pragma mark - 将百分比穿换成pieView使用的百分比数组
- (NSArray *)changeScaleArrayToPieViewArray:(NSArray *)scaleArr
{
    CGFloat total = 0.0f;
    CGFloat start = 0.0f;
    CGFloat end = 0.0f;
    NSMutableArray *mScaleArr = [NSMutableArray array];
    for (int i = 0; i < scaleArr.count; i ++) {
        total += [scaleArr[i] floatValue];
        end = M_PI * 2 * [scaleArr[i] floatValue] + start;
        start = end;
        [mScaleArr addObject:[NSNumber numberWithFloat:end]];
    }
    return [mScaleArr copy];
}
```
- 转换完成后返回一个饼图可用的数组

**最后调用饼图制造者方法**

- 里面使用到了`UIBezierPath`, `CAShapeLayer`这两个类
- 先绘制`path`, 然后添加到`shapLayer`上面

```objc
#pragma mark - 饼图制造者
- (instancetype)PieViewMaker
{
    
    if (self.colorArr.count < self.scaleArr.count) {
        return nil;
    }
    
    //当线宽大于等于半径时候, 将为实心圆
    if (self.lineWidth >= self.pieViewRadius) {
        self.lineWidth = self.pieViewRadius;
    }
    
    CGRect pieViewFrame = self.frame;
    pieViewFrame.size.width = self.pieViewRadius * 2;
    pieViewFrame.size.height = self.pieViewRadius * 2;
    
    self.frame = pieViewFrame;
    
    //里面空心圆半径
    _pieRadius = (self.frame.size.width - self.lineWidth) / 2;
    
    // 如果传入数组数量为零 则直接返回
    if (self.scaleArr.count == 0) {
        return nil;
    }
    //如果传入数组数量为1, 则绘制整个圆
    if (self.scaleArr.count == 1) {
        return nil;
    } else {
        //否则正常绘制
        for (int i = 0; i <= self.scaleArr.count - 2; i++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path addArcWithCenter:self.center radius:_pieRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [self adjust:path];
            [path stroke];
            
            _bezierPath = [UIBezierPath bezierPath];
            [_bezierPath addArcWithCenter:self.center radius:_pieRadius startAngle:[self.scaleArr[i] floatValue] endAngle:[self.scaleArr[i + 1] floatValue]  clockwise:YES];
            
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.frame = self.bounds;
            _shapeLayer.path = _bezierPath.CGPath;
            [self adjustPathAndShapeLayer:_bezierPath shapeLayer:_shapeLayer color:((UIColor *)self.colorArr[i + 1])];
            [self.layer addSublayer:_shapeLayer];
        }
        
    }
    return self;
}
```
- 返回self, 在里面反推宽高
- 里面做了容错处理

---

###DescribeView解析
- 根据描述数组中最大的字符串先计算出宽度, 使用KVC中的`@"@max.intValue"`方法

```objc
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
```
- 控件整体使用frame计算宽高
- 返回self, 在空间内部计算宽高
- 根据行列, 根据行折行数量, 计算孔家显示排布

```objc
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
```
- 其中做了容错处理

--- 

###BigBackgroundView控件解析
- `import以上两个控件`在这个控件中包含了以上两个控件的所有属性, 以便于直接调用修改
- 创建控件的时候直接传入两个控件的内边距, BigBackgroundView控件内部会做处理
- 返回self创建控件的时候不必设置frame, 只需要设置位置即可

```objc
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
```

- 里面做了容错处理
    - 传入的内边距做了绝对值处理 
    - 对传入数组做了容错处理
    - 对边距做了容错处理

##使用方面
- 我模拟了一个模型`DescriptionModel`

```objc
//模型
    DescriptionModel *model = [DescriptionModel new];
```
**单独使用PieView**
> 警告⚠️: 
> 1) 使用PieViews控件, 一定要在调用 "changeScaleArrayToPieViewArray:" 方法前设置属性.
> 2) 使用PieViews控件, 一定要先调用转换百分比方法 "changeScaleArrayToPieViewArray:"   再调用PieView制造者方法 "PieViewMaker"
> 3) 使用PieViews控件, 一定要在 "addSubView" 之前 调用 "changeScaleArrayToPieViewArray:" 方法
> 4) 单独使用PieViews控件,需要自己在PieViews控件外面包一层View,否则移动时会出现错乱.
     PieView使用顺序:
     设置属性 > 调用"changeScaleArrayToPieViewArray:" > 调用"PieViewMaker" > 包一层View > addSubViw

```objc
    /***********单独使用**************/
    PieViews *pieView = [PieViews new];
    pieView.lineWidth = 30;
    pieView.pieViewRadius = 60;
    pieView.colorArr = model.colorArr;
    pieView.scaleArr = [pieView changeScaleArrayToPieViewArray:model.scaleArray];
    [pieView PieViewMaker];
    //包一层View
    UIView *basePieView = [UIView new];
    basePieView.frame = CGRectMake(20, 40, pieView.frame.size.width, pieView.frame.size.height);
    [basePieView addSubview:pieView];
    [self.view addSubview:basePieView];
    /********************************/
```
- 控件创建的时候不需要设置frame
- 需要包一层View, 绘制图形的通病
- 如果要设置位置, 只需要改变外面包的那层view的位置即可

**单独使用DescribeView**
> 无特殊警告⚠️

```objc
    /***********单独使用**************/
    DescribeView *desView = [DescribeView new];
    desView.frame = CGRectMake(20, pieView.frame.size.height + 50, 0, 0);
    desView.labelFont = 10;
    desView.desButtonAndLabelMargin = 5;
    desView.rowMargin = 5;
    desView.colMargin = 5;
    desView.breakLineNumber = 3;
    desView.positionStyle = kPositionTypeVertical;
    [desView describeInPieView:model.descriptionArray withColorArr:model.colorArr withScaleArr:model.scaleArray];
    [self.view addSubview:desView];
    /********************************/
```

**整体使用BigBackgroundView**
> 警告⚠️
> 1) 使用BigBackGroundView控件时, 一定要在调用 "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:"方法前设置属性.
> 2) 设置center属性时, 要在 "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:"方法后设置. 直接设置frame无所谓.
> 
> BigBackgroundView使用顺序:
> 设置属性 > "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:" > 设置 center 属性(不了解为什么)

```objc
/***************整合*****************/
    BigBackgroundView *showView = [BigBackgroundView new];
    showView.pieViewRadius = 60;
    showView.lineWidth = 30;
    showView.positionStyle = kPositionTypeVertical;
    showView.breakLineNumber = 5;
    showView.colorArr = model.colorArr;
    showView.scaleArr = model.scaleArray;
    showView.describeArr = model.descriptionArray;
    [self.view addSubview:showView];
    [showView bigViewWithPieViewEdgeInset:UIEdgeInsetsMake(0, 0, 0, 10) DescribeViewEdgeInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    showView.center = self.view.center;
    /********************************/
```

#### YG -- 阳光
##### 如果觉得写得还不错请给予一颗小⭐️⭐️

[GitHub地址](https://github.com/YouareMylovelyGirl)
[博客园地址](http://www.cnblogs.com/Dog-Ping/)



