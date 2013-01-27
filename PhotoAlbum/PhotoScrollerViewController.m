//
//  PhotoScrollerViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-20.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "PhotoScrollerViewController.h"

@interface PhotoScrollerViewController ()
@property (strong, nonatomic) NSMutableSet *recycledPages;
@property (strong, nonatomic) NSMutableSet *visiblePages;
@end

@implementation PhotoScrollerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)configurePage:(MyImageView *)imageView forIndex:(int)index
{
    imageView.tag = index;
    imageView.frame = [self frameForPageAtIndex:index];
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
    CGRect photoScrFrame = [[UIScreen mainScreen] bounds];
    photoScrFrame.origin.x -= 10;
    photoScrFrame.size.width += 20;
    UIScrollView *photoScr = [[UIScrollView alloc] initWithFrame:photoScrFrame];
    [photoScr setPagingEnabled:YES];
    [photoScr setBounces:YES];
    [photoScr setBackgroundColor:[UIColor blackColor]];
    [photoScr setShowsHorizontalScrollIndicator:NO];
    [photoScr setShowsVerticalScrollIndicator:NO];
    self.view = photoScr;
    photoScr = nil;
    
    self.recycledPages = [[NSMutableSet alloc] init];
    self.visiblePages = [[NSMutableSet alloc] init];
}

- (void)tilePages
{
    //计算哪页是当前显示页面
    CGRect visibleBounds = self.view.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf(CGRectGetMaxX(visibleBounds)/CGRectGetWidth(visibleBounds) - 1);
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, [self.photoArray count] - 1);
    
    //重用当前显示页面
    for (UIImageView *imageView in self.visiblePages)
    {
        if (imageView.tag < firstNeededPageIndex || imageView.tag > lastNeededPageIndex)
        {
            [self.recycledPages addObject:imageView];
            [imageView removeFromSuperview];
        }
        
        [self.visiblePages minusSet:self.recycledPages];
    }
    
    //添加未显示页面
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index ++) {
        if (!self)
        {
            <#statements#>
        }
    }
}

/*
 返回重用的UIImageView
 */
-(UIImageView *)dequeueRecyclePage
{
    UIImageView *imageView = [self.recycledPages anyObject];
    
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
    
    for (UIImageView *imageView in self.visiblePages) {
        if (imageView.tag == index)
        {
            foundPage = YES;
            break;
        }
    }
    
    return foundPage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.photoArray = [ImageList GetImageList];
    
    CGSize contentCGSize = CGSizeMake(self.photoArray.count*self.view.frame.size.width, self.view.frame.size.height);
    [(UIScrollView*)self.view setContentSize:contentCGSize];
    
    //add photos
    for (int i = 0; i < self.photoArray.count; ++ i)
    {
        MyImageView *iv = [[MyImageView alloc] initWithImageName:[self.photoArray objectAtIndex:i]
                                                          ofType:@"jpg" andBounds:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        //ofType:@"jpg" andBounds:CGRectNull];
        [self configurePage:iv forIndex:i];
        [self.view addSubview:iv];
        self.testImageView = iv;
        iv = nil;
    }
    
    NSLog(@"Photo Scroll frame:%@", NSStringFromCGRect(self.view.frame));  //TEST
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"myImageView: %@", self.testImageView);
    NSLog(@"Photo scr: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"Image view: %@", NSStringFromCGRect(self.testImageView.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
