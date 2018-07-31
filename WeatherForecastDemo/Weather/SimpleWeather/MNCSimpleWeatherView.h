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
 
 */
@property (nonatomic, strong) MNCSimpleWeatherData *simpleWeatherData;
- (void)createUIData:(NSUInteger)index;

@end
