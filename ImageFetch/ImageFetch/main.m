//
//  main.m
//  ImageFetch
//
//  Created by OUT-Nikitin-SA1 on 24/12/2019.
//  Copyright © 2019 OUT-Nikitin-SA1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
