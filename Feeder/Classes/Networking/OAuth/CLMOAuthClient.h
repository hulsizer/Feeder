//
//  CLMOAuthClient.h
//  Feeder
//
//  Created by Andrew Hulsizer on 4/21/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CLMOAuthClient : AFHTTPClient

+ (instancetype)clientWithBaseURL:(NSURL *)baseURL
                         clientID:(NSString *)clientID
                     clientSecret:(NSString *)clientSecret
                      redirectURL:(NSURL *)redirectURL;

- (id)initWithBaseURL:(NSURL *)baseURL
             clientID:(NSString *)clientID
         clientSecret:(NSString *)clientSecret
          redirectURL:(NSURL *)redirectURL;

- (void)requestAuthorizationInWebView:(UIWebView *)webView;
@end
