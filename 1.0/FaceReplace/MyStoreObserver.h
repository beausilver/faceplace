//
//  MyStoreObserver.h
//  FaceReplace
//
//  Created by beau silver on 9/11/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver>

+(NSString*)picturePackIdentifier;
@property (strong, nonatomic) UINavigationController* navigationController;
@end
