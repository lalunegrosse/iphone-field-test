//
//  workerThread.h
//  TowerInfo
//
//  Created by urfilez on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataForModel.h"


@interface workerThread : NSObject {
    bool isServingCell;
    int neighboureNumber;
	bool isPLMN;
	dataForModel *model;
	

}

-(void) getToWork;
@end
