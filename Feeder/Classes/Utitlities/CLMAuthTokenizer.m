//
//  CLMAuthTokenizer.m
//  Feeder
//
//  Created by Andrew Hulsizer on 5/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMAuthTokenizer.h"

#define SALT 13291989
#define USER_HASH 16121989

@implementation CLMAuthTokenizer

- (NSString *)userIDHash:(NSString *)userID
{
    return userID;
}

- (NSURL *)tokenizeStringToURL:(NSString *)string
{
    return [NSURL URLWithString:string];
}

- (NSURL *)tokenizeURLToURL:(NSURL *)url
{
    return url;
}

- (NSString *)tokenizeStringToString:(NSString *)string
{
    return string;
}

- (NSString *)tokenizeURLToString:(NSURL *)url
{
    return [url absoluteString];
}
@end
