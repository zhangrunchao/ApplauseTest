//
//  ViewController.m
//  ApplauseDemo
//
//  Created by 张润潮 on 2016/10/19.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "RCViewController.h"

@interface RCViewController ()
@property(nonatomic,strong) UIButton    *applauseBut;
@property(nonatomic,strong) UILabel     *applauseLabel;
@property(nonatomic       ) NSInteger   applauseCount;
@end

@implementation RCViewController

-(id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.applauseBut = [[UIButton alloc] initWithFrame:CGRectMake( 20 , self.view.frame.size.height - 20 - 60, 60, 60)];
        self.applauseBut.contentMode = UIViewContentModeScaleToFill;
        [self.applauseBut setImage:[UIImage imageNamed:@"applause"] forState:UIControlStateNormal];
        [self.applauseBut setImage:[UIImage imageNamed:@"applause"] forState:UIControlStateHighlighted];
        [self.applauseBut addTarget:self action:@selector(applauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.applauseBut];
        //鼓掌数
        self.applauseLabel = [[UILabel alloc]init];
        self.applauseLabel.textColor = [UIColor blackColor];
        self.applauseLabel.font = [UIFont systemFontOfSize:12];
        self.applauseLabel.text = @"0";
        [self.view addSubview:self.applauseLabel];
        self.applauseLabel.textAlignment = NSTextAlignmentCenter;
        self.applauseLabel.frame = CGRectMake(self.applauseBut.frame.origin.x  , self.applauseBut.frame.size.height+self.applauseBut.frame.origin.y , self.applauseBut.frame.size.width, 12);
    }
    return self;
}
- (void)applauseBtnClick {
    self.applauseCount++;
    self.applauseLabel.text = [NSString stringWithFormat:@"%zd",self.applauseCount];
    [self showApplauseIn:self.view below:self.applauseBut];
}

- (void)showApplauseIn:(UIView *)view below:(UIButton *)v{

    NSInteger index             = arc4random_uniform(7); //取随机图片
    NSString *image             = [NSString stringWithFormat:@"applause_%zd",index];
    UIImageView *applauseView   = [[UIImageView alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height - 150, 40, 40)];//增大y值可隐藏弹出动画
    [view insertSubview:applauseView belowSubview:v];
    applauseView.image          = [UIImage imageNamed:image];
    
    //动画高度
    CGFloat animHeight          = 300;
    applauseView.transform      = CGAffineTransformMakeScale(0, 0);
    applauseView.alpha          = 0;

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
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
