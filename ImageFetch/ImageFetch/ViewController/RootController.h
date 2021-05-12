//
//  RootController.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootControllerDelegate <NSObject>

- (void) reloadImage;

@end

@interface RootController : UIViewController

@end
