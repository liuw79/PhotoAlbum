//
//  ViewController.m
//  PhotoAlbum
//
//  Created by liuwei on 13-1-13.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    ImageList *imgList = [[ImageList alloc] init];
    NSArray *array = [imgList GetImageList];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [scrollView setBounces:YES];
    self.scrollView = scrollView;
    CGFloat scrHeight = Y_OFF_SET + ceil((float)array.count/PAGE_COL)  *  ySpacing;
    [self.scrollView setContentSize:CGSizeMake(1024, scrHeight)];
    [self.view addSubview:self.scrollView];

    for (int i = 1; i <= array.count; ++ i)
    {
        ListUnit *singleImage = [[ListUnit alloc] initWithOrderNum:i
                                                      andImageName:[array objectAtIndex:i - 1]];
        
        [self.scrollView addSubview:singleImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
