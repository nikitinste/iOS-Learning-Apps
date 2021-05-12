//
//  FlickrRestRequest.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrRestRequest : NSObject

@property (assign, nonatomic, readonly) NSInteger page;
@property (assign, nonatomic, readonly) NSInteger perPage;
@property (assign, nonatomic, readonly) NSInteger pages;
@property (assign, nonatomic, readonly) NSInteger total;

- (NSURL*  _Nullable)generateNewRequestWithText:(NSString* _Nonnull)text;
- (NSURL*  _Nullable)generateRandomRequest;
- (NSURL* _Nullable)generateNextRequest;
- (BOOL)updatePagesInfoFrom:(NSDictionary* _Nullable)response;

@end
