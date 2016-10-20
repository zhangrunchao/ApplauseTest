# ApplauseTest


仿直播间点赞
通过bezier曲线 及 帧动画

//弹出动画
   [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        applauseView.transform = CGAffineTransformIdentity;
        applauseView.alpha     = .9;
    } completion:NULL];
    
    //偏转
    NSInteger rotate = arc4random_uniform(2);
    NSInteger direction = 1-(2*rotate);     //1 -1  方向
    NSInteger fraction  = arc4random_uniform(10);   //随机角度
    
    //上升旋转
    [UIView animateWithDuration:4 animations:^{
        applauseView.transform = CGAffineTransformMakeRotation(direction * M_PI / (4+fraction *.25));
        
    }];
    
    //动画路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:applauseView.center];
    
    //随机终点
    CGFloat centerX = applauseView.center.x;
    CGFloat centerY = applauseView.center.y;
    CGPoint endPoint = CGPointMake(centerX + direction *8, centerY  - animHeight);
    
    //随机控制点
    NSInteger j = arc4random_uniform(2);
    NSInteger c1x = centerX + direction * (arc4random_uniform(15) + 40);
    NSInteger c1y = centerY - 60 + direction *(arc4random_uniform(15));
    NSInteger c2x = centerX - direction * (arc4random_uniform(15) + 40);
    NSInteger c2y = centerY - 100 + direction *(arc4random_uniform(15));
    
    [path addCurveToPoint:endPoint controlPoint1:CGPointMake(c1x, c1y) controlPoint2:CGPointMake(c2x, c2y)];
    
    //关键帧动画
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnim.path = [path CGPath];
    keyAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyAnim.duration = 3;
    [applauseView.layer addAnimation:keyAnim forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseView.alpha = 0;
    
    } completion:^(BOOL finished){
        [applauseView removeFromSuperview];
    }];
