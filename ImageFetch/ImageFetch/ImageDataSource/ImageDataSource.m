//
//  ImageDataSource.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 27/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import "ImageDataSource.h"

@interface ImageDataSource ()


@property (strong, nonatomic) NSArray* imageName;

@end

@implementation ImageDataSource

- (id)init {
    self = [super init];
    if(self) {
        self.imageName = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    }
    return self;
}

- (UIImage*)getImage:(NSIndexPath*)indexPath {
    return [UIImage imageNamed:self.imageName[indexPath.item % 3]];
}

@end
