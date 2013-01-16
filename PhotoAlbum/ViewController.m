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

    for (int i = 1; i <= array.count; ++ i)
    {
        ListUnit *singleImage = [[ListUnit alloc] initWithOrderNum:i
                                                      andImageName:[array objectAtIndex:i - 1]];
        
        [self.view addSubview:singleImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
