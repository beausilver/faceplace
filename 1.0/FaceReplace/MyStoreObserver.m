//
//  MyStoreObserver.m
//  FaceReplace
//
//  Created by beau silver on 9/11/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MyStoreObserver.h"
#import "Common.h"

#import "PickPhotoViewController.h"

@implementation MyStoreObserver

+(NSString*)picturePackIdentifier{
    return @"com.beausilver.facereplace.picturepack.basic";
}

/*

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction is being added to the server queue.");
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    //[self recordTransaction:transaction];
    //[self provideContent:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSString* pID = transaction.payment.productIdentifier;

    //Set User Defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:pID];
    [PickPhotoViewController modelIsDirty:YES];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    
    NSString* pID = transaction.payment.productIdentifier;
    //Set User Defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:pID];
    [PickPhotoViewController modelIsDirty:YES];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Do Display Err here!!!
        NSLog(@"Transaction FAILED!");
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

 */
 
@end
