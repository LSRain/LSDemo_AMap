//
//  LSLinesOverlayViewController.m
//  LSDemo_AMap
//
//  Created by WangBiao on 2017/11/2.
//  Copyright © 2017年 LSRain. All rights reserved.
//

#import "LSLinesOverlayViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface LSLinesOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSArray *lines;

@end

@implementation LSLinesOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLines];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.lines];
}

#pragma mark - Initialization
- (void)initLines {
    NSMutableArray *arr = [NSMutableArray array];
    
    //line 1 - 虚线
    CLLocationCoordinate2D line1Points[2];
    line1Points[0].latitude = 39.925539;
    line1Points[0].longitude = 116.279037;
    
    line1Points[1].latitude = 39.925539;
    line1Points[1].longitude = 116.520285;
    
    MAPolyline *line1 = [MAPolyline polylineWithCoordinates:line1Points count:2];
    [arr addObject:line1];
    
    //line 2 - M
    CLLocationCoordinate2D line2Points[5];
    line2Points[0].latitude = 39.938698;
    line2Points[0].longitude = 116.275177;
    
    line2Points[1].latitude = 39.966069;
    line2Points[1].longitude = 116.289253;
    
    line2Points[2].latitude = 39.944226;
    line2Points[2].longitude = 116.306076;
    
    line2Points[3].latitude = 39.966069;
    line2Points[3].longitude = 116.322899;
    
    line2Points[4].latitude = 39.938698;
    line2Points[4].longitude = 116.336975;
    
    MAPolyline *line2 = [MAPolyline polylineWithCoordinates:line2Points count:5];
    [arr addObject:line2];
    
    self.lines = [NSArray arrayWithArray:arr];
}

#pragma mark - Action Handlers
- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor = [UIColor blueColor];
        polylineRenderer.lineWidth   = 5.f;
        
        NSInteger index = [self.lines indexOfObject:overlay];
        if(index == 0) {
            polylineRenderer.lineCapType = kCGLineCapSquare;
            polylineRenderer.lineDash = YES;
        } else {
            polylineRenderer.strokeColor = [UIColor greenColor];
            polylineRenderer.lineDash = NO;
        }
        
        
        return polylineRenderer;
    }
    
    return nil;
}

@end
