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
	dataForModel	*model;

}

/*----------------------------------------------------------------------
 *                            Class Methods                                
 *----------------------------------------------------------------------*/
+ (SQLManager *)sharedSQLManager;
-(void) initilizeDB;
-(void) checkAndCreateDatabase;

-(int) averageRssi:(NSString *) reqMNC;
-(int) minRssi:(NSString *) reqMNC;
-(int) maxRssi:(NSString *) reqMNC;
-(int) totalReadings:(NSString *) reqMNC;
-(int) averageNeighboures:(NSString *) reqMNC;
-(int) act1Val:(NSString *) reqMNC;
-(int) act2Val:(NSString *) reqMNC;
-(int) act3Val:(NSString *) reqMNC;
-(int) act4Val:(NSString *) reqMNC;

-(NSMutableArray*) rssiArray;
-(NSMutableArray*) cidArray;
-(NSMutableArray*) lnogiArray;
-(NSMutableArray*) latiArray;


@property (nonatomic, copy)		NSString		*databaseName;
@property (nonatomic, copy)		NSString		*databasePath;
@end
