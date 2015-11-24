//
//  TheMoveViewController.m
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//

#import "TheMoveViewController.h"

@interface TheMoveViewController ()

@end

@implementation TheMoveViewController


NSString * urlStr;



// CHANGE YOUR PHP STORE FILES REMOTE URL ADDRESSES BETWEEN ""

NSString *barurl = @"http://steelcitydevstudios.com/dev/themove/stores.php";
NSString *premiumurl = @"http://steelcitydevstudios.com/dev/themove/premium.php";




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)barbutton {
    
    urlStr = barurl;
    
}
-(void)premiumbutton
{
    urlStr = premiumurl;
    
}



#pragma mark iAd Delegate Methods

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 1.
    // We do this because we are going to have it set to 0 to start and setting it to 1 will cause the iAd to fade into view.
    [banner setAlpha:1];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 0.
    // We do this because we are going to have it set to 1 to start and setting it to 0 will cause the iAd to fade out of view.
    [banner setAlpha:0];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}



@end
