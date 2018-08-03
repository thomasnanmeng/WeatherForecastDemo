//
//  MNCTomorrowWeatherData.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCSimpleWeatherData : NSObject

/**
 最高温度
 */

@property (strong, nonatomic) NSString *temperatureMax;

/**
 最低温度
 */

@property (strong, nonatomic) NSString *temperatureMin;

/**
 白天天气状况
 */

@property (strong, nonatomic) NSString *conditionDay;

/**
 晚间天气状况
 */

@property (strong, nonatomic) NSString *conditionNight;

/**
 天气日期
 */

@property (strong, nonatomic) NSString *date;



@end
