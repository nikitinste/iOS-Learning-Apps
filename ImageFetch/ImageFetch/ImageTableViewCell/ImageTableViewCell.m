//
//  ImageTableViewCell.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatotCenterConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation ImageTableViewCell

@synthesize imageView = _imageView;
@synthesize bottomConstraint = _bottomConstraint;
@synthesize indicatotCenterConstraint = _indicatotCenterConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor* backgroundColor = [UIColor colorNamed:@"backgroundColor"];
    [self setBackgroundColor:backgroundColor];
}

- (void)setImageItem:(UIImage*)imageItem {
    self.imageView.image = imageItem;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)indicatorStartLoading {
    [self.loadingIndicator startAnimating];
}

- (void)indicatorStopLoading {
    [self.loadingIndicator stopAnimating];
}

- (void)setConstraintsForCell:(BOOL)bottom {
    if (bottom) {
        self.bottomConstraint.constant = 0;
    } else {
        self.bottomConstraint.constant = 8;
    }
}

@end
