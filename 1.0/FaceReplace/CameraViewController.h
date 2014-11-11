//
//  CameraViewController.h
//  FaceReplace
//
//  Created by beau silver on 3/1/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver, SKPaymentTransactionObserver>

@property (nonatomic, strong) UIImage* overlayImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhotoTaken;
@property bool purchasing;

@end
