//
//  TKCameraPreviewController.h
//  TKVideoPlanet
//
//  Created by wang animeng on 2016/11/3.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKCameraPreviewController : NSObject

- (UIView*)getLocalCameraPreview;
- (UIView*)getRemoteCameraPreview;

- (void)turnOnCamera;
- (void)turnOffCamera;

- (void)closeRemoteCameraPreview;

@end
