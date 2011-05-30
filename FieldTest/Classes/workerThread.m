//
//  workerThread.m
//  TowerInfo
//
//  Created by urfilez on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "workerThread.h"
#include <stdio.h>
#include <string.h>
#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#import  "readingInfo.h"

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <errno.h>
#include <time.h>

#define BUFSIZE (65536+100)

@implementation workerThread

- (id)init { 
    self = [super init];
    if (self != nil) {
		
		
    }
    return self;
}

-(void) getToWork
{
	NSLog(@"thread start to work");
	model = [dataForModel shareddataForModel];
	[NSThread detachNewThreadSelector:@selector(startFetchingData) toTarget:self withObject:nil];
}

-(void) startFetchingData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int modem;
	char cmd[1024];	
	NSString *responseString;
	
	// Set AT command to fetch balance 
	//sprintf(cmd,[inputField.text cString]);
	//sprintf(cmd,"AT+CUSD=1,\"*124#\",15\r");
	sprintf(cmd,"AT+CGED=0\r");
	
	
	NSLog([NSString stringWithFormat:@"buffer length= %d,", strlen(cmd)]);
	//cmd[strlen(cmd)] = '\r';
	
	modem = [self InitConn:115200];
	
	while (1) 
	{
		isPLMN = FALSE;
		isServingCell = FALSE;
		neighboureNumber = 0;
		
	NSLog (@"Waiting for modem to be free..");
	[self AT:modem]; // wait for device to be free, by polling with AT commands.
	
	[self SendStrCmd:modem :cmd];
	
	NSMutableArray *lineStrings;
	for (int i=0;i<2;i++) {
        if((responseString = [self ReadResp:modem :10])) {
			
			readingInfo *currReading = [[readingInfo alloc] init];
			lineStrings = [responseString componentsSeparatedByString:@"\n"];
			for(int currLine=0; currLine < [lineStrings count]; currLine++)
			{
				NSString *currString = [lineStrings objectAtIndex:currLine];
				NSLog(currString);
				
				NSRange startRange = [currString rangeOfString:@"RAT:\"" options:NSCaseInsensitiveSearch];
				
				if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@"\"," options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 5;
                    int endIndex = endRange.location - startIndex;
                    currReading.RAT = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    
				}
                
                startRange = [currString rangeOfString:@"RR:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@"\r" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    currReading.RR = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"txpwr:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", RxLevServ" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 6;
                    int endIndex = endRange.location - startIndex;
                    currReading.txpwr = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"RxLevServ:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", RxQualFull" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 10;
                    int endIndex = endRange.location - startIndex;
                    currReading.RxLevServ = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"RxQualFull:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", RxQualSub" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 11;
                    int endIndex = endRange.location - startIndex;
                    currReading.RxQualFull = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"RxQualSub:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@",\r" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 10;
                    int endIndex = endRange.location - startIndex;
                    currReading.RxQualSub = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"dtx_used:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", drx_used" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 9;
                    int endIndex = endRange.location - startIndex;
                    currReading.dtx_used = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] boolValue];
                    
				}
                
                startRange = [currString rangeOfString:@"drx_used:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@",\r" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 9;
                    int endIndex = endRange.location - startIndex;
                    currReading.drx_used = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] boolValue];
                    
				}
                
                startRange = [currString rangeOfString:@"SFRLC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", RSR" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 6;
                    int endIndex = endRange.location - startIndex;
                    currReading.SFRLC = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"RSR:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", RC" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 4;
                    int endIndex = endRange.location - startIndex;
                    currReading.RSR = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"RC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", LM" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    currReading.RC = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"LM:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@"\r" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    currReading.LM = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                
                startRange = [currString rangeOfString:@"GSM Serving Cell:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    isServingCell = YES;
                    
				}
                
				startRange = [currString rangeOfString:@"Ci:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", B" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    if(neighboureNumber == 1)
                    {
                        currReading.Ci_1 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        
                    }
                    else if(neighboureNumber ==2)
                    {
                        currReading.Ci_2 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber ==3)
                    {
                        currReading.Ci_3 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber ==4)
                    {
                        currReading.Ci_4 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber ==5)
                    {
                        currReading.Ci_5 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber ==6)
                    {
                        currReading.Ci_6 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
					
				}
				
                startRange = [currString rangeOfString:@"B:\"" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@"\", Arfcn" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {
                        currReading.SCG = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 1)
                    {
                        currReading.B_1 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 2)
                    {
                        currReading.B_2 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 3)
                    {
                        currReading.B_3 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 4)
                    {
                        currReading.B_4 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 5)
                    {
                        currReading.B_5 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 6)
                    {
                        currReading.B_6 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    
				}
                
                startRange = [currString rangeOfString:@"Arfcn:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", Rssi" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 6;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {
                        currReading.SCArfcn = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 1)
                    {
                        currReading.Arfcn_1 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 2)
                    {
                        currReading.Arfcn_2 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 3)
                    {
                        currReading.Arfcn_3 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 4)
                    {
                        currReading.Arfcn_4 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 5)
                    {
                        currReading.Arfcn_5 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 6)
                    {
                        currReading.Arfcn_6 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
				}
                
                startRange = [currString rangeOfString:@"Rssi:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", C1" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 5;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {
                        currReading.SCRssi = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 1)
                    {
                        currReading.Rssi_1 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 2)
                    {
                        currReading.Rssi_2 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 3)
                    {
                        currReading.Rssi_3 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 4)
                    {
                        currReading.Rssi_4 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 5)
                    {
                        currReading.Rssi_5 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 6)
                    {
                        currReading.Rssi_6 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    
				}
                
                startRange = [currString rangeOfString:@"C1:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange;
                    if(isServingCell)
                    {
                        endRange = [currString rangeOfString:@", C2" options:NSCaseInsensitiveSearch];
                    }
                    else
                    {
                        endRange = [currString rangeOfString:@", Bsic" options:NSCaseInsensitiveSearch];
                    }
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {
                        currReading.SCC1 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 1)
                    {
                        currReading.C1_1 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 2)
                    {
                        currReading.C1_2 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 3)
                    {
                        currReading.C1_3 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 4)
                    {
                        currReading.C1_4 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 5)
                    {
                        currReading.C1_5 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
                    else if(neighboureNumber == 6)
                    {
                        currReading.C1_6 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
				}
                
                startRange = [currString rangeOfString:@"C2:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", Bsic" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {   
                        currReading.SCC2 = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    }
				}
                
                startRange = [currString rangeOfString:@"Bsic:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange;
                    if(isServingCell)
                    {
                        endRange = [currString rangeOfString:@", MA" options:NSCaseInsensitiveSearch];
                    }
                    else
                    {
                        endRange = [currString rangeOfString:@"\r" options:NSCaseInsensitiveSearch];

                    }
                    int startIndex = startRange.location + 5;
                    int endIndex = endRange.location - startIndex;
                    if(isServingCell)
                    {   
                        currReading.SCBsic = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    }
                    else if(neighboureNumber == 1)
                    {
                        currReading.Bsic_1 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 2;
                    }
                    else if(neighboureNumber == 2)
                    {
                        currReading.Bsic_2 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 3;
                    }
                    else if(neighboureNumber == 3)
                    {
                        currReading.Bsic_3 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 4;
                    }
                    else if(neighboureNumber == 4)
                    {
                        currReading.Bsic_4 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 5;
                    }
                    else if(neighboureNumber == 5)
                    {
                        currReading.Bsic_5 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 6;
                    }
                    else if(neighboureNumber == 6)
                    {
                        currReading.Bsic_6 = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                        neighboureNumber = 0;
                    }
				}
                
                startRange = [currString rangeOfString:@"MA:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@", MADed" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 3;
                    int endIndex = endRange.location - startIndex;
                    currReading.SCMA = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"MADed:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    NSRange endRange = [currString rangeOfString:@"\r" options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 6;
                    int endIndex = endRange.location - startIndex;
                    currReading.SCMADed = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
                    
				}
                
                startRange = [currString rangeOfString:@"GSM Neighboring Cell:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
                    isServingCell = NO;
                    neighboureNumber = 1;
                    
				}
                
               
				
				
				startRange = [currString rangeOfString:@"UMTS Neighboring Cell:" options:NSCaseInsensitiveSearch];
				if(startRange.location != NSNotFound)
				{
					isServingCell = NO;
					neighboureNumber = 0;
					
				}
				
				startRange = [currString rangeOfString:@"Serving PLMN:" options:NSCaseInsensitiveSearch];
				if(startRange.location != NSNotFound)
				{
					isPLMN = TRUE;
					
				}
				
				startRange = [currString rangeOfString:@"MCC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@", MNC" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 4;
						int endIndex = endRange.location - startIndex;
						currReading.MCC = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
					}
                    
				}
				
				startRange = [currString rangeOfString:@"MNC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@", LAC" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 4;
						int endIndex = endRange.location - startIndex;
						currReading.MNC = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
					}
                    
				}
				
				startRange = [currString rangeOfString:@"LAC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@", CI" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 4;
						int endIndex = endRange.location - startIndex;
						currReading.LAC = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
					}
                    
				}
				
				startRange = [currString rangeOfString:@"CI:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@", RAC" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 3;
						int endIndex = endRange.location - startIndex;
						currReading.CI = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
					}
                    
				}
				
				startRange = [currString rangeOfString:@"RAC:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@", AcT" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 4;
						int endIndex = endRange.location - startIndex;
						currReading.RAC = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
					}
                    
				}
				
				startRange = [currString rangeOfString:@"AcT:" options:NSCaseInsensitiveSearch];
                if(startRange.location != NSNotFound)
				{
					if(isPLMN)
					{
						NSRange endRange = [currString rangeOfString:@"\r" options:NSCaseInsensitiveSearch];
						int startIndex = startRange.location + 4;
						int endIndex = endRange.location - startIndex;
						currReading.AcT = [[currString substringWithRange:NSMakeRange(startIndex, endIndex)] intValue];
					}
                    
				}
				
			}
			if(currReading.SCRssi > 0)
			{
				model.currReading = currReading;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"newReading" object:nil 
																  userInfo:nil];
			}
			
		}
		
		
    }
	}
	
	[self CloseConn:modem];
	[pool release];
	NSLog (@"Closing connection:::");
}

/* 
 Start of 'sendmodem' code. 
 ------------------------------------------------------------------------------
 */

unsigned char readbuf[BUFSIZE];

static struct termios term;
static struct termios gOriginalTTYAttrs;
int InitConn(int speed);

-(void) SendCmd:(int) modem: (void *)buf: (size_t) size
{
    if(write(modem, buf, size) == -1) {
        fprintf(stderr, "SendCmd error. %s\n", strerror(errno));
        exit(1);
    }
}

-(void) SendStrCmd: (int) modem: (char *) buf
{
    fprintf(stderr,"Sending command to modem: %s\n",buf);
    [self SendCmd:modem :buf :strlen(buf)];
}

-(NSString *) ReadResp: (int) modem: (int) timeoutSec
{
    int len = 0;
    struct timeval timeout;
    int nfds = modem + 1;
    fd_set readfds;
    int select_ret;
	
    FD_ZERO(&readfds);
    FD_SET(modem, &readfds);
	
    // Wait 10 seconds for carrier response
    timeout.tv_sec = timeoutSec;
    timeout.tv_usec = 500000;
	
    fprintf(stderr,"-");
    while ((select_ret = select(nfds, &readfds, NULL, NULL, &timeout)) > 0) {
        fprintf(stderr,".");
        len += read(modem, readbuf + len, BUFSIZE - len);
        FD_ZERO(&readfds);
        FD_SET(modem, &readfds);
        timeout.tv_sec = 0;
        timeout.tv_usec = 500000;
    }
    if (len > 0) {
        fprintf(stderr,"+\n");
    }
	
	readbuf[len] = 0;
	
	NSString *responseString = [NSString stringWithCString:(const char *)readbuf encoding:NSUTF8StringEncoding];
	
    return responseString;
}

-(int) InitConn: (int) speed
{
    int modem = open("/dev/tty.debug", O_RDWR | O_NOCTTY);
	
    if(modem == -1) {
        fprintf(stderr, "%i(%s)\n", errno, strerror(errno));
        exit(1);
    }
	
    ioctl(modem, TIOCEXCL);
    fcntl(modem, F_SETFL, 0);
	
    tcgetattr(modem, &term);
    gOriginalTTYAttrs = term;
	
    cfmakeraw(&term);
    cfsetspeed(&term, speed);
    term.c_cflag = CS8 | CLOCAL | CREAD;
    term.c_iflag = 0;
    term.c_oflag = 0;
    term.c_lflag = 0;
    term.c_cc[VMIN] = 0;
    term.c_cc[VTIME] = 0;
    tcsetattr(modem, TCSANOW, &term);
	
    return modem;
}
-(void) CloseConn: (int) modem
{
    tcdrain(modem);
    tcsetattr(modem, TCSANOW, &gOriginalTTYAttrs);
    close(modem);
}

-(void) SendAT:(int) fd
{
    char cmd[5];
	
    //  SendStrCmd(fd, "AT\r");
    sprintf(cmd,"AT\r");
    [self SendCmd:fd :cmd :strlen(cmd)];
}

-(void) AT :(int) fd
{
    fprintf(stderr, "Sending command to modem: AT\n");
    [self SendAT:fd];
    for (;;) {
        if([self ReadResp:fd :1] != 0) {
            if(strstr((const char *)readbuf,"OK") != NULL)
            {
                break;
            }
        }
        [self SendAT:fd];
    }
}
@end
