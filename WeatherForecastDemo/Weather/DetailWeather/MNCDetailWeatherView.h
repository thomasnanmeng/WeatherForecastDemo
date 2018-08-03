//
//  MNCDetailWeatherView.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/8/3.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCDetailWeatherView : UIView

/**
 展示城市名称
 */

@property (strong, nonatomic) UILabel *cityNameLabel;

/**
 展示当前温度，目前支持展示最高温度
 */

@property (strong, nonatomic) UILabel *temperatureLabel;

/**
 展示最高温度、最低温度、湿度、风力、天气状态五个元素
 */

@property (strong, nonatomic) UILabel *moreElementLabel;


@end
