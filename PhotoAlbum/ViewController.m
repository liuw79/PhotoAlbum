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
    [self.photoScr.view setFrame:self.view.frame];
    
    NSArray *array = [ImageList GetImageList];
    
    for (int i = 1; i <= array.count; ++ i)
    {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        //[tapGestureRecognizer setNumberOfTouchesRequired:1];
        
        ListUnit *singleImage = [[ListUnit alloc] initWithOrderNum:i
                                                      andImageName:[array objectAtIndex:i - 1]];
        
        [singleImage addGestureRecognizer:tapGestureRecognizer];
        [singleImage setUserInteractionEnabled:YES];
        
        [self.scrollView addSubview:singleImage];
        CGFloat scrHeight = Y_OFF_SET + ceil((float)array.count/PAGE_COL)  *  ySpacing;
        [self.scrollView setContentSize:CGSizeMake(1024, scrHeight)];
    }
    
    
    
     [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [scrollView setBounces:YES];
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    
    self.photoScr = [[PhotoScrollerViewController alloc] init];
    [self.photoScr.view setFrame:self.view.frame];
}

- (void)tapAction:(id)sender
{
    testViewController *test = [[testViewController alloc] initWithNibName:@"testViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:self.photoScr animated:YES];
    //[self.view addSubview:test.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
