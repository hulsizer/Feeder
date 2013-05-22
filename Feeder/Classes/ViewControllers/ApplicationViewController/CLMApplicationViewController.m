//
//  CLMApplicationViewController.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/16/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMApplicationViewController.h"
#import "CLMLoginViewController.h"
#import "CLMFeaturedViewController.h"
#import "CLMConstants.h"

@interface CLMApplicationViewController ()

@property (nonatomic, strong) CLMLoginViewController *loginViewController;
@property (nonatomic, strong) CLMFeaturedViewController *featuredViewController;
@end

@implementation CLMApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.launchBlock();
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin:) name:CLMUserAccountLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout:) name:CLMUserAccountLogoutNotification object:nil];
    
    self.loginViewController = [[CLMLoginViewController alloc] init];
    [self.view addSubview:self.loginViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Loaders

- (CLMFeaturedViewController *)featuredViewController
{
    if (!_featuredViewController)
    {
        _featuredViewController = [[CLMFeaturedViewController alloc] init];
    }
    
    return _featuredViewController;
}

- (void)handleLogin:(NSNotification *)notification
{
    [self.view insertSubview:self.featuredViewController.view atIndex:0];
    [self.loginViewController willMoveToParentViewController:nil];
    [self.loginViewController removeFromParentViewController];
    [self.loginViewController.view removeFromSuperview];
}

- (void)handleLogout:(NSNotification *)notification
{
    [self addChildViewController:self.loginViewController];
    [self.view addSubview:self.loginViewController.view];
    [self.loginViewController didMoveToParentViewController:self];
}
@end
