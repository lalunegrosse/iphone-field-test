//
//  TowerInfoViewController.h
//  TowerInfo
//
//  Created by urfilez on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataForModel.h"
#import "SQLManager.h"

@interface TowerInfoViewController : UIViewController {
	UITextView *infoView;
	UITextField *inputField;
	dataForModel *model;
	SQLManager	*sqlManager;
	int totalReadings;
	
	UILabel		*numOfReadings;
	UILabel		*signalStrength;
	UILabel		*neighbourCells;
	UILabel		*accessTech;
	UILabel		*lati;
	UILabel		*longi;

}

-(IBAction) getData;
-(IBAction) sendCommand;


@property (nonatomic, retain) IBOutlet UITextView *infoView;
@property (nonatomic, retain) IBOutlet UITextField *inputField;

@property (nonatomic, retain) IBOutlet UILabel		*numOfReadings;
@property (nonatomic, retain) IBOutlet UILabel		*signalStrength;
@property (nonatomic, retain) IBOutlet UILabel		*neighbourCells;
@property (nonatomic, retain) IBOutlet UILabel		*accessTech;
@property (nonatomic, retain) IBOutlet UILabel		*lati;
@property (nonatomic, retain) IBOutlet UILabel		*longi;

@end

