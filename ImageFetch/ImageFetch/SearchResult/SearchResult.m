//
//  SearchResult.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 30/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import "SearchResult.h"
#import "FlickrRestRequest.h"

@interface SearchResult ()

@property (nonatomic, readwrite) BOOL isLastPage;
@property (nonatomic) NSString * _Nullable requestText;
@property (nonatomic) NSInteger count;
@property (strong, nonatomic) FlickrRestRequest * _Nonnull request;
@property (strong, nonatomic) GetImageFromURL * _Nonnull images;

@property (strong, nonatomic) NSURLSession * _Nonnull session;
@property (strong, nonatomic) dispatch_queue_t downloadQueue;

@end

@implementation SearchResult

@synthesize isLastPage = _isLastPage;

- (instancetype)initWithImageFromURLs: (GetImageFromURL*)images session:(NSURLSession*)session {
    self = [super init];
    if(self) {
        _isLastPage = NO;
        self.requestText = nil;
        self.count = 0;
        self.images = images;
        self.session = session;
        self.request = [[FlickrRestRequest alloc] init];
        self.downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (void)setSearchRequest:(NSString *)textInput {
    if (textInput) {
        NSLog(@"Request: %@", textInput);
        self.requestText = textInput;
    } else {
        NSLog(@"Error: Empty request string");
    }
}

- (void)sendRequest {
    NSURL *requestURL = self.requestText? [self.request generateNewRequestWithText:self.requestText] : [self.request generateRandomRequest];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && data) {
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                  
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            if (error) {
                NSLog(@"Json error:\n\t\t%@", error);
            }
            [self.images clearData];
            
            [self mapFlickrJSON:responseDictionary];
            self.count = [self.images getImagesCount];
            [self.delegate searchResultReceived];
        } else {
            NSLog(@"Error:\n%@", error);
        }
    }];
    dispatch_async(self.downloadQueue, ^{
        [dataTask resume];
    });
}

- (void)sendNextRequest {
    NSURL *requestURL = [self.request generateNextRequest];
    if (requestURL) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error && data) {
                NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                      
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

                if (error) {
                    NSLog(@"Json error:\n\t\t%@", error);
                }
                
                [self mapFlickrJSON:responseDictionary];
                self.count = [self.images getImagesCount];
                [self.delegate nextSearchResultReceived];
                
            } else {
                NSLog(@"Error:\n%@", error);
            }
        }];
        dispatch_async(self.downloadQueue, ^{
            [dataTask resume];
        });
    }
}

- (void)mapFlickrJSON:(NSDictionary *)flickrResponse {
    for (id key in flickrResponse) {
        if ([key  isEqual: @"photos"]) {
            NSDictionary *photos = [flickrResponse objectForKey:key];
            for (id albumKey in photos) {
                if ([albumKey isEqual:@"photo"]) {
                    for (NSDictionary* photoData in [[flickrResponse objectForKey:key] objectForKey:albumKey]) {
                        PhotoObject* photoItem = [[PhotoObject alloc] initWithDictionary:photoData];
                        [self.images addPhotoItem:photoItem];
                    }
                }
            }
            _isLastPage = [self.request updatePagesInfoFrom:photos];
        }
    }
}

- (NSInteger)getCount {
    return self.count;
}

@end
