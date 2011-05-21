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
	[NSThread detachNewThreadSelector:@selector(startFetchingData) toTarget:self withObject:nil];
	NSLog(@"thread ending");
}

-(void) startFetchingData
{
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
	
	NSLog (@"Waiting for modem to be free..");
	[self AT:modem]; // wait for device to be free, by polling with AT commands.
	
	NSLog (@"Requesting Prepaid balance from PCCW..");
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
					NSLog(@"found");
                    NSRange endRange = [currString rangeOfString:@"\"," options:NSCaseInsensitiveSearch];
                    int startIndex = startRange.location + 5;
                    int endIndex = endRange.location - startIndex;
                    //currReading.RAT = [currString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    
				}
			}
        }
		NSLog (@"Skipping:::");
    }
	
	[self CloseConn:modem];
	
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
