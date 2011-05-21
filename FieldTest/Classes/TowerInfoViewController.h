//
//  TowerInfoViewController.h
//  TowerInfo
//
//  Created by urfilez on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TowerInfoViewController : UIViewController {
	UITextView *infoView;
	UITextField *inputField;

}

-(IBAction) getData;
-(IBAction) sendCommand;


@property (nonatomic, retain) IBOutlet UITextView *infoView;
@property (nonatomic, retain) IBOutlet UITextField *inputField;

@end

