//
//  ListUnit.h
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-16.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"

#define X_OFF_SET 100
#define Y_OFF_SET 20
#define PAGE_COL 4
#define ySpacing 120
#define PHOTOWIDTH 128
#define PHOTOHEIGHT 90

@interface ListUnit : MyImageView

- (id)initWithOrderNum:(NSInteger)orderNum
          andImageName:(NSString*)imageName ;

@end
