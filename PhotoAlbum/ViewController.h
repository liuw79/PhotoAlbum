//
//  ViewController.h
//  PhotoAlbum
//
//  Created by liuwei on 13-1-13.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGestureRecognizer;

@end
