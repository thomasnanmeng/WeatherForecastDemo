//
//  MNCSimpleWeatherView.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCSimpleWeatherData.h"



@interface MNCSimpleWeatherView : UIView

/**
 数据模型 tomorrowData or afterTomorrowData 的对象
 */

@property (strong, nonatomic) MNCSimpleWeatherData *simpleData;

/**
 更新数据
 参数说明: simpleData 一个类对象，可以为明天数据或者后天数据
 */

- (void)createUIData:(MNCSimpleWeatherData *)simpleData;

/**
 返回参数对象的天气状况
 参数说明: simpleData 一个类对象，可以为明天数据或者后天数据
 */

- (NSString *)updataWeatherState:(MNCSimpleWeatherData *)simpleData;
@end
