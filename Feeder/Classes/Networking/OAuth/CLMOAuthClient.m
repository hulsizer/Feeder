//
//  CLMOAuthClient.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/21/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMOAuthClient.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface CLMOAuthClient () <UIWebViewDelegate>

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURL;

@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation CLMOAuthClient 

- (id)initWithAppID:(NSString*)appID secret:(NSString*)secret redirectURL:(NSURL*)redirectURL
{
	self = [super init];
	if (self)
	{
		_clientID = appID;
		_clientSecret = secret;
		_redirectURL = redirectURL;
	}
	return self;
}

- (void)requestAuthorization
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:@""];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
}
@end
