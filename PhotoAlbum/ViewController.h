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
#import "ValueDefine.h"
#import "PhotoScrollerViewController.h"
#import "testViewController.h"
#import "ImageFrame.h"
#import "ValueDefine.h"


@interface ViewController : UIViewController<UIGestureRecognizerDelegate, PhotoViewDelegate>

@property (nonatomic,readwrite)BOOL orientationIsPortrait;

@end

