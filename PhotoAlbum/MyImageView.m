//
//  MyImageView.m
//  CarMag
//
//  Created by LIU WEI on 12-12-22.
//  Copyright (c) 2012年 LIU WEI. All rights reserved.

#import "MyImageView.h"

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setUpProperties:frame];
    }
    
    return self;
}

- (id)initWithImageName:(NSString*)imageName ofType:(NSString*)imageType andBounds:(CGRect)bounds
{
    self = [super init];
    
    if (self)
    {
        [self setImageWithName:imageName ofType:imageType andBounds:(CGRect)bounds];
        self.userInteractionEnabled = YES;
        [self setUpProperties:bounds];
        [self setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return self;
}

- (id)initWithImagePath:(NSString *)imagePath andBounds:(CGRect)bounds
{
    self = [super init];
    
    if (self) {
        [self setImageWithPath:imagePath andBounds:(CGRect)bounds];
        self.userInteractionEnabled = YES;
        [self setUpProperties:bounds];
    }
    
    return self;
}

-(void)setImageWithName:(NSString *)imageName ofType:(NSString *)imageType andBounds:(CGRect)bounds
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    [self setFrame:bounds];
}

-(void)setImageWithPath:(NSString *)imagePath andBounds:(CGRect)bounds
{
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    [self setFrame:bounds];
}

- (NSString *)description
{
    NSString *des = [[NSString
                     alloc] initWithFormat:@"Image Name:%@; Image Frame:%@",
                     self.image,
                     NSStringFromCGRect(self.frame)];
    return des;
}

- (void)setUpProperties:(CGRect)frame
{
    [self setFrame:frame];
    
    //self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    
    //self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tapGestureRecognizer setNumberOfTapsRequired:2];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    
    self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    
    //[self addGestureRecognizer:self.panGestureRecognizer];
    [self addGestureRecognizer:self.pinchGestureRecognizer];
    //[self addGestureRecognizer:self.tapGestureRecognizer];
    [self addGestureRecognizer:self.rotationGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:self];
    
    gesture.view.center = CGPointMake(translate.x + gesture.view.center.x, translate.y + gesture.view.center.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)gesture
{
    CGFloat factor = [gesture scale];
    gesture.view.transform = CGAffineTransformMakeScale(factor, factor);
    
    //不允许大于4倍,小于原大
    if (factor > 4)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             gesture.view.transform = CGAffineTransformScale(gesture.view.transform, 4/factor, 4/factor);
                         }
                         completion:nil];
    }
    
    if (factor < 0.2)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             gesture.view.transform = CGAffineTransformScale(gesture.view.transform, 0.2/factor, 0.2/factor);
                         }
                         completion:nil];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         if (self.frame.size.width < self.image.size.width*2)
                         {
                             gesture.view.transform = CGAffineTransformScale(gesture.view.transform, 2, 2);
                         }
                         else
                         {
                             gesture.view.transform = CGAffineTransformScale(gesture.view.transform, 0.5, 0.5);
                         }
                     }
                     completion:nil];
}

- (void)rotationAction:(UIRotationGestureRecognizer *)gesture
{
    CGFloat rot = [gesture rotation];
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, rot);
    gesture.rotation = 0;
}

@end
