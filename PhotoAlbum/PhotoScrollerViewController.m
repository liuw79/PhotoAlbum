//
//  PhotoScrollerViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-20.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "PhotoScrollerViewController.h"

@interface PhotoScrollerViewController ()

@end

@implementation PhotoScrollerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photoArray = [ImageList GetImageList];
        
        
        UIScrollView *photoScr = [[UIScrollView alloc] init];
        [photoScr setPagingEnabled:YES];
        [photoScr setBounces:YES];
        [photoScr setBackgroundColor:[UIColor whiteColor]];
        [photoScr setShowsHorizontalScrollIndicator:YES];
        [photoScr setShowsVerticalScrollIndicator:YES];
        [photoScr setContentSize:CGSizeMake(self.photoArray.count*photoScr.frame.size.width, photoScr.frame.size.height)];
        
        self.view = photoScr;
        
        photoScr = nil;
        
        
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

    }
    return self;
}


- (void)configurePage:(MyImageView *)imageView forIndex:(int)index
{
    imageView.frame = [self frameForPageAtIndex:index];
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    
    CGRect bounds = self.view.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width = bounds.size.width + 10;
    pageFrame.origin.x = bounds.size.width * index;
    
    
    NSLog(@"photoScr bounds: %@", NSStringFromCGRect(bounds));
    NSLog(@"pageFrame: %@", NSStringFromCGRect(pageFrame));
    
    
    return pageFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"myImageView: %@", self.testImageView);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
