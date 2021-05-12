//
//  ImageTableViewCell.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageTableViewCell : UITableViewCell

- (void)setImageItem:(UIImage*)imageItem;
- (void)setConstraintsForCell:(BOOL)bottom;
- (void)indicatorStartLoading;
- (void)indicatorStopLoading;

@end

NS_ASSUME_NONNULL_END
