//
//  CLMApplicationViewController.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/16/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMApplicationViewController.h"
#import "CLMLoginViewController.h"

@interface CLMApplicationViewController ()

@property (nonatomic, strong) CLMLoginViewController *loginViewController;
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
    
    self.loginViewController = [[CLMLoginViewController alloc] init];
    [self.view addSubview:self.loginViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
