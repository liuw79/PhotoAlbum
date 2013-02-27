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
#import "ThumbnailPickerView.h"

@protocol PhotoViewDelegate;

@interface PhotoScrollerViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *images;
@property CGPoint selectedCellOriginalPos;
@property(nonatomic,assign)id<PhotoViewDelegate>photoDelegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property(nonatomic,retain)UIToolbar *toolBar;
@property (strong, nonatomic) ThumbnailPickerView *thumbnailPickerView;
@property(nonatomic,readwrite)int currentPageNum;
@property(nonatomic,readwrite)BOOL orientationIsPortrait;

- (void)tilePages;
- (void)renewContentsViewSize:(UIInterfaceOrientation)toOrientation;

@end

@protocol PhotoViewDelegate <NSObject>
- (void)photoViewDisappear:(BOOL)value;
- (void)animateImageViewBackToNormal:(int)currentPageNum WithPosition:(CGPoint)point;
- (void)moveImageView:(UIImageView *)imageView ToPosition:(CGPoint)point;
- (void)photoHiddenSwitch:(int)newIndex;

@end

