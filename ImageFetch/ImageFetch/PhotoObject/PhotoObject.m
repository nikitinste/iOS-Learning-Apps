//
//  PhotoObject.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 22/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import "PhotoObject.h"

static NSString * const kFlickrURL = @"https://farm%@.staticflickr.com/%@/%@_%@.jpg";
static NSString * const pageFlickrURL = @"https://www.flickr.com/photos/%@/%@";

@interface PhotoObject ()

@property (nonatomic, readwrite) NSDictionary<NSString*, NSString*> * _Nullable data;
@property (nonatomic, readwrite) NSURL * _Nullable url;
@property (nonatomic, readwrite) NSURL * _Nullable pageURL;
@property (nonatomic, readwrite) CGFloat cellHeight;

@end

@implementation PhotoObject

@synthesize data = _data;
@synthesize url = _url;
@synthesize pageURL = _pageURL;
@synthesize cellHeight = _cellHeight;

- (instancetype) initWithDictionary:(NSDictionary<NSString*, NSString*>*)dictionary {
    if (self = [super init]) {
        _cellHeight = 0;
        self.imageRatio = 0;
        _data = dictionary;
        [self generateURLs];
        self.image = nil;
        self.imageIsLoading = NO;
    }
    return self;
}

- (void) generateURLs {
    NSString *farm = [self.data objectForKey:@"farm"];
    NSString *server = [self.data objectForKey:@"server"];
    NSString *imageID = [self.data objectForKey:@"id"];
    NSString *userID = [self.data objectForKey:@"owner"];
    NSString *secret = [self.data objectForKey:@"secret"];
    NSString *urlString = [[NSString alloc] initWithFormat:kFlickrURL, farm, server, imageID, secret];
    NSString *pageURLstring = [[NSString alloc] initWithFormat:pageFlickrURL, userID, imageID];
    
    NSLog(@"%@", urlString);
    NSLog(@"%@", pageURLstring);
    
    _url = [[NSURL alloc] initWithString:urlString];
    _pageURL = [[NSURL alloc] initWithString:pageURLstring];
}

- (void) setCellHeight:(CGFloat)height {
    _cellHeight = height;
}

- (void) removeImage {
    _image = nil;
}

@end
