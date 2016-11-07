//
//  ViewController.m
//  TKVideoPlanetDemo
//
//  Created by wang animeng on 2016/10/31.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import "ViewController.h"
#import <TKVideoPlanet/TKVideoPlanet.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic,strong) TKVideoPlanet * planet;
@property (nonatomic,strong) NSString * roomId;

@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIView *remoteView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *connectTipLabel;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *leaveBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.planet = [TKVideoPlanet videoPlanet:@"581a91f9f8c3e102a9a1273c"];
    
    self.activityView.hidden = YES;
    [self.activityView startAnimating];
    self.leaveBtn.hidden = YES;
    self.connectTipLabel.hidden = YES;
    
    [self startCapture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRoomInput:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"房间号" message:@"请输入房间号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.roomId = alert.textFields[0].text;
        [self connectRoom];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入房间号";
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)leave:(id)sender
{
    [self.planet leaveRoomId:self.roomId];
    self.leaveBtn.hidden = YES;
    self.connectBtn.hidden = NO;
}

- (void)connectRoom
{
    self.activityView.hidden = NO;
    self.connectTipLabel.hidden = NO;
    @weakify(self);
    [self.planet connectRoomId:self.roomId
                         state:^(TKVideoConnectState state, NSError *error) {
                             @strongify(self);
                             BOOL needHiddenBtn;
                             BOOL needHiddenLoadingView;
                             if (state == TKVideoPalnetConnected) {
                                 needHiddenBtn = YES;
                                 needHiddenLoadingView = YES;
                                 self.connectTipLabel.text = @"connected";
                             }
                             else if(state == TKVideoPalnetDisconnected){
                                 needHiddenBtn = NO;
                                 needHiddenLoadingView = YES;
                                 self.connectTipLabel.text = @"disconnect";
                             }
                             else if(state == TKVideoPalnetConnecting){
                                 needHiddenBtn = YES;
                                 needHiddenLoadingView = NO;
                                 self.connectTipLabel.text = [NSString stringWithFormat:@"connect room:%@",self.roomId];
                             }
                             self.activityView.hidden = needHiddenLoadingView;
                             self.connectTipLabel.hidden = needHiddenLoadingView;
                             self.leaveBtn.hidden = !needHiddenBtn;
                             self.connectBtn.hidden = needHiddenBtn;
                         }];
    
    UIView * remotePreview = self.planet.cameraPreviewController.getRemoteCameraPreview;
    if (!remotePreview.superview) {
        [self.remoteView addSubview:remotePreview];
        [remotePreview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.remoteView);
        }];
    }
}

- (void)startCapture
{
    UIView * preview = [self.planet.cameraPreviewController getLocalCameraPreview];
    [self.planet.cameraPreviewController turnOnCamera];
    [self.localView addSubview:preview];
    [preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
