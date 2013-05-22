//
//  CLMDataManager.h
//  Feeder
//
//  Created by Andrew Hulsizer on 5/7/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^dataCompletion)(NSError *error,BOOL success, id data);
typedef void (^dataSuccess)(NSError *error, id data);
typedef void (^dataFailure)(NSError *error, id data);

@interface CLMDataManager : NSObject

+ (instancetype)sharedManager;

//Fetch Requests
- (void)fetchUserDataWithSuccess:(dataSuccess)successBlock andFailure:(dataFailure)failureBlock;
@end
