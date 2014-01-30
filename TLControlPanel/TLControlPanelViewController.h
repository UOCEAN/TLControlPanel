//
//  TLControlPanelViewController.h
//  TLControlPanel
//
//  Created by Chentou TONG on 16/1/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLControlPanelViewController : UIViewController <NSStreamDelegate>


@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;


- (void)initNetworkCommunication;
- (IBAction)BtnPoll:(id)sender;
- (IBAction)BtnOnOff:(id)sender;

- (IBAction)ReconnectSvr:(UIButton *)sender;
- (IBAction)appExit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LanternA;
@property (weak, nonatomic) IBOutlet UIImageView *LanternB;
@property (weak, nonatomic) IBOutlet UIImageView *LanternC;
@property (weak, nonatomic) IBOutlet UIImageView *LanternD;
@property (weak, nonatomic) IBOutlet UIImageView *LanternE;
@property (weak, nonatomic) IBOutlet UIImageView *Foghorn;
@property (weak, nonatomic) IBOutlet UIButton *btnTLA_ON_OFF;
@property (weak, nonatomic) IBOutlet UIButton *btnTLB_ON_OFF;
@property (weak, nonatomic) IBOutlet UIButton *btnTLC_ON_OFF;
@property (weak, nonatomic) IBOutlet UIButton *btnTLD_ON_OFF;
@property (weak, nonatomic) IBOutlet UIButton *btnTLE_ON_OFF;
@property (weak, nonatomic) IBOutlet UIButton *btnFH1_ON_OFF;


@property (weak, nonatomic) IBOutlet UIImageView *AlarmA;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmB;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmC;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmD;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmE;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmFH1;

@property (weak, nonatomic) IBOutlet UIButton *btnTLA_POLL;
@property (weak, nonatomic) IBOutlet UIButton *btnTLB_POLL;
@property (weak, nonatomic) IBOutlet UIButton *btnTLC_POLL;
@property (weak, nonatomic) IBOutlet UIButton *btnTLD_POLL;
@property (weak, nonatomic) IBOutlet UIButton *btnTLE_POLL;
@property (weak, nonatomic) IBOutlet UIButton *btnFH1_POLL;


@end
