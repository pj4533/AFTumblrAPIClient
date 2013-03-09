//
//  SGSViewController.m
//  TumblrExample
//
//  Created by PJ Gray on 3/9/13.
//  Copyright (c) 2013 Say Goodnight Software. All rights reserved.
//

#import "SGSViewController.h"
#import "AFTumblrAPIClient.h"

NSString * const kTumblrAPITokenString = @"YOUR-KEY-HERE";
NSString * const kTumblrAPISecretString = @"YOUR-SECRET-HERE";
NSString * const kTumblrCallbackURLString = @"YOUR-SCHEME-HERE://success";

@interface SGSViewController ()

@end

@implementation SGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AFTumblrAPIClient* tumblrClient = [[AFTumblrAPIClient alloc] initWithKey:kTumblrAPITokenString secret:kTumblrAPISecretString callbackUrlString:kTumblrCallbackURLString];
    
    if ([tumblrClient isAuthenticated]) {
        [tumblrClient getBlogNamesWithSuccess:^(NSArray *blogsArray) {
            
            NSLog(@"BLOGS: %@", blogsArray);
            
        } withFailure:^{
            
        }];
    } else {
        [tumblrClient authenticateWithCompletion:^{
            [tumblrClient getBlogNamesWithSuccess:^(NSArray *blogsArray) {
                
                NSLog(@"BLOGS: %@", blogsArray);
                
            } withFailure:^{
                
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
