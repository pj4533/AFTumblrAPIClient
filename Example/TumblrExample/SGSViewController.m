//
//  SGSViewController.m
//  TumblrExample
//
//  Created by PJ Gray on 3/9/13.
//  Copyright (c) 2013 Say Goodnight Software. All rights reserved.
//

#import "SGSViewController.h"
#import "AFTumblrAPIClient.h"

@interface SGSViewController ()

@end

@implementation SGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[AFTumblrAPIClient sharedClient] authenticateWithCompletion:^{
        [[AFTumblrAPIClient sharedClient] getBlogNamesWithSuccess:^(NSArray *blogsArray) {
            
            NSLog(@"BLOGS: %@", blogsArray);
            
        } withFailure:^{
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
