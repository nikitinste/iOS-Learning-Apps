//
//  GetImageFromURL.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 10/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import "PhotoObject.h"
#import "DetailsViewController.h"

@protocol GetImageFromURLDelegate <NSObject>
@required

- (void) imageDidLoadFor:(NSIndexPath *)indexPath;

@end

@interface GetImageFromURL : NSObject  <DetailsControllerDelegate>
@property (weak) id <GetImageFromURLDelegate> delegate;

- (instancetype)initWithSession:(NSURLSession *)session;
- (void)addPhotoItem:(PhotoObject *)photoItem;
- (void)clearData;
- (void)downloadImageFor:(NSIndexPath *)indexPath;
- (void)removeImageFor:(NSIndexPath *)indexPath;
- (UIImage *)getImageFor:(NSIndexPath *)indexPath;
- (void)setImageCellHeight:(CGFloat)height AtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)getImageRatioFor:(NSIndexPath *)indexPath;
- (CGFloat)getImageCellHeightAtIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)getImagesCount;

@end
