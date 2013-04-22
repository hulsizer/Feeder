//
//  CLMOAuthClient.h
//  Feeder
//
//  Created by Andrew Hulsizer on 4/21/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMOAuthClient : NSObject

- (id)initWithAppID:(NSString*)appID secret:(NSString*)secret redirectURL:(NSURL*)redirectURL;

- (void)requestAuthorization;

@end
