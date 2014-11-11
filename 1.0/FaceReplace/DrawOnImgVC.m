//
//  DrawOnImgVC.m
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "DrawOnImgVC.h"
#import "DrawOnImgView.h"
#import <QuartzCore/QuartzCore.h>

@interface DrawOnImgVC ()

@property (nonatomic, strong) DrawOnImgView* mySubview;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation DrawOnImgVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myImageView.image = self.image;
    //self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.myImageView];
    
    DrawOnImgView* mySubview = [[DrawOnImgView alloc] initWithFrame:self.view.bounds usingImage:self.image];
    [self.view addSubview:mySubview];
    
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    
    UIButton* myButton = [[UIButton alloc] initWithFrame:CGRectMake(width/15,height/20,width/4,height/10)];
    myButton.layer.cornerRadius = 10;
    myButton.clipsToBounds = YES;
    UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:.7];
    [myButton setBackgroundColor:color];
    [myButton setTitle:@"Done" forState:UIControlStateNormal];
    [myButton addTarget:self.delegate action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];

}

- (UIImage*)getImage{
    //remove button
    NSArray* temp = [self.view subviews];
    UIView* tempV = [temp lastObject];
    [tempV removeFromSuperview];
    
    UIGraphicsBeginImageContext( [self.view bounds].size );
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
