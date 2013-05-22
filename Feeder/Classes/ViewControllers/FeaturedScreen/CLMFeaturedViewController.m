//
//  CLMFeaturedViewController.m
//  Feeder
//
//  Created by Andrew Hulsizer on 5/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMFeaturedViewController.h"
#import "CLMFeedlingManager.h"
@interface CLMFeaturedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *feedArticles;
@property (nonatomic, strong) IBOutlet UITableView *articleTableView;
@end

@implementation CLMFeaturedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[CLMFeedlingManager sharedFeedling] addFeed:@"http://kotaku.com/index.xml"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
