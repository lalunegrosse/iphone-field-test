

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface POI : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitle; 
	NSString *title;
	NSString *mnc;
	
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, copy) NSString *mnc;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;

@end