//
//  DetailsViewController.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 28/01/2020.
//  Copyright © 2020 OUT-Nikitin-SA1. All rights reserved.
//

#import "DetailsViewController.h"
#import "RootController.h"

static NSString * const photoText = @"%@ by %@";

@interface DetailsViewController () <RootControllerDelegate>

@property (strong, nonatomic) PhotoObject *photoData;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoData = [self.delegate getPhotoObjectFor:self.detailPhotoIndex];
    self.photo.image = self.photoData.image;
    if (!(self.photo.image)) {
        [self.loadingIndicator startAnimating];
    }
    NSString *title = [self.photoData.data objectForKey:@"title"];
    NSString *owner = [self.photoData.data objectForKey:@"ownername"];
    NSString *textString = [NSString stringWithFormat:photoText, title, owner];
    self.photoLabel.text = textString;
}

- (IBAction)gotoFlickrButton:(UIButton *)sender {
    UIApplication *flickrApp = [UIApplication sharedApplication];
    BOOL canOpenURL = [flickrApp canOpenURL:self.photoData.pageURL];
    if (!canOpenURL) {
        return ;
    }
    [flickrApp openURL:self.photoData.pageURL options:@{} completionHandler:nil];
}

- (void) reloadImage {
    [self.loadingIndicator stopAnimating];
    [UIView transitionWithView:self.photo
      duration:0.4f
       options:UIViewAnimationOptionTransitionCrossDissolve
    animations:^{
        self.photo.image = self.photoData.image;
    } completion:nil];
    NSLog(@"Say lala, to world!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
