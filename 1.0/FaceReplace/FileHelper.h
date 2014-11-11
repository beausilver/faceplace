//
//  ImageWriter.h
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE @"image"
#define NAME @"name"
#define URL @"url"
#define STR @"str"

@interface FileHelper : NSObject

- (void)writeToDisc:(UIImage*)img;
- (NSArray*)getImagesFromDisc;
- (NSArray*)getLocalImageInfo;
- (NSData*)getImageData:(NSURL*)url;
- (NSData*)getImageDataStr:(NSString*)str;
- (void)writeToDisc:(UIImage*)img usingName:(NSString*)name;

@end
