//
//  MNCDetailWeatherViewController.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNCDetailViewControllerDelegate <NSObject>

/**
 利用传入的天气状况参数更新MNCWeatherViewController类的背景图片
 参数说明: stata   当天的天气状况
 */

- (void)updataWeatherbackgroundImage:(NSString *)stata;
@end

@interface MNCDetailWeatherViewController : UIViewController

/**
 更改 MNCWeatherViewController类的背景图片 delegate
 */

@property (weak, nonatomic) id <MNCDetailViewControllerDelegate> delegate;

@end
