//
//  CLMDataManager.m
//  Feeder
//
//  Created by Andrew Hulsizer on 5/7/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMDataManager.h"

static CLMDataManager *sharedManager;

@implementation CLMDataManager


+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager)
        {
            sharedManager = [[CLMDataManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (void)fetchUserDataWithSuccess:(dataSuccess)successBlock andFailure:(dataFailure)failureBlock
{
    successBlock(nil, @[@"www.kotaku.com"]);
}

@end
