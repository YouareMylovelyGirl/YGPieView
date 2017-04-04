//
//  DescriptionModel.h
//  Libui
//
//  Created by 阳光 on 2017/3/31.
//  Copyright © 2017年 johnlau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DescriptionModel : NSObject
/** 描述数组 */
@property(nonatomic, strong) NSArray *descriptionArray;
/** 百分比数组 */
@property(nonatomic, strong) NSArray *scaleArray;
/** 颜色数组 */
@property(nonatomic, strong) NSArray *colorArr;

- (instancetype)init;
@end
