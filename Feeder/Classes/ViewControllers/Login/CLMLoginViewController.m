//
//  CLMLoginViewController.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/16/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface CLMLoginViewController ()

@property (nonatomic, strong) IBOutlet UIView *imageView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) BOOL isMaskOpen;

- (IBAction)login:(id)sender;
@end

@implementation CLMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGPoint)pointForAngle:(CGFloat)angle
{
	return CGPointMake(sinf(angle), -cosf(angle));
}

- (CGPathRef)makeHexagonPath:(CGMutablePathRef)path withRadius:(NSInteger)radius
{
	CGPoint point = [self pointForAngle:0];
	CGPathMoveToPoint(path, nil, self.view.center.x+point.x*radius, self.view.center.y+point.y*radius);
	for (int i = 1; i < 6; i++)
	{
		CGFloat angleDif = ((M_PI*2)/6.0);
		point = [self pointForAngle:i*angleDif];
		CGPathAddLineToPoint(path, nil, self.view.center.x+point.x*radius, self.view.center.y+point.y*radius);
	}
	
	point = [self pointForAngle:0];
	CGPathAddLineToPoint(path, nil, self.view.center.x+point.x*radius, self.view.center.y+point.y*radius);
	
	return path;
}

- (CGPathRef)makeHexagonPathWithRadius:(NSInteger)radius
{
	// Both frames are defined in the same coordinate system
	CGRect biggerRect = self.view.bounds;
	
	CGMutablePathRef maskPath1 = CGPathCreateMutable();
	
	CGPathMoveToPoint(maskPath1, nil, CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect));
	CGPathAddLineToPoint(maskPath1, nil, CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect));
	CGPathAddLineToPoint(maskPath1, nil, CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect));
	CGPathAddLineToPoint(maskPath1, nil, CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect));
	CGPathAddLineToPoint(maskPath1, nil, CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect));
	
	[self makeHexagonPath:maskPath1 withRadius:radius];
	
	CGPathCloseSubpath(maskPath1);
	
	return maskPath1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.isMaskOpen = FALSE;
	self.maskLayer = [CAShapeLayer layer];
	
	CGPathRef firstPath = [self makeHexagonPathWithRadius:0];
	
	[self.maskLayer setPath:firstPath];
	[self.maskLayer setFillRule:kCAFillRuleEvenOdd];
	
	self.imageView.layer.mask = self.maskLayer;
	
}

- (IBAction)login:(id)sender
{
	CGPathRef path;
	if (self.isMaskOpen)
	{
		path = [self makeHexagonPathWithRadius:0];
		self.isMaskOpen = NO;
	}else{
		path = [self makeHexagonPathWithRadius:100];
		self.isMaskOpen = YES;
	}
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
	[anim setFromValue:(__bridge id)(self.maskLayer.path)];
	[anim setToValue:(__bridge id)(path)];
	[anim setDelegate:self];
	[anim setDuration:.5];
	[anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	self.maskLayer.path = path;
	[self.maskLayer addAnimation:anim forKey:@"path"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
