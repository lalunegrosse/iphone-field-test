//
//  readingInfo.h
//  FieldTest
//
//  Created by urfilez on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface readingInfo : NSObject {
	NSString	*RAT;       //<rat> - currently selected Radio Access Technologie (RAT) and may be: "UMTS" "GSM"
	int			RR;         /*<rr_state> - values 1-35 
                             STATE GRR_START	1 
                             STATE GRR_WAIT_FOR_ACT STATE 2
                             STATE GRR_CELL_SELECTION STATE GRR_WAIT_CELL_SELECTION	4 
                             STATE GRR_DEACT_CELL_SELECTION	5
                             STATE GRR_SELECT_ANY_CELL	6
                             STATE GRR_WAIT_SELECT_ANY_CELL	7 
                             STATE GRR_DEACT_SELECT_ANY_CELL 8
                             STATE GRR_WAIT_INACTIVE 9
                             STATE GRR_INACTIVE	10 
                             STATE GRR_IDLE	11
                             STATE GRR_PLMN_SEARCH 12
                             STATE GRR_WAIT_PLMN_SEARCH 13
                             STATE GRR_CELL_RESELECTION 14
                             STATE GRR_WAIT_CELL_RESELECTION 15
                             STATE GRR_ABORT_PLMN_SEARCH	16 
                             STATE GRR_DEACT_PLMN_SEARCH	17
                             STATE GRR_CELL_CHANGE STATE 18
                             GRR_CS_CELL_CHANGE STATE 19
                             GRR_WAIT_CELL_CHANGE STATE 20
                             GRR_SINGLE_BLOCK_ASSIGN 21
                             STATE GRR_DOWNL_TBF_EST 22
                             STATE GRR_UPL_TBF_EST 23
                             STATE GRR_WAIT_TBF 24
                             STATE GRR_TRANSFER 25
                             STATE GRR_MO_CON_EST 26
                             STATE GRR_MT_CON_EST 27
                             STATE GRR_RR_CONNECTION 28
                             STATE GRR_CALL_REESTABLISH	29 
                             STATE GRR_NORMAL_CHN_REL	30
                             STATE GRR_LOCAL_CHN_REL STATE 31
                             GRR_WAIT_IDLE STATE 32
                             GRR_DEACTIVATION STATE 33
                             GRR_IR_CELL_RESEL_TO_UTRAN	34 
                             STATE RR_INACTIVE	35
                             */
                             
    int		txpwr;      //<txpwr> - Transmit power level of the current connection, range 0-31 (5 bits);
	int			RxLevServ;  //RxLevserv is the receiving level of the currently serving source cell
	int			RxQualFull; //<RxQualFull> - Received signal quality on serving cell, measured on all slots; range 0-7;
	int			RxQualSub;  //<RxQualSub> - Received signal qual.onserving cell, measured on a subset of slots, range 0-7;
	bool		dtx_used;   //<dtx_used>: DTX used, range 0-1; 
	bool		drx_used;   //<dtr_used> - DTX used, range 0-1;
	int			SFRLC;      //:<signal_failure/radio_link_counter>  - integer, range 0-99
                          //in case of grr_state == GRR_IDLE (11) Downlink Signaling Counter will be printed 
                          //in case of grr_state == GRR_RR_CONNECTION (28) Radio Link Loss Counter will be printed
	int			RSR;        //<reselection_reason> - integer, range 0-99 
                            //0 - RESEL_PLMN_CHANGE 
                            //1 - RESEL_SERV_CELL_NOT_SUITABLE 
                            //2 - RESEL_BETTER_C2_C32
                            //3 - RESEL_DOWNLINK_FAIL 
                            //4 - RESEL_RA_FAILURE 
                            //5 - RESEL_SI_RECEIPT_FAILURE
                            //6 - RESEL_C1_LESS_NULL 
                            //7 - RESEL_CALL_REEST_TIMEOUT 
                            //8 - RESEL_ABNORMAL_RESEL 
                            //9 - RESEL_CELL_CHANGE_ORDER 
                            //10 - RESEL_NOT_OCCURRED
	int			RC;         //<release_cause> - integer, range 0-99
	int			LM;         //<limited_mode> may be 0-1
	
	//GSM Serving Cell
	NSString	*SCG;       // <gsm_band>
                            //"D",- 1800 MHz 
                            //"P",- 1900 MHz 
                            //"G" - 900 MHz
	int			SCArfcn;    //<arfcn> - absolute radio frequency channel number, range 0-1023
	int			SCRssi;     //<rssi> - radio signal strength -110 ... - 48 (negative values)
	int			SCC1;       //<c1> - integer, range 0-99
	int			SCC2;       //<c2> - integer, range 0-99
	int			SCBsic;     //<bsic> - base station identify code, range 0-3Fh (6 bits)
	int			SCMA;       //<nr_of_rf_in_ma> - integer, range 0-99
	int			SCMADed;    //<dedicated_arfcn> - dedicated arfcn, range 0-1023
	NSMutableArray	*GSMNCell;
	NSMutableArray	*UMTSNCell;
	
	int			CRT;        //<cell_reselecetion_total> - integer, range 0-999
	int			IRCR;       //<ir_cell_reseelection_counter> - integer, range 0-999
	int			AIRCR;      //<attempted_ir_cell_reselection> - integer, range 0-999
	int			IRHO;       //<ir_handover> - integer, range 0-999
	int			AIRHO;      //<attempted_ir_handover> - integer, range 0-999
	
	int			EMCC;       //<MCC> - Mobile country code, range 0-999 (3 digits)
	int			EMNC;       //<MNC> - Mobile network code, range 0-99 (2 digits)
    
    // serving PLMN
	int			MCC;        //<MCC> - Mobile country code, range 0-999 (3 digits)
	int			MNC;        //<MNC> - Mobile network code, range 0-99 (2 digits)
	NSString	*LAC;       //<LAC> - Location area code, range 0h-FFFFh (2 octets)
	NSString	*CI;        //<CI> - Cell Identity, range 0h-FFFFh (2 octets)
	int			RAC;        //<RAC> - Routing Area Code, range 0-1 (i bit);
	int			AcT;        //<AcT> - Access Technology, range 0..8,
                                //GSM=0, GPRS=1, EGPRS=2, EGPRS_PCR=3, EGPRS_EPCR=4,
                                //UMTS=5 (unused), DTM=6, EGPRS_DTM=7, undefined=8
	
	//GPRS Parameters
	bool		SplitPg; 
	int			Count_LR;   //<Count_LR> - PSI_COUNT_LR, range 0-63 (4 bits);
	int			Count_HR;   //<Count_HR> - PSI_COUNT_HR, range 0-15 mapped to 1-16 (4 bits);
	int			C_R_Hyst;   //<C_R_Hyst> - CELL-RESELECT-HYSTERESIS, range 0-7 (3 bits);
	int			C31;        //<C31> - Value of c31, integer
	int			C32;        //<C32> - Value of c32, integer
	int			Prior_Acc_Thr;  //<Prior_Acc_Thr> - Prioriry_ACCESS_THR, range 0-7 (3 bits);
    
    
    // neighbouring cells
    NSString    *Ci_1;
    NSString    *B_1; 
    int         Arfcn_1;
    int         Rssi_1;
    int         C1_1;
    NSString    *Bsic_1;
    
    NSString    *Ci_2;
    NSString    *B_2; 
    int         Arfcn_2;
    int         Rssi_2;
    int         C1_2;
    NSString    *Bsic_2;
    
    NSString    *Ci_3;
    NSString    *B_3; 
    int         Arfcn_3;
    int         Rssi_3;
    int         C1_3;
    NSString    *Bsic_3;
    
    NSString    *Ci_4;
    NSString    *B_4; 
    int         Arfcn_4;
    int         Rssi_4;
    int         C1_4;
    NSString    *Bsic_4;
    
    NSString    *Ci_5;
    NSString    *B_5; 
    int         Arfcn_5;
    int         Rssi_5;
    int         C1_5;
    NSString    *Bsic_5;
    
    NSString    *Ci_6;
    NSString    *B_6; 
    int         Arfcn_6;
    int         Rssi_6;
    int         C1_6;
    NSString    *Bsic_6;

}



@property (nonatomic, copy) NSString	*RAT;
@property (nonatomic)       int			RR;
@property (nonatomic)       int			txpwr;
@property (nonatomic)       int			RxLevServ;
@property (nonatomic)       int			RxQualFull;
@property (nonatomic)       int			RxQualSub;
@property (nonatomic)       bool		dtx_used;
@property (nonatomic)       bool		drx_used;
@property (nonatomic)       int			SFRLC;
@property (nonatomic)       int			RSR;
@property (nonatomic)       int			RC;
@property (nonatomic)       int			LM;

//GSM Serving Cell
@property (nonatomic, copy) NSString	*SCG;
@property (nonatomic)       int			SCArfcn;
@property (nonatomic)       int			SCRssi;
@property (nonatomic)       int			SCC1;
@property (nonatomic)       int			SCC2;
@property (nonatomic)       int			SCBsic;
@property (nonatomic)       int			SCMA;
@property (nonatomic)       int			SCMADed;
@property (nonatomic, retain) NSMutableArray	*GSMNCell;
@property (nonatomic, retain) NSMutableArray	*UMTSNCell;

@property (nonatomic)       int			CRT;
@property (nonatomic)       int			IRCR;
@property (nonatomic)       int			AIRCR;
@property (nonatomic)       int			IRHO;
@property (nonatomic)       int			AIRHO;

@property (nonatomic)       int			EMCC;
@property (nonatomic)       int			EMNC;
@property (nonatomic)       int			MCC;
@property (nonatomic)       int			MNC;
@property (nonatomic, copy) NSString	*LAC;
@property (nonatomic, copy) NSString	*CI;
@property (nonatomic)       int			RAC;
@property (nonatomic)       int			AcT;

//GPRS Parameters
@property (nonatomic)       bool		SplitPg;
@property (nonatomic)       int			Count_LR;
@property (nonatomic)       int			Count_HR;
@property (nonatomic)       int			C_R_Hyst;
@property (nonatomic)       int			C31;
@property (nonatomic)       int			C32;
@property (nonatomic)       int			Prior_Acc_Thr;

//neighbouring cells
@property (nonatomic, copy) NSString    *Ci_1;
@property (nonatomic, copy) NSString    *B_1; 
@property (nonatomic)       int         Arfcn_1;
@property (nonatomic)       int         Rssi_1;
@property (nonatomic)       int         C1_1;
@property (nonatomic, copy) NSString    *Bsic_1;

@property (nonatomic, copy) NSString    *Ci_2;
@property (nonatomic, copy) NSString    *B_2; 
@property (nonatomic)       int         Arfcn_2;
@property (nonatomic)       int         Rssi_2;
@property (nonatomic)       int         C1_2;
@property (nonatomic, copy) NSString    *Bsic_2;

@property (nonatomic, copy) NSString    *Ci_3;
@property (nonatomic, copy) NSString    *B_3; 
@property (nonatomic)       int         Arfcn_3;
@property (nonatomic)       int         Rssi_3;
@property (nonatomic)       int         C1_3;
@property (nonatomic, copy) NSString    *Bsic_3;

@property (nonatomic, copy) NSString    *Ci_4;
@property (nonatomic, copy) NSString    *B_4; 
@property (nonatomic)       int         Arfcn_4;
@property (nonatomic)       int         Rssi_4;
@property (nonatomic)       int         C1_4;
@property (nonatomic, copy) NSString    *Bsic_4;

@property (nonatomic, copy) NSString    *Ci_5;
@property (nonatomic, copy) NSString    *B_5; 
@property (nonatomic)       int         Arfcn_5;
@property (nonatomic)       int         Rssi_5;
@property (nonatomic)       int         C1_5;
@property (nonatomic, copy) NSString    *Bsic_5;

@property (nonatomic, copy) NSString    *Ci_6;
@property (nonatomic, copy) NSString    *B_6; 
@property (nonatomic)       int         Arfcn_6;
@property (nonatomic)       int         Rssi_6;
@property (nonatomic)       int         C1_6;
@property (nonatomic, copy) NSString    *Bsic_6;




@end
