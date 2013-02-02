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

- (void)viewWillAppear:(BOOL)animated
{
    [self.bigPhotoScrollerViewController.view setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
    
    NSLog(@"vc scr frame %@", NSStringFromCGRect(self.bigPhotoScrollerViewController.view.frame));
    
    NSArray *array = [ImageList GetImageList];
    
    for (int i = 1; i <= array.count; ++ i)
    {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        //[tapGestureRecognizer setNumberOfTouchesRequired:1];
        
        //ListUnit *singleImage = [[ListUnit alloc] initWithOrderNum:i
        //                                           andImageName:[array objectAtIndex:i - 1]];
        MyImageView *singleImage = [[MyImageView alloc] initWithImageName:[array objectAtIndex:i - 1]
                                                                   ofType:@"jpg" andFrame:[ImageFrame FrameWithOrdernumber:i]];
        
        [singleImage addGestureRecognizer:tapGestureRecognizer];
        [singleImage setUserInteractionEnabled:YES];
        [singleImage.layer setBorderWidth:5.0f];
        [singleImage.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [self.smallPhotoScrollView addSubview:singleImage];
        CGFloat scrHeight = Y_OFF_SET + ceil((float)array.count/PAGE_COL)  *  ySpacing;
        [self.smallPhotoScrollView setContentSize:CGSizeMake(LANDSCAPE_WIDTH, scrHeight)];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
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

- (void)tapAction:(id)sender
{
    [self.view addSubview:self.bigPhotoScrollerViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
