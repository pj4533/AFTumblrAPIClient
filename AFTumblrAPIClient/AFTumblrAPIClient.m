//
//  AFTumblrAPIClient.m
//
//  Created by PJ Gray on 2/18/13.
//

#import "AFTumblrAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kTumblrAPIBaseURLString = @"http://api.tumblr.com/v2/";

@interface AFTumblrAPIClient () {
    NSString* _callbackUrlString;
    NSString* _key;
    NSString* _secret;
}

@end

@implementation AFTumblrAPIClient


- (id)initWithKey:(NSString *)key
           secret:(NSString *)secret
callbackUrlString:(NSString *)callbackUrlString {
    self = [super initWithBaseURL:[NSURL URLWithString:kTumblrAPIBaseURLString] key:key secret:secret];
    if (!self) {
        return nil;
    }
    
    _callbackUrlString = callbackUrlString;
    _key = key;
    _secret = secret;

    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* tokenkey = [currentDefaults objectForKey:@"oauth_token"];
    NSString* tokensecret = [currentDefaults objectForKey:@"oauth_token_secret"];
    if (tokenkey) {
        self.accessToken = [[AFOAuth1Token alloc] initWithQueryString:[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@", tokenkey, tokensecret]];
    }
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/x-www-form-urlencoded"]];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    return self;

}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    
    
    // if we are doing oauth then set the content type to xml,
    // otherwise add accept for text/plain so we process the JSON correctly.
    NSRange textRange;
    textRange =[path rangeOfString:@"oauth"];
    if(textRange.location == NSNotFound) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    
    return request;
}

- (void)acquireOAuthAccessTokenWithPath:(NSString *)path
                           requestToken:(AFOAuth1Token *)requestToken
                           accessMethod:(NSString *)accessMethod
                                success:(void (^)(AFOAuth1Token *accessToken))success
                                failure:(void (^)(NSError *error))failure
{
    self.accessToken = requestToken;
    [super acquireOAuthAccessTokenWithPath:path requestToken:requestToken accessMethod:accessMethod success:success failure:failure];
}

- (void)authorizeUsingOAuthWithRequestTokenPath:(NSString *)requestTokenPath
                          userAuthorizationPath:(NSString *)userAuthorizationPath
                                    callbackURL:(NSURL *)callbackURL
                                accessTokenPath:(NSString *)accessTokenPath
                                   accessMethod:(NSString *)accessMethod
                                        success:(void (^)(AFOAuth1Token *accessToken))success
                                        failure:(void (^)(NSError *error))failure {

    
    [super authorizeUsingOAuthWithRequestTokenPath:requestTokenPath
                             userAuthorizationPath:userAuthorizationPath
                                       callbackURL:callbackURL
                                   accessTokenPath:accessTokenPath
                                      accessMethod:accessMethod
                                           success:^(AFOAuth1Token *accessToken) {
                                               
                                               NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                                               [currentDefaults setObject:accessToken.key forKey:@"oauth_token"];
                                               [currentDefaults setObject:accessToken.secret forKey:@"oauth_token_secret"];
                                               [currentDefaults synchronize];
                                               success(accessToken);
                                           }
                                           failure:failure];
}

- (BOOL) isAuthenticated {
    if (self.accessToken) {
        return YES;
    } else {
        return NO;
    }
    
    return NO;
}

- (void) authenticateWithCompletion:(void (^)())completion {
    AFTumblrAPIClient* oauthClient = [[AFTumblrAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.tumblr.com/"]
                                                                            key:_key
                                                                         secret:_secret];
    [oauthClient authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token"
                                   userAuthorizationPath:@"oauth/authorize"
                                             callbackURL:[NSURL URLWithString:_callbackUrlString]
                                         accessTokenPath:@"oauth/access_token"
                                            accessMethod:@"POST"
                                                 success:^(AFOAuth1Token *accessToken) {
                                                     self.accessToken = accessToken;
                                                     completion();
                                                 }
                                                 failure:^(NSError *error) {
                                                     NSLog(@"FAIL: %@", error);
                                                 }];

}

- (void) getBlogNamesWithSuccess:(void (^)(NSArray* blogsArray))success withFailure:(void (^)())failure {
    [self getPath:@"user/info"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary* responseDict = [responseObject objectForKey:@"response"];
              NSDictionary* userDict = [responseDict objectForKey:@"user"];
              NSArray* blogsArray = [userDict objectForKey:@"blogs"];
              success(blogsArray);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"ERROR: %@", error);
              failure();
          }];
}

- (void) postPhotoWithData:(NSData *)photoData
                  withTags:(NSString *)tags
          withClickThruUrl:(NSString *)clickThruUrl
               withCaption:(NSString *)captionText
          intoBlogHostName:(NSString *)blogHostName
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{

    NSDictionary* params = @{
                             @"type" : @"photo",
                             @"tags" : tags,
                             @"caption" : captionText
                             };
    
    
    
    NSMutableURLRequest* request = [self multipartFormRequestWithMethod:@"POST"
                                                                   path:[NSString stringWithFormat:@"blog/%@/post", blogHostName]
                                                             parameters:params
                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                  [formData appendPartWithFileData:photoData name:@"data" fileName:@"photo.jpg" mimeType:@"image/jpg"];
                                              }];

	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

@end
