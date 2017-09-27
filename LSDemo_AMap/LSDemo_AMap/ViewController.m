//
//  ViewController.m
//  LSDemo_AMap
//
//  Created by WangBiao on 2017/8/26.
//  Copyright © 2017年 LSRain. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ViewController


- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView                     = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.zoomLevel           = 18.0;
        _mapView.desiredAccuracy     = kCLLocationAccuracyBestForNavigation;
        _mapView.showsUserLocation   = YES;
        _mapView.userTrackingMode    = MAUserTrackingModeFollow;
        // 关闭相机旋转 - 能够降低能耗，省电
        _mapView.rotateCameraEnabled = NO;
        _mapView.showsScale          = NO;
        _mapView.rotateEnabled       = NO;
        _mapView.showsIndoorMap      = YES;
        _mapView.showsCompass        = NO;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

#pragma mark - UI setup

- (void)setupUI{
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self mapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
