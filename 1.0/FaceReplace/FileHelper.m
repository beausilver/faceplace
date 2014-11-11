//
//  ImageWriter.m
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FileHelper.h"

@interface FileHelper()

@property (strong, nonatomic) NSURL* docsURL;
@property (strong, nonatomic) NSString* docsPath;
@property (strong, nonatomic) NSFileManager* fm;
- (NSURL*)getFullDiscURL:(NSURL*)url;
- (void)writeToDisc:(NSURL*)url usingData:(NSData*)data;
- (void)removeOldestFileInCache;
- (unsigned long long int) cacheFolderSize;

@property (strong, nonatomic) NSString* cachePath;
@property (strong, nonatomic) NSURL* cacheURL;

@end

//Dude, Johan - sorry, I looked really hard and cannot find what's making 
@implementation FileHelper

#define MAX_CACHE_BYTES 1000000 //small size for testing
//#define MAX_CACHE_BYTES 20000000 //more reasonable size

- (NSURL*)docsURL{
    //Is it ok to index '0' into this array?  Will it always return only 1 URL?
    return [[NSFileManager defaultManager] URLsForDirectory:(NSSearchPathDirectory)NSDocumentDirectory inDomains:NSUserDomainMask][0];
}

- (NSString*)docsPath{
    //Is it ok to index '0' into this array?  Will it always return only 1 URL?
    return [self.docsURL path];
}

- (NSURL*)cacheURL{
    //Is it ok to index '0' into this array?  Will it always return only 1 URL?
    return [[NSFileManager defaultManager] URLsForDirectory:(NSSearchPathDirectory)NSCachesDirectory inDomains:NSUserDomainMask][0];
}

- (NSString*)cachePath{
    //Is it ok to index '0' into this array?  Will it always return only 1 URL?
    return [self.docsURL path];
}

- (NSFileManager*)fm{
    if (!_fm) _fm = [[NSFileManager alloc] init];
    return _fm;
}

- (void)writeToDisc:(UIImage*)img usingName:(NSString*)name{
    //NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"dd-MM-yyyy_HH-mm"];
    //NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString* temp = [NSString stringWithFormat:@"%@%@", self.docsURL, name];
    NSURL* url = [[NSURL alloc] initWithString:temp];
    
    NSData* myData = UIImageJPEGRepresentation(img, 1);
    if([url isFileURL]){
        [myData writeToURL:url atomically:YES];
    }
}


- (NSArray*)getLocalImageInfo{
    NSArray* fileNames = [[NSArray alloc] init];
    fileNames = [self.fm contentsOfDirectoryAtPath:self.docsPath error:NULL];
    NSMutableArray* imgDictArray = [[NSMutableArray alloc] init];
    
    NSString* fullPath;
    for (NSString* name in fileNames) {
        NSMutableDictionary* imgDict = [[NSMutableDictionary alloc] init];
        fullPath = [self.docsPath stringByAppendingPathComponent:name];
        //NSURL* myURL = [[NSURL alloc] initWithString:fullPath];
        //NSLog(@"%@", myURL);
        imgDict[STR] = fullPath;
        //imgDict[URL] = myURL;
        imgDict[NAME] = name;
        [imgDictArray addObject:imgDict];
    }
    
    return [imgDictArray copy];}

/////////////////old

- (NSData*)getImageDataStr:(NSString*)str{
    NSData* imageData;
    BOOL exists = [self.fm fileExistsAtPath:str];
    if (exists){ //read it from disc
        imageData = [NSData dataWithContentsOfFile:str];
    }
    return imageData;
}

- (NSData*)getImageData:(NSURL*)url{
    NSData* imageData;
    //next, check if name is in caches path
    NSURL* discURL = [self getFullDiscURL:url];
    BOOL exists = [self.fm fileExistsAtPath:[discURL path]];
    if (exists){ //read it from disc
        imageData = [NSData dataWithContentsOfURL:discURL];
    }
    else{ // get it from net
        imageData = [[NSData alloc] initWithContentsOfURL:url];
        //write it to disc
        [self writeToDisc:discURL usingData:imageData];
    }
    return imageData;
}

- (NSURL*)getFullDiscURL:(NSURL*)url{
    NSArray* urls = [self.fm URLsForDirectory:(NSSearchPathDirectory)NSCachesDirectory inDomains:NSUserDomainMask];
    NSArray* splitStr = [[NSString stringWithFormat:@"%@", url] componentsSeparatedByString: @"/"];
    NSString* imgFileName = splitStr[splitStr.count - 1];
    NSString* temp = [NSString stringWithFormat:@"%@%@", urls[0], imgFileName];
    //NSLog(@"%@", temp);
    return [[NSURL alloc] initWithString:temp];
}

- (void)writeToDisc:(NSURL*)url usingData:(NSData*)data{
    if([url isFileURL]){
        unsigned long long cacheSize = [self cacheFolderSize];
        while (cacheSize > MAX_CACHE_BYTES){
            [self removeOldestFileInCache];
            cacheSize = [self cacheFolderSize];
        }
        [data writeToURL:url atomically:YES];
    }
}

- (void)removeOldestFileInCache{
    NSArray* files = [[NSArray alloc] init];
    files = [self.fm contentsOfDirectoryAtPath:self.cachePath error:NULL];
    
    NSDictionary* attr = [[NSDictionary alloc] init];
    NSString* fullPath = [[NSString alloc] init];
    NSString* oldestPath = nil;
    NSDate* oldestDate = nil;
    //NSLog(@"%@", files);
    for (NSString *path in files) {
        fullPath = [self.cachePath stringByAppendingPathComponent:path];
        attr = [self.fm attributesOfItemAtPath:fullPath error:NULL];
        NSDate *theDate = [attr objectForKey:NSFileModificationDate];
        if (oldestDate == nil || [theDate compare: oldestDate] == NSOrderedAscending)
        {
            oldestDate = theDate;
            oldestPath = fullPath;
        }
    }
    [self.fm removeItemAtPath:oldestPath error:nil];
}

- (unsigned long long int) cacheFolderSize {
    NSArray* files = [[NSArray alloc] init];
    files = [self.fm contentsOfDirectoryAtPath:self.cachePath error:NULL];
    NSDictionary* attr = [[NSDictionary alloc] init];
    NSString* fullPath = [[NSString alloc] init];
    unsigned long long int fileSize = 0;
    for (NSString *path in files) {
        fullPath = [self.cachePath stringByAppendingPathComponent:path];
        attr = [self.fm attributesOfItemAtPath:fullPath error:NULL];
        fileSize += [attr fileSize];
    }
    return fileSize;
}


@end
