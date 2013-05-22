//
//  CLMUserManager.m
//  Feeder
//
//  Created by Andrew Hulsizer on 5/7/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMUserManager.h"
#import "CLMConstants.h"
#import "CLMDataManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

static CLMUserManager *sharedManager;
typedef void (^accountCompletionBlock)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

@interface CLMUserManager ()

@property (nonatomic, strong) CLMUser *user;
@end

@implementation CLMUserManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager)
        {
            sharedManager = [[CLMUserManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (void)logout
{
    [self publishNotification:CLMUserAccountLogoutNotification];
}

- (void)login:(AccountType)accountType
{
    switch (accountType) {
        case FacebookAccount:
            [self loginFacebook];
            break;
        case TwitterAccount:
            [self loginTwitter];
        default:
            break;
    }
}

#pragma mark - Account Logins
- (void)loginFacebook
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookTypeAccount = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                          options:@{ACFacebookAppIdKey: FacebookClientID, ACFacebookPermissionsKey: @[@"email"]}
                                       completion:^(BOOL granted, NSError *error) {
                                           if(granted){
                                               NSArray *accounts = [accountStore accountsWithAccountType:facebookTypeAccount];
                                               ACAccount *facebookAccount = [accounts lastObject];
                                               
                                               [self userIdFromFacebook:facebookAccount];
                                           }else{
                                               
                                           }
                                       }];
}

- (void)loginTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];                
                [self userIdFromTwitter:twitterAccount];
            }
        }
     }];

}

- (void)userIdFromFacebook:(ACAccount *)account
{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    [self userIdFromURL:meurl account:account completionBlock:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
  
        NSError *jsonError = nil;
        NSDictionary *userInfo = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        
        
        NSLog(@"Facebook: %@", [userInfo objectForKey:@"id"]);
        //[[CLMDataManager sharedManager] fetchUserData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CLMUserAccountLoginNotification object:nil];
        });
        
    }];
}

- (void)userIdFromTwitter:(ACAccount *)account
{
    NSURL *meurl = [NSURL URLWithString:[@"https://api.twitter.com/1/users/show.json?screen_name=" stringByAppendingString:account.username]];
    
    [self userIdFromURL:meurl account:account completionBlock:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *userInfo = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        
        
        NSLog(@"Twitter: %@", [userInfo objectForKey:@"id"]);
        //[[CLMDataManager sharedManager] fetchUserData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CLMUserAccountLoginNotification object:nil];
        });
        
    }];
}

- (void)userIdFromURL:(NSURL *)url account:(ACAccount *)account completionBlock:(accountCompletionBlock)comptetionBlock
{
    SLRequest *idRequest = [SLRequest requestForServiceType:[self serviceTypeForAcount:account]
                                              requestMethod:SLRequestMethodGET
                                                        URL:url
                                                 parameters:nil];
    
    idRequest.account = account;
    
    [idRequest performRequestWithHandler:comptetionBlock];
}

- (NSString *)serviceTypeForAcount:(ACAccount *)account
{
    if ([account.accountType.identifier isEqualToString:ACAccountTypeIdentifierFacebook])
    {
        return SLServiceTypeFacebook;
    }
    else if ([account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter])
    {
        return SLServiceTypeTwitter;
    }
    
    return @"";
}

#pragma mark - Account Login Handlers
- (void)handleFacebookLogin
{
    [self publishNotification:CLMUserAccountLoginNotification];
}

- (void)handleTwitterLogin
{
    [self publishNotification:CLMUserAccountLoginNotification];
}

- (void)publishNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}
@end
