//
//  CameraControlViewController.m
//  P2PCamera
//
//  Created by yan luke on 14-3-18.
//
//

#import "CameraControlViewController.h"

@interface CameraControlViewController ()

@end

@implementation CameraControlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIden = @"cellIden";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"时间";
            break;
        case 1:
            cell.textLabel.text = @"SD卡状态";
            break;
        case 2:
            cell.textLabel.text = @"WIFI";
            break;
        case 3:
            cell.textLabel.text = @"TF卡录像";
            break;
        case 4:
            
            break;
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            _m_PPPPChannelMgt->SetDateTimeDelegate((char*)[_strDID UTF8String], self);
            _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
        }
            break;
        case 1:
        {
            _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[self.strDID UTF8String], MSG_TYPE_GET_RECORD, NULL, 0);
            _m_PPPPChannelMgt->SetSDcardScheduleDelegate((char*)[self.strDID UTF8String], self);
        }
            break;
        case 2:
        {
            _m_PPPPChannelMgt->SetWifiParamDelegate((char*)[_strDID UTF8String], self);
            _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
            _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[_strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
        }
            break;
        case 3:
        {
            _m_PPPPChannelMgt->SetSDCardSearchDelegate((char*)[_strDID UTF8String], self);
            _m_PPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[_strDID UTF8String], 0, 500);
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark DateTimeProtocol <NSObject>

- (void) DateTimeProtocolResult:(int)now tz:(int)tz ntp_enable:(int)ntp_enable net_svr:(NSString*)ntp_svr{
    NSTimeInterval se=(long)now;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-tz]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"Date Time %@",[formatter stringFromDate:date]);
}

#pragma mark SdcardScheduleProtocol <NSObject>
-(void)sdcardScheduleParams:(NSString *)did Tota:(int)total/*SD卡总容量*/  RemainCap:(int)remain/*SD卡剩余容量*/ SD_status:(int)status/*1:停止录像 2:正在录像 0:未检测到卡*/ Cover:(int) cover_enable/*0:不自动覆盖1:自动覆盖 */ TimeLength:(int)timeLength/*录像时长*/ FixedTimeRecord:(int)ftr_enable/*0:未开启实时录像 1:开启实时录像*/ RecordSize:(int)recordSize/*录像总容量*/ record_schedule_sun_0:(int) record_schedule_sun_0 record_schedule_sun_1:(int) record_schedule_sun_1 record_schedule_sun_2:(int) record_schedule_sun_2 record_schedule_mon_0:(int) record_schedule_mon_0 record_schedule_mon_1:(int) record_schedule_mon_1 record_schedule_mon_2:(int) record_schedule_mon_2 record_schedule_tue_0:(int) record_schedule_tue_0 record_schedule_tue_1:(int) record_schedule_tue_1 record_schedule_tue_2:(int) record_schedule_tue_2 record_schedule_wed_0:(int) record_schedule_wed_0 record_schedule_wed_1:(int) record_schedule_wed_1 record_schedule_wed_2:(int) record_schedule_wed_2 record_schedule_thu_0:(int) record_schedule_thu_0 record_schedule_thu_1:(int) record_schedule_thu_1 record_schedule_thu_2:(int) record_schedule_thu_2 record_schedule_fri_0:(int) record_schedule_fri_0 record_schedule_fri_1:(int) record_schedule_fri_1 record_schedule_fri_2:(int) record_schedule_fri_2 record_schedule_sat_0:(int) record_schedule_sat_0 record_schedule_sat_1:(int) record_schedule_sat_1 record_schedule_sat_2:(int) record_schedule_sat_2{
    NSLog(@"Camera %@ SD Status total %d ....",did, total);
}

#pragma mark Wifi Param Protocol
- (void) WifiParams: (NSString*)strDID enable:(NSInteger)enable ssid:(NSString*)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString*)strKey1 strKey2:(NSString*)strKey2 strKey3:(NSString*)strKey3 strKey4:(NSString*)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString*)wpa_psk{
    NSLog(@"Camera WifiParams.....strDID: %@, enable:%d, ssid:%@, channel:%d, mode:%d, authtype:%d, encryp:%d, keyformat:%d, defkey:%d, strKey1:%@, strKey2:%@, strKey3:%@, strKey4:%@, key1_bits:%d, key2_bits:%d, key3_bits:%d, key4_bits:%d, wap_psk:%@", strDID, enable, strSSID, channel, mode, authtype, encryp, keyformat, defkey, strKey1, strKey2, strKey3, strKey4, key1_bits, key2_bits, key3_bits, key4_bits, wpa_psk);
}

- (void) WifiScanResult: (NSString*)strDID ssid:(NSString*)strSSID mac:(NSString*)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd{
    NSLog(@"WifiScanResult.....strDID:%@, ssid:%@, mac:%@, security:%d, db0:%d, db1:%d, mode:%d, channel:%d, bEnd:%d", strDID, strSSID, strMac, security, db0, db1, mode, channel, bEnd);
    
    
    /**
     *  Set Wifi
     *
     *  
     char *pkey = NULL;
     char *pwpa_psk = NULL;
     
     switch (m_security) {
     case 0: //none
     pkey = (char*)"";
     pwpa_psk = (char*)"";
     break;
     case 1: //wep
     pkey = (char*)[m_strPwd UTF8String];
     pwpa_psk = (char*)"";
     break;
     case 2: //wpa-psk(AES)
     case 3://wpa-psk(TKIP)
     case 4://wpa2-psk(AES)
     case 5://wpa3-psk(TKIP)
     pkey = (char*)"";
     pwpa_psk = (char*)[m_strPwd UTF8String];
     break;
     default:
     break;
     }
     m_pChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[m_strSSID UTF8String], m_channel, 0, m_security, 0, 0, 0, pkey, (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, pwpa_psk);
     */
}

#pragma mark SDCardRecordFileSearchProtocol <NSObject>

- (void) SDCardRecordFileSearchResult: (NSString *) strFileName fileSize: (NSInteger) fileSize bEnd: (BOOL) bEnd{
    NSLog(@"TF Recprd File Name %@",strFileName);
    
    /**
     *  Play TF Record
     *
     *  
     Start Play 
     m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], self);//实现代理同实时播放
     if (!m_pPPPPMgnt->PPPPStartPlayback((char*)[strDID UTF8String],(char*)[m_strFileName UTF8String], 0)) {
     
     }
     stop Play 
     m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], nil);
     m_pPPPPMgnt->PPPPStopPlayback((char*)[strDID UTF8String]);
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
