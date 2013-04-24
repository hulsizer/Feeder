//
//  CLMAuthCredential.h
//  Feeder
//
//  Created by Andrew Hulsizer on 4/22/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMAuthCredential : NSObject <NSCoding>

///--------------------------------------
/// @name Accessing Credential Properties
///--------------------------------------

/**
 
 */
@property (readonly, nonatomic) NSString *accessToken;

/**
 
 */
@property (readonly, nonatomic) NSString *tokenType;

/**
 
 */
@property (readonly, nonatomic) NSString *refreshToken;

/**
 
 */
@property (readonly, nonatomic, assign, getter = isExpired) BOOL expired;

///--------------------------------------------
/// @name Creating and Initializing Credentials
///--------------------------------------------

/**
 
 */
+ (instancetype)credentialWithOAuthToken:(NSString *)token
                               tokenType:(NSString *)type;

/**
 
 */
- (id)initWithOAuthToken:(NSString *)token
               tokenType:(NSString *)type;

///----------------------------
/// @name Setting Refresh Token
///----------------------------

/**
 
 */
- (void)setRefreshToken:(NSString *)refreshToken
             expiration:(NSDate *)expiration;

///-----------------------------------------
/// @name Storing and Retrieving Credentials
///-----------------------------------------

#ifdef _SECURITY_SECITEM_H_
/**
 
 */
+ (BOOL)storeCredential:(CLMAuthCredential *)credential
         withIdentifier:(NSString *)identifier;

/**
 
 */
+ (BOOL)deleteCredentialWithIdentifier:(NSString *)identifier;

/**
 
 */
+ (CLMAuthCredential *)retrieveCredentialWithIdentifier:(NSString *)identifier;
#endif

@end

///----------------
/// @name Constants
///----------------

/**
 
 */
extern NSString * const kCLMOAuthCodeGrantType;
extern NSString * const kCLMOAuthClientCredentialsGrantType;
extern NSString * const kCLMOAuthPasswordCredentialsGrantType;
extern NSString * const kCLMOAuthRefreshGrantType;
