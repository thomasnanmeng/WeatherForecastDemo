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
@property (nonatomic, strong) NSString *TmpMax;
/**
 最低温度
 */
@property (nonatomic, strong) NSString *TmpMin;
/**
 白天天气状况
 */
@property (nonatomic, strong) NSString *conditionsDay;
/**
 晚间天气状况
 */
@property (nonatomic, strong) NSString *conditionsNight;
/**
 当天天气日期
 */
@property (nonatomic, strong) NSString *Date;


- (void)initSimpleWeatherPropertiesFromDic:(NSDictionary *)propretiesDic;

- (void)initWeatherPropertiesFromPlist:(NSUInteger)index;


@end
