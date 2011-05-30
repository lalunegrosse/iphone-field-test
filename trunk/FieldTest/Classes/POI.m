

#import "POI.h"


@implementation POI


@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize mnc;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
	
	self = [super init];
	
	if (self != nil) {
		
		coordinate = coords; 
		
	}
	
	return self;
	
}

- (void) dealloc

{
	
	[title release];
	[subtitle release];
	[super dealloc];
	
}

@end
