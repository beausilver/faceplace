//
//  MyNavController.m
//  FaceReplace
//
//  Created by beau silver on 4/4/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MyNavController.h"

@interface MyNavController ()

@end

@implementation MyNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.navigationController.navigationBar.translucent = YES;
    //[(UIView*)[self.navigationController.navigationBar.subviews objectAtIndex:0] setAlpha:0.7f];
    self.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
