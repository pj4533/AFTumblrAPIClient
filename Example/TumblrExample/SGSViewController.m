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

    // First create the client
    AFTumblrAPIClient* tumblrClient = [[AFTumblrAPIClient alloc] initWithKey:kTumblrAPITokenString
                                                                      secret:kTumblrAPISecretString
                                                           callbackUrlString:kTumblrCallbackURLString];
    
    
    // Check if we previously authenticated
    if ([tumblrClient isAuthenticated]) {
        
        // If so, just make a call
        [tumblrClient getBlogNamesWithSuccess:^(NSArray *blogsArray) {
            
            NSLog(@"BLOGS: %@", blogsArray);
            
        } withFailure:^{
            
        }];
    } else {
        
        // If not, authenticate
        [tumblrClient authenticateWithCompletion:^{
            
            // Then make a call
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
