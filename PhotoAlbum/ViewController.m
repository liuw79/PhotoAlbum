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

@property (nonatomic, strong) PhotoScrollerViewController *bigPhotoScrollerViewController;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIScrollView *smallPhotoScrollView;
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UIPanGestureRecognizer *panGesture;
@property (nonatomic,retain)UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,retain)UITapGestureRecognizer *tapGesture;
@property (nonatomic,retain)UIRotationGestureRecognizer *rotateGesture;
@property (nonatomic,readwrite)CGPoint lastPosition;
@property (nonatomic,readwrite)CGFloat lastScale;
@property (nonatomic,readwrite)CGFloat preScale;
@property (nonatomic,readwrite)CGFloat deltaScale;
@property (nonatomic,readwrite)CGFloat lastRotation;
@property (nonatomic,retain)PhotoScrollerViewController *photoViewController;

- (void)presentPhotoView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.bigPhotoScrollerViewController.view setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
    
    NSLog(@"vc scr frame %@", NSStringFromCGRect(self.bigPhotoScrollerViewController.view.frame));
    
    NSArray *array = [ImageList GetImageList];
    
    for (int i = 1; i <= array.count; ++ i)
    {
        MyImageView *singleImageView = [[MyImageView alloc] initWithImageName:[array objectAtIndex:i - 1]
                                                                   ofType:@"jpg" andFrame:[ImageFrame FrameWithOrdernumber:i]];
        
        [singleImageView setUserInteractionEnabled:YES];
        [singleImageView.layer setBorderWidth:5.0f];
        [singleImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self addGestureRecognizersWithView:singleImageView];
        
        [self.smallPhotoScrollView insertSubview:singleImageView atIndex:0];
        CGFloat scrHeight = Y_OFF_SET + ceil((float)array.count/PAGE_COL)  *  ySpacing;
        [self.smallPhotoScrollView setContentSize:CGSizeMake(LANDSCAPE_WIDTH, scrHeight)];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
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
    NSLog(@"tapGestureUpdated");
    
    [self.view bringSubviewToFront:tapGesture.view];
    
    NSLog(@"tapGesture view:%@", NSStringFromCGRect(tapGesture.view.frame));
    
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
    NSLog(@"rotateGestureUpdated");
    
    [self.view bringSubviewToFront:rotateGesture.view];
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

    [self.view bringSubviewToFront:panGesture.view];
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
    NSLog(@"pinch GestureUpdated");
    [self.view bringSubviewToFront:pinchGesture.view];
    NSLog(@"pinch view:%@", self.view);
    
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
                
                [view setHidden:YES];
                
                [self presentPhotoView];
                
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

- (void)presentPhotoView
{
    NSLog(@"The imageView center is %@", NSStringFromCGPoint(self.imageView.center));
    //[self.bigPhotoScrollerViewController setSelectedCellOriginalPos:self.imageView.center];
    
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
        
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             //***************添加结束动画********************//
                             [UIView animateWithDuration:kDefaultAnimationDuration
                                                   delay:0
                                                 options:kDefaultAnimationOptions
                                              animations:^{
                                                  
                                                  [self presentPhotoView];
                                                  
                                              }
                                              completion:nil
                              ];
                             
                         }
                         completion:nil
         
         ];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIScrollView *smallPhotoScrollView = [[UIScrollView alloc]
                                          initWithFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
    self.smallPhotoScrollView = smallPhotoScrollView;
    [self.view addSubview:self.smallPhotoScrollView];
    
    self.bigPhotoScrollerViewController = [[PhotoScrollerViewController alloc] init];
    [self.bigPhotoScrollerViewController.view
     setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
