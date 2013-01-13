//
//  ViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-13.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.image = [UIImage imageNamed:@"image002.jpg"];
    self.imageView = [[[UIImageView alloc] initWithImage:self.image] autorelease];
    [self.imageView setFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    [self.view addSubview:self.imageView];
    
    self.panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)] autorelease];
    
    self.pinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)] autorelease];
    
    self.tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)] autorelease];
    [self.tapGestureRecognizer setNumberOfTapsRequired:2];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    
    self.rotationGestureRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)] autorelease];
    
    [self.imageView addGestureRecognizer:self.panGestureRecognizer];
    [self.imageView addGestureRecognizer:self.pinchGestureRecognizer];
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
    [self.imageView addGestureRecognizer:self.rotationGestureRecognizer];
    [self.imageView setUserInteractionEnabled:YES];
    
    NSLog(@"%@", self.imageView);  //TEST
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:self.view];

    gesture.view.center = CGPointMake(translate.x + gesture.view.center.x, translate.y + gesture.view.center.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
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
    
    if (factor < 1)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             gesture.view.transform = CGAffineTransformScale(gesture.view.transform, 1/factor, 1/factor);
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
                         if (self.imageView.frame.size.width < self.image.size.width*2)
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
