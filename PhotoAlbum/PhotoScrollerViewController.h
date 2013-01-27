//
//  PhotoScrollerViewController.h
//  PhotoAlbum
//
//  Created by liuwei on 13-1-20.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValueDefine.h"
#import "ImageList.h"
#import "MyImageView.h"

@interface PhotoScrollerViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *photoArray;

@property (strong, nonatomic) MyImageView *testImageView;

@end
