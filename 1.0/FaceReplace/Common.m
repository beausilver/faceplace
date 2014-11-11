//
//  Common.m
//  FaceReplace
//
//  Created by beau silver on 4/4/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSString*)BGName{return @"bg2";}
+ (NSString*)CameraButtonName{return @"camera_black2";}

+ (UIImage*)imageWithDeviceCheck:(NSString*)name
{
    //assumes PNG (I think)
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        name = [NSString stringWithFormat:@"%@-568h@2x", name];
    }
    else if ([UIScreen mainScreen].scale == 2.f) {
        name = [NSString stringWithFormat:@"%@@2x", name];
    }
    else{
        //do nothing, name already good!
    }
    return [UIImage imageNamed:name];
}

+ (bool)isiPhone5
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f)
        return true;
    return false;
}

+ (bool)isiPhone4
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight < 568.0f)
        return true;
    return false;
            
}

@end
