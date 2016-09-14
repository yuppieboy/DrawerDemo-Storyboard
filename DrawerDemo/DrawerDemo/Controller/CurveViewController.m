//
//  CurveViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "CurveViewController.h"
#import "Charts-Swift.h"
#import <Realm/Realm.h>


@interface CurveViewController ()<ChartViewDelegate>
@property (strong, nonatomic) IBOutlet LineChartView *chartView;

@end

@implementation CurveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [self writeRandomDataToDbWithObjectCount:20];
    
    self.title = Localized(@"Curve");
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleStepped", @"label": @"Toggle Stepped"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    _chartView.delegate = self;
    
    [self setupBarLineChartView:_chartView];
    
    _chartView.leftAxis._axisMaximum = 20.f;
    _chartView.leftAxis._axisMinimum = 0.f;
    _chartView.leftAxis.drawGridLinesEnabled = NO;
    _chartView.xAxis.drawGridLinesEnabled = NO;
    
    [self setData];
    
}

- (void)setData
{
    ChartDataEntry *entry0 = [[ChartDataEntry alloc]initWithValue:0 xIndex:0];
    ChartDataEntry *entry1 = [[ChartDataEntry alloc]initWithValue:5 xIndex:1];
    ChartDataEntry *entry2 = [[ChartDataEntry alloc]initWithValue:2 xIndex:2];
    ChartDataEntry *entry3 = [[ChartDataEntry alloc]initWithValue:10 xIndex:3];
    ChartDataEntry *entry4 = [[ChartDataEntry alloc]initWithValue:20 xIndex:4];
    ChartDataEntry *entry5 = [[ChartDataEntry alloc]initWithValue:15 xIndex:8];
    
    LineChartDataSet *set = [[LineChartDataSet alloc]init];
    set.label = @"Steps";
    set.drawCircleHoleEnabled = NO;
    set.color = [ChartColorTemplates colorFromString:@"#FF5722"];
    [set setCircleColor:[ChartColorTemplates colorFromString:@"#FF5722"]];
    set.lineWidth = 1.8f;
    set.circleRadius = 3.6f;

    [set addEntry:entry0];
    [set addEntry:entry1];
    [set addEntry:entry2];
    [set addEntry:entry3];
    [set addEntry:entry4];
    [set addEntry:entry5];
    
    NSArray<id <IChartDataSet>> *dataSets = @[set];
    
    NSMutableArray *XVals = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [XVals addObject:[NSString stringWithFormat:@"%i",i]];
    }
    LineChartData *data = [[LineChartData alloc]initWithXVals:XVals dataSets:dataSets];
    [self styleData:data];
    
    [_chartView zoom:3.f scaleY:1.f x:0.f y:0.f];
    _chartView.data = data;
    
    [_chartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.mode = set.mode == LineChartModeCubicBezier ? LineChartModeLinear : LineChartModeCubicBezier;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleStepped"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawSteppedEnabled = !set.isDrawSteppedEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    [super handleOption:key forChartView:_chartView];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
