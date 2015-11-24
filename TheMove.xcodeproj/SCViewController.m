//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import "SCViewController.h"
#import "SCStepsViewController.h"

@interface SCViewController () <MKMapViewDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    
    NSString *bak;
    NSMutableArray *myButtons;
}


@end


@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.activityIndicator.hidden = YES;
    self.routeDetailsButton.hidden = YES;
    self.routeDetailsButton.enabled = NO;
    self.mapView.delegate = self;
    self.navigationItem.title = @"City Guide Route";
    
    
    
    NSArray *modelsAsArray = [self.descriptionf componentsSeparatedByString:@"||"];
    
    
    
    _longa = [modelsAsArray objectAtIndex:1];
    _lota = [modelsAsArray objectAtIndex:2];


}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)handleRoutePressed:(id)sender {
    // We're working
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.routeButton.enabled = NO;
    self.routeDetailsButton.enabled = NO;
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
    
  
    
       CLLocationDegrees latF = [_lota floatValue];
       CLLocationDegrees lngF = [_longa floatValue];
 
       CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(latF,lngF);
    
    

    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        self.routeButton.enabled = YES;
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        // So there wasn't an error - let's plot those routes
        self.routeDetailsButton.enabled = YES;
        self.routeDetailsButton.hidden = NO;
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SCStepsViewController class]]) {
        SCStepsViewController *vc = (SCStepsViewController *)segue.destinationViewController;
        vc.route = _currentRoute;
    }
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

@end
