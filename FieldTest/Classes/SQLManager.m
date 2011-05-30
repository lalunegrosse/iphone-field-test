//
//  SQLManager.m
//  UrFilez
//
//  Created by urfilez on 12/20/10.
//  Copyright 2010 UrFilez. All rights reserved.
//

#import "SQLManager.h"
#import "SynthesizeSingleton.h"
#import <sqlite3.h>
#import "dataForModel.h"


@implementation NSMutableArray (Reverse)

- (void)reverse {
	if([self count] < 2)
	{
		return;
	}
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
		
        i++;
        j--;
    }
}

@end


static sqlite3_stmt *selectStmt = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *compiledStatementForRead = nil;
static sqlite3_stmt *compiledStatementForWrite = nil;
static sqlite3_stmt *deleteNotiStmt = nil;

@implementation SQLManager
SYNTHESIZE_SINGLETON_FOR_CLASS(SQLManager);

@synthesize databaseName;
@synthesize databasePath;

-(void) initilizeDB
{
	self.databaseName = @"celltoweres.sql";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	self.databasePath = [[documentsDir stringByAppendingPathComponent:databaseName]retain];
	NSLog(databasePath);
	
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Init the Arrays
		
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newReading) name:@"newReading" object:nil];
	model = [dataForModel shareddataForModel];
}

- (void) newReading
{
	
	[self performSelectorOnMainThread:@selector(updateValues) withObject:nil waitUntilDone:NO];
}

- (void) updateValues
{
	NSString *neighboreCount = nil;
	
	if(model.currReading.Rssi_6 > 0)
	{
		neighboreCount = @"6";
	}
	else if(model.currReading.Rssi_5 > 0)
	{
		neighboreCount = @"5";
	}
	else if(model.currReading.Rssi_4 > 0)
	{
		neighboreCount = @"4";
	}
	else if(model.currReading.Rssi_3 > 0)
	{
		neighboreCount = @"3";
	}
	else if(model.currReading.Rssi_2 > 0)
	{
		neighboreCount = @"2";
	}
	else if(model.currReading.Rssi_1 > 0)
	{
		neighboreCount = @"1";
	}
	else
	{
		neighboreCount = @"0";
	}
	const char *sqlStatement = "insert into readings (lati,longi,mcc,mnc, lac,cellid,rssi,act,neighbores) VALUES (?, ?, ?, ?, ?, ?, ?, ? ,?)";
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForWrite, NULL) == SQLITE_OK)    {
		sqlite3_bind_text( compiledStatementForWrite, 1, [model.latitude UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 2, [model.longitude UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 3, [[NSString stringWithFormat:@"%d", model.currReading.MCC] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 4, [[NSString stringWithFormat:@"%d", model.currReading.MNC] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 5, [model.currReading.LAC UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 6, [model.currReading.CI UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 7, [[NSString stringWithFormat:@"%d", model.currReading.SCRssi] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 8, [[NSString stringWithFormat:@"%d", model.currReading.AcT] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text( compiledStatementForWrite, 9, [neighboreCount UTF8String], -1, SQLITE_TRANSIENT);
		
	}
	//NSLog(@"%i",sqlite3_step(compiledStatementForWrite));
	
	if(sqlite3_step(compiledStatementForWrite) != SQLITE_DONE ) {
		NSLog( @"Error: %s :  %i", sqlite3_errmsg(database));
	} else {
		//NSLog( @"Insert into row id = %d", sqlite3_last_insert_rowid(database));
	}
	sqlite3_reset(compiledStatementForWrite);
	//sqlite3_finalize(compiledStatementForWrite);
	
}

-(void) checkAndCreateDatabase
{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	[fileManager release];
}



-(void) dealloc{
	sqlite3_close(database);
	[super dealloc];
}


-(int) averageRssi:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 6)];
			totRes++;
			retVal = retVal + [currVal intValue];
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	
	if(totRes == 0)
	{
		return 0;
	}
	else
	{
		return retVal/totRes;
	}

}

-(int) minRssi:(NSString *) reqMNC
{
	int retVal = 1000;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 6)];
			totRes++;
			if(retVal > [currVal intValue])
			{
				retVal = [currVal intValue];
			}
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
		return retVal;
	
}

-(int) maxRssi:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 6)];
			totRes++;
			if(retVal < [currVal intValue])
			{
				retVal = [currVal intValue];
			}
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retVal;
	
}

-(int) totalReadings:(NSString *) reqMNC
{
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 6)];
			totRes++;
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return totRes;
	
}


-(int) averageNeighboures:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 8)];
			totRes++;
			retVal = retVal + [currVal intValue];
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	
	if(totRes == 0)
	{
		return 0;
	}
	else
	{
		return retVal/totRes;
	}
	
}

-(int) act1Val:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 7)];
			if([currVal intValue] == 1)
			{
				totRes++;
			}
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
		return totRes;
	
}

-(int) act2Val:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 7)];
			if([currVal intValue] == 2)
			{
				totRes++;
			}
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return totRes;
	
}

-(int) act3Val:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 7)];
			if([currVal intValue] == 3)
			{
				totRes++;
			}
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return totRes;
	
}

-(int) act4Val:(NSString *) reqMNC
{
	int retVal = 0;
	int totRes = 0;
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings where mnc = ?";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			//When binding parameters, index starts from 1 and not zero.
			sqlite3_bind_text(compiledStatementForRead, 1, [reqMNC UTF8String],-1, SQLITE_TRANSIENT);
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 7)];
			if([currVal intValue] == 4)
			{
				totRes++;
			}
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return totRes;
	
}

-(NSMutableArray*) latiArray
{
	NSMutableArray *retArray = [[NSMutableArray alloc] init];
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 0)];
			
			[retArray addObject:currVal];
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retArray;
	
}

-(NSMutableArray*) lnogiArray
{
	NSMutableArray *retArray = [[NSMutableArray alloc] init];
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 1)];
			
			[retArray addObject:currVal];
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retArray;
	
}

-(NSMutableArray*) cidArray
{
	NSMutableArray *retArray = [[NSMutableArray alloc] init];
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 5)];
			
			[retArray addObject:currVal];
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retArray;
	
}

-(NSMutableArray*) rssiArray
{
	NSMutableArray *retArray = [[NSMutableArray alloc] init];
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 6)];
			
			[retArray addObject:currVal];
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retArray;
	
}

-(NSMutableArray*) mncArray
{
	NSMutableArray *retArray = [[NSMutableArray alloc] init];
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from readings";
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatementForRead, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatementForRead) == SQLITE_ROW ) {
			
			// Read the data from the result row
			NSString *currVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementForRead, 3)];
			
			[retArray addObject:currVal];
			
		}
	}
	
	// Release the compiled statement from memory
	sqlite3_reset(compiledStatementForRead);
	return retArray;
	
}
@end
