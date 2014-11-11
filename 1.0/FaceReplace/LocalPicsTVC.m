//
//  LocalPicsTVC.m
//  FaceReplace
//
//  Created by beau silver on 3/6/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "LocalPicsTVC.h"
#import "FileHelper.h"
#import "common.h"

@interface LocalPicsTVC ()

@property (nonatomic) NSArray* savedPics;
@property (nonatomic) NSMutableArray* picImages;
@property (nonatomic) FileHelper* fileHelper;

@end

@implementation LocalPicsTVC

- (FileHelper*)fileHelper{
    if (!_fileHelper) _fileHelper = [[FileHelper alloc] init];
    return _fileHelper;
}

- (NSArray*)savedPics{
    if (!_savedPics) {
        _savedPics = [self.fileHelper getLocalImageInfo];
    }
    return _savedPics;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Common BGName]]];
}

- (void)viewDidAppear:(BOOL)animated{
    
    //Fill the picImages array 
    self.picImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.savedPics count] ; i++)
    {
        NSData* imageData = [self.fileHelper getImageDataStr:self.savedPics[i][STR]];
        [self.picImages addObject:[[UIImage alloc] initWithData:imageData]];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    self.savedPics = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.savedPics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocalPic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.savedPics[indexPath.item][NAME];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //alloc every time?  No way, do it just once...
    //NSData* imageData = [self.fileHelper getImageDataStr:self.savedPics[indexPath.item][STR]];
    //cell.imageView.image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image = self.picImages[indexPath.item];
    
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
            NSString* str = self.savedPics[indexPath.item][STR];
            if ([segue.destinationViewController respondsToSelector:@selector(setImageStr:)]) {
                [segue.destinationViewController performSelector:@selector(setImageStr:) withObject:str];
            }
        }
    }
}

@end
