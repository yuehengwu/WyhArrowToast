//
//  WyhArrowToastStyle.h
//  WyhArrowToast_Example
//
//  Created by Michael Wu on 2019/4/30.
//  Copyright © 2019 Michael Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WyhArrowToastStyle : NSObject

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL isShowShadow;

@property (nonatomic, assign) NSTimeInterval dismissInterval;

@end
