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
	self.databaseName = @"UrFilez.sql";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	self.databasePath = [[documentsDir stringByAppendingPathComponent:databaseName]retain];
	
	
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Init the Arrays
		
	}
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


@end
