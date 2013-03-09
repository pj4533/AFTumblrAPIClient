//
//  AFTumblrAPIClient.h
//
//  Created by PJ Gray on 2/18/13.
//

#import "AFOAuth1Client.h"

@interface AFTumblrAPIClient : AFOAuth1Client

- (id)initWithKey:(NSString *)key
           secret:(NSString *)secret
callbackUrlString:(NSString *)callbackUrlString;

- (BOOL) isAuthenticated;
- (void) authenticateWithCompletion:(void (^)())completion;

- (void) getBlogNamesWithSuccess:(void (^)(NSArray* blogsArray))success withFailure:(void (^)())failure;

- (void) postPhotoWithData:(NSData *)photoData
                  withTags:(NSString *)tags
          withClickThruUrl:(NSString *)clickThruUrl
               withCaption:(NSString *)captionText
          intoBlogHostName:(NSString *)blogHostName
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
