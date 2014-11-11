//
//  PrefsHelper.m
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PrefsHelper.h"

@implementation PrefsHelper

#define DRAW @"draw"

+ (void)setDraw:(BOOL)draw{
    [[NSUserDefaults standardUserDefaults] setBool:draw forKey:DRAW];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getDraw{
    BOOL ret = NO;
    ret = [[NSUserDefaults standardUserDefaults] boolForKey:DRAW];
    return ret;
}

@end
