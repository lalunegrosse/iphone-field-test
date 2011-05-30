//
//  TowerInfoViewController.m
//  TowerInfo
//
//  Created by urfilez on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TowerInfoViewController.h"
#import "workerThread.h"
#include <stdio.h>
#include <string.h>
#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>


#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <errno.h>
#include <time.h>

#define BUFSIZE (65536+100)
@implementation TowerInfoViewController
@synthesize inputField;
@synthesize infoView;
@synthesize numOfReadings;
@synthesize signalStrength;
@synthesize neighbourCells;
@synthesize accessTech;
@synthesize lati;
@synthesize longi;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	model = [dataForModel shareddataForModel];
	sqlManager = [SQLManager sharedSQLManager];
	[sqlManager initilizeDB];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newReading) name:@"newReading" object:nil];
	workerThread *wt = [[workerThread alloc] init];
	[wt getToWork];
}

- (void) newReading
{
	
	[self performSelectorOnMainThread:@selector(updateValues) withObject:nil waitUntilDone:NO];
}

- (void) updateValues
{
	totalReadings++;
	lati.text = model.latitude;
	longi.text = model.longitude;
	
	signalStrength.text = [NSString stringWithFormat:@"%d", model.currReading.SCRssi];
	accessTech.text = [NSString stringWithFormat:@"%d", model.currReading.AcT];
	numOfReadings.text = [NSString stringWithFormat:@"%d",totalReadings];
	
	if(model.currReading.Rssi_6 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",6];
	}
	else if(model.currReading.Rssi_5 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",5];
	}
	else if(model.currReading.Rssi_4 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",4];
	}
	else if(model.currReading.Rssi_3 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",3];
	}
	else if(model.currReading.Rssi_2 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",2];
	}
	else if(model.currReading.Rssi_1 > 0)
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",1];
	}
	else
	{
		neighbourCells.text = [NSString stringWithFormat:@"%d",0];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction) sendCommand
{
	
	workerThread *wt = [[workerThread alloc] init];
	[wt getToWork];
	return;
	
	int modem;
	char cmd[1024];	
	NSString *responseString;
	
	// Set AT command to fetch balance 
	sprintf(cmd,[inputField.text cString]);
	//sprintf(cmd,"AT+CUSD=1,\"*124#\",15\r");
	//sprintf(cmd,"AT+CGED=0\r");
	
	
	NSLog([NSString stringWithFormat:@"buffer length= %d,", strlen(cmd)]);
	cmd[strlen(cmd)] = '\r';
	
	modem = [self InitConn:115200];
	
	NSLog (@"Waiting for modem to be free..");
	[self AT:modem]; // wait for device to be free, by polling with AT commands.
	
	NSLog (@"Requesting Prepaid balance from PCCW..");
	[self SendStrCmd:modem :cmd];
	
	
	// Loop til we find the balance response
	for (int i=0;i<3;i++) {
        if((responseString = [self ReadResp:modem :10])) {
			infoView.text = [NSString stringWithFormat:@"%@ %@",infoView.text, responseString];
        }
		NSLog (@"Skipping: %@", responseString);
    }
	
	[self CloseConn:modem];
	
	NSLog (@"Response: %@", responseString);
	
	
}

-(IBAction) getData
{
	NSLog(@"start.....modem");
	int modem;
	char cmd[1024];	
	NSString *responseString;
	
	// Set AT command to fetch balance 
	sprintf(cmd,"AT+CUSD=1,\"*124#\",15\r");
	
	modem = [self InitConn:115200];
	
	NSLog (@"Waiting for modem to be free..");
	[self AT:modem]; // wait for device to be free, by polling with AT commands.
	
	NSLog (@"Requesting Prepaid balance from PCCW..");
	[self SendStrCmd:modem :cmd];
	
	NSRange check;
	// Loop til we find the balance response
	for (int i=0;i<20;i++) {
        if((responseString = [self ReadResp:modem :10])) {
			check = [responseString rangeOfString: @"Rs."];
            if(check.length > 0){
                break;
            }
        }
		NSLog (@"Skipping: %@", responseString);
    }
	
	[self CloseConn:modem];
	
	NSLog (@"Response: %@", responseString);
	
	// Parse prepaid balance (first string between '$' and ',')
	NSRange match;
	match = [responseString rangeOfString: @"."]; // Find first occurence of $
	responseString = [responseString substringFromIndex: match.location];
	match = [responseString rangeOfString: @","]; // First occurence of , after $
	NSString *balance = [responseString substringToIndex: match.location];
	
	NSLog (@"Fetched balance. Setting operator to: %@", balance);
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

/* 
 End of 'sendmodem' code. 
 ------------------------------------------------------------------------------
 */
@end
