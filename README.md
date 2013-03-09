# AFTumblrAPIClient

An AFOAuth1Client subclass for easily authenticating and using Tumblr.

## Instructions

Register your application to [launch from a custom URL scheme](http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html), and use that with the path `/success` as your callback URL.

Here's how it all looks together:

``` objective-c
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
```

## Contact

PJ Gray

- http://github.com/pj4533
- http://twitter.com/pj4533
- pj@pj4533.com

## License

AFTumblrAPIClient is available under the MIT license. See the LICENSE file for more info.

