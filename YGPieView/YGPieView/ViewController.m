//
//  ViewController.m
//  YGPieView
//
//  Created by 阳光 on 2017/4/4.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "ViewController.h"
#import "BigBackgroundView.h"
#import "DescribeView.h"
#import "PieViews.h"
#import "DescriptionModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //模型
    DescriptionModel *model = [[DescriptionModel alloc] init];
    
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
    
    
    
    
    /*
     
     注意⚠️:
     PieView控件逻辑:
     1) 使用PieViews控件, 一定要在调用 "changeScaleArrayToPieViewArray:" 方法前设置属性.
     2) 使用PieViews控件, 一定要先调用转换百分比方法 "changeScaleArrayToPieViewArray:"   再调用PieView制造者方法 "PieViewMaker"
     3) 使用PieViews控件, 一定要在 "addSubView" 之前 调用 "changeScaleArrayToPieViewArray:" 方法
     4) 单独使用PieViews控件,需要自己在PieViews控件外面包一层View,否则移动时会出现错乱.
     PieView使用顺序:
     设置属性 > 调用"changeScaleArrayToPieViewArray:" > 调用"PieViewMaker" > 包一层View > addSubViw
     
     BigBackGroundView控件逻辑:
     1) 使用BigBackGroundView控件时, 一定要在调用 "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:"方法前设置属性.
     2) 设置center属性时, 要在 "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:"方法后设置. 直接设置frame无所谓.
     
     BigBackgroundView使用顺序:
     设置属性 > "bigViewWithPieViewEdgeInset: DescribeViewEdgeInset:" > 设置 center 属性(不了解为什么)
     
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
