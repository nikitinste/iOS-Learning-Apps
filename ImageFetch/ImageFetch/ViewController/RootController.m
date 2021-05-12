//
//  ViewController.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import "RootController.h"
#import "ImageTableViewCell.h"
#import "SearchResult.h"
#import "DetailsViewController.h"

@interface RootController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GetImageFromURLDelegate, SearchResultDelegate, UITableViewDataSourcePrefetching>

@property (weak) id <RootControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) GetImageFromURL *imageFromURL;
@property (strong, nonatomic) SearchResult *searchResult;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSIndexPath *detailPhotoIndex;

@end

@implementation RootController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    [self imageFromURSetup];
    [self searchResultSetup];
    [self.view setBackgroundColor:UIColor.systemBackgroundColor];
    [self searchBarSetup];
    [self tableViewSetup];
    [self.searchResult sendRequest];
    self.detailPhotoIndex = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back to photos"
        style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)searchBarSetup {
    self.searchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    [self.searchResult setSearchRequest:self.searchBar.text];
    [self.searchResult sendRequest];
}

- (void)searchResultSetup {
    self.searchResult = [[SearchResult alloc] initWithImageFromURLs:self.imageFromURL session:self.session];
    self.searchResult.delegate = self;
}

- (void) searchResultReceived {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self.tableView reloadData];
        if ([self.searchResult getCount]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });
}

- (void) nextSearchResultReceived {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self.tableView reloadData];
    });
}

- (void)tableViewSetup {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.prefetchDataSource = self;
    [[self tableView] registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImageId"];
    UIColor* backgroundColor = [UIColor colorNamed:@"backgroundColor"];
    
    [self.tableView setBackgroundColor:backgroundColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImageId"];
    [cell indicatorStartLoading];
    UIImage* image = [self.imageFromURL getImageFor:indexPath];
    [cell setImageItem:image];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [self.imageFromURL getImageCellHeightAtIndexPath:indexPath];
    if (rowHeight) {
        return rowHeight;
    }
    CGFloat imageRatio = [self.imageFromURL getImageRatioFor:indexPath];
    if (imageRatio) {
        rowHeight = (CGRectGetWidth(tableView.frame) / imageRatio) + 8;
        [self.imageFromURL setImageCellHeight:rowHeight AtIndexPath:indexPath];
        return rowHeight;
    }
    return 250;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [self.imageFromURL getImageCellHeightAtIndexPath:indexPath];
    if (rowHeight) {
        return rowHeight;
    }
    return 250;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ImageTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.imageFromURL downloadImageFor:indexPath];
    
    if (indexPath.item == [tableView numberOfRowsInSection:0] - 1) {
        [self.searchResult sendNextRequest];
        if (self.searchResult.isLastPage) {
            [cell setConstraintsForCell:YES];
        }
    } else {
        [cell setConstraintsForCell:NO];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResult getCount];
}

/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar endEditing:YES];
    return indexPath;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.searchBar.searchTextField isFirstResponder]) {
        [self.searchBar endEditing:YES];
        return ;
    }
    self.detailPhotoIndex = indexPath;
    [self performSegueWithIdentifier:@"SegueToSinglePhoto" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToSinglePhoto"]) {
        DetailsViewController *detailsController = (DetailsViewController *)segue.destinationViewController;
        detailsController.detailPhotoIndex = self.detailPhotoIndex;
        self.delegate = detailsController;
    }
}


- (IBSegueAction DetailsViewController *)showDetails:(NSCoder *)coder {
    DetailsViewController *detailsController = [[DetailsViewController alloc] initWithCoder:coder];
    detailsController.delegate = self.imageFromURL;
    return detailsController;
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSMutableString *cellsString = [[NSMutableString alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [cellsString appendFormat:@":%li", indexPath.item];
        [self.imageFromURL downloadImageFor:indexPath];
    }
}

- (void)imageFromURSetup {
    self.imageFromURL = [[GetImageFromURL alloc] initWithSession:self.session];
    self.imageFromURL.delegate = self;
}

- (void) imageDidLoadFor:(NSIndexPath*)indexPath {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        ImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell indicatorStopLoading];
        if (self != self.navigationController.topViewController) {
            NSLog(@"image for index: %li did load on background", indexPath.item);
            if (indexPath == self.detailPhotoIndex) {
                [self.delegate reloadImage];
            }
            return ;
        }
        if (![self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            return ;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    });
}

@end
