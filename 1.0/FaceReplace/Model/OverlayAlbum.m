//
//  OverlayAlbum.m
//  FaceReplace
//
//  Created by beau silver on 2/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "OverlayAlbum.h"
#import <sys/utsname.h>

//#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import "Common.h"
#import "MyStoreObserver.h"

@interface OverlayAlbum()

@end

@implementation OverlayAlbum


- (id) init
{
    if (self = [super init]){
        [self refreshPics];
    }
    return self;
}

- (void)refreshPics{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool picturePack = [defaults boolForKey:[MyStoreObserver picturePackIdentifier]];
    
    self.pics = [[NSMutableArray alloc] init];
    [self.pics addObject:[Common imageWithDeviceCheck: @"wizard"]];
    [self.pics addObject:[Common imageWithDeviceCheck: @"singer"]];
    [self.pics addObject:[Common imageWithDeviceCheck: @"lego"]];
    
    if (picturePack){
        [self.pics addObject:[Common imageWithDeviceCheck: @"cat"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"president"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"barbie"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"barbie_glam"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"muscles"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"cowboy"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"muscle_yard"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"monk"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"golden"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"baby_face"]];
        [self.pics addObject:[Common imageWithDeviceCheck: @"baby_oran"]];
    }
    else{
        //note no actual real pic
        [self.pics addObject:[UIImage imageNamed: @"buy"]];
    }
        
    self.picsNoDeviceCheck = [[NSMutableArray alloc] init];
    [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"wizard"]];
    [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"singer"]];
    [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"lego"]];
    
    if (picturePack){
    
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"cat"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"president"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"barbie"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"barbie_glam"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"muscles"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"cowboy"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"muscle_yard"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"monk"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"golden"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"baby_face"]];
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"baby_oran"]];
    }
    else{
        [self.picsNoDeviceCheck addObject:[UIImage imageNamed: @"buy"]];
    }
}

- (NSArray*)getPics{
    return [self.pics copy];
}

@end
