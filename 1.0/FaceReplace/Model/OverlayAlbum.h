//
//  OverlayAlbum.h
//  FaceReplace
//
//  Created by beau silver on 2/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface OverlayAlbum : NSObject <SKProductsRequestDelegate>

- (NSArray*)getPics;
@property (nonatomic) NSMutableArray* pics;
@property (nonatomic) NSMutableArray* picsNoDeviceCheck;
- (void)refreshPics;
@end
