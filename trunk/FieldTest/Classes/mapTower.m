//
//  mapTower.m
//  FieldTest
//
//  Created by urfilez on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "mapTower.h"

#define LABEL_PACKAGE_NAME 9999
#define LABEL_PACKAGE_NAME_VALUE 9998
#define LABEL_PAID_VIA 9997
#define LABEL_PAID_VIA_VALUE 9996
#define LABEL_STATE_DATE 9995
#define LABEL_STATE_DATE_VALUE 9994
#define LABEL_END_DATE 9993
#define LABEL_END_DATE_VALUE 9992
#define LABEL_AMOUNT 9991
#define LABEL_AMOUNT_VALUE 9990
#define LABEL_CURR_VALUE 10000


@implementation mapTower
@synthesize myTableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	model = [dataForModel shareddataForModel];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newReading) name:@"newReading" object:nil];
}

- (void) newReading
{
	
	[self performSelectorOnMainThread:@selector(updateValues) withObject:nil waitUntilDone:NO];
}

- (void) updateValues
{
	[myTableView reloadData];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(model.currReading.Rssi_6 > 0)
	{
		return 6;
	}
	else if(model.currReading.Rssi_5 > 0)
	{
		return 5;
	}
	else if(model.currReading.Rssi_4 > 0)
	{
		return 4;
	}
	else if(model.currReading.Rssi_3 > 0)
	{
		return 3;
	}
	else if(model.currReading.Rssi_2 > 0)
	{
		return 2;
	}
	else if(model.currReading.Rssi_1 > 0)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"NoteCell%d %d",indexPath.section, indexPath.row];
    UILabel *labelPackageName = nil;
	UILabel *labelPackageNameValue = nil;
	UILabel *labelPaidVia = nil;
	UILabel *labelPaidViaValue = nil;
	UILabel *labelStartDate = nil;
	UILabel *labelStartDateValue = nil;
	UILabel *labelEndDate = nil;
	UILabel *labelEndDateValue = nil;
	UILabel *labelAmount = nil;
	UILabel *labelAmountValue = nil;
	UILabel *currencyValue = nil;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		CGRect frame;
		
		UIImageView *thumb = nil;
		thumb = [[[UIImageView alloc] init] autorelease];
		thumb.image = [UIImage imageNamed:@"cell-bg10.png"];
		//cell.backgroundView = thumb;
		cell.backgroundColor = [UIColor clearColor];
		
        frame.origin.x = 10;
        frame.origin.y = 10;
        frame.size.width = 120;
        frame.size.height = 20;
        labelPackageName = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelPackageName.tag = LABEL_PACKAGE_NAME;
		labelPackageName.text = @"Cell ID: ";
		labelPackageName.textColor = [UIColor blackColor];
		labelPackageName.font = [UIFont systemFontOfSize:14];
		labelPackageName.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelPackageName];
		
		
		frame.origin.x = 140;
        frame.origin.y = 10;
        frame.size.width = 120;
        frame.size.height = 20;
		labelPackageNameValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelPackageNameValue.tag = LABEL_PACKAGE_NAME_VALUE;
		labelPackageNameValue.text = @"";
		labelPackageNameValue.textColor = [UIColor blueColor];
		labelPackageNameValue.font = [UIFont systemFontOfSize:14];;
		labelPackageNameValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelPackageNameValue];
		
		
		frame.origin.x = 10;
        frame.origin.y = 90;
        frame.size.width = 120;
        frame.size.height = 20;
		labelPaidVia = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelPaidVia.tag = LABEL_PAID_VIA ;
		labelPaidVia.text = @"Band type: ";
		labelPaidVia.textColor = [UIColor blackColor];
		labelPaidVia.font = [UIFont systemFontOfSize:14];
		labelPaidVia.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelPaidVia];
		
		frame.origin.x = 140;
        frame.origin.y = 90;
        frame.size.width = 120;
        frame.size.height = 20;
        labelPaidViaValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelPaidViaValue.tag = LABEL_PAID_VIA_VALUE;
		labelPaidViaValue.text = @"";
		labelPaidViaValue.textColor = [UIColor blueColor];
		labelPaidViaValue.font = [UIFont systemFontOfSize:14];
		labelPaidViaValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelPaidViaValue];
		
		frame.origin.x = 10;
        frame.origin.y = 50;
        frame.size.width = 120;
        frame.size.height = 20;
        labelStartDate = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelStartDate.tag = LABEL_STATE_DATE;
		labelStartDate.text = @"Arfcn:";
		labelStartDate.textColor = [UIColor blackColor];
		labelStartDate.font = [UIFont systemFontOfSize:14];
		labelStartDate.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelStartDate];
		
		
		
		frame.origin.x = 140;
        frame.origin.y = 50;
        frame.size.width = 160;
        frame.size.height = 20;
        labelStartDateValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelStartDateValue.tag = LABEL_STATE_DATE_VALUE;
		labelStartDateValue.textColor = [UIColor blueColor];
		labelStartDateValue.text = @"";
		labelStartDateValue.font = [UIFont systemFontOfSize:14];
		labelStartDateValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelStartDateValue];
		
		frame.origin.x = 10;
        frame.origin.y = 70;
        frame.size.width = 100;
        frame.size.height = 20;
        labelEndDate = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelEndDate.tag = LABEL_END_DATE;
		labelEndDate.text = @"Rssi:";
		labelEndDate.textColor = [UIColor blackColor];
		labelEndDate.font = [UIFont systemFontOfSize:14];
		labelEndDate.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelEndDate];
		
		
		
		frame.origin.x = 140;
        frame.origin.y = 70;
        frame.size.width = 160;
        frame.size.height = 20;
        labelEndDateValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelEndDateValue.tag = LABEL_END_DATE_VALUE;
		labelEndDateValue.text = @"";
		labelEndDateValue.textColor = [UIColor blueColor];
		labelEndDateValue.font = [UIFont systemFontOfSize:14];
		labelEndDateValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelEndDateValue];
		
		frame.origin.x = 10;
        frame.origin.y = 30;
        frame.size.width = 100;
        frame.size.height = 20;
        labelAmount = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelAmount.tag = LABEL_AMOUNT;
		labelAmount.text = @"Bsic:";
		labelAmount.textColor = [UIColor blackColor];
		labelAmount.font = [UIFont systemFontOfSize:14];
		labelAmount.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelAmount];
		
		frame.origin.x = 140;
        frame.origin.y = 30;
        frame.size.width = 20;
        frame.size.height = 20;
        labelAmountValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        labelAmountValue.tag = LABEL_AMOUNT_VALUE;
		labelAmountValue.text = @"";
		labelAmountValue.textColor = [UIColor blueColor];
		labelAmountValue.font = [UIFont systemFontOfSize:14];
		labelAmountValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:labelAmountValue];
		
		frame.origin.x = 150;
        frame.origin.y = 30;
        frame.size.width = 50;
        frame.size.height = 20;
        currencyValue = [[[UILabel alloc] initWithFrame:frame] autorelease];
        currencyValue.tag = LABEL_CURR_VALUE;
		currencyValue.text = @"";
		currencyValue.textColor = [UIColor blueColor];
		currencyValue.font = [UIFont systemFontOfSize:14];
		currencyValue.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:currencyValue];
		
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
		labelPackageName = (UILabel *) [cell.contentView viewWithTag:LABEL_PACKAGE_NAME];
		labelPackageNameValue = (UILabel *) [cell.contentView viewWithTag:LABEL_PACKAGE_NAME_VALUE];
		labelPaidVia = (UILabel *) [cell.contentView viewWithTag:LABEL_PAID_VIA];
		labelPaidViaValue = (UILabel *) [cell.contentView viewWithTag:LABEL_PAID_VIA_VALUE];
		labelStartDate = (UILabel *) [cell.contentView viewWithTag:LABEL_STATE_DATE];
		labelStartDateValue = (UILabel *) [cell.contentView viewWithTag:LABEL_STATE_DATE_VALUE];
		labelEndDate = (UILabel *) [cell.contentView viewWithTag:LABEL_END_DATE];
		labelEndDateValue = (UILabel *) [cell.contentView viewWithTag:LABEL_END_DATE_VALUE];
		labelAmount = (UILabel *) [cell.contentView viewWithTag:LABEL_AMOUNT];
		labelAmountValue = (UILabel *) [cell.contentView viewWithTag:LABEL_AMOUNT_VALUE];
		currencyValue = (UILabel *) [cell.contentView viewWithTag:LABEL_CURR_VALUE];
    }
	if(indexPath.row == 0)
	{
		labelPackageNameValue.text = model.currReading.Ci_1;
		labelPaidViaValue.text = model.currReading.B_1;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_1] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_1] ;
		labelAmountValue.text = model.currReading.Bsic_1;
		
	}
	else if(indexPath.row == 1)
	{
		labelPackageNameValue.text = model.currReading.Ci_2;
		labelPaidViaValue.text = model.currReading.B_2;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_2] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_2] ;
		labelAmountValue.text = model.currReading.Bsic_2;
	}
	else if(indexPath.row == 2)
	{
		labelPackageNameValue.text = model.currReading.Ci_3;
		labelPaidViaValue.text = model.currReading.B_3;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_3] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_3] ;
		labelAmountValue.text = model.currReading.Bsic_3;
	}
	else if(indexPath.row == 3)
	{
		labelPackageNameValue.text = model.currReading.Ci_4;
		labelPaidViaValue.text = model.currReading.B_4;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_4] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_4] ;
		labelAmountValue.text = model.currReading.Bsic_4;
	}
	else if(indexPath.row == 4)
	{
		labelPackageNameValue.text = model.currReading.Ci_5;
		labelPaidViaValue.text = model.currReading.B_5;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_5] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_5] ;
		labelAmountValue.text = model.currReading.Bsic_5;
	}
	else if(indexPath.row == 5)
	{
		labelPackageNameValue.text = model.currReading.Ci_6;
		labelPaidViaValue.text = model.currReading.B_6;
		labelStartDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Arfcn_6] ;
		labelEndDateValue.text = [NSString stringWithFormat:@"%d",model.currReading.Rssi_6] ;
		labelAmountValue.text = model.currReading.Bsic_6;
	}
	
    return cell;
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {  
	
	return 120;
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
	
	
}

@end
