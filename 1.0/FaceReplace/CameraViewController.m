//
//  CameraViewController.m
//  FaceReplace
//
//  Created by beau silver on 3/1/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CameraViewController.h"
#import "FileHelper.h"
#import "DrawOnImgVC.h"
#import "PrefsHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "MyStoreObserver.h"
#import "PickPhotoViewController.h"

static bool firstTime = YES;

@interface CameraViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property BOOL takePicture;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) UIImage* photoTaken;
@property (nonatomic) FileHelper* fileHelper;
- (void)combinePicsWithText:(NSAttributedString*)text;

@property (strong, nonatomic) NSString* myPictureName;
@property (strong, nonatomic) UIImage* myImage;
@property (strong, nonatomic) DrawOnImgVC* drawVC;

@property (weak, nonatomic) UIActionSheet *actionSheet;

@property (nonatomic, strong) UIImagePickerController* picker;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) NSArray* productList; //for in app purchases
@property (strong, nonatomic) MyStoreObserver* storeObs; //for in app purchases

@end

@implementation CameraViewController

- (FileHelper*)fileHelper{
    if (!_fileHelper) _fileHelper = [[FileHelper alloc] init];
    return _fileHelper;
}

//- (MyStoreObserver*)storeObs{
//    if (!_storeObs) _storeObs = [[MyStoreObserver alloc] init];
//    return _storeObs;
//}

- (void)openCamera
{
    // make sure this device has a front facing camera - eventually, do back or front camera
    //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront ]) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.allowsEditing = NO;
        self.picker.showsCameraControls = NO;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //picker.cameraViewTransform = CGAffineTransformMakeScale(-1, 1);
        
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];

        if ([UIScreen mainScreen].scale == 2.f){
        //PIGPIGPIG why do we have to set the scale to 2? (@2x, etc)
        self.overlayImage = [UIImage imageWithCGImage:self.overlayImage.CGImage scale:2 orientation:UIImageOrientationUp];
        }
        
        UIImageView *overlay = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        overlay.userInteractionEnabled = YES;
        overlay.image = self.overlayImage;
        overlay.contentMode = UIViewContentModeTop;
        
        self.picker.cameraOverlayView = overlay;
        
        ///////////////////////////////////////////
        //Add take photo button
        CGRect myBounds = [[UIScreen mainScreen] bounds];
        CGSize mySize = myBounds.size;
        float width = mySize.width;
        float height = mySize.height;
        
        UIButton* myButton = [[UIButton alloc] initWithFrame:CGRectMake(width/3,17*height/20,width/3,height/8)];
        //UIButton* myButton = [[UIButton alloc] initWithFrame:CGRectMake(0,430,3,100)];
        myButton.layer.cornerRadius = 10;
        myButton.clipsToBounds = YES;
        //UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:.5];
        UIColor* color = [UIColor whiteColor];
        color = [color colorWithAlphaComponent:.5];
        [myButton setBackgroundColor:color];
        //[myButton setTitle:@"Take" forState:UIControlStateNormal];
        [myButton setImage:[UIImage imageNamed:[Common CameraButtonName]] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
        [overlay addSubview:myButton];
        
        
        
    } else {
        [self addCameraUnavailableAlertView];
    }
}

//////////////////////
//NO CAMERA
///////////////////////

- (void)noCameraButContinue
{
    [self.indicator stopAnimating];
    
    CGRect myBounds = [[UIScreen mainScreen] bounds];
    CGSize mySize = myBounds.size;
    float width = mySize.width;
    float height = mySize.height;
    float myScale = height/width;

    //pseudo hack - not sure why scale of overlayImage goes to 2 with PickerController, but setting it here by hand
    if ([UIScreen mainScreen].scale == 2.f){
    self.overlayImage = [UIImage imageWithCGImage:self.overlayImage.CGImage scale:2 orientation:UIImageOrientationUp];
    }
    
    //Make the alpha black, or leave it alpha?  Doesn't matter...
    //self.photoTaken = [Common imageWithDeviceCheck:@"Default"];
    //self.photoTaken = [UIImage imageWithCGImage:self.photoTaken.CGImage scale:myScale orientation:UIImageOrientationLeftMirrored];
    [self addTextAlertView];
    self.takePicture = NO;
}

///////////////////////////////
//YES CAMERA
////////////////////////////

#define CAMERA_CONTROLS_HEIGHT 50

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.indicator stopAnimating];
    [picker dismissViewControllerAnimated:YES completion:nil];

    //CGRect myBounds = [[UIScreen mainScreen] bounds];
    //CGSize mySize = myBounds.size;
    //float width = mySize.width;
    //float height = mySize.height;
    //float myScale = height/width;
    //float myScale = 2.78;//height/width;
    float myScale = 1.0;
    if ([Common isiPhone5]) {
        myScale = IPHONE_5_RETINA_CAM_SCALE; //iPhone 5 camera scaling, whack pigpigpig
    }
    else {
        myScale = IPHONE_4_RETINA_CAM_SCALE; //iPhone 4 scaling, whack, pigpigpig
    }
    //Dude, can't have an iPhone 3gs, no front facing camera, so we're good
    
    self.photoTaken = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoTaken = [UIImage imageWithCGImage:self.photoTaken.CGImage scale:myScale orientation:UIImageOrientationLeftMirrored];
    [self addTextAlertView];
    
    self.takePicture = NO;
}

- (NSString *)cleanFileNameString:(NSString *)fileName {
    NSCharacterSet* illegalChars = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
    NSString* retStr = [[fileName componentsSeparatedByCharactersInSet:illegalChars] componentsJoinedByString:@""];
    return [retStr stringByReplacingOccurrencesOfString:@" " withString:@"_"]; //remove spaces
}

- (void)combinePicsWithText:(NSAttributedString*)text{
    
    //Create some size helper vars
    CGRect myBounds = [[UIScreen mainScreen] bounds];
    CGSize mySize = myBounds.size;
    float width = mySize.width;
    float height = mySize.height;// - CAMERA_CONTROLS_HEIGHT;
    
    //Combine overlay and photo
    UIGraphicsBeginImageContext( CGSizeMake(width,height) );
    
    int xCoord = 0; //iPhone 4 picture stretching is not so bad, so draw at 0
    if ([Common isiPhone5]) {
        xCoord = -10;  //iPhone 5 picture stretching is whacked from camera to actual pic, hack! Draw 10 pixels to left pigpigpig
    }
    
    [self.photoTaken drawAtPoint:CGPointMake(xCoord,0)];
    [self.overlayImage drawAtPoint:CGPointMake(0,0)];
    
    [text drawAtPoint:CGPointMake(width/8,7*height/8)];
    
    //set background to black?
    
    //Draw Frame
    if ([PrefsHelper getDraw]) { //user pref said to draw the frame
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextBeginPath(ctx);
        CGContextSetLineWidth(ctx, 30.0);
        CGContextMoveToPoint   (ctx, 0, 0);
        CGContextAddLineToPoint(ctx, 0, height);
        CGContextAddLineToPoint(ctx, width, height);
        CGContextAddLineToPoint(ctx, width, 0);  
        CGContextClosePath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0 green: 0.6 blue:0.4 alpha:1].CGColor);
        CGContextStrokePath(ctx);
    }
    
    //Get the final image
    UIImage * draft = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Capture name and img for saving later
    NSString* temp = [text string]; //convert attrstr to str
    self.myPictureName = [self cleanFileNameString:temp]; //clean name of illegal file chars
    self.myImage = draft;
    
    //Actually save it
    [self.fileHelper writeToDisc:self.myImage usingName:self.myPictureName]; //save to Docs folder
    //UIImageWriteToSavedPhotosAlbum(self.myImage, nil, nil, nil ); //save to photos
    
    [self.imageViewPhotoTaken setImage:draft];
    self.imageViewPhotoTaken.contentMode = UIViewContentModeScaleAspectFit;
    
}

////////////////////////////////////////
//ALERT VIEWS
///////////////////////////////////////

- (void)addCameraUnavailableAlertView{
    NSString* myMsg = @"The front facing camera is unavailable on this device - continuing without picture";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable"
                                                    message:myMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
}

#define MAX_TEXT 12

- (void)addTextAlertView{
    //Ask the user to add some text to the photo
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Text"
                                                     message:@"What do you have to say for yourself? (11 characters max)"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"Continue", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert show];
}

- (void)doPurchaseAlertView{
    
    NSMutableArray* buttons = [[NSMutableArray alloc] init];
    for (SKProduct* item in self.productList){
        NSString* temp = [[NSArray arrayWithObjects:item.localizedTitle, item.price, nil] componentsJoinedByString:@" "];
        [buttons addObject:temp];
    }
    
    //Ask the user to add some text to the photo
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Buy Picture Pack"
                                                     message:nil//@"Would you like to buy a picture pack?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    for (NSString *title in buttons) {
        [alert addButtonWithTitle:title];
    }
    
    //Apple is forcing me to add a 'restore' button
    [alert addButtonWithTitle:@"Restore"];
    
    alert.delegate = self;
    [alert show];
}

///////////////////////////////////
//ALL ALERT VIEW CALLBACKS
//////////////////////////////////

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ( [alertView.title isEqualToString:@"Camera Unavailable"] ){
        [self noCameraButContinue];
    }
    
    else if( [alertView.title isEqualToString:@"Add Text"] ){
        
        NSString* temp = [[alertView textFieldAtIndex:0] text];
        NSMutableAttributedString * contents = [[NSMutableAttributedString alloc] initWithString:temp];
        NSInteger length = [contents length];
        
        //shorten if too long
        if (length > MAX_TEXT){
            NSRange range;
            range.location = MAX_TEXT;
            range.length = length - MAX_TEXT;
            [contents deleteCharactersInRange:range];
        }
        
        NSRange wholeRange = NSMakeRange(0,[contents length]);
        [contents addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:wholeRange];
        [contents addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40] range:wholeRange];
        [self combinePicsWithText:contents];
     
        //Now make toolbars visible
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        self.toolbar.hidden = NO;
    }
    
    else if([alertView.title isEqualToString:@"Buy Picture Pack"] ){
        if (buttonIndex == 0){ //cancel, so go back
            [self donePurchasing];
        }
        else{
            if (buttonIndex == [self.productList count] + 1){ //Restore
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            }
            else if (buttonIndex <= [self.productList count]){ //Buy it!
                SKProduct *selectedProduct = self.productList[buttonIndex-1];
                SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }
        }
    }
    
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput){
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= MAX_TEXT ) //limit the num chars
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }

    return YES;
}

//////////////////////////////////////////////////////////////////////
//PURCHASING
//////////////////////////////////////////////////////////////////////

//Consider moving this to it's own class!!!
-(void)doPurchasing{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments]) {
        // Display a store to the user.
        [self requestProductData];
    } else {
        // Warn the user that purchases are disabled.
        //TODO actually add warning!
        [self donePurchasing];
    }
}

-(void)donePurchasing{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) requestProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: [MyStoreObserver picturePackIdentifier]]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.productList = response.products;
    // Populate your UI from the products list.
    // Save a reference to the products list.
    
    [self doPurchaseAlertView];
}

/////////////////////////////////////////////////////////////////////
//STORE OBSERVER

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
    
    //FOR TESTING!!!
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSString* pID = transaction.payment.productIdentifier;
    
    //Set User Defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:pID];
    [PickPhotoViewController modelIsDirty:YES];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [self donePurchasing];
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
    
    [self donePurchasing];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Do Display Err here!!!
        NSLog(@"Transaction Failed!");
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [self donePurchasing];
}

///////////////////////////////////////////////////////////////////////

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //someone's doing in in-app purchase
    if (self.purchasing){
        [self doPurchasing];
    }
    
    //otherwise, just open up the camera and continue...
    else{
        if (self.takePicture){
            [self openCamera];
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.takePicture = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.takePicture = YES;
    self.indicator.hidesWhenStopped = YES;
    [self.indicator startAnimating];
    self.myImageView.userInteractionEnabled = YES;
    
    //Hide toolbars
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    self.toolbar.hidden = YES;
    self.toolbar.barStyle = UIBarStyleBlack;
    self.toolbar.translucent = YES;
    
    //set BG color
    //self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Common BGName]]];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)shareIt:(id)sender {
}

- (IBAction)share:(id)sender {
}
//Going to the DrawOnImgVC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"drawOnImage"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setImage:)]) {
            [segue.destinationViewController performSelector:@selector(setImage:) withObject:self.myImage];
            self.drawVC = segue.destinationViewController;
            [self.drawVC setDelegate:self];
        }
    }
}

//User has pushed the 'done' button in the DrawOnImgVC
- (IBAction) done:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage* temp = [self.drawVC getImage];
    self.imageViewPhotoTaken.image = temp;
    self.myImage = temp;
    [self.fileHelper writeToDisc:self.myImage usingName:self.myPictureName]; //save to Docs folder
}

- (IBAction)capture:(id)sender {
     [self.picker takePicture];
}

- (IBAction)sharePic:(id)sender {
    //email, Facebook, save to photos
    NSArray *activityItems = @[@"FaceReplace", self.myImage];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMessage , UIActivityTypeCopyToPasteboard ];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}


- (IBAction)tapped:(id)sender {
    // show/hide toolbars
    [[self navigationController] setNavigationBarHidden:!self.toolbar.hidden animated:NO];
    self.toolbar.hidden = !self.toolbar.hidden;
}

@end
