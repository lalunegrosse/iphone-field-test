//
//  mapTower.h
//  FieldTest
//
//  Created by urfilez on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataForModel.h"


@interface mapTower : UIViewController {
	UITableView				*myTableView;/**<main table view for the controller  */
	NSMutableArray			*tableData;/**<src for table  */
	dataForModel			*model;

}


@property (nonatomic, retain) IBOutlet	UITableView				*myTableView;
@end
