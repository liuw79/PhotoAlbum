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
#import "ListUnit.h"
#import "ValueDefine.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;



@end
