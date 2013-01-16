//
//  ViewController.h
//  PhotoAlbum
//
//  Created by liuwei on 13-1-13.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageList.h"
#import "MyImageView.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;



@end
