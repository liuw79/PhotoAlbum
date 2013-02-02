//
//  MyImageView.m
//  CarMag
//
//  Created by LIU WEI on 12-12-22.
//  Copyright (c) 2012年 LIU WEI. All rights reserved.

#import "MyImageView.h"

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setUpProperties:frame];
    }
    
    return self;
}

- (id)initWithImageName:(NSString*)imageName ofType:(NSString*)imageType andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setImageWithName:imageName ofType:imageType andFrame:(CGRect)frame];
        self.userInteractionEnabled = YES;
        [self setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return self;
}

- (id)initWithImagePath:(NSString *)imagePath andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setImageWithPath:imagePath andFrame:(CGRect)frame];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)setImageWithName:(NSString *)imageName ofType:(NSString *)imageType andFrame:(CGRect)frame
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    [self setFrame:frame];
}

-(void)setImageWithPath:(NSString *)imagePath andFrame:(CGRect)frame
{
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    [self setFrame:frame];
}

- (NSString *)description
{
    NSString *des = [[NSString
                     alloc] initWithFormat:@"Image Name:%@; Image Frame:%@",
                     self.image,
                     NSStringFromCGRect(self.frame)];
    return des;
}

- (void)setUpProperties:(CGRect)frame
{
    [self setFrame:frame];
}

@end
