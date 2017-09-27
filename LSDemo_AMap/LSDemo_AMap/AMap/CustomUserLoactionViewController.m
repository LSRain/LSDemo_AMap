//
//  CustomUserLoactionViewController.m
//  LSDemo_AMap
//
//  Created by WangBiao on 2017/9/27.
//  Copyright © 2017年 LSRain. All rights reserved.
//

#import "CustomUserLoactionViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface CustomUserLoactionViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation CustomUserLoactionViewController

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView                     = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

#pragma mark - UI setup

- (void)setupUI{
    [self mapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
