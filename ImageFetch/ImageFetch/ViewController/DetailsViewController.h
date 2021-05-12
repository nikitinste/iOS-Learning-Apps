//
//  DetailsViewController.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 28/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoObject.h"

@protocol DetailsControllerDelegate <NSObject>
@required

- (PhotoObject *)getPhotoObjectFor:(NSIndexPath *)indexPath;

@end

@interface DetailsViewController : UIViewController
@property (weak) id <DetailsControllerDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *detailPhotoIndex;

@end
