//
//  MNCSimpleWeatherView.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCSimpleWeatherView.h"

@interface MNCSimpleWeatherView ()
@end

@implementation MNCSimpleWeatherView

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
    //    UILabel *dateLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + 10,
    //                                   rect.origin.y + 10,
    //                                   (rect.size.width - 20) / 4,
    //                                   rect.size.height / 4)];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,50,50)];
    _dateLabel.font = [UIFont fontWithName:@"Arial" size:20];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    //_dateLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_dateLabel];
    
    //    UILabel *tmpLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + dateLab.frame.size.width + 10,
    //                                   rect.origin.y + 10  ,
    //                                   (rect.size.width - 20) - 40,
    //                                   rect.size.height / 4)];
    _tmpLabel = [[UILabel alloc] initWithFrame:
                 CGRectMake(_dateLabel.bounds.size.width,_dateLabel.bounds.origin.y,150,50)];
    _tmpLabel.font = [UIFont fontWithName:@"Arial" size:20];
    _tmpLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tmpLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:
                   CGRectMake(10, 50 + 10,100,50)];
    _stateLabel.font = [UIFont fontWithName:@"Arial" size:20];
    _stateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_stateLabel];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.frame = CGRectMake(_stateLabel.bounds.size.width + 10 ,
                                 50 + 10,
                                 50,
                                 50);
    [self addSubview:_iconView];
}


@end

