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
 
 */
- (void)updataDetailWeatherbackgroundImage:(NSString *)stata;

@end

@interface MNCDetailWeatherViewController : UIViewController
@property (nonatomic, assign) id <MNCDetailViewControllerDelegate> delegate;

@end
