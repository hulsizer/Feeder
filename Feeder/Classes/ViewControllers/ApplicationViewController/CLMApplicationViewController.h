//
//  CLMApplicationViewController.h
//  Feeder
//
//  Created by Andrew Hulsizer on 4/16/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LaunchBlock)(void);

@interface CLMApplicationViewController : UIViewController

@property (nonatomic, copy) LaunchBlock launchBlock;

@end
