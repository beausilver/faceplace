//
//  PrefsHelper.h
//  FaceReplace
//
//  Created by beau silver on 3/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrefsHelper : NSObject

+ (void)setDraw:(BOOL)draw;
+ (BOOL)getDraw;
//+ (void)resetDefaults;

@end
