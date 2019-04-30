//
//  WyhArrowToastStyle.m
//  WyhArrowToast_Example
//
//  Created by Michael Wu on 2019/4/30.
//  Copyright © 2019 Michael Wu. All rights reserved.
//

#import "WyhArrowToastStyle.h"

@implementation WyhArrowToastStyle

- (instancetype)init {
    if (self = [super init]) {
        _lineColor = [UIColor whiteColor];
        _backgroundColor = [UIColor whiteColor];
        _isShowShadow = YES;
        _dismissInterval = 3.f;
        _textColor = [UIColor orangeColor];
    }
    return self;
}

@end
