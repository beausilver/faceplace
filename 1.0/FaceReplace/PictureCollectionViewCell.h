//
//  PictureCollectionViewCell.h
//  FaceReplace
//
//  Created by beau silver on 2/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureImageView.h"

@interface PictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PictureImageView *pictureImageView;
@end
