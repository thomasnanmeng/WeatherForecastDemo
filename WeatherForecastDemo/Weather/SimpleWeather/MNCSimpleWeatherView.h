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
 展示“明天”或者“后天”关键字
 */

@property (strong, nonatomic) UILabel *dateLabel;

/**
 展示温度的UILabel  示例： 36/24    最高温/最低温
 */

@property (strong, nonatomic) UILabel *tmpLabel;

/**
 
 展示当天天气状态，目前只展示白天天气状态
 */

@property (strong, nonatomic) UILabel *stateLabel;

/**
 展示天气状态对应的icon
 */

@property (strong, nonatomic) UIImageView *iconView;


/**
 返回参数对象的天气状况
 参数说明: simpleData 一个类对象，可以为明天数据或者后天数据
 */

- (NSString *)updataWeatherState:(MNCSimpleWeatherData *)simpleData;
@end

