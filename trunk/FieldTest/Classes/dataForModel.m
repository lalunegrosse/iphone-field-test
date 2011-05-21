//
//  dataForModel.m
//  UrFilez
//
//  Created by Ashar on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "dataForModel.h"
#import "SynthesizeSingleton.h"

/////////////////

@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";



@implementation NSData (MBBase64)



+ (id)dataWithBase64EncodedString:(NSString *)string;
{
	if (string == nil)
		[NSException raise:NSInvalidArgumentException format:nil];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding;
{
	if ([self length] == 0)
		return @"";
	
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [self length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

@end
///////////////////

@implementation dataForModel
SYNTHESIZE_SINGLETON_FOR_CLASS(dataForModel);

@synthesize notificationCount;
@synthesize latitude,longitude;
//@synthesize rememberMeSwitch;

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self != nil)
    {
		
		self.notificationCount = [coder decodeIntForKey:@"notificationCount"];
    }
	
    return self;
}


- (void) encodeWithCoder: (NSCoder *)coder
{
	
	[coder encodeInt:notificationCount forKey:@"notificationCount"];
}

- (void)dealloc
{
	
	[super dealloc];
}

- (id) init
{
    self = [super init];
    if (self != nil) {
		// Create the manager object 
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		// This is the most important property to set for the manager. It ultimately determines how the manager will
		// attempt to acquire location and thus, the amount of power that will be consumed.
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		// Once configured, the location manager must be "started".
		[locationManager startUpdatingLocation];
		
    }
    return self;
}


-(NSString *)getUID
{
	//UIDevice *device = [UIDevice currentDevice];
	//return [device uniqueIdentifier];
	return @"844BDF1C-5333-5776-B704-51CBD64DEC63";
}
-(NSString *)getDevice
{
	UIDevice *device = [UIDevice currentDevice];
	NSLog([device model]);
	return [device model];
}

-(NSString *)getOSVer
{
	UIDevice *device = [UIDevice currentDevice];
	return [device systemVersion];
}
-(BOOL)isDeviceHiRes
{
	BOOL hasHighResScreen = NO;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		CGFloat scale = [[UIScreen mainScreen] scale];
		if (scale > 1.0) {
			hasHighResScreen = YES;
		}
	}
	return hasHighResScreen;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
   
	self.latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
	self.longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
	NSLog(@"location updated");
		
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error location not available");
    if ([error code] != kCLErrorLocationUnknown) {
        //[self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

@end
