//
//  ViewController.m
//  FaceReplace
//
//  Created by beau silver on 2/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PickPhotoViewController.h"
#import "PictureCollectionViewCell.h"
#import "PictureImageView.h"
#import "CameraViewController.h"
#import "OverlayAlbum.h"
#import "Common.h"
#import "MyStoreObserver.h"

@interface PickPhotoViewController ()  <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *pickPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) OverlayAlbum* overlayAlbum;
@property bool modelIsDirty;

@end

@implementation PickPhotoViewController

+ (void)modelIsDirty:(bool)dirty{
    modelIsDirty = dirty;
}

- (OverlayAlbum*)overlayAlbum{
    if (!_overlayAlbum){
        _overlayAlbum = [[OverlayAlbum alloc] init];
    }
    return _overlayAlbum;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Common BGName]]];
}

- (void)viewDidAppear:(BOOL)animated{
    //just refresh accessing it!
    if (modelIsDirty){
     
        [self.overlayAlbum refreshPics];
        modelIsDirty = NO;
        [self.collectionView reloadData];
        [self.view setNeedsDisplay];

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.overlayAlbum.pics count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Photo" forIndexPath:indexPath];
    if ([cell isKindOfClass:[PictureCollectionViewCell class]]) {
        PictureImageView* piv = ((PictureCollectionViewCell *)cell).pictureImageView;
        
        
        [piv setImage:self.overlayAlbum.picsNoDeviceCheck[indexPath.item]];
    }
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowCamera"]){
        PictureCollectionViewCell *cell = (PictureCollectionViewCell *)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        CameraViewController *cvc = (CameraViewController *)[segue destinationViewController];
        cvc.overlayImage =  self.overlayAlbum.pics[indexPath.item];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        bool alreadyBoughtPicturePack = [defaults boolForKey:[MyStoreObserver picturePackIdentifier]];
        bool isLast = indexPath.item == [self.overlayAlbum.pics count] - 1;
        
        if (isLast && !alreadyBoughtPicturePack){
            //you chose the last item, so set purchasing!
            cvc.purchasing = YES;
        }
        else{
            cvc.purchasing = NO;
        }
        
    }
}

@end
