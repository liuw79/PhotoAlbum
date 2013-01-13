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
    UIImage *image = [UIImage imageNamed:@"image002.jpg"];
    self.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    //hello
    self.panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction1:)] autorelease];
    self.pinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)] autorelease];
    self.tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)] autorelease];
    self.rotationGestureRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panAction1:(UIGestureRecognizer *)gesture
{
    
}

- (void)pinchAction:(UIGestureRecognizer *)gesture
{
    
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    
}

- (void)rotationAction:(UIGestureRecognizer *)gesture
{
    
}

@end
