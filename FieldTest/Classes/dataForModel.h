

/** \class dataForModel \brief serves as the 'Model' for the app.
 * Shared Model for the app, as presumed in MVC style of coding.
 * Also responsible to represent the state of the app. Interested controller can 
 * observe the keys as KVO in Objective-C. Used as synchronized singleton.
 * implements the NSCoding. safe to serialize. 
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MapKit.h>
#import "readingInfo.h"


/*----------------------------------------------------------------------
 *                            Interface                                
 *----------------------------------------------------------------------*/
@interface dataForModel : NSObject <NSCoding, CLLocationManagerDelegate>{

	NSString				*latitude;
	NSString				*longitude;
	readingInfo				*currReading;
	CLLocationManager		*locationManager;
	int						notificationCount;
	
}
/*----------------------------------------------------------------------
 *                            Class Methods                                
 *----------------------------------------------------------------------*/
+ (dataForModel *)shareddataForModel;

/*----------------------------------------------------------------------
 *                            Instance Methods                                
 *----------------------------------------------------------------------*/


-(NSString *)getUID;
-(NSString *)getDevice;
-(NSString *)getOSVer;
-(BOOL)isDeviceHiRes;


/*----------------------------------------------------------------------
 *                            Properties                                
 *----------------------------------------------------------------------*/

@property (nonatomic)			int				notificationCount;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, retain) readingInfo *currReading;


@end
