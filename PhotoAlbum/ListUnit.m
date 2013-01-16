//
//  ListUnit.m
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-16.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import "ListUnit.h"

@implementation ListUnit

- (id)initWithOrderNum:(NSInteger)orderNum
          andImageName:(NSString*)imageName  //order number for Calculate position
{
    float xSpacing = (1024.0 - X_OFF_SET*2)/PAGE_COL;   //下一个的 x 偏移量
    int colIndex = (orderNum - 1) % PAGE_COL;   //向右偏移的列数 0,1,2...
    int lineIndex = ceil((float)orderNum/PAGE_COL) - 1;  //向下偏移行数 0,1,2...
    
    float xPosition = X_OFF_SET + xSpacing*colIndex;
    float yPosition = Y_OFF_SET + ySpacing*lineIndex;
    
    CGRect frame = CGRectMake(xPosition, yPosition, PHOTOWIDTH, PHOTOHEIGHT);
    
    NSLog(@"%@", NSStringFromCGRect(frame));
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageWithName:imageName ofType:@"jpg" andBounds:frame];
    }
    return self;
}

@end
