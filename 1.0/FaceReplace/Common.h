//
//  Common.h
//  FaceReplace
//
//  Created by beau silver on 4/4/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPHONE_4_RETINA_CAM_SCALE 1.5
#define IPHONE_5_RETINA_CAM_SCALE 2.7

@interface Common : NSObject

+ (NSString*)BGName;
+ (NSString*)CameraButtonName;
+ (NSString*)PicturePack1;
+ (UIImage*)imageWithDeviceCheck:(NSString*)name;
+ (bool)isiPhone5;
+ (bool)isiPhone4;

@end
