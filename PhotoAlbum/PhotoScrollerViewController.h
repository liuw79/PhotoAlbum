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

@protocol PhotoViewDelegate;

@interface PhotoScrollerViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property CGPoint selectedCellOriginalPos;
@property(nonatomic,assign)id<PhotoViewDelegate>photoDelegate;
@property (strong, nonatomic) UIScrollView *scrollView;

- (void)tilePages;

@end

@protocol PhotoViewDelegate <NSObject>
- (void)photoViewDisappear:(BOOL)value;
- (void)animateImageViewBackToNormal:(UIImageView *)imageView WithPosition:(CGPoint)point;
- (void)moveImageView:(UIImageView *)imageView ToPosition:(CGPoint)point;

@end

