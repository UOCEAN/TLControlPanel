//
//  TLControlPanelViewController.m
//  TLControlPanel
//
//  Created by Chentou TONG on 16/1/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "TLControlPanelViewController.h"
#import "Constants.h"

@interface TLControlPanelViewController ()

@end

@implementation TLControlPanelViewController {
    NSMutableArray *_sites;
    UIAlertView *Alert;
    
}

@synthesize messages = _messages;
@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;



- (void) presentAlert
{ // present Connection Alert Windows until connection establish or time out
    Alert = [[UIAlertView alloc]initWithTitle:@"Connection" message:@"Try to connect server!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [Alert show];
}

-(void)aCommInitTimer
{ // one sec timer after presentAlert
    [self initNetworkCommunication];
}

-(void)tryConnectServer
{ //try to connect the server, present alert and init network
    [self presentAlert];
    // timer to call network init
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aCommInitTimer) userInfo:nil repeats:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // queue for message rx
    self.messages = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self tryConnectServer];
    
    // Timer to decode message received
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decodeMsgRx) userInfo:nil repeats:YES];
    
    // update image
    UIImage *image1 = [UIImage imageNamed:@"Background"];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    iv.image = image1;
    [self.view addSubview:iv];
    [self.view sendSubviewToBack:iv];
    
    [self.LanternA setImage:[UIImage imageNamed:@"NavLight-OFF"]];
    [self.LanternB setImage:[UIImage imageNamed:@"NavLight-OFF"]];
    [self.LanternC setImage:[UIImage imageNamed:@"NavLight-OFF"]];
    [self.LanternD setImage:[UIImage imageNamed:@"NavLight-OFF"]];
    [self.LanternE setImage:[UIImage imageNamed:@"NavLight-OFF"]];
    [self.Foghorn setImage:[UIImage imageNamed:@"redHorn-X-Sound"]];
    
    [self.AlarmA setImage:[UIImage imageNamed:@"light_yellow"]];
    [self.AlarmB setImage:[UIImage imageNamed:@"light_yellow"]];
    [self.AlarmC setImage:[UIImage imageNamed:@"light_yellow"]];
    [self.AlarmD setImage:[UIImage imageNamed:@"light_yellow"]];
    [self.AlarmE setImage:[UIImage imageNamed:@"light_yellow"]];
    [self.AlarmFH1 setImage:[UIImage imageNamed:@"light_yellow"]];
    
    [self.btnTLA_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    [self.btnTLB_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    [self.btnTLC_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    [self.btnTLD_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    [self.btnTLE_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    [self.btnFH1_POLL setBackgroundImage:[UIImage imageNamed:@"Btn-Poll-Normal"] forState:UIControlStateNormal];
    
    [self.btnTLA_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    [self.btnTLB_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    [self.btnTLC_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    [self.btnTLD_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    [self.btnTLE_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    [self.btnFH1_ON_OFF setBackgroundImage:[UIImage imageNamed:@"Btn-OFF-Normal"] forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)decodeMsgRx
{
    while ([self.messages count]) {
        id output = [self.messages lastObject];
        
        NSRange end = [output rangeOfString:@":"];
        if (end.length == 0) {
            // format error
        } else {
            // format correct
            NSString *clientName = [output substringToIndex:end.location];
            NSString *tclientName = [clientName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *msgContent = [output substringFromIndex:end.location+1];
            NSString *tmsgContent = [msgContent stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            UIImage *btnOFFimage = [UIImage imageNamed:@"Btn-OFF-Normal"];
            UIImage *btnONimage = [UIImage imageNamed:@"Btn-ON-Normal"];
            UIImage *NavLightON = [UIImage imageNamed:@"NavLight-ON"];
            UIImage *NavLightOFF = [UIImage imageNamed:@"NavLight-OFF"];
            UIImage *LightRed = [UIImage imageNamed:@"light_red"];
            UIImage *LightYellow = [UIImage imageNamed:@"light_yellow"];
            UIImage *HornSound = [UIImage imageNamed:@"redHorn-Sound"];
            UIImage *HornNoSound = [UIImage imageNamed:@"redHorn-X-Sound"];
            
            if ([tclientName isEqualToString:MYNAME]) {
                // own msg no need to proceed
                NSLog(@"Own msg, nil action");
            } else {
                NSRange endSite = [tmsgContent rangeOfString:@"@"];
                if (endSite.length !=0) {
                    NSString *siteName = [tmsgContent substringToIndex:endSite.location];
                    NSString *tsiteName = [siteName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *siteCMD = [tmsgContent substringFromIndex:endSite.location+1];
                    NSString *tsiteCMD = [siteCMD stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSLog(@"Client %@ say: %@@%@", tclientName, tsiteName, tsiteCMD);
                    
                    switch ([@[@"TLA", @"TLB", @"TLC", @"TLD", @"TLE", @"FH1", MYNAME] indexOfObject:tsiteName]) {
                        case 0:
                            if ([tsiteCMD isEqualToString:@"LANON"]) {
                                [self.LanternA setImage:NavLightON];};
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {
                                [self.LanternA setImage:NavLightOFF];};
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmA setImage:LightRed];};
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmA setImage:LightYellow];};
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnTLA_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnTLA_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 1:
                            if ([tsiteCMD isEqualToString:@"LANON"]) {[self.LanternB setImage:NavLightON]; }
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {[self.LanternB setImage:NavLightOFF];}
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmB setImage:LightRed];}
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmB setImage:LightYellow];}
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnTLB_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnTLB_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 2:
                            if ([tsiteCMD isEqualToString:@"LANON"]) {[self.LanternC setImage:NavLightON]; }
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {[self.LanternC setImage:NavLightOFF];}
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmC setImage:LightRed];}
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmC setImage:LightYellow];}
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnTLC_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnTLC_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 3:
                            if ([tsiteCMD isEqualToString:@"LANON"]) {[self.LanternD setImage:NavLightON]; }
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {[self.LanternD setImage:NavLightOFF];}
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmD setImage:LightRed];}
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmD setImage:LightYellow];}
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnTLD_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnTLD_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 4:
                            if ([tsiteCMD isEqualToString:@"LANON"]) {[self.LanternE setImage:NavLightON]; }
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {[self.LanternE setImage:NavLightOFF];}
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmE setImage:LightRed];}
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmE setImage:LightYellow];}
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnTLE_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnTLE_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 5:
                            NSLog(@"FH1");
                            if ([tsiteCMD isEqualToString:@"LANON"]) {[self.Foghorn setImage:HornSound]; }
                            if ([tsiteCMD isEqualToString:@"LANOFF"]) {[self.Foghorn setImage:HornNoSound];}
                            if ([tsiteCMD isEqualToString:@"ACNG"]) {[self.AlarmFH1 setImage:LightRed];}
                            if ([tsiteCMD isEqualToString:@"ACOK"]) {[self.AlarmFH1 setImage:LightYellow];}
                            if ([tsiteCMD isEqualToString:@"ACKON"]) {
                                [self.btnFH1_ON_OFF setBackgroundImage:btnONimage forState:UIControlStateNormal];}
                            if ([tsiteCMD isEqualToString:@"ACKOFF"]) {
                                [self.btnFH1_ON_OFF setBackgroundImage:btnOFFimage forState:UIControlStateNormal];}
                            break;
                        case 6:
                            NSLog(@"%@ Message",MYNAME);
                            break;
                        default:
                            NSLog(@"No such site****");
                            break;
                    }
                    
                }
            }
        }
        // remove from buffer
        [self.messages removeObjectAtIndex:[self.messages count] - 1];
    }
}

- (void)messageReceived:(NSString *)message
{
    [self.messages addObject:message];
}

-(void)sendMsg:(NSString *)msg
{
    NSString *response = [NSString stringWithFormat:@"%@", msg];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)joinChat
{
    NSString *msg = [NSString stringWithFormat:@"%@%@", @"iam:", MYNAME];
    [self sendMsg:msg];
}


- (void)initNetworkCommunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    // GFWDC01 IP address
    NSString *svrIP = @"192.168.102.10";
    svrIP = GFWDC01;
    NSLog(@"Server & Port: %@:%i", svrIP, SVRPORT);
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)svrIP, SVRPORT, &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    
    // delegate
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    //schedule input stream to have procesing in the run loop
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //open the connection
    [self.inputStream open];
    [self.outputStream open];
    
    [self joinChat];
    
}

- (IBAction)BtnPoll:(id)sender {
    
    if ( [sender tag] == 100) {
        [self sendMsg:@"msg:TLA@POLL"];
    }
    else if ([sender tag] == 101) {
        [self sendMsg:@"msg:TLB@POLL"];
    }
    else if ([sender tag] == 102) {
        [self sendMsg:@"msg:TLC@POLL"];
    }
    else if ([sender tag] == 103) {
        [self sendMsg:@"msg:TLD@POLL"];
    }
    else if ([sender tag] == 104) {
        [self sendMsg:@"msg:TLE@POLL"];
    }
    else if ([sender tag] == 105) {
        [self sendMsg:@"msg:FH1@POLL"];
    }
}

- (IBAction)BtnOnOff:(id)sender {
    UIImage *btnCurrentBgImage = [sender backgroundImageForState:UIControlStateNormal];
    UIImage *btnOFFimage = [UIImage imageNamed:@"Btn-OFF-Normal"];
    UIImage *btnONimage = [UIImage imageNamed:@"Btn-ON-Normal"];
    
    if ([sender tag] == 200)
    { // TLA
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:TLA@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:TLA@OFF"];}
    }
    else if ([sender tag] == 201)
    { // TLB
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:TLB@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:TLB@OFF"];}
    }
    else if ([sender tag] == 202)
    { // TLC
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:TLC@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:TLC@OFF"];}
    }
    else if ([sender tag] == 203)
    { // TLD
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:TLD@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:TLD@OFF"];}
    }
    else if ([sender tag] == 204)
    { // TLE
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:TLE@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:TLE@OFF"];}
    }
    else if ([sender tag] == 205)
    { // Fog Horn
        if (btnCurrentBgImage == btnOFFimage) {[self sendMsg:@"msg:FH1@ON"];}
        else if (btnCurrentBgImage == btnONimage) {[self sendMsg:@"msg:FH1@OFF"];}
    }
    else if ([sender tag] == 300) {
        NSLog(@"Master OFF send");
    }
    
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            // NSLog(@"%lu: Stream opened", streamEvent);
            [Alert dismissWithClickedButtonIndex:0 animated:TRUE];
            break;
        case NSStreamEventHasBytesAvailable:
            // NSLog(@"%lu: Msg received", streamEvent);
            // msg received
            if (theStream == self.inputStream)
            {
                uint8_t buffer[1024];
                long len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len>0){
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output) {
                            //save message
                            [self messageReceived:output];
                        }
                        
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            //NSLog(@"%lu: Cannot connect to the host", streamEvent);
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [Alert dismissWithClickedButtonIndex:0 animated:TRUE];
            //back to chart mode
            break;
        case NSStreamEventEndEncountered:
            // NSLog(@"%lu: Server close the connection", streamEvent);
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            // back to chart mode
            break;
        case NSStreamEventHasSpaceAvailable:
            // NSLog(@"%lu: Steam can accept bytes for writing", streamEvent);
            break;
        default:
            NSLog(@"%u: Unknown event", streamEvent);
            break;
    }
    
}

- (void)closeStream:(NSStream *)stream
{
    [stream close];
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    stream = nil;
}

- (void)disconnectServer
{
    [self closeStream:self.inputStream];
    [self closeStream:self.outputStream];
    
}


- (IBAction)ReconnectSvr:(UIButton *)sender
{
    [self disconnectServer];
    [self tryConnectServer];
}

- (IBAction)appExit:(UIButton *)sender {
    [self disconnectServer];
    exit(0);
}

@end
