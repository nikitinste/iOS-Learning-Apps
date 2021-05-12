//
//  PhotoObject.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 22/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoObject : NSObject

@property (nonatomic, readonly)  NSDictionary<NSString*, NSString*> * _Nullable data;
@property (nonatomic, readonly) NSURL * _Nullable url;
@property (nonatomic, readonly) NSURL * _Nullable pageURL;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic) UIImage * _Nullable image;
@property (nonatomic) CGFloat imageRatio;
@property (nonatomic) BOOL imageIsLoading;

- (instancetype _Nonnull) initWithDictionary:(NSDictionary * _Nonnull)dictionary;
- (void) setCellHeight:(CGFloat)height;
- (void) removeImage;

@end
