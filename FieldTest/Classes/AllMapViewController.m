//

#import "AllMapViewController.h"
#import "POI.h"
#import "DDAnnotationView.h"

@implementation AllMapViewController
@synthesize latitudes, longitudes;
@synthesize pintitle;
@synthesize pinsubTitle;
@synthesize MNCs;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	latitudes = [[NSMutableArray alloc] init];
	longitudes = [[NSMutableArray alloc] init];
	pintitle = [[NSMutableArray alloc] init];
	pinsubTitle = [[NSMutableArray alloc] init];
	MNCs = [[NSMutableArray alloc] init];
    return self;
}


- (void)loadView {
	
	
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	

	//coords.latitude = 51.515087;
	//coords.longitude = -0.142254;
	MKMapView *mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds]; 
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	mapView.scrollEnabled = YES; 
	mapView.zoomEnabled = YES;
	mapView.showsUserLocation = FALSE;
	
	
	for(int currIndex = 0; currIndex <[latitudes count]; currIndex++)
	{
		CLLocationCoordinate2D  coords;
		coords.latitude = [[latitudes objectAtIndex:currIndex] doubleValue];
		coords.longitude = [[longitudes objectAtIndex:currIndex] doubleValue];
		POI *poi = [[POI alloc] initWithCoords:coords];
		poi.title = [pintitle objectAtIndex:currIndex];
		poi.subtitle = [pinsubTitle objectAtIndex:currIndex];
		poi.mnc = [MNCs objectAtIndex:currIndex];
		//NSLog([pinsubTitle objectAtIndex:currIndex]);
		[mapView addAnnotation:poi];
		[poi release];
		
		if([[latitudes objectAtIndex:currIndex] doubleValue] > maxLat)
			maxLat = [[latitudes objectAtIndex:currIndex] doubleValue];
		if([[latitudes objectAtIndex:currIndex] doubleValue] < minLat)
			minLat = [[latitudes objectAtIndex:currIndex] doubleValue];
		if([[longitudes objectAtIndex:currIndex] doubleValue] > maxLon)
			maxLon = [[longitudes objectAtIndex:currIndex] doubleValue];
		if([[longitudes objectAtIndex:currIndex] doubleValue] < minLon)
			minLon = [[longitudes objectAtIndex:currIndex] doubleValue];
		
		
	}
	MKCoordinateRegion region;
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	if(([latitudes count] >0) && (maxLat-minLat >0) && (maxLon-minLon>0))
	{
		[mapView setRegion:region];
	}
	
	
	self.view = mapView;
	//UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	//headerImage.image = [UIImage imageNamed:@"Header.PNG"];
	[self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header.PNG"]]];
	
	//[mapView release];
	
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	if(annotation ==  mapView.userLocation)
		return nil;
	
	NSString *identifier;
	POI *poiAnnotation = (POI*) annotation;
	if([poiAnnotation.mnc intValue] == 3)
	{
		if([annotation.subtitle intValue] > 60)
		{
			identifier = @"Red1";
		}
		else if([annotation.subtitle intValue] > 55)
		{
			identifier = @"Red2";
		}
		else if([annotation.subtitle intValue] > 50)
		{
			identifier = @"Red3";
		}
		else if([annotation.subtitle intValue] > 45)
		{
			identifier = @"Red4";
		}
		else if([annotation.subtitle intValue] > 40)
		{
			identifier = @"Red5";
		}
		else if([annotation.subtitle intValue] > 35)
		{
			identifier = @"Red6";
		}
		else if([annotation.subtitle intValue] > 30)
		{
			identifier = @"Red7";
		}
		else if([annotation.subtitle intValue] > 25)
		{
			identifier = @"Red8";
		}
		else if([annotation.subtitle intValue] > 20)
		{
			identifier = @"Red9";
		}
		else if([annotation.subtitle intValue] > 15)
		{
			identifier = @"Red10";
		}
		else if([annotation.subtitle intValue] > 10)
		{
			identifier = @"Red10";
		}
		else
		{
			identifier = @"Red10";
		}
	}
	else if([poiAnnotation.mnc intValue] == 4)
	{
		if([annotation.subtitle intValue] > 60)
		{
			identifier = @"B1";
		}
		else if([annotation.subtitle intValue] > 55)
		{
			identifier = @"B2";
		}
		else if([annotation.subtitle intValue] > 50)
		{
			identifier = @"B3";
		}
		else if([annotation.subtitle intValue] > 45)
		{
			identifier = @"B4";
		}
		else if([annotation.subtitle intValue] > 40)
		{
			identifier = @"B5";
		}
		else if([annotation.subtitle intValue] > 35)
		{
			identifier = @"B6";
		}
		else if([annotation.subtitle intValue] > 30)
		{
			identifier = @"B7";
		}
		else if([annotation.subtitle intValue] > 25)
		{
			identifier = @"B8";
		}
		else if([annotation.subtitle intValue] > 20)
		{
			identifier = @"B9";
		}
		else if([annotation.subtitle intValue] > 15)
		{
			identifier = @"B10";
		}
		else if([annotation.subtitle intValue] > 10)
		{
			identifier = @"B10";
		}
		else
		{
			identifier = @"B10";
		}
	}
	else
	{
		if([annotation.subtitle intValue] > 60)
		{
			identifier = @"G1";
		}
		else if([annotation.subtitle intValue] > 55)
		{
			identifier = @"G2";
		}
		else if([annotation.subtitle intValue] > 50)
		{
			identifier = @"G3";
		}
		else if([annotation.subtitle intValue] > 45)
		{
			identifier = @"G4";
		}
		else if([annotation.subtitle intValue] > 40)
		{
			identifier = @"G5";
		}
		else if([annotation.subtitle intValue] > 35)
		{
			identifier = @"G6";
		}
		else if([annotation.subtitle intValue] > 30)
		{
			identifier = @"G7";
		}
		else if([annotation.subtitle intValue] > 25)
		{
			identifier = @"G8";
		}
		else if([annotation.subtitle intValue] > 20)
		{
			identifier = @"G9";
		}
		else if([annotation.subtitle intValue] > 15)
		{
			identifier = @"G10";
		}
		else if([annotation.subtitle intValue] > 10)
		{
			identifier = @"G10";
		}
		else
		{
			identifier = @"G10";
		}
	}


	


	DDAnnotationView *annotationView = (DDAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (annotationView == nil) {
		annotationView = [[[DDAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
	}
	// Dragging annotation will need _mapView to convert new point to coordinate;
	annotationView.mapView = mapView;
	return annotationView;
	
	/*MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
	
	newAnnotation.pinColor = MKPinAnnotationColorGreen;
	
	newAnnotation.animatesDrop = YES; 
	newAnnotation.canShowCallout = YES;
    newAnnotation.calloutOffset = CGPointMake(-5, 5);
	return newAnnotation;*/
	
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	if ([control isKindOfClass:[UIButton class]]) {
		POI *buddyPin = (POI *)[view annotation];
		
		
		
	}
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[latitudes release];
	[longitudes release];
	[pintitle release];
	[pinsubTitle release];
    [super dealloc];
}


@end
