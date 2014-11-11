//
//  SavedPicsTVC.m
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "WebPicsTVC.h"
#import "FileHelper.h"
#import "FlickrFetcher.h"

@interface WebPicsTVC ()

@property (nonatomic, strong) NSArray *allFlickrPhotos; // of NSDictionary
@property (nonatomic) FileHelper* fileHelper;

@end

@implementation WebPicsTVC

- (FileHelper*)fileHelper{
    if (!_fileHelper) _fileHelper = [[FileHelper alloc] init];
    return _fileHelper;
}

//- (NSArray*)allFlickrPhotos{
//    if (!_allFlickrPhotos) {
//        _allFlickrPhotos = [FlickrFetcher faceReplacePhotos];
//    }
//    return _allFlickrPhotos;
//}

- (void) refreshAll{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr_downloader", NULL);
    dispatch_async(downloadQueue, ^{
        self.allFlickrPhotos = [FlickrFetcher faceReplacePhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refreshAll];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allFlickrPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SavedPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.allFlickrPhotos[indexPath.item][FLICKR_PHOTO_TITLE];
    
    //Get the thumbnail image
    dispatch_queue_t downloadQueue = dispatch_queue_create("img_downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        
        
        if ([FlickrFetcher getGlobalNetCount] == 0){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // bad
        }
        [FlickrFetcher modGlobalNetCount:1];
        NSData *imageData;
        
        NSURL* url = [FlickrFetcher urlForPhoto:self.allFlickrPhotos[indexPath.item] format:FlickrPhotoFormatSquare];
        imageData = [self.fileHelper getImageData:url];
        
        if ([FlickrFetcher getGlobalNetCount] == 1){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // bad
        }
        [FlickrFetcher modGlobalNetCount:-1];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
                [cell setNeedsLayout];
            });
        }
    });
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"showPic"]) {
            NSURL *url = [FlickrFetcher urlForPhoto:self.allFlickrPhotos[indexPath.row] format:FlickrPhotoFormatLarge];
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
            }
        }
    }
}

- (IBAction)refresh{
    [self.refreshControl beginRefreshing];
    [self refreshAll];
}

@end