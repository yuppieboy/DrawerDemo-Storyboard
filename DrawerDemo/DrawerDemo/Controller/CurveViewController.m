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
#import "Step.h"

@interface CurveViewController ()<ChartViewDelegate>
@property (strong, nonatomic) IBOutlet LineChartView *chartView;
@property (strong, nonatomic) NSMutableArray *dataArray;

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
    LineChartDataSet *set = [[LineChartDataSet alloc]init];
    set.label = @"Steps";
    set.drawCircleHoleEnabled = NO;
    set.color = [ChartColorTemplates colorFromString:@"#FF5722"];
    [set setCircleColor:[ChartColorTemplates colorFromString:@"#FF5722"]];
    set.lineWidth = 1.8f;
    set.circleRadius = 3.6f;
    
    //初始位置(原点)
    Gate *gate = [SocketManager shareManager].values[_selectIndex];
    ChartDataEntry *entry = [[ChartDataEntry alloc]initWithValue:[gate.position floatValue] xIndex:0];
    [set addEntry:entry];

    //添加除原点位置以外的点
    self.dataArray = [NSMutableArray arrayWithArray:[[DataBaseManager sharedManager]getStepsFromGateIndex:(int)self.selectIndex+1]];
    float lastTime = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        Step *step = self.dataArray[i];
        ChartDataEntry *entry = [[ChartDataEntry alloc]initWithValue:step.position xIndex:lastTime + step.time];
        [set addEntry:entry];

        lastTime = lastTime + step.time;
    }
    
    NSArray<id <IChartDataSet>> *dataSets = @[set];
    
    NSMutableArray *XVals = [NSMutableArray array];
    for (int i = 0; i < 120; i++) {
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
