//
//  ImageDataSource.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 27/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDataSource : NSObject

- (UIImage*)getImage:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
