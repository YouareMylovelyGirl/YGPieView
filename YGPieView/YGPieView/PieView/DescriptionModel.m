//
//  DescriptionModel.m
//  Libui
//
//  Created by 阳光 on 2017/3/31.
//  Copyright © 2017年 johnlau. All rights reserved.
//

#import "DescriptionModel.h"

@implementation DescriptionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scaleArray = @[@0.1, @0.1, @0.1, @0.1, @0.1, @0.1, @0.1, @0.1, @0.2];
        self.descriptionArray = @[@"美股", @"六合彩", @"泡泡糖", @"奥特曼", @"去厕所", @"喝奶奶", @"红灯侠", @"你好", @"再见"];
        self.colorArr = @[[UIColor redColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor cyanColor], [UIColor grayColor], [UIColor blueColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor brownColor],];
    }
    return self;
}
@end
