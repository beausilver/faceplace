//
//  DrawOnImgView.h
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawOnImgView : UIView

@property (nonatomic, strong) UIImage* edittedImage;
@property (nonatomic, strong) UIImage* imageToDisp;
- (id)initWithFrame:(CGRect)frame usingImage:(UIImage*)image;

@end
