//
//  MNCDetailWeatherView.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/8/3.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCDetailWeatherView.h"
#import "MNCHeader.h"

@implementation MNCDetailWeatherView

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - Private methods

- (void)createUI {
    CGRect bounds = CGRectMake(0, 0, kScreenW, kScreenH / 2.5);
    _cityNameLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(bounds.origin.x + 100,
                                 bounds.origin.y + 30,
                                 (bounds.size.width - 200) / 2 + 100,
                                 50)];
    _cityNameLabel.font = [UIFont fontWithName:@"Arial" size:40];
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_cityNameLabel];
    
    _temperatureLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(bounds.origin.x + 100,
                                    bounds.origin.y + 80,
                                    (bounds.size.width - 200) / 2 + 100,
                                    bounds.size.height / 6)];
    _temperatureLabel.font = [UIFont fontWithName:@"Arial" size:40];
    _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_temperatureLabel];
    
    _moreElementLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(bounds.origin.x,
                                    bounds.origin.y + 30 + 100,
                                    bounds.size.width + 30,
                                    50)];
    _moreElementLabel.font = [UIFont fontWithName:@"Arial" size:17];
    _moreElementLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moreElementLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
