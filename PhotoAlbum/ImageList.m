//
//  ImageList.m
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-15.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ImageList.h"

@implementation ImageList


+ (NSArray *)GetImageList
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:58];
    
    for (int i = 0; i <= 57; ++ i)
    {
        @autoreleasepool {
            NSString *tmpString = [NSString stringWithFormat:
                                   @"image%03d", i];
            [tmpArray addObject:tmpString];
        }
    }
    
    //NSLog(@"%@", tmpArray);
    
    return [tmpArray copy];
}

@end
