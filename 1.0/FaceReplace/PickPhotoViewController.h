//
//  ViewController.h
//  FaceReplace
//
//  Created by beau silver on 2/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

static bool modelIsDirty;

@interface PickPhotoViewController : UIViewController //should this be a UICollectionViewController?

+(void)modelIsDirty:(bool) dirty;

@end
