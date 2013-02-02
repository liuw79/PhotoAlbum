//
//  ImageFrame.m
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-30.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ImageFrame.h"

@implementation ImageFrame

+ (CGRect)FrameWithOrdernumber:(NSInteger)orderNum
{
    float xSpacing = (1024.0 - X_OFF_SET*2)/PAGE_COL;   //下一个的 x 偏移量
    int colIndex = (orderNum - 1) % PAGE_COL;   //向右偏移的列数 0,1,2...
    int lineIndex = ceil((float)orderNum/PAGE_COL) - 1;  //向下偏移行数 0,1,2...
    
    float xPosition = X_OFF_SET + xSpacing*colIndex;
    float yPosition = Y_OFF_SET + ySpacing*lineIndex;
    
    CGRect frame = CGRectMake(xPosition, yPosition, PHOTOWIDTH, PHOTOHEIGHT);
    
    return frame;
}

@end
