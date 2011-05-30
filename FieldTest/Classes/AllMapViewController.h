//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AllMapViewController : UIViewController <MKMapViewDelegate> {
	NSMutableArray *latitudes;
	NSMutableArray *longitudes;
	NSMutableArray *pintitle;
	NSMutableArray *pinsubTitle;
	NSMutableArray *MNCs;

}
@property (nonatomic, retain) NSMutableArray *pintitle;
@property (nonatomic, retain) NSMutableArray *pinsubTitle;
@property (nonatomic, retain) NSMutableArray *latitudes;
@property (nonatomic, retain) NSMutableArray *longitudes;
@property (nonatomic, retain) NSMutableArray *MNCs;

@end
