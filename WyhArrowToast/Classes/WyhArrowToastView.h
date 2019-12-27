//
//  WyhArrowToastView.h
//  Arm
//
//  Created by Michael Wu on 2019/4/16.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WyhArrowToastStyle.h"

extern CGFloat const kArrowToastDismissTimeInterval;// default dismiss time interval

typedef NS_ENUM(NSUInteger, WyhArrowToastViewDirection) {
    WyhArrowToastViewDirectionLeftTop ,
    WyhArrowToastViewDirectionCenterTop,
    WyhArrowToastViewDirectionRightTop,
    
    WyhArrowToastViewDirectionLeftBottom ,
    WyhArrowToastViewDirectionCenterBottom,
    WyhArrowToastViewDirectionRightBottom,
    
    WyhArrowToastViewDirectionRightCenter,
    WyhArrowToastViewDirectionLeftCenter,
};

@interface WyhArrowToastView : UIView

@property (nonatomic, assign, readonly) BOOL isAppear;

+ (instancetype)showToastMessage:(NSString *)msg
                           point:(CGPoint)point
                       direction:(WyhArrowToastViewDirection)direction
                           style:(WyhArrowToastStyle *)style
                       superView:(UIView *)superView;

- (instancetype)initToastMessage:(NSString *)msg
                           point:(CGPoint)point
                       direction:(WyhArrowToastViewDirection)direction
                           style:(WyhArrowToastStyle *)style
                       superView:(UIView *)superView;

- (void)updateToastMessage:(NSString *)msg
                     point:(CGPoint)point
                 direction:(WyhArrowToastViewDirection)direction
                     style:(WyhArrowToastStyle *)style
                 superView:(UIView *)superView;

- (void)show;
- (void)showNerverDismiss;

- (void)dismiss;

@end


