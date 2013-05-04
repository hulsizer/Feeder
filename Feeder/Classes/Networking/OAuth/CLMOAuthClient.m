//
//  CLMOAuthClient.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/21/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMOAuthClient.h"
#import "CLMAuthCredential.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+QueryString.h"

@interface CLMOAuthClient () <UIWebViewDelegate>

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURL;

@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation CLMOAuthClient 

- (NSString *)requestPath
{
    return @"";
}

+ (instancetype)clientWithBaseURL:(NSURL *)baseURL
                         clientID:(NSString *)clientID
                     clientSecret:(NSString *)clientSecret
                      redirectURL:(NSURL *)redirectURL
{
    return [[self alloc] initWithBaseURL:baseURL clientID:clientID clientSecret:clientSecret redirectURL:redirectURL];
}

- (id)initWithBaseURL:(NSURL *)baseURL
             clientID:(NSString *)clientID
         clientSecret:(NSString *)clientSecret
          redirectURL:(NSURL *)redirectURL
{
    self = [super initWithBaseURL:baseURL];
    if (self)
    {
        _clientID = clientID;
        _clientSecret = clientSecret;
        _redirectURL = redirectURL;
    }
    return self;
}

- (NSURLRequest *)userAuthorizationRequestWithParameters:(NSDictionary *)additionalParameters;
{
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"web_server" forKey:@"type"];
    [params setValue:self.clientID forKey:@"client_id"];
    [params setValue:[self.redirectURL absoluteString] forKey:@"redirect_uri"];
    [params setValue:@"token" forKey:@"response_type"];
    [params setValue:@"https://www.googleapis.com/auth/userinfo.email" forKey:@"scope"];
    
    if (additionalParameters) {
        for (NSString *key in additionalParameters) {
            [params setValue:[additionalParameters valueForKey:key] forKey:key];
        }
    }
    NSURL *fullURL = [NSURL URLWithString:[[[self.baseURL absoluteString] stringByAppendingPathComponent:[self requestPath]] stringByAppendingFormat:@"?%@", [params stringWithFormEncodedComponents]]];
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:fullURL];
    [authRequest setHTTPMethod:@"GET"];
    
    return [authRequest copy];
}

- (void)requestAuthorizationInWebView:(UIWebView *)webView
{
    webView.delegate = self;
    [webView loadRequest:[self userAuthorizationRequestWithParameters:nil]];
}

//Rename
- (void)verifyAuthorizationWithAccessCode:(NSString *)path
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(CLMAuthCredential *credential))success
                                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableParameters setObject:self.clientID forKey:@"client_id"];
    [mutableParameters setValue:self.clientSecret forKey:@"client_secret"];
    [mutableParameters setValue:[self.redirectURL absoluteString] forKey:@"redirect_uri"];
    parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    [self clearAuthorizationHeader];
   
    NSLog(@"%@", [parameters stringWithFormEncodedComponents]);
    
    NSMutableURLRequest *mutableRequest = [self requestWithMethod:@"POST" path:path parameters:parameters];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
        
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:mutableRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseObject = [NSDictionary dictionaryWithFormEncodedString:operation.responseString];
       
        if ([responseObject valueForKey:@"error"]) {
            if (failure) {
                // TODO: Resolve the `error` field into a proper NSError object
                // http://tools.ietf.org/html/rfc6749#section-5.2
                failure(nil);
            }
            
            return;
        }
        
        NSString *refreshToken = [responseObject valueForKey:@"refresh_token"];
        if (refreshToken == nil || [refreshToken isEqual:[NSNull null]]) {
            refreshToken = [parameters valueForKey:@"refresh_token"];
        }
        
        CLMAuthCredential *credential = [CLMAuthCredential credentialWithOAuthToken:[responseObject valueForKey:@"access_token"] tokenType:[responseObject valueForKey:@"token_type"]];
        
        NSDate *expireDate = nil;
        id expiresIn = [responseObject valueForKey:@"expires"];
        if (expiresIn != nil && ![expiresIn isEqual:[NSNull null]]) {
            expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
        }
        
        [credential setRefreshToken:refreshToken expiration:expireDate];
        
        [self setAuthorizationHeaderWithCredential:credential];
        
        if (success) {
            success(credential);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    [self enqueueHTTPRequestOperation:requestOperation];
}

- (void)extractCredentialsFromResponse:(NSDictionary*)response
{
    [self verifyAuthorizationWithAccessCode:@"oauth/access_token" parameters:response success:^(CLMAuthCredential *credential) {
        
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    // Use the "Bearer" type as an arbitrary default
    [self setAuthorizationHeaderWithToken:token ofType:@"Bearer"];
}

- (void)setAuthorizationHeaderWithCredential:(CLMAuthCredential *)credential {
    [self setAuthorizationHeaderWithToken:credential.accessToken ofType:credential.tokenType];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token
                                 ofType:(NSString *)type
{
    // http://tools.ietf.org/html/rfc6749#section-7.1
    // The Bearer type is the only finalized type
    if ([[type lowercaseString] isEqualToString:@"bearer"]) {
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", token]];
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:[self.redirectURL absoluteString]])
    {
        //Grab the token
        [self extractCredentialsFromResponse:[NSDictionary dictionaryWithFormEncodedString:request.URL.query]];
        //start AFHTTPOperation to get the actual token
        return NO;
    }
    
    return YES;
}

/**
 * custom URL schemes will typically cause a failure so we should handle those here
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
@end
