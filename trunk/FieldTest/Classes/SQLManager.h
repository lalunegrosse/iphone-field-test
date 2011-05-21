//
//  SQLManager.h
//  UrFilez
//
//  Created by urfilez on 12/20/10.
//  Copyright 2010 UrFilez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "dataForModel.h"


@interface SQLManager : NSObject {
	
	NSString *databaseName;
	NSString *databasePath;
	sqlite3 *database;

}

/*----------------------------------------------------------------------
 *                            Class Methods                                
 *----------------------------------------------------------------------*/
+ (SQLManager *)sharedSQLManager;
-(void) initilizeDB;
-(void) checkAndCreateDatabase;


@property (nonatomic, copy)		NSString		*databaseName;
@property (nonatomic, copy)		NSString		*databasePath;
@end
