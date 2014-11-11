//
//  SavedPicsVC.m
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "ScrollViewController.h"
#import "FileHelper.h"
#import "DrawOnImgVC.h"
#import "Common.h"

@interface ScrollViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) FileHelper* fileHelper;

@property (strong, nonatomic) DrawOnImgVC* drawVC;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ScrollViewController

//***************************
//properties
//***************************

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (FileHelper*)fileHelper{
    if (!_fileHelper) _fileHelper = [[FileHelper alloc] init];
    return _fileHelper;
}

//***************************
//Funcs
//***************************


- (void)resetImage
{
    if (self.myScrollView && (self.imageURL || self.imageStr)) {
        self.myScrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        //[self.spinner startAnimating];      // if self.spinner is nil, does nothing
        dispatch_queue_t downloadQueue = dispatch_queue_create("image_downloader", NULL);
        dispatch_async(downloadQueue, ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // bad
            
            NSData *imageData;
            if (self.imageStr){
                imageData = [self.fileHelper getImageDataStr:self.imageStr];
            }
            else{
                imageData = [self.fileHelper getImageData:self.imageURL];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // bad
             UIImage *image = [[UIImage alloc] initWithData:imageData];
            //UIImage *image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.myScrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    
                    float myScale = [self getZoomScale];
                    self.myScrollView.zoomScale = myScale;
                    //[self.spinner stopAnimating];       // spinner should have hidesWhenStopped set
                });
            }
            
        });
    }
}

- (float)getZoomScale
{
    float myScale;
    int SCWidth = self.view.frame.size.width;
    int SCHeight = self.view.frame.size.height;
    int ImgWidth = self.imageView.frame.size.width;
    int ImgHeight = self.imageView.frame.size.height;
    
    float SCRatio = (float)SCWidth / (float)SCHeight;
    float ImgRatio = (float)ImgWidth / (float)ImgHeight;
    
    /*
    if (ImgRatio < SCRatio){
        //constrain by width
        myScale = (float)SCWidth / (float)ImgWidth;
    }
    else{
        //constrain by height
        myScale = (float)SCHeight / (float)ImgHeight;
    }
    */
    //if (ImgRatio < SCRatio){
        //constrain by width
    //    myScale = (float)SCWidth / (float)ImgWidth;
    //}
    //else{
        //constrain by height
        myScale = (float)SCHeight / (float)ImgHeight;
    //}
    
    return myScale;
    
}

//******************************
//view callbacks
//******************************

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.myScrollView.zoomScale = 1;
    [self resetImage];
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)myScrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myScrollView.userInteractionEnabled = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    self.toolbar.hidden = NO;
    self.toolbar.translucent = YES;
    self.toolbar.barStyle = UIBarStyleBlack;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Common BGName]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    //Nothing here yet
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myScrollView addSubview:self.imageView];
    [self.view layoutSubviews];
    self.myScrollView.minimumZoomScale = .8;
    self.myScrollView.maximumZoomScale = 2;
    self.myScrollView.delegate = self;
    self.myScrollView.zoomScale = 1;
    [self resetImage];
}

//////////////////////////////////////////

//Going to the DrawOnImgVC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"drawOnImage"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setImage:)]) {
            [segue.destinationViewController performSelector:@selector(setImage:) withObject:self.imageView.image];
            self.drawVC = segue.destinationViewController;
            [self.drawVC setDelegate:self];
        }
    }
}

//User has pushed the 'done' button in the DrawOnImgVC
- (IBAction) done:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage* temp = [self.drawVC getImage];
    //self.imageViewPhotoTaken.image = temp;
    self.imageView.image = temp;
    NSArray *myArray = [self.imageStr componentsSeparatedByString:@"/"];
    [self.fileHelper writeToDisc:self.imageView.image usingName:[myArray lastObject]]; //save to Docs folder
    [self resetImage];
}

- (IBAction)sharePic:(id)sender {
    ///////////////////////////HACK
    
    ////////////HACK
    NSArray *activityItems = @[@"Hello",self.imageView.image];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMessage , UIActivityTypeCopyToPasteboard ];
    [self presentViewController:activityViewController animated:YES completion:NULL];
    /////////////////
    ///////////////////////////
}

- (IBAction)delete:(id)sender {
    if (self.imageStr){
        NSFileManager* fm = [[NSFileManager alloc] init];
        if ([fm removeItemAtPath:self.imageStr error:nil])
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tapped:(id)sender {
    [[self navigationController] setNavigationBarHidden:!self.toolbar.hidden animated:NO];
    self.toolbar.hidden = !self.toolbar.hidden;
}

@end
