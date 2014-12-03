//
//  UpdateManager.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-4.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateManager : NSObject

/**
 * 获取服务器上的版本信息
 * ex:
 * {"appName":"SmartHome","verCode":"1027","verName":"1.0.27","verComment":"程序有新版本v1.0.27可更新","mustUpdate":"false","downloadUrl":"http://www.chongchi-tech.com/ccsoft/uploads/app/SmartHome.apk"}
 */
-(NSDictionary *)getRemoteVersionInfo;

/**
 * 版本对比
 * 返回值为YES表示有更新，NO表示无更新
 */
-(Boolean)checkVersion:(NSDictionary *)dict;

@end
