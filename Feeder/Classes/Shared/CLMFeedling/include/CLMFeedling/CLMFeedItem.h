//
//  CLMFeedElement.h
//  CLMFeedling
//
//  Created by Andrew Hulsizer on 3/18/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLMFeedItem <NSObject>

@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *guid;

@end

@interface CLMFeedItem : NSObject <CLMFeedItem>

@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *guid;

@end
