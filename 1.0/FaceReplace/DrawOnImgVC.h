//
//  DrawOnImgVC.h
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawOnImgVC : UIViewController

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIImage* image;
- (UIImage*)getImage;
@end
