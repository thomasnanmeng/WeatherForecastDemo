//
//  MNCWeatherPropertiesFile.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface MNCWeatherPropertiesFile : NSObject

@property (nonatomic, strong) NSArray *weatherPropertiesInFiled;
- (void)changeWeatherPropertiesToFiled:(NSDictionary *)weatherProperty;


@end
