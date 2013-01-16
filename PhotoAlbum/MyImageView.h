//
//  MyImageView.h
//  CarMag
//
//  Created by LIU WEI on 12-12-22.
//  Copyright (c) 2012年 LIU WEI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyImageView : UIImageView


@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;


- (id)initWithImageName:(NSString*)imageName ofType:(NSString*)imageType andBounds:(CGRect)bounds;
- (id)initWithImagePath:(NSString*)imagePath andBounds:(CGRect)bounds;

- (void)setImageWithName:(NSString*)imageName ofType:(NSString*)imageType andBounds:(CGRect)bounds;

- (void)setImageWithPath:(NSString *)imagePath andBounds:(CGRect)bounds;

- (void)setUpProperties:(CGRect)frame;

@end

