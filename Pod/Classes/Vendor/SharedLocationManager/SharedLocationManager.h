//
//  SharedLocationManager.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SharedLocationManager : NSObject <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

+ (id) sharedManager;
- (void) setCurrentLocation;
- (CLLocation*) getCurrentLocation;
- (BOOL) locationIsSet;
- (BOOL) localizationIsAuthorized;
- (CLAuthorizationStatus) localizationAuthorizationStatus;

@end
