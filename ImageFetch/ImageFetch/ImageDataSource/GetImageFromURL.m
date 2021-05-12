//
//  GetImageFromURL.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 10/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import "GetImageFromURL.h"

@interface GetImageFromURL ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray<PhotoObject *> *photoAlbum;

@property (strong, nonatomic) dispatch_queue_t downloadQueue;
@property (strong, nonatomic) dispatch_queue_t appendQueue;

@end

@implementation GetImageFromURL

- (instancetype)initWithSession:(NSURLSession *)session {
    self = [super init];
    
    if(self) {
        self.session = session;
        self.photoAlbum = [NSMutableArray<PhotoObject *> array];
        self.downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.appendQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (void)addPhotoItem:(PhotoObject *)photoItem {
    [self.photoAlbum addObject:photoItem];
}

- (void)clearData {
        [self.photoAlbum removeAllObjects];
}

- (void)downloadImageFor:(NSIndexPath *)indexPath {
    if (self.photoAlbum[indexPath.item].image == nil && !self.photoAlbum[indexPath.item].imageIsLoading) {
        dispatch_async(self.downloadQueue, ^{
            NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:self.photoAlbum[indexPath.item].url
                                                         completionHandler:^(NSData *dataItem, NSURLResponse *response, NSError *error) {
                self.photoAlbum[indexPath.item].imageIsLoading = NO;
                if (!error && dataItem && [response.URL isEqual:self.photoAlbum[indexPath.item].url]) {
                    UIImage *image = [UIImage imageWithData:dataItem];
                    if (image) {
                        dispatch_async(self.appendQueue, ^{
                            [self.photoAlbum[indexPath.item] setImage:image];
                            CGFloat imageRatio = image.size.width / image.size.height;
                            [self.photoAlbum[indexPath.item] setImageRatio:imageRatio];
                            [self.delegate imageDidLoadFor:indexPath];
                        });
                    } else {
                        NSLog(@"Error: downloadImageForindexPath: %li", indexPath.item);
                    }
                } else if (error) {
                    NSLog(@"Error:\n%@", error);
                }
            }];
            self.photoAlbum[indexPath.item].imageIsLoading = YES;
            [dataTask resume];
        });
    }
}

- (void)removeImageFor:(NSIndexPath *)indexPath {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if (self.photoAlbum.count > indexPath.item && self.photoAlbum[indexPath.item].image) {
            [self.photoAlbum[indexPath.item] removeImage];
            NSLog(@"removing image for cell:%li", indexPath.item);
        }
    });
}

- (UIImage *)getImageFor:(NSIndexPath *)indexPath {
    if (!(self.photoAlbum.count > indexPath.item && self.photoAlbum[indexPath.item].image)) {
        return nil;
    }
    return self.photoAlbum[indexPath.item].image;
}

- (CGFloat)getImageRatioFor:(NSIndexPath *)indexPath {
    return self.photoAlbum[indexPath.item].imageRatio;
}

- (CGFloat)getImageCellHeightAtIndexPath:(NSIndexPath*)indexPath {
    return self.photoAlbum[indexPath.item].cellHeight;
}

- (void)setImageCellHeight:(CGFloat)height AtIndexPath:(NSIndexPath*)indexPath {
    [self.photoAlbum[indexPath.item] setCellHeight:height];
}

- (NSInteger)getImagesCount {
    return self.photoAlbum.count;
}

- (PhotoObject *)getPhotoObjectFor:(NSIndexPath *)indexPath {
    if (!(self.photoAlbum.count > indexPath.item)) {
        return nil;
    }
    return self.photoAlbum[indexPath.item];
}

@end
