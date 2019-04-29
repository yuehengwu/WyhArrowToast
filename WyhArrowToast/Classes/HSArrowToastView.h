//
//  HSArrowToastView.h
//  Arm
//
//  Created by Michael Wu on 2019/4/16.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCodeTime.h"

extern CGFloat const kArrowToastDismissTimeInterval;// default dismiss time interval

typedef NS_ENUM(NSUInteger, HSArrowToastViewDirection) {
    HSArrowToastViewDirectionLeftTop ,
    HSArrowToastViewDirectionCenterTop,
    HSArrowToastViewDirectionRightTop,
    
    HSArrowToastViewDirectionLeftBottom ,
    HSArrowToastViewDirectionCenterBottom,
    HSArrowToastViewDirectionRightBottom,
};

@interface HSArrowToastView : UIView

@property (nonatomic, assign, readonly) BOOL isAppear;

+ (void)showToastMessage:(NSString *)msg
                   point:(CGPoint)point
               direction:(HSArrowToastViewDirection)direction
             triggerMode:(HSCodeTimeState)mode
               superView:(UIView *)superView;

- (instancetype)initToastMessage:(NSString *)msg
                           point:(CGPoint)point
                       direction:(HSArrowToastViewDirection)direction
                       superView:(UIView *)superView;

- (void)updateToastMessage:(NSString *)msg
                     point:(CGPoint)point
                 direction:(HSArrowToastViewDirection)direction
                 superView:(UIView *)superView;

- (void)show;
- (void)showNerverDismiss;

- (void)dismiss;

@end


