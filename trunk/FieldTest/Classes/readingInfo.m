//
//  readingInfo.m
//  FieldTest
//
//  Created by urfilez on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "readingInfo.h"


@implementation readingInfo
@synthesize RAT, RR, txpwr, RxLevServ, RxQualFull, RxQualSub, dtx_used, drx_used, SFRLC, RSR, RC, LM, SCG, SCArfcn, SCRssi, SCC1, SCC2, SCBsic, SCMA, SCMADed, GSMNCell, UMTSNCell, CRT, IRCR, AIRCR, IRHO, AIRHO, EMCC, EMNC, MCC, MNC, LAC, CI, RAC, AcT, SplitPg, Count_LR, Count_HR, C_R_Hyst, C31, C32, Prior_Acc_Thr;
@synthesize Ci_1, B_1, Arfcn_1, Rssi_1, C1_1, Bsic_1;
@synthesize Ci_2, B_2, Arfcn_2, Rssi_2, C1_2, Bsic_2;
@synthesize Ci_3, B_3, Arfcn_3, Rssi_3, C1_3, Bsic_3;
@synthesize Ci_4, B_4, Arfcn_4, Rssi_4, C1_4, Bsic_4;
@synthesize Ci_5, B_5, Arfcn_5, Rssi_5, C1_5, Bsic_5;
@synthesize Ci_6, B_6, Arfcn_6, Rssi_6, C1_6, Bsic_6;

- (id)init { 
    self = [super init];
    if (self != nil) {
        GSMNCell = [[NSMutableArray alloc] init];
		
    }
    return self;
}

- (void)dealloc
{
	[GSMNCell release];
	[super dealloc];
}

@end
