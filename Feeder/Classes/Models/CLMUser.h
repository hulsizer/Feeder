//
//  CLMUser.h
//  Feeder
//
//  Created by Andrew Hulsizer on 5/7/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMUser : NSObject

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSArray *feedURLs;
@end
