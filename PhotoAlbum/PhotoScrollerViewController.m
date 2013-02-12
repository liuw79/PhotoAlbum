//
//  PhotoScrollerViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-20.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "PhotoScrollerViewController.h"
#import "ThumbnailPickerView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kDefaultAnimationDuration = 0.3;
static const UIViewAnimationOptions kDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

@interface PhotoScrollerViewController ()

@property (strong, nonatomic) NSArray *photoArray;
@property (strong, nonatomic) NSNumber *currentImage;
@property (strong, nonatomic) MyImageView *testImageView;

@property (strong, nonatomic) NSMutableSet *recycledPages;
@property (strong, nonatomic) NSMutableSet *visiblePages;

@property (nonatomic,assign)MyImageView *imageView;
@property(nonatomic,readwrite)CGFloat lastScale;
@property(nonatomic,readwrite)CGFloat preScale;
@property(nonatomic,readwrite)CGFloat deltaScale;
@property(nonatomic,readwrite)CGFloat lastRotation;
@property(nonatomic,readwrite)CGPoint lastPosition;
@property(nonatomic,retain)ThumbnailPickerView *pickerView;
@property(nonatomic,retain)UIToolbar *toolBar;

@end

@implementation PhotoScrollerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //获取所有图片数据
        self.photoArray = [ImageList GetImageList];
        
        //建立图片ScrollView
        CGRect photoScrFrame = CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT);
        UIScrollView *photoScr = [[UIScrollView alloc] initWithFrame:photoScrFrame];
        [photoScr setPagingEnabled:YES];
        [photoScr setDirectionalLockEnabled:YES];
        [photoScr setAlwaysBounceHorizontal:YES];
        [photoScr setShowsHorizontalScrollIndicator:NO];
        [photoScr setShowsVerticalScrollIndicator:NO];
        [photoScr setContentSize: CGSizeMake(photoScrFrame.size.width * self.photoArray.count, photoScrFrame.size.height)];
        [photoScr setDelegate:self];
        self.scrollView = photoScr;
        [self.view addSubview:self.scrollView];     //TEST
        NSLog(@"PhotoScrollerViewController  init scrollView:%@", self.scrollView);   //TEST
        photoScr = nil;
    }
    return self;
}

- (void)configurePage:(MyImageView *)imageView forIndex:(int)index
{
    imageView.tag = index;
    [imageView setImageWithName:[self.photoArray objectAtIndex:index] ofType:@"jpg"
                      andFrame:[self frameForPageAtIndex:index]];
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = self.view.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width = bounds.size.width + 10;
    pageFrame.origin.x = bounds.size.width * index;
    //    NSLog(@"photoScr bounds: %@", NSStringFromCGRect(bounds));
    //    NSLog(@"pageFrame: %@", NSStringFromCGRect(pageFrame));
    
    return pageFrame;
}

- (void)loadView
{
    self.view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    //[self.view setBackgroundColor:[UIColor blueColor]];
    NSLog(@"PhotoScrollerViewController frame:%@  (LoadView)", NSStringFromCGRect(self.view.frame));

    //初始化复用相关SET
    self.recycledPages = [[NSMutableSet alloc] init];
    self.visiblePages = [[NSMutableSet alloc] init];
    
    //根据需要创建图片对象
    [self tilePages];
    
    //缩略图ToolBar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 728, 1024, 40)];          //TEST
    self.pickerView = [[ThumbnailPickerView alloc] init];
    [self.toolBar addSubview:self.pickerView];
    [self.view addSubview:self.toolBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self.scrollView scrollRectToVisible:CGRectMake(1024*3, 0, 1024, <#CGFloat height#>) animated:<#(BOOL)#>]
}

- (void)tilePages
{
    //计算哪页是当前显示页面
    CGRect visibleBounds = self.scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1)/CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, [self.photoArray count] - 1);
    
    //重用当前显示页面
    for (MyImageView *imageView in self.visiblePages)
    {
        if (imageView.tag < firstNeededPageIndex || imageView.tag > lastNeededPageIndex)
        {
            [self.recycledPages addObject:imageView];
            [imageView removeFromSuperview];
        }
    }
    
    [self.visiblePages minusSet:self.recycledPages];
    
    //添加未显示页面
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index ++)
    {
        if (![self isDisplayingPageForIndex:index])
        {
            MyImageView *imageView = [self dequeueRecyclePage];
            if (nil == imageView) {
                imageView = [[MyImageView alloc] initWithFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
                [imageView setAutoresizingMask: UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                
                [self addGestureRecognizersWithView:imageView];
            }
            
            [self configurePage:imageView forIndex:index];
            [self.scrollView addSubview:imageView];
            [self.visiblePages addObject:imageView];
        }
    }
}

/*
 返回重用的UIImageView
 */
-(MyImageView *)dequeueRecyclePage
{
    MyImageView *imageView = [self.recycledPages anyObject];
    
    if (imageView)
    {
        [self.recycledPages removeObject:imageView];
    }
    
    return imageView;
}

/*
 判断是否为当前显示页
 参数判断页数
 return 返回判断布尔值
 */
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    
    for (MyImageView *imageView in self.visiblePages) {
        if (imageView.tag == index)
        {
            foundPage = YES;
            break;
        }
    }
    
    return foundPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
    
}

//首次加载完成执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    [self setCurrentImageview];  
    
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setCurrentImageview];
    
    CGRect visibleBounds = self.scrollView.bounds;
    int pageIndex = roundf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    [self.photoDelegate photoHiddenSwitch:pageIndex];
}

- (void)setCurrentImageview
{
    //计算哪页是当前显示页面
    CGRect visibleBounds = self.scrollView.bounds;
    
    NSLog(@"CGRectGetMinX(visibleBounds):%f", CGRectGetMinX(visibleBounds));
    NSLog(@"CGRectGetWidth(visibleBounds):%f", CGRectGetWidth(visibleBounds));
    NSLog(@"CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds):%f", CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    
    int pageIndex = roundf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    
    for (MyImageView *imageView in self.visiblePages)
    {
        if (imageView.tag == pageIndex)
        {
            self.imageView = imageView;
        }
    }
}

- (void)addGestureRecognizersWithView:(UIView *)view
{
    //*************添加UIRotateGestreRecognizer*******************//
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateGestureUpdated:)];
    rotateGesture.delegate = self;
    [view addGestureRecognizer:rotateGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureUpdated:)];
    pinchGesture.delegate = self;
    [view addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureUpdated:)];
    panGesture.delegate = self;
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setMinimumNumberOfTouches:2];
    [view addGestureRecognizer:panGesture];
}

#pragma mark - ======================UIGestureRecognizerDelegate====================
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


- (void)rotateGestureUpdated: (UIRotationGestureRecognizer *)rotateGesture
{
    switch (rotateGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:rotateGesture afterDelay:0.2];
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            self.lastRotation = rotateGesture.rotation;
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            self.lastRotation = rotateGesture.rotation;
            
            UIView *view = rotateGesture.view;
            CGAffineTransform transform = view.transform;
            transform = CGAffineTransformRotate(transform, self.lastRotation);
            view.transform = transform;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)pinchGestureUpdated:(UIPinchGestureRecognizer *)pinchGesture
{
    
    UIView *view = pinchGesture.view;
    
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            const CGFloat kMaxScale = 3;
            const CGFloat kMinScale = 0.5;
            
            //*********************设置scrollView的边界颜色*************************//
            [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:0].CGColor];
            
            if ([pinchGesture scale] >= kMinScale && [pinchGesture scale] <= kMaxScale)
            {
                
                [self performSelector:@selector(transformingGestureDidFinishWithGesture:) withObject:pinchGesture afterDelay:0.2];
                
                //***********************设置布尔值，判断PhotoView是否消失*************//
                //多余？
//                if ([self.photoDelegate respondsToSelector:@selector(PhotoViewDisappear:)]) {
//                    [self.photoDelegate photoViewDisappear:NO];
//                }
                
            }else {
                
                //恢复toolBar的alpha值
                self.toolBar.alpha = 1;
                
                //***************移除PhotoView******************//
                
                [self.view removeFromSuperview];
                
                //***********设置复位动画延时********************//
                [UIView animateWithDuration:kDefaultAnimationDuration
                                      delay:0
                                    options:kDefaultAnimationOptions
                                 animations:^{
                                     
                                     NSLog(@"The selectedCellOriginalPos is %@", NSStringFromCGPoint(self.selectedCellOriginalPos));
                                     
                                     //***********************Pinch手势结束时，将选中的Cell图片使用动画复位***************************//
                                     if ([self.photoDelegate respondsToSelector:@selector(animateImageViewBackToNormal:WithPosition:)]) {
                                         
                                         [self.photoDelegate animateImageViewBackToNormal:self.imageView WithPosition:self.selectedCellOriginalPos];
                                     }
                                     
                                 }
                 
                                 completion:nil
                 
                 ];
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            
            //*********************设置scrollView的边界宽度和颜色*************************//
            [view.layer setBorderWidth:15.0f];
            [view.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:0].CGColor];
            
            
            //*********更新当前缩放数值*************//
            self.lastScale = pinchGesture.scale;
            self.preScale = pinchGesture.scale;
            
            //***********************设置布尔值，判断PhotoView是否消失*************//
            if ([self.photoDelegate respondsToSelector:@selector(PhotoViewDisappear:)]) {
                [self.photoDelegate photoViewDisappear:YES];
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            //***********************Pinch手势进行时，根据当前拖动位置，更新选中的Cell图片的位置***************************//
            if ([self.photoDelegate respondsToSelector:@selector(moveImageView:ToPosition:)]) {
                
                [self.photoDelegate moveImageView:self.imageView ToPosition:self.scrollView.center];
                
            }
            
            self.lastScale = [pinchGesture scale];
            
            //**************取差值的绝对值*********************//
            self.deltaScale = fabs(self.lastScale - self.preScale);
            
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
            
            //***************处理scrollView的缩放和旋转动画****************//
            view.transform = CGAffineTransformMakeScale(self.lastScale, self.lastScale);
            
            CGAffineTransform transform = view.transform;
            transform = CGAffineTransformRotate(transform, self.lastRotation);
            view.transform = transform;
            
            self.toolBar.alpha = self.lastScale;
            
            break;
            
        }
        default:
            break;
    }
    
}

- (void)panGestureUpdated:(UIPanGestureRecognizer *)panGesture
{
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
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            UIView *panView = [panGesture view];
            CGPoint translation = [panGesture translationInView:[panView superview]];
            
            [panView setCenter:CGPointMake([panView center].x + translation.x, [panView center].y + translation.y)];
            [panGesture setTranslation:CGPointZero inView:[panView superview]];
            
            break;
            
        }
        default:
            break;
    }
    
}

- (void)transformingGestureDidFinishWithGesture:(UIGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    
    if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        
        //*********************添加结束动画，重置旋转值********************//
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             view.transform = CGAffineTransformMakeRotation(0);
                             
                         }
                         completion:nil
         ];
        
    }else if([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        
        
        //*********************添加结束动画，重置放大值********************//
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             view.transform = CGAffineTransformMakeScale(1, 1);
                             
                             //恢复toolBar的alpha值
                             self.toolBar.alpha = 1;
                         }
                         completion:nil
         ];
        
    }else if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        //*********************添加结束动画，重置ScrollView的中心坐标值********************//
        
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:kDefaultAnimationOptions
                         animations:^{
                             
                             view.center = CGPointMake(self.lastPosition.x, self.lastPosition.y);
                             
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
