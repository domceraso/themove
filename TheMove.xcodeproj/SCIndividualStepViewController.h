//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import <UIKit/UIKit.h>
@import MapKit;

@interface SCIndividualStepViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKRouteStep *routeStep;
@property (assign, nonatomic) NSUInteger stepIndex;

@end
