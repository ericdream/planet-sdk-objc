//
//  TKVideoPlanet.h
//  TKVideoPlanet
//
//  Created by wang animeng on 2016/10/31.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKCameraPreviewController.h"

typedef NS_ENUM(NSInteger, TKVideoConnectState) {
    TKVideoPalnetInit,
    TKVideoPalnetConnecting,
    TKVideoPalnetConnected,
    TKVideoPalnetDisconnected,
};

typedef void (^TKTokenReady)(NSString *token,NSError * error);
typedef void (^TKConnectStateListen)(TKVideoConnectState state,NSError * error);

@interface TKVideoPlanet : NSObject

@property (nonatomic,readonly) TKCameraPreviewController * cameraPreviewController;

+ (instancetype)videoPlanet:(NSString*)appId;
- (void)setTokenReadyCallback:(TKTokenReady)tokenReady;

- (void)connectRoomId:(NSString*)roomId
        state:(TKConnectStateListen)complete;
- (void)leaveRoomId:(NSString*)roomId;

@end
