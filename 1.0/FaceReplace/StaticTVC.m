//
//  StaticTVC.m
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "StaticTVC.h"
#import "PrefsHelper.h"

@interface StaticTVC ()
@property (weak, nonatomic) IBOutlet UISwitch *drawSwitchOutlet;

@end

@implementation StaticTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)drawSwitch:(id)sender {
    UISwitch* tempSwitch = (UISwitch*) sender;
    [PrefsHelper setDraw:tempSwitch.on];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PrefsHelper getDraw]) {
        [self.drawSwitchOutlet setOn:YES animated:NO];
    }
    else{
        [self.drawSwitchOutlet setOn:NO animated:NO];
    }
}

@end
