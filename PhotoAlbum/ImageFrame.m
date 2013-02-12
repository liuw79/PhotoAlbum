//
//  ImageFrame.m
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-30.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ImageFrame.h"

@implementation ImageFrame

+ (CGRect)FrameWithOrdernumberLandscape:(NSInteger)orderNum
{
    float xSpacing = (1024.0 - X_OFF_SET_LANDSCAPE*2)/PAGE_COL_LANDSCAPE;   //下一个的 x 偏移量
    int colIndex = orderNum % PAGE_COL_LANDSCAPE;   //向右偏移的列数 0,1,2...
    int lineIndex = ceil( (orderNum + 1.0) /PAGE_COL_LANDSCAPE) - 1;  //向下偏移行数 0,1,2...
    
    float xPosition = X_OFF_SET_LANDSCAPE + xSpacing*colIndex;
    float yPosition = Y_OFF_SET_LANDSCAPE + ySpacing_LANDSCAPE*lineIndex;
    
    CGRect frame = CGRectMake(xPosition, yPosition, PHOTOWIDTH, PHOTOHEIGHT);
    
    return frame;
}

+ (CGRect)FrameWithOrdernumberPortrait:(NSInteger)orderNum
{
    float xSpacing = (768.0 - X_OFF_SET_PORTRAIT*2)/PAGE_COL_PORTRAIT;   //下一个的 x 偏移量
    int colIndex = orderNum % PAGE_COL_PORTRAIT;   //向右偏移的列数 0,1,2...
    int lineIndex = ceil( (orderNum + 1.0)  /PAGE_COL_PORTRAIT) - 1;  //向下偏移行数 0,1,2...
    
    float xPosition = X_OFF_SET_PORTRAIT + xSpacing*colIndex;
    float yPosition = Y_OFF_SET_PORTRAIT + ySpacing_PORTRAIT*lineIndex;
    
    CGRect frame = CGRectMake(xPosition, yPosition, PHOTOWIDTH, PHOTOHEIGHT);
    
    return frame;
}

@end
