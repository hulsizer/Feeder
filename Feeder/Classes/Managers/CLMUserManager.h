//
//  CLMUserManager.h
//  Feeder
//
//  Created by Andrew Hulsizer on 5/7/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLMUser.h"

typedef NS_ENUM(int, AccountType)
{
    FacebookAccount = 0,
    TwitterAccount,
    AccountCount
};

@interface CLMUserManager : NSObject

@property (nonatomic, readonly) CLMUser *user;

+ (instancetype)sharedManager;

- (void)logout;
- (void)login:(AccountType)accountType;
@end
