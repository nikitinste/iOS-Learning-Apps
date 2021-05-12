//
//  SearchResult.h
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 30/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetImageFromURL.h"

@protocol SearchResultDelegate <NSObject>
@required

- (void) searchResultReceived;
- (void) nextSearchResultReceived;

@end

@interface SearchResult : NSObject
@property (weak, nonatomic) id <SearchResultDelegate> delegate;
@property (nonatomic, readonly)  BOOL isLastPage;

- (instancetype)initWithImageFromURLs: (GetImageFromURL*)images session:(NSURLSession*)session;
- (void)setSearchRequest:(NSString *)textInput;
- (NSInteger)getCount;
- (void)sendRequest;
- (void)sendNextRequest;

@end
