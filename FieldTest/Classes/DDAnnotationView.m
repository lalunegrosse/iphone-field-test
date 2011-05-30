//
//  DDAnnotationView.m
//  MapKitDragAndDrop
//
//  Created by digdog on 7/24/09.
//  Copyright 2009 digdog software.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DDAnnotationView.h"
//#import "DDAnnotation.h"
#import "POI.h"


@interface DDAnnotationView ()
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint originalCenter;
@end


#pragma mark -
#pragma mark DDAnnotationView implementation

@implementation DDAnnotationView

@synthesize isMoving = _isMoving;
@synthesize startLocation = _startLocation;
@synthesize originalCenter = _originalCenter;
@synthesize mapView = _mapView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
		self.enabled = YES;
		self.canShowCallout = YES;
		self.multipleTouchEnabled = NO;
		self.animatesDrop = NO;
		self.pinColor = MKPinAnnotationColorGreen;
		if([reuseIdentifier isEqualToString:@"Red1"])
		{
			self.image = [UIImage imageNamed:@"Red1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red2"])
		{
			self.image = [UIImage imageNamed:@"Red1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red3"])
		{
			self.image = [UIImage imageNamed:@"Red3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red4"])
		{
			self.image = [UIImage imageNamed:@"Red3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red5"])
		{
			self.image = [UIImage imageNamed:@"Red5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red6"])
		{
			self.image = [UIImage imageNamed:@"Red5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red7"])
		{
			self.image = [UIImage imageNamed:@"Red7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red8"])
		{
			self.image = [UIImage imageNamed:@"Red7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red9"])
		{
			self.image = [UIImage imageNamed:@"Red10.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"Red10"])
		{
			self.image = [UIImage imageNamed:@"Red10.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B1"])
		{
			self.image = [UIImage imageNamed:@"B1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B2"])
		{
			self.image = [UIImage imageNamed:@"B1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B3"])
		{
			self.image = [UIImage imageNamed:@"B3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B4"])
		{
			self.image = [UIImage imageNamed:@"B3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B5"])
		{
			self.image = [UIImage imageNamed:@"B5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B6"])
		{
			self.image = [UIImage imageNamed:@"B5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B7"])
		{
			self.image = [UIImage imageNamed:@"B7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B8"])
		{
			self.image = [UIImage imageNamed:@"B7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B9"])
		{
			self.image = [UIImage imageNamed:@"B10.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"B10"])
		{
			self.image = [UIImage imageNamed:@"B10.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G1"])
		{
			self.image = [UIImage imageNamed:@"G1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G2"])
		{
			self.image = [UIImage imageNamed:@"G1.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G3"])
		{
			self.image = [UIImage imageNamed:@"G3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G4"])
		{
			self.image = [UIImage imageNamed:@"G3.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G5"])
		{
			self.image = [UIImage imageNamed:@"G5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G6"])
		{
			self.image = [UIImage imageNamed:@"G5.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G7"])
		{
			self.image = [UIImage imageNamed:@"G7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G8"])
		{
			self.image = [UIImage imageNamed:@"G7.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G9"])
		{
			self.image = [UIImage imageNamed:@"G10.PNG"];
		}
		else if([reuseIdentifier isEqualToString:@"G10"])
		{
			self.image = [UIImage imageNamed:@"G10.PNG"];
		}
		
		
		
		POI *buddyPin = (POI *) annotation;
		UIImageView *leftIconView = nil;
		if([reuseIdentifier rangeOfString:@"Red"].location != NSNotFound)
		{
				leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ufone.PNG"]];
		}
		else if([reuseIdentifier rangeOfString:@"B"].location != NSNotFound)
		{
				leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Zong.PNG"]];
		}
		else
		{
			leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Telenor.PNG"]];
		}

		
			self.leftCalloutAccessoryView = leftIconView;
			[leftIconView release];
		
		
		

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.rightCalloutAccessoryView = rightButton;		
	}
	return self;
}

#pragma mark -
#pragma mark Handling events

// Reference: iPhone Application Programming Guide > Device Support > Displaying Maps and Annotations > Displaying Annotations > Handling Events in an Annotation View

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// The view is configured for single touches only.
    UITouch* aTouch = [touches anyObject];
    self.startLocation = [aTouch locationInView:[self superview]];
    self.originalCenter = self.center;
	
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch* aTouch = [touches anyObject];
    CGPoint newLocation = [aTouch locationInView:[self superview]];
    CGPoint newCenter;
	
	// If the user's finger moved more than 5 pixels, begin the drag.
    if ((abs(newLocation.x - self.startLocation.x) > 5.0) || (abs(newLocation.y - self.startLocation.y) > 5.0)) {
		self.isMoving = YES;		
	}
	
	// If dragging has begun, adjust the position of the view.
    if (self.isMoving) {
        newCenter.x = self.originalCenter.x + (newLocation.x - self.startLocation.x);
        newCenter.y = self.originalCenter.y + (newLocation.y - self.startLocation.y);
        self.center = newCenter;
    } else {
		// Let the parent class handle it.
        [super touchesMoved:touches withEvent:event];		
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

 /*   if (self.isMoving) {
        // Update the map coordinate to reflect the new position.
        CGPoint newCenter = self.center;
        DDAnnotation* theAnnotation = (DDAnnotation *)self.annotation;
        CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:newCenter toCoordinateFromView:self.superview];
		
        [theAnnotation changeCoordinate:newCoordinate];
		
        // Clean up the state information.
        self.startLocation = CGPointZero;
        self.originalCenter = CGPointZero;
        self.isMoving = NO;
    } else {
        [super touchesEnded:touches withEvent:event];		
	}*/
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.isMoving) {
        // Move the view back to its starting point.
        self.center = self.originalCenter;
		
        // Clean up the state information.
        self.startLocation = CGPointZero;
        self.originalCenter = CGPointZero;
        self.isMoving = NO;
    } else {
        [super touchesCancelled:touches withEvent:event];		
	}
}

@end
