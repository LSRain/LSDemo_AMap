//
//  CustomAnnotationViewController.m
//  LSDemo_AMap
//
//  Created by WangBiao on 2017/9/29.
//  Copyright © 2017年 LSRain. All rights reserved.
//

#import "CustomAnnotationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation CustomAnnotationViewController

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView                      = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel            = 18.0;
        _mapView.desiredAccuracy      = kCLLocationAccuracyBestForNavigation;
        _mapView.showsUserLocation    = YES;
        _mapView.userTrackingMode     = MAUserTrackingModeFollow;
        // close rotateCamera
        _mapView.rotateCameraEnabled  = NO;
        _mapView.showsScale           = NO;
        _mapView.rotateEnabled        = NO;
        _mapView.showsIndoorMap       = YES;
        _mapView.showsCompass         = NO;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    [self mapView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"固定"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(lockAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self initAnnotations]; // 不能写在`viewDidLoad`, 涉及到坐标点是否获取到的问题
}

- (void)initAnnotations {
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[2] = {
        {
            self.mapView.userLocation.coordinate.latitude + 0.00002,
            self.mapView.userLocation.coordinate.longitude + 0.00002
        },
        {
            self.mapView.userLocation.coordinate.latitude + 0.00018,
            self.mapView.userLocation.coordinate.longitude + 0.00019,
            
        },
    };
    
    for (int i = 0; i < 2; ++i)
    {
        MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
        a.coordinate = coordinates[i];
        [self.annotations addObject:a];
        if(i == 0) {
            a.lockedToScreen = YES;
            a.lockedScreenPoint = self.mapView.center;
        }
    }
    
    [self.mapView addAnnotations:self.annotations];
}

#pragma mark - event handling
- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lockAction {
    MAPointAnnotation *an = self.annotations.firstObject;
    
    [an setLockedScreenPoint:self.mapView.center];
    [an setLockedToScreen:YES];
}

#pragma mark - MAMapviewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /*
         - 自定义userLocation对应的annotationView.
         - 这里涉及到一个代码上下顺序的问题
     */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation  reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            
            annotationView.canShowCallout            = YES;
            annotationView.animatesDrop              = YES;
            annotationView.draggable                 = YES;
        }
        
        annotationView.pinColor = (annotation == self.annotations.firstObject ? MAPinAnnotationColorRed : MAPinAnnotationColorGreen);
        
        return annotationView;
    }
    
    return nil;
}

@end

