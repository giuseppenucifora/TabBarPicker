//
//  SharedLocationManager.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//

#import "SharedLocationManager.h"

@implementation SharedLocationManager
+ (id)sharedManager {
    static SharedLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            [CLLocationManager authorizationStatus];
        }
        else {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (void)setCurrentLocation {
    
    [locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != nil) {
        currentLocation = newLocation;
    }
    [locationManager stopUpdatingLocation];
}

-(BOOL)locationIsSet {
    if(currentLocation != nil)
        return YES;
    else
        return NO;
}

-(CLLocation*)getCurrentLocation {
    return currentLocation;
}

- (BOOL) localizationIsAuthorized {
    if ( [CLLocationManager locationServicesEnabled] == NO || [self localizationAuthorizationStatus] == kCLAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}

- (CLAuthorizationStatus) localizationAuthorizationStatus {
    return [CLLocationManager authorizationStatus];
}


@end
