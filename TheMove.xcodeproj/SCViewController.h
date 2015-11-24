//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIButton *routeDetailsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)handleRoutePressed:(id)sender;
@property (nonatomic, retain) NSString *descriptionf;
@property (nonatomic, retain) NSNumber *longa;
@property (nonatomic, retain) NSNumber *lota;
@end
