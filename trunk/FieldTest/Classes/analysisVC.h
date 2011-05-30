//
//  analysisVC.h
//  FieldTest
//
//  Created by Ashar on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataForModel.h"
#import "SQLManager.h"


@interface analysisVC : UIViewController {
	UILabel *totlaReadings;
	UILabel *maxRSSI;
	UILabel *minRSSI;
	UILabel *avgRSSI;
	UILabel *avgNeighbour;
	UILabel *Act1;
	UILabel *Act2;
	UILabel	*Act3;
	UILabel	*Act4;
	
	UISegmentedControl *topSegment;
	NSString *selMNC;
	
	dataForModel *model;
	SQLManager	*sqlManager;

}

-(IBAction) segmentChanged :(id) sender;

@property (nonatomic, retain) IBOutlet UILabel *totlaReadings;
@property (nonatomic, retain) IBOutlet UILabel *maxRSSI;
@property (nonatomic, retain) IBOutlet UILabel *minRSSI;
@property (nonatomic, retain) IBOutlet UILabel *avgRSSI;
@property (nonatomic, retain) IBOutlet UILabel *avgNeighbour;
@property (nonatomic, retain) IBOutlet UILabel *Act1;
@property (nonatomic, retain) IBOutlet UILabel *Act2;
@property (nonatomic, retain) IBOutlet UILabel	*Act3;
@property (nonatomic, retain) IBOutlet UILabel	*Act4;
@property (nonatomic, retain) IBOutlet UISegmentedControl *topSegment;

@end
