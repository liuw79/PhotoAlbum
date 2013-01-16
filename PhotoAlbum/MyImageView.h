//
//  MyImageView.h
//  CarMag
//
//  Created by LIU WEI on 12-12-22.
//  Copyright (c) 2012年 LIU WEI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyImageView : UIImageView


@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGestureRecognizer;


- (id)initWithImageName:(NSString*)imageName ofType:(NSString*)imageType atLocation:(CGPoint)imagePoint;
- (id)initWithImagePath:(NSString*)imagePath atLocation:(CGPoint)imagePoint;

- (void)setImageWithName:(NSString*)imageName ofType:(NSString*)imageType atLocation:(CGPoint)imagePoint;

- (void)setImageWithPath:(NSString *)imagePath atLocation:(CGPoint)imagePoint;

- (void)setUpProperties;

@end

