//
//  WyhViewController.m
//  WyhArrowToast
//
//  Created by Michael Wu on 04/25/2019.
//  Copyright (c) 2019 Michael Wu. All rights reserved.
//

#import "WyhViewController.h"
#import <WyhArrowToastView.h>

@interface WyhViewController ()

@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@end

@implementation WyhViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self showAllToast];
    });
    
}


- (void)showAllToast {
    // point0
    CGPoint point0 = CGPointMake(CGRectGetMinX(_view0.frame) + CGRectGetWidth(_view0.frame)*0.5, CGRectGetMinY(_view0.frame));
    [self showArrowToastWithPoint:point0 direction:(WyhArrowToastViewDirectionLeftTop)];
    
    // point1
    CGPoint point1 = CGPointMake(CGRectGetMidX(_view1.frame), CGRectGetMaxY(_view1.frame));
    [self showArrowToastWithPoint:point1 direction:(WyhArrowToastViewDirectionRightBottom)];
    
    // point2
    CGPoint point2 = CGPointMake(CGRectGetMinX(_view2.frame) + CGRectGetWidth(_view2.frame)*0.5, CGRectGetMinY(_view2.frame));
    [self showArrowToastWithPoint:point2 direction:(WyhArrowToastViewDirectionCenterTop)];
    
    // point3
    CGPoint point3 = CGPointMake(CGRectGetMaxX(_view3.frame), CGRectGetMidY(_view3.frame));
    [self showArrowToastWithPoint:point3 direction:(WyhArrowToastViewDirectionLeftCenter)];
    
    // point 4
    CGPoint point4 = CGPointMake(CGRectGetMidX(_view4.frame), CGRectGetMinY(_view4.frame));
    [self showArrowToastWithPoint:point4 direction:(WyhArrowToastViewDirectionCenterTop)];
}

- (void)showArrowToastWithPoint:(CGPoint)point direction:(WyhArrowToastViewDirection)direction {
    
    [WyhArrowToastView showToastMessage:NSLocalizedString(@"Click anywhere to show again", nil) point:point direction:direction style:nil superView:self.view];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self showAllToast];
}

@end
