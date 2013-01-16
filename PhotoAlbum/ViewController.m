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
    
    ImageList *imgList = [[ImageList alloc] init];
    NSArray *array = [imgList GetImageList];
    
    MyImageView *testImage = [[MyImageView alloc] initWithImageName:@"image002" ofType:@"jpg" atLocation:CGPointMake(0, 0)];
    [self.view addSubview:testImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
