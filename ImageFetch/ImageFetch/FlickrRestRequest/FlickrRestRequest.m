//
//  FlickrRestRequest.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import "FlickrRestRequest.h"
#include <stdlib.h>

static NSString * const kFlickrREST = @"%@&page=%li&per_page=%li&text=%@";
static NSString * const requestHeader = @"https://www.flickr.com/services/rest/?format=json&nojsoncallback=?&method=flickr.photos.search&api_key=1b94d18c639e8a1dfa52855ca21ef65f&sort=relevance&content_type=1&extras=owner_name";

@interface FlickrRestRequest ()

@property (nonatomic, readwrite) NSInteger page;
@property (nonatomic, readwrite) NSInteger perPage;
@property (nonatomic, readwrite) NSInteger pages;
@property (nonatomic, readwrite) NSInteger total;
@property (nonatomic) NSArray<NSString*>* defaultRequestText;
@property (nonatomic) NSString * _Nullable requestText;

@end

@implementation FlickrRestRequest

@synthesize page = _page;
@synthesize perPage = _perPage;
@synthesize pages = _pages;
@synthesize total = _total;

- (instancetype)init {
    if(self = [super init]) {
        self.defaultRequestText = @[@"waves", @"surfing", @"waveporn", @"surfers", @"big waves", @"surfing girls", @"wave", @"surfer"];
        self.page = 1;
        self.perPage = 50;
        self.pages = 0;
        self.total = 0;
        self.requestText = nil;
    }
    return self;
}

- (NSURL*)generateNewRequestWithText:(NSString*)text {
    self.page = 1;
    self.pages = 0;
    self.total = 0;
    return [self generateRequestWithText:text];
}

- (NSURL*)generateRequestWithText:(NSString*)text {
    self.requestText = text;
    NSString * urlText = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString* requestString = [NSString stringWithFormat:kFlickrREST, requestHeader, self.page, self.perPage, urlText];
    NSLog(@"Generating request:\n%@", requestString);
    return [NSURL URLWithString:requestString];
}

- (NSURL*)generateNextRequest {
    if (self.requestText && self.page < self.pages) {
        self.page += 1;
        return [self generateRequestWithText:self.requestText];
    }
    return nil;
}

- (NSURL*)generateRandomRequest {
    self.requestText = self.defaultRequestText[arc4random_uniform((int)self.defaultRequestText.count)];
    return [self generateRequestWithText:self.requestText];
}

- (BOOL)updatePagesInfoFrom:(NSDictionary<NSString*, NSString*>*)response {
    self.pages = [[response objectForKey:@"pages"] integerValue];
    self.total = [[response objectForKey:@"total"] integerValue];
    NSLog(@"page:%li, pages:%li, per page:%li, total:%li", self.page, self.pages, self.perPage, self.total);
    if (self.page == self.pages || self.pages == 0) {
        return YES;
    }
    return NO;
}

@end
