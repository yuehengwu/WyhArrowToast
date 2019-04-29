//
//  HSArrowToastView.m
//  Arm
//
//  Created by Michael Wu on 2019/4/16.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import "HSArrowToastView.h"

CGFloat const kArrowToastDismissTimeInterval = 5.f;

static NSString * const kAnimation_Type_Key = @"animationType";
static NSString * const kAnimation_Show_Value = @"show";
static NSString * const kAnimation_Dismiss_Value = @"dismiss";

static NSString * const kShow_Animation_Key = @"kShow_Animation_Key";
static NSString * const kDismiss_Animation_Key = @"kDismiss_Animation_Key";

@interface HSArrowToastView () <CAAnimationDelegate>

@property (nonatomic, weak) UIView *superView;

// required-parameter
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) HSArrowToastViewDirection direction;
@property (nonatomic, assign) CGPoint showPointCenter;

// const
@property (nonatomic, assign) CGFloat textLeftMargion;
@property (nonatomic, assign) CGFloat textTopMargion;
@property (nonatomic, assign) CGSize triangleSize;
@property (nonatomic, assign) CGFloat triangleLeftMargion;

// var
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, strong) NSArray<NSValue *> *points;
@property (nonatomic, assign) CGFloat squareTopMargion;

@end

@implementation HSArrowToastView

#pragma mark - Life

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    // 三角形
    CGPoint points[3];
    points[0] = [_points[0] CGPointValue];
    points[1] = [_points[1] CGPointValue];
    points[2] = [_points[2] CGPointValue];
    
    CGContextAddLines(context, points, 3);
//    [Color_ThemeColor setStroke];
    [Color_White setFill];
    
    // 矩形
    CGFloat squareTopY = 0.f;
    switch (_direction) {
        case HSArrowToastViewDirectionLeftTop:
        case HSArrowToastViewDirectionCenterTop:
        case HSArrowToastViewDirectionRightTop:
        {
            squareTopY = 0;
        }
            break;
        case HSArrowToastViewDirectionLeftBottom:
        case HSArrowToastViewDirectionCenterBottom:
        case HSArrowToastViewDirectionRightBottom:
        {
            squareTopY = _triangleSize.height;
        }
            break;
        default:
        {
            NSAssert(NO, @"unknwon direction");
        }
            break;
    }
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, squareTopY, self.bounds.size.width, self.bounds.size.height - _triangleSize.height) cornerRadius:5.f];
    [Color_White setStroke];
    [Color_White setFill];
    [squarePath fill];
    [squarePath stroke];
    
    // 文字
    CGFloat toastTextY = 0.f;
    switch (_direction) {
        case HSArrowToastViewDirectionLeftTop:
        case HSArrowToastViewDirectionCenterTop:
        case HSArrowToastViewDirectionRightTop:
        {
            toastTextY = _textTopMargion;
        }
            break;
        case HSArrowToastViewDirectionRightBottom:
        case HSArrowToastViewDirectionLeftBottom:
        case HSArrowToastViewDirectionCenterBottom:
        {
            toastTextY = _triangleSize.height + _textTopMargion;
        }
            break;
        default:
            break;
    }
    
    CGRect textRect = CGRectMake(_textLeftMargion, toastTextY, _textSize.width, _textSize.height);
    [_message drawInRect:textRect withAttributes:[self getTextAttribute]];
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)layoutSubviews {
    [self updateShadow];
}



#pragma mark - Initialize

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initToastMessage:(NSString *)msg
                           point:(CGPoint)point
                       direction:(HSArrowToastViewDirection)direction
                       superView:(UIView *)superView {
    
    if (self = [self init]) {
        
        [self updateToastMessage:msg point:point direction:direction superView:superView];
    }
    
    return self;
}

- (void)initialize {
    
    self.opaque = NO;
    
    _textLeftMargion = 18.f;
    _textTopMargion = 12.f;
    _triangleLeftMargion = 10.f;
    
    _triangleSize = CGSizeMake(18, 10);
}

#pragma mark - Api

+ (void)showToastMessage:(NSString *)msg
                   point:(CGPoint)point
               direction:(HSArrowToastViewDirection)direction
             triggerMode:(HSCodeTimeState)mode
               superView:(UIView *)superView {
    
    // every time just for test !
    [HSCodeTime performWithState:mode key:msg code:^{
        HSArrowToastView *toast = [[HSArrowToastView alloc]initToastMessage:msg point:point direction:direction superView:superView];
        [toast show];
    }];
}

- (void)updateToastMessage:(NSString *)msg
                     point:(CGPoint)point
                 direction:(HSArrowToastViewDirection)direction
                 superView:(UIView *)superView {
    
    _message = msg;
    _direction = direction;
    _showPointCenter = point;
    
    _superView = superView?:[UIApplication sharedApplication].delegate.window;
    _textSize = [self caculateTextSize];
    self.frame = [self caculateFrameWithTextSize:_textSize];
    _points = [self calculateTrianglePoints];
    
}

- (void)show {
    [self showIfDelayDismiss:YES];
}

- (void)showNerverDismiss {
    [self showIfDelayDismiss:NO];
}

- (void)showIfDelayDismiss:(BOOL)ifDismiss {
    if (_isAppear) {
        return;
    }
    _isAppear = YES;
    
    [self setNeedsDisplay];
    
    [_superView addSubview:self];
    [self animation_show];
    
    if (ifDismiss) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:5.f];
    }
}

- (void)dismiss {
    if (!_isAppear) {
        return;
    }
    [self animation_dismiss];
}

#pragma mark - UI

- (void)animation_show {
    
    CABasicAnimation *alphaAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnima.duration = .2f;
    alphaAnima.removedOnCompletion = NO;
    alphaAnima.fromValue = @0;
    alphaAnima.toValue = @1;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.keyTimes = @[ @0, @0.5, @1 ];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    /** postion and anchorPoint :
     *
     * frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
     * frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
     */
    CGRect oldFrame = self.frame;
    switch (_direction) {
        case HSArrowToastViewDirectionLeftTop:
        {
            self.layer.anchorPoint = CGPointMake(0.1, 1);
        }
            break;
        case HSArrowToastViewDirectionCenterTop:
        {
            self.layer.anchorPoint = CGPointMake(0.5, 1);
        }
            break;
        case HSArrowToastViewDirectionRightTop:
        {
            self.layer.anchorPoint = CGPointMake(0.9, 1);
        }
            break;
        case HSArrowToastViewDirectionLeftBottom:
        {
            self.layer.anchorPoint = CGPointMake(0.1, 0);
        }
            break;
        case HSArrowToastViewDirectionCenterBottom:
        {
            self.layer.anchorPoint = CGPointMake(0.5, 0);
        }
            break;
        case HSArrowToastViewDirectionRightBottom:
        {
            self.layer.anchorPoint = CGPointMake(0.9, 0);
        }
            break;
        default:
            break;
    }
    self.frame = oldFrame; // fix wrong frame when anchorPoint changed.
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[alphaAnima,animation];
    group.delegate = self;
    
    [group setValue:kAnimation_Show_Value forKey:kAnimation_Type_Key];
    [self.layer addAnimation:group forKey:kShow_Animation_Key];
    
}

- (void)animation_dismiss {
    /*
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    animation.removedOnCompletion = NO;
    [animation setValue:kAnimation_Dismiss_Value forKey:kAnimation_Type_Key];

    [self.layer addAnimation:animation forKey:kDismiss_Animation_Key];
     */
    
    [UIView animateWithDuration:.2f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.f;
        _isAppear = NO;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark -

- (void)updateShadow {
    
    CALayer *shadowLayer = self.layer;
    shadowLayer.shadowOpacity = 0.1f;
    shadowLayer.shadowRadius = 5.f;
    shadowLayer.shadowOffset = CGSizeMake(0, 1);
    
}

#pragma mark - Private

- (CGRect)caculateFrameWithTextSize:(CGSize)textSize {
    
    CGFloat toastX = 0.f;
    CGFloat toastY = 0.f;
    CGFloat toastWidth = textSize.width + _textLeftMargion*2;
    CGFloat toastHeight = textSize.height + _textTopMargion*2 + _triangleSize.height;
    
    switch (_direction) {
            
            // top:
        case HSArrowToastViewDirectionLeftTop:
        {
            toastX = _showPointCenter.x - _triangleSize.width*0.5 - _triangleLeftMargion;
            toastY = _showPointCenter.y - toastHeight;
        }
            break;
        case HSArrowToastViewDirectionCenterTop:
        {
            toastX = _showPointCenter.x  - toastWidth*0.5;
            toastY = _showPointCenter.y  - toastHeight;
        }
            break;
        case HSArrowToastViewDirectionRightTop:
        {
            toastX = _showPointCenter.x - _triangleSize.width*0.5 - (toastWidth-(_triangleLeftMargion+_triangleSize.width));
            toastY = _showPointCenter.y  - toastHeight;
        }
            break;
            
            // bottom:
        case HSArrowToastViewDirectionLeftBottom:
        {
            toastX = _showPointCenter.x - _triangleSize.width*0.5 - _triangleLeftMargion;
            toastY = _showPointCenter.y;
        }
            break;
        case HSArrowToastViewDirectionCenterBottom:
        {
            toastX = _showPointCenter.x - toastWidth*0.5;
            toastY = _showPointCenter.y;
        }
            break;
        case HSArrowToastViewDirectionRightBottom:
        {
            toastX = _showPointCenter.x - _triangleSize.width*0.5 - (toastWidth-(_triangleLeftMargion+_triangleSize.width));
            toastY = _showPointCenter.y;
        }
            break;
        default:
        {
            NSAssert(NO, @"unknwon direction");
        }
            break;
    }
    
    CGRect frame = CGRectMake(toastX, toastY, toastWidth, toastHeight);
    
    return frame;
}

- (NSArray<NSValue*>*)calculateTrianglePoints {
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        NSAssert(NO, @"frame must get before this !");
    }
    
    CGFloat triangleLeftMargion = 0.f;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    
    switch (_direction) {
            
            // top:
        case HSArrowToastViewDirectionLeftTop:
        case HSArrowToastViewDirectionCenterTop:
        case HSArrowToastViewDirectionRightTop:
        {
            if (_direction == HSArrowToastViewDirectionLeftTop) {
                triangleLeftMargion = _triangleLeftMargion;
            }else if (_direction == HSArrowToastViewDirectionCenterTop){
                triangleLeftMargion = self.bounds.size.width*0.5 - _triangleSize.width*0.5;
            }else if (_direction == HSArrowToastViewDirectionRightTop){
                triangleLeftMargion = self.bounds.size.width - (_triangleLeftMargion+_triangleSize.width) ;
            }
            
            point0 = CGPointMake(triangleLeftMargion, self.bounds.size.height-_triangleSize.height);
            point1 = CGPointMake(triangleLeftMargion +_triangleSize.width*0.5, self.bounds.size.height);
            point2 = CGPointMake(triangleLeftMargion + _triangleSize.width, point0.y);
        }
            break;
            
            // bottom:
        case HSArrowToastViewDirectionLeftBottom:
        case HSArrowToastViewDirectionCenterBottom:
        case HSArrowToastViewDirectionRightBottom:
        {
            if (_direction == HSArrowToastViewDirectionLeftBottom) {
                triangleLeftMargion = _triangleLeftMargion;
            }else if (_direction == HSArrowToastViewDirectionCenterBottom){
                triangleLeftMargion = self.bounds.size.width*0.5 - _triangleSize.width*0.5;
            }else if (_direction == HSArrowToastViewDirectionRightBottom){
                triangleLeftMargion = self.bounds.size.width - (_triangleLeftMargion+_triangleSize.width) ;
            }
            point0 = CGPointMake(triangleLeftMargion, _triangleSize.height);
            point1 = CGPointMake(triangleLeftMargion +_triangleSize.width*0.5, 0);
            point2 = CGPointMake(triangleLeftMargion + _triangleSize.width, point0.y);
        }
            break;
        
        default:
        {
            NSAssert(NO, @"unknwon direction");
        }
            break;
    }
    
    NSValue *value0 = [NSValue valueWithCGPoint:point0];
    NSValue *value1 = [NSValue valueWithCGPoint:point1];
    NSValue *value2 = [NSValue valueWithCGPoint:point2];
    
    return @[value0,value1,value2];
}

- (CGSize)caculateTextSize {
    
    NSParameterAssert(_message);
    
    CGSize textSize = [_message boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:[self getTextAttribute]
                                         context:nil].size;
    
    return textSize;
}

#pragma mark - Setter / Getter

- (NSDictionary *)getTextAttribute {
    NSDictionary *textAttribute = @{
                                    NSForegroundColorAttributeName:Color_ThemeColor,
                                    NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                                    };
    return textAttribute;
}

- (void)setAnchorPoint:(CGPoint)point {
    
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kAnimation_Type_Key] isEqualToString:kAnimation_Dismiss_Value]) {
        _isAppear = NO;
//        [self removeFromSuperview];
    }
//    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
}

@end
