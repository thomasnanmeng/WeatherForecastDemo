//
//  MNCTodayWeatherData.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCDetailWeatherData : NSObject

/**
 城市名称
 */

@property (strong, nonatomic) NSString *cityName;

/**
 白天天气状况
 */

@property (strong, nonatomic) NSString *conditionDay;

/**
 晚间天气状况
 */

@property (strong, nonatomic) NSString *conditionNight;

/**
 当天日期
 */

@property (strong, nonatomic) NSString *date;

/**
 风力
 */

@property (strong, nonatomic) NSString *windForce;

/**
 最高温度
 */

@property (strong, nonatomic) NSString *temperatureMax;

/**
 最低温度
 */

@property (strong, nonatomic) NSString *temperatureMin;

/**
 相对湿度
 */

@property (strong, nonatomic) NSString *humidity;




@end

