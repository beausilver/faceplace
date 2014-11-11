//
//  DrawOnImgView.m
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "DrawOnImgView.h"
#import "DrawOnImgVC.h"

@interface DrawOnImgView()
@property (nonatomic, strong) UIColor* brushPattern;
@property (nonatomic, strong) UIBezierPath *myPath;

@end

@implementation DrawOnImgView

- (void)setImageToDisp:(UIImage*)image{
    _imageToDisp = image;
}

- (id)initWithFrame:(CGRect)frame usingImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myPath=[[UIBezierPath alloc]init];
        self.myPath.lineWidth=10;
        self.brushPattern=[UIColor redColor]; //This is the color of my stroke
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.myPath moveToPoint:[mytouch locationInView:self]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.myPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
    [self.brushPattern setStroke];
    [self.myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}


@end
