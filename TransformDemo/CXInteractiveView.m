//
//  CXInteractiveView.m
//  Test
//
//  Created by SamirChen on 3/10/14.
//  Copyright (c) 2014 SamirChen. All rights reserved.
//

#import "CXInteractiveView.h"

@interface CXInteractiveView ()
@property (nonatomic, strong) UIView *contentArea;
@property (nonatomic, strong) UIView *dragArea;

@property (assign, nonatomic) CGFloat dragRotateAngle;
@property (assign, nonatomic) CGFloat dragScale;
@end

@implementation CXInteractiveView

#pragma mark - Lifecycle
- (id)init {
    self = [self initWithFrame:CGRectMake(20, 70, 250, 250)];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // ==== Content Area ====
        self.contentArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentArea setBackgroundColor:[UIColor colorWithRed:arc4random()%100/255.0 green:arc4random()%100/255.0 blue:arc4random()%100/255.0 alpha:1.0]];
        // Single tap gesture recognizer in content area.
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTapRecognizer.numberOfTapsRequired = 1; // 单击
        [self.contentArea addGestureRecognizer:singleTapRecognizer];
        // Pan gesture recognizer in content area. 拖拽。
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.maximumNumberOfTouches = 1;
        [self.contentArea addGestureRecognizer:panRecognizer];
        // Rotation gesture in content area.
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        [self.contentArea addGestureRecognizer:rotationRecognizer];
        // Pinch gesture in content area.
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self.contentArea addGestureRecognizer:pinchRecognizer];
        [self addSubview:self.contentArea];
        
        // ==== Drag area ====
        self.dragArea = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-30, self.frame.size.height-30, 30, 30)];
        [self.dragArea setBackgroundColor:[UIColor blackColor]];
        // Pan gesture recognizer in drag area.
        UIPanGestureRecognizer *panDragAreaRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDragArea:)];
        panDragAreaRecognizer.minimumNumberOfTouches = 1;
        panDragAreaRecognizer.maximumNumberOfTouches = 1;
        [self.dragArea addGestureRecognizer:panDragAreaRecognizer];
        [self addSubview:self.dragArea];
        
        
        self.dragRotateAngle = 0;
        self.dragScale = 1;
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)layoutSubviews {
    NSLog(@"layoutSubviews...");
    
}

#pragma mark - Action In Content Area
- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"Single Tap in %@.", self);
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    
    [self printFrameOfView:self];
    [self printFrameOfView:self.contentArea];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"Pan in self.");
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }

    if ((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded)) {
        
        //CGPoint touchPoint = [recognizer locationInView:self];
        //NSLog(@"P(%f, %f)", touchPoint.x, touchPoint.y);
        
        
        CGPoint translation = [recognizer translationInView:self];
        
        // [
        // Way 1: 利用API接口设置矩阵。
        // 官方注释：Translate `t' by `(tx, ty)' and return the result:
        // t' = [ 1 0 0 1 tx ty ] * t
        //self.transform = CGAffineTransformTranslate(self.transform, translation.x, translation.y);
        // ]
        
        // [
        // Way 2: 直接设置矩阵。API CGAffineTransformTranslate() 的做法。
        CGAffineTransform t = CGAffineTransformMake(1, 0, 0, 1, translation.x, translation.y);
        self.transform = CGAffineTransformConcat(t, self.transform); // 注意这里两个矩阵的顺序不能颠倒。
        // ]
        
        [recognizer setTranslation:CGPointZero inView:self]; // 移动的时候，注意在最后重设当前的 translation。
        
    }
    
    [self printFrameOfView:self];
    [self printFrameOfView:self.contentArea];
}

- (void)rotate:(UIRotationGestureRecognizer *)recognizer {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    
    CGFloat rotation = recognizer.rotation;
    NSLog(@"Rotation: %f", rotation);
    
    // Rotate the subview who holds the recognizer.
    //recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
    
    // Rotate the whole view.
    // [
    // Way 1: 利用API接口设置矩阵。
    // 官方注释：Rotate `t' by `angle' radians and return the result:
    // t' =  [ cos(angle) sin(angle) -sin(angle) cos(angle) 0 0 ] * t
    //self.transform = CGAffineTransformRotate(self.transform, rotation);
    //]
    
    // [
    // Way 2: 直接设置矩阵。API CGAffineTransformRotate() 的做法。
    CGAffineTransform t = CGAffineTransformMake(cos(rotation), sin(rotation), -sin(rotation), cos(rotation), 0, 0);
    self.transform = CGAffineTransformConcat(t, self.transform); // 注意这里两个矩阵的顺序不能颠倒。
    // ]
    
    recognizer.rotation = 0;
    
    [self printFrameOfView:self];
    [self printFrameOfView:self.contentArea];
    
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    
    CGFloat scale = recognizer.scale;
    NSLog(@"Scale: %f", scale);
    
    // Pinch the subview who holds the recognizer.
    //recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    // Pinch the whole view.
    // [
    // Way 1: 利用API接口设置矩阵。
    // 官方注释：Scale `t' by `(sx, sy)' and return the result:
    // t' = [ sx 0 0 sy 0 0 ] * t
    //self.transform = CGAffineTransformScale(self.transform, scale, scale);
    // ]
    
    // [
    // Way 2: 直接设置矩阵。API CGAffineTransformScale() 的做法。
    CGAffineTransform t = CGAffineTransformMake(scale, 0, 0, scale, 0, 0);
    self.transform = CGAffineTransformConcat(t, self.transform); // 注意这里两个矩阵的顺序不能颠倒。
    // ]
    
    recognizer.scale = 1;
    
    
    [self printFrameOfView:self];
    [self printFrameOfView:self.contentArea];
}

#pragma mark - Action In Drag Area
- (void)panDragArea:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"Pan Drag Area");
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }

    // 在 self.superView 坐标系手势移动的向量。
    CGPoint translation = [recognizer translationInView:self.superview];
    
    static CGPoint beganCenter;
    static CGFloat beganDistance = 0;
    static CGFloat beganAngle = 0;
    static CGFloat accumulativeAngle = 0;
    static CGFloat accumulativeScale = 0;
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // center 表示的是当前 view 的中心在其 super view 坐标系中的位置。
        // 将 dragArea 的 center 坐标转换到 self.superView 所在的坐标系，以便后面统一在 self.superView 的坐标系拿 self.center 和转换后的 dragArea.center 来做向量计算。
        beganCenter = [self.superview convertPoint:self.dragArea.center fromView:self.dragArea.superview];

        // 在 self.superView 的坐标系中做向量计算。
        CGPoint beganVector = CGPointMake(beganCenter.x - self.center.x, beganCenter.y - self.center.y);
        beganDistance = sqrt(beganVector.x * beganVector.x + beganVector.y * beganVector.y); // 初始时 beganVector 的长度。用于后面计算缩放比例。
        beganAngle = atan2(beganVector.y, beganVector.x); // 初始时 beganVector 与 x 轴的夹角。用于后面计算旋转角度。
        
        accumulativeAngle = self.dragRotateAngle; // 累计旋转角度。
        accumulativeScale = self.dragScale; // 累计缩放比例。
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint changingVector = CGPointMake(beganCenter.x + translation.x - self.center.x, beganCenter.y + translation.y - self.center.y);
        CGFloat changingDistance = sqrt(changingVector.x * changingVector.x + changingVector.y * changingVector.y);
        CGFloat changingAngle = atan2(changingVector.y, changingVector.x);
        
        // 计算出当前总的旋转角度。
        CGFloat newRotateAngle = accumulativeAngle + changingAngle - beganAngle;
        
        // 计算出当前总的缩放比例。
        CGFloat newScale = MAX(accumulativeScale * changingDistance / beganDistance, 0.2);
        
        // 计算本次旋转角度增量。
        CGFloat deltaRotateAngle = newRotateAngle - self.dragRotateAngle;
        self.transform = CGAffineTransformRotate(self.transform, deltaRotateAngle);
        self.dragRotateAngle = newRotateAngle;
        
        // 计算本次缩放比例增量。
        CGFloat deltaScale = newScale / self.dragScale;
        self.transform = CGAffineTransformScale(self.transform, deltaScale, deltaScale);
        self.dragScale = newScale;
        
    }
    
}

#pragma mark - Utility
- (void)printFrameOfView:(UIView *)v {
    NSLog(@"Frame:(%.2f, %.2f, %.2f, %.2f) Center:(%.2f, %.2f) Bounds:(%.2f, %.2f, %.2f, %.2f)", v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height, v.center.x, v.center.y, v.bounds.origin.x, v.bounds.origin.y, v.bounds.size.width, v.bounds.size.height);
}


@end
