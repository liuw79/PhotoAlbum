//
//  ListUnit.h
//  PhotoAlbum
//
//  Created by LIU WEI on 13-1-16.
//  Copyright (c) 2013年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"
#import "ValueDefine.h"



@interface ListUnit : MyImageView

- (id)initWithOrderNum:(NSInteger)orderNum
          andImageName:(NSString*)imageName ;

@end
