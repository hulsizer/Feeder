//
//  CLMLoginViewController.m
//  Feeder
//
//  Created by Andrew Hulsizer on 4/16/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMLoginViewController.h"
#import "AFOAuth2Client.h"
#import "AFJSONRequestOperation.h"
#import "CLMOAuthClient.h"
#import "CLMConstants.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "CLMUserManager.h"

@interface CLMLoginViewController ()

@property (nonatomic, strong) IBOutlet UILabel *selectLabel;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *googleButton;
@property (nonatomic, strong) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterButton;
@property (nonatomic, strong) IBOutlet UIImageView *dailyImage;
@property (nonatomic, strong) IBOutlet UIView *loginView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) BOOL isMaskOpen;

@property (nonatomic, strong) UIWebView *loginWebView;
@property (nonatomic, strong) CLMOAuthClient *client;

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
	
	self.loginView.layer.mask = self.maskLayer;
	
    [self blurImage];
}

- (void)blurImage
{
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.dailyImage.image.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    //add our blurred image to the scrollview
    self.dailyImage.image = [UIImage imageWithCGImage:cgImage];
}

- (IBAction)login:(id)sender
{
	if (self.isMaskOpen)
	{
		[self closeMask];
        self.isMaskOpen = NO;
	}else{
		[self openMask];
        self.isMaskOpen = YES;
	}
}

- (void)openMask
{
    CGPathRef path = [self makeHexagonPathWithRadius:90];
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
	[anim setFromValue:(__bridge id)(self.maskLayer.path)];
	[anim setToValue:(__bridge id)(path)];
	[anim setDelegate:self];
	[anim setDuration:1];
	[anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	self.maskLayer.path = path;
	[self.maskLayer addAnimation:anim forKey:@"path"];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.loginButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            [self.cancelButton setAlpha:1.0];
            [self.selectLabel setAlpha:1.0];
        }];
    }];

}

- (void)closeMask
{
    [UIView animateWithDuration:.5 animations:^{
            [self.googleButton setCenter:CGPointMake(89, 158)];
            [self.facebookButton setCenter:CGPointMake(278, 272)];
            [self.twitterButton setCenter:CGPointMake(89, 382)];
    } completion:^(BOOL finished) {
        CGPathRef path = [self makeHexagonPathWithRadius:0];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        [anim setFromValue:(__bridge id)(self.maskLayer.path)];
        [anim setToValue:(__bridge id)(path)];
        [anim setDelegate:self];
        [anim setDuration:1];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        self.maskLayer.path = path;
        [self.maskLayer addAnimation:anim forKey:@"path"];
    }];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.cancelButton setAlpha:0.0];
        [self.selectLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            [self.loginButton setAlpha:1.0];
        }];
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        [UIView animateWithDuration:.5 animations:^{
            if (self.isMaskOpen)
            {
                [self.googleButton setCenter:CGPointMake(137, 241)];
                [self.facebookButton setCenter:CGPointMake(195, 272)];
                [self.twitterButton setCenter:CGPointMake(137, 306)];
                
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CAAnimations

-(CABasicAnimation *)bounceAnimationFrom:(NSValue *)from
                                      to:(NSValue *)to
                              forKeyPath:(NSString *)keypath
                            withDuration:(CFTimeInterval)duration
{
    CABasicAnimation * result = [CABasicAnimation animationWithKeyPath:keypath];
    [result setFromValue:from];
    [result setToValue:to];
    [result setDuration:duration];
    
    [result setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :.8 :0.8]];
    
    return  result;
}


-(CAKeyframeAnimation *)keyframeBounceAnimationFrom:(NSValue *)from
                                                via:(NSValue *)via
                                                 to:(NSValue *)to
                                         forKeypath:(NSString *)keyPath
                                       withDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    [animation setValues:[NSArray arrayWithObjects:from, via, to, nil]];
    [animation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:.7], [NSNumber numberWithFloat:1.0], nil]];
    
    animation.duration = duration;
    return animation;
}

#pragma mark - Login
- (IBAction)facebookLogin:(id)sender
{
    [[CLMUserManager sharedManager] login:FacebookAccount];
}

- (IBAction)twitterLogin:(id)sender
{
    [[CLMUserManager sharedManager] login:TwitterAccount];
}

@end
