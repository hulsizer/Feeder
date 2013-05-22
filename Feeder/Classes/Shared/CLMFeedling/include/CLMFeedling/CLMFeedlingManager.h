//
//  CLMFeedlingManager.h
//  CLMFeedling
//
//  Created by Andrew Hulsizer on 3/18/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMFeedlingManager : NSObject

+ (CLMFeedlingManager*)sharedFeedling;

- (void)refreshFeeds;
- (void)refreshFeedsInCategory:(NSString*)category;
- (void)addFeed:(NSString*)feedURL;
- (void)addFeed:(NSString*)feedURL toCategory:(NSString*)category;
@end
