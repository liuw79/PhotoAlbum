//
//  ViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-13.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kDefaultAnimationDuration = 0.3;
static const UIViewAnimationOptions kDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

@interface ViewController ()

@property (nonatomic, readwrite) int currentHiddenIndex;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) PhotoScrollerViewController *bigPhotoScrollerViewController;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIScrollView *smallPhotoScrollView;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIPanGestureRecognizer *panGesture;
@property (nonatomic,retain) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic,retain) UIRotationGestureRecognizer *rotateGesture;
@property (nonatomic,readwrite) CGPoint lastPosition;
@property (nonatomic,readwrite) CGFloat lastScale;
@property (nonatomic,readwrite) CGFloat preScale;
@property (nonatomic,readwrite) CGFloat deltaScale;
@property (nonatomic,readwrite) CGFloat lastRotation;
@property (nonatomic,retain) PhotoScrollerViewController *photoViewController;

- (void)presentPhotoView;

@end

@implementation ViewController

- (void)animateImageViewBackToNormal:(UIImageView *)imageView WithPosition:(CGPoint)point
{
    UIView *view = [self.smallPhotoScrollView viewWithTag:imageView.tag];
    [view setHidden:NO];

}

//大图切换，改变当前隐藏的小图
- (void)photoHiddenSwitch:(int)newIndex
{
    UIView *view = [self.smallPhotoScrollView viewWithTag:self.currentHiddenIndex];
    [view setHidden:NO];
    
    UIView *nextView = [self.smallPhotoScrollView viewWithTag:newIndex];
    [nextView setHidden:YES];
    
    self.currentHiddenIndex = newIndex;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photo Album";
    
    [self.view setFrame:[self getStartFrame]];
    self.photoArray = [ImageList GetImageList];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.smallPhotoScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.smallPhotoScrollView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.smallPhotoScrollView];
    
    self.bigPhotoScrollerViewController = [[PhotoScrollerViewController alloc] init];
    [self.bigPhotoScrollerViewController setPhotoDelegate:self];
    [self.bigPhotoScrollerViewController.scrollView
     setContentSize:CGSizeMake(self.view.frame.size.width * self.photoArray.count,
                               self.view.frame.size.height)];
    
    for (int i = 0; i <= self.photoArray.count - 1; ++ i)
    {
        MyImageView *cellImageView
        = [[MyImageView alloc] initWithImageName:[self.photoArray objectAtIndex:i]
                                          ofType:@"jpg" andFrame:[ImageFrame FrameWithOrdernumberPortrait:i]];
        
        [cellImageView setTag:i];
        [cellImageView setUserInteractionEnabled:YES];
        [cellImageView.layer setBorderWidth:5.0f];
        [cellImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self addGestureRecognizersWithView:cellImageView];
            
        [self.smallPhotoScrollView addSubview:cellImageView];
    }
    
    [self RenewSmallPhotoViewFrame:[UIApplication sharedApplication].statusBarOrientation];
    [self RenewSmallPhotoScrollViewContentsize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"view frame:%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"scr frame:%@", NSStringFromCGRect(self.smallPhotoScrollView.frame));
}

//获取初始frame
- (CGRect)getStartFrame
{
    CGRect frame;
    
    if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) )
    {
        frame = CGRectMake(0, 0, kPORTRAIT_WIDTH, kPORTRAIT_HEIGHT);
    }
    else
    {
        frame = CGRectMake(0, 0, kLANDSCAPE_WIDTH, kLANDSCAPE_HEIGHT);
    }
    
    return frame;
}

//准备旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self RenewSmallPhotoViewFrame:toInterfaceOrientation];
}

//旋转完毕
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.smallPhotoScrollView setFrame:self.view.frame];
    
    [self RenewSmallPhotoScrollViewContentsize];
}

//更新contentsize
- (void)RenewSmallPhotoScrollViewContentsize
{
    CGFloat scrHeight;
    if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) )
    {
        scrHeight = Y_OFF_SET_PORTRAIT + ceil((float)self.photoArray.count/PAGE_COL_PORTRAIT)  *  ySpacing_PORTRAIT;
    }
    else
    {
        scrHeight = Y_OFF_SET_LANDSCAPE + ceil((float)self.photoArray.count/PAGE_COL_LANDSCAPE) * ySpacing_LANDSCAPE;
    }
    
    [self.smallPhotoScrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrHeight)];
}

//更新ScrollView和里面每个小图的frame
- (void)RenewSmallPhotoViewFrame:(UIInterfaceOrientation)toInterfaceOrientation
{
    for (int i = 1; i <= self.photoArray.count; ++ i) {
        UIView *view = [self.view viewWithTag:i];
        
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        {
            [view setFrame:[ImageFrame FrameWithOrdernumberPortrait:i]];
        }
        else
        {
            [view setFrame:[ImageFrame FrameWithOrdernumberLandscape:i]];
        }
    }
}

//更新ScrollView的Frame
- (void)RenewSmallPhotoScrollViewFrame
{
    UIInterfaceOrientation InterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation))
    {
        //[self.smallPhotoScrollView setFrame:CGRectMake(0, 0, 768, 1004)];
        [self.smallPhotoScrollView setFrame:CGRectMake(0, 0, kPORTRAIT_WIDTH, kPORTRAIT_HEIGHT)];
    }
    else
    {
        //[self.smallPhotoScrollView setFrame:CGRectMake(0, 0, 1024, 748)];
        [self.smallPhotoScrollView setFrame:CGRectMake(0, 0, kLANDSCAPE_WIDTH, kLANDSCAPE_HEIGHT)];
    }
}

//**********************添加拖动，捏合和点击的手势识别*****************//
- (void)addGestureRecognizersWithView:(UIView *)view
{
    
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureUpdated:)];
    self.panGesture.delegate = self;
    [self.panGesture setCancelsTouchesInView:YES];
    [self.panGesture setMaximumNumberOfTouches:2];
    [self.panGesture setMinimumNumberOfTouches:2];
    [view addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureUpdated:)];
    self.pinchGesture.delegate = self;
    [self.pinchGesture setCancelsTouchesInView:YES];
    [view addGestureRecognizer:self.pinchGesture];
    
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureUpdated:)];
    self.tapGesture.delegate = self;
    [self.tapGesture setCancelsTouchesInView:YES];
    [self.tapGesture setNumberOfTapsRequired:2];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:self.tapGesture];
    
    
    self.rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateGestureUpdated:)];
    self.rotateGesture.delegate = self;
    [view addGestureRecognizer:self.rotateGesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)tapGestureUpdated:(UITapGestureRecognizer *)tapGesture
{
    
    [self.smallPhotoScrollView bringSubviewToFront:tapGesture.view];
    
    switch (tapGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            //****************延迟0.2秒执行transformingGestureDidFinishWithGesture函数***************//
            [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:tapGesture afterDelay:0.2];
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)rotateGestureUpdated: (UIRotationGestureRecognizer *)rotateGesture
{
    
    [self.smallPhotoScrollView bringSubviewToFront:rotateGesture.view];
    
    UIView *view = rotateGesture.view;
    switch (rotateGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            //****************延迟0.2秒执行transformingGestureDidFinishWithGesture函数***************//
            [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:rotateGesture afterDelay:0.2];
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            
            //*********禁止滚动操作********//
            self.lastRotation = rotateGesture.rotation;
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            //设置UIImageView的旋转动画************//
            
            self.lastRotation = rotateGesture.rotation;
            CGAffineTransform transform = view.transform;
            transform = CGAffineTransformRotate(transform, self.lastRotation);
            view.transform = transform;
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)panGestureUpdated:(UIPanGestureRecognizer *)panGesture
{
    NSLog(@"pan GestureUpdated");

    [self.smallPhotoScrollView bringSubviewToFront:panGesture.view];
    UIView *view = panGesture.view;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:panGesture afterDelay:0.2];
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            self.lastPosition = CGPointMake(view.center.x,view.center.y);
            
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            CGPoint translate = [panGesture translationInView:self.view];
            [view setCenter:CGPointMake(view.center.x + translate.x, view.center.y + translate.y)];
            [panGesture setTranslation:CGPointZero inView:self.view];
            
            break;
        }
            
        default:
            break;
    }
    
}

-(void)pinchGestureUpdated:(UIPinchGestureRecognizer *)pinchGesture
{
    [self.smallPhotoScrollView bringSubviewToFront:pinchGesture.view];
    
    UIView *view = pinchGesture.view;
    
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            const CGFloat kMaxScale = 2;
            const CGFloat kMinScale = 0.5;
            
            if ([pinchGesture scale] >= kMinScale && [pinchGesture scale] <= kMaxScale)
            {
                
                [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:pinchGesture afterDelay:0.2];
                
            }else {
                
                [self presentPhotoView:view.tag];
                NSLog(@"pinch view tag:%d", view.tag);  //TEST
                
                view.transform = CGAffineTransformMakeScale(1, 1);
                [view.layer setBorderWidth:15.0f];
                [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            
            //*********更新lastScale和preScale的值*************//
            self.lastScale = pinchGesture.scale;
            self.preScale = pinchGesture.scale;
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            self.lastScale = pinchGesture.scale;
            
            //************进行缩小操作****************//
            if (self.preScale > self.lastScale) {
                
                //****************当进行缩小操作时，减少cell的白色边框的透明度*********//
                [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:1 - view.frame.size.width/1000].CGColor];
                
                //*********进行放大操作************//
            }else {
                
                //****************当进行放大操作时，增加cell的白色边框的透明度*********//
                [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:1 - view.frame.size.width/1000].CGColor];
                
            }
            
            self.preScale = [pinchGesture scale];
            
            //***************处理cell的缩放和旋转动画****************//
            view.transform = CGAffineTransformMakeScale(self.lastScale,self.lastScale);
            CGAffineTransform transform = view.transform;
            transform = CGAffineTransformRotate(transform, self.lastRotation);
            view.transform = transform;
            
            break;
            
        }
        default:
            break;
    }
    
}

- (void)presentPhotoView:(NSInteger)cellViewTag
{
    UIView *view = [self.smallPhotoScrollView viewWithTag:cellViewTag];
    [view setHidden:YES];
    self.currentHiddenIndex = view.tag;
    
    CGRect toFrame = CGRectMake(
                                 self.bigPhotoScrollerViewController.scrollView.frame.size.width*cellViewTag-1, 0,
                                 self.bigPhotoScrollerViewController.scrollView.frame.size.width,
                                 self.bigPhotoScrollerViewController.scrollView.frame.size.height);

    
    [self.bigPhotoScrollerViewController.scrollView scrollRectToVisible:toFrame animated:NO];
    [self.bigPhotoScrollerViewController renewContentsViewSize:[UIApplication sharedApplication].statusBarOrientation];
    [self.bigPhotoScrollerViewController.scrollView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [self.bigPhotoScrollerViewController.scrollView setTransform:CGAffineTransformRotate(self.bigPhotoScrollerViewController.scrollView.transform, 0.0)];
    [self.view addSubview:self.bigPhotoScrollerViewController.view];

}

- (void)transformingGestureDidFinishWithGesture:(UIGestureRecognizer *)recognizer
{
    if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        
        //***************添加结束动画********************//
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             UIView *view = recognizer.view;
                             view.transform = CGAffineTransformMakeRotation(0);
                         }
                         completion:nil
         ];
        
    }else if([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        
        //***************添加结束动画********************//
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             UIView *view = recognizer.view;
                             view.transform = CGAffineTransformMakeScale(1, 1);
                             [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
                             
                             
                         }
                         completion:nil
         ];
        
    }else if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        //***************添加结束动画********************//
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             UIView *view = recognizer.view;
                             view.center = CGPointMake(self.lastPosition.x, self.lastPosition.y);
                         }
                         completion:nil
         ];
        
    }else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        UIView *view = recognizer.view;
        
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             //***************添加结束动画********************//
                             [UIView animateWithDuration:kDefaultAnimationDuration
                                                   delay:0
                                                 options:kDefaultAnimationOptions
                                              animations:^{
                                                  
                                                  [self presentPhotoView:view.tag];
                                                  NSLog(@"tap view tag:%d", view.tag);  //TEST
                                              }
                                              completion:nil
                              ];
                             
                         }
                         completion:nil
         
         ];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
