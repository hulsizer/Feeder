//
//  CLMAuthTokenizer.h
//  Feeder
//
//  Created by Andrew Hulsizer on 5/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMAuthTokenizer : NSObject

- (NSString *)userIDHash:(NSString *)userID;

- (NSURL *)tokenizeStringToURL:(NSString *)string;
- (NSURL *)tokenizeURLToURL:(NSURL *)url;
- (NSString *)tokenizeStringToString:(NSString *)string;
- (NSString *)tokenizeURLToString:(NSURL *)url;
@end
