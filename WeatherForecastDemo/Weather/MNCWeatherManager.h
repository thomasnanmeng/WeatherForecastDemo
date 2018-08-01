//
//  MNCWeatherMessage.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/17.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MNCWeatherManager : NSObject

/**
 单例模式设计
 */

+ (MNCWeatherManager *)sharedInstance;

/**
 使用城市名称去请网络请求天气数据
 请求成功通过通知 MNCWeatherPropertiesFileNotification 抛给 MNCWeatherPropertiesFile 去保存数据
 参数说明: cityName  城市名称
 */

- (void)useCityNameToRequestWeatherData:(NSString *)cityName;

//- (void)responseDicToPropretiesDic:(NSDictionary *)responseDic;


@end
