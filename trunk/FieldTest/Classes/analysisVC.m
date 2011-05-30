//
//  analysisVC.m
//  FieldTest
//
//  Created by Ashar on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "analysisVC.h"
#import "AllMapViewController.h"


@implementation analysisVC
@synthesize totlaReadings;
@synthesize maxRSSI;
@synthesize minRSSI;
@synthesize avgRSSI;
@synthesize avgNeighbour;
@synthesize Act1;
@synthesize Act2;
@synthesize Act3;
@synthesize Act4;
@synthesize topSegment;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	model = [dataForModel shareddataForModel];
	sqlManager = [SQLManager sharedSQLManager];
	selMNC = @"3";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newReading) name:@"newReading" object:nil];
	
	UIBarButtonItem *MapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map View" style:UIBarButtonItemStyleBordered target:self action:@selector(MapButtonAction:)];
	[self.navigationItem setLeftBarButtonItem:MapButton];
	[MapButton release];
	
}

- (IBAction)MapButtonAction:(id)sender{
	AllMapViewController *myMapContr = [[AllMapViewController alloc] init];
	myMapContr.title = @"All Towers";
	
			
	myMapContr.latitudes  = [sqlManager latiArray];
	myMapContr.longitudes =  [sqlManager lnogiArray];
	myMapContr.pintitle = [sqlManager cidArray];
	myMapContr.pinsubTitle =  [sqlManager rssiArray];
	myMapContr.MNCs = [sqlManager mncArray];
	
	
	
	[self.navigationController pushViewController:myMapContr animated:TRUE];
	[myMapContr release];
	
}

- (void) newReading
{
	
	[self performSelectorOnMainThread:@selector(updateValues) withObject:nil waitUntilDone:NO];
}

- (void) updateValues
{
	
	int dbVal = [sqlManager averageRssi:selMNC];
	avgRSSI.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager maxRssi:selMNC];
	maxRSSI.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager minRssi:selMNC];
	minRSSI.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager totalReadings:selMNC];
	totlaReadings.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager averageNeighboures:selMNC];
	avgNeighbour.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager act1Val:selMNC];
	Act1.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager act2Val:selMNC];
	Act2.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager act3Val:selMNC];
	Act3.text = [NSString stringWithFormat:@"%d",dbVal];
	
	dbVal = [sqlManager act4Val:selMNC];
	Act4.text = [NSString stringWithFormat:@"%d",dbVal];
	
	
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction) segmentChanged :(id) sender
{
	if(topSegment.selectedSegmentIndex == 0)
	{
		selMNC = @"3";
	}
	else if(topSegment.selectedSegmentIndex == 1)
	{
		selMNC = @"4";
	}
	else
	{
		selMNC = @"6";
	}
	[self updateValues];
}

@end
