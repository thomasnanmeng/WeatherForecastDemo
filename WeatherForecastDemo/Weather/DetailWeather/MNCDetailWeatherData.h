//
//  MNCTodayWeatherData.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCDetailWeatherData : NSObject

@property (nonatomic, strong) NSString *location;   //城市名称

@property (nonatomic, strong) NSString *condCodeDay;     //白天天气状况代码
@property (nonatomic, strong) NSString *condCodeNight;   //晚间天气状况代码
@property (nonatomic, strong) NSString *condTxtDay;      //白天天气状况描述
@property (nonatomic, strong) NSString *condTxtNight;    //晚间天气状况描述
@property (nonatomic, strong) NSString *currentTime;     //时间
@property (nonatomic, strong) NSString *windForce;       //风力
@property (nonatomic, strong) NSString *temperatureMax;  //最高温度
@property (nonatomic, strong) NSString *temperatureMin;  //最低温度
@property (nonatomic, strong) NSString *hum;             //相对湿度

- (void)initDetailWeatherPropertiesFromDic:(NSDictionary *)propretiesDic info:(NSString *)flag;

//温度
- (NSString *)updataTempMax;
- (NSString *)updataTempMin;
//湿度
- (NSString *)updataHum;
//晴雨
- (NSString *)updataState;
//风力
- (NSString *)updataWindForce;
//城市
- (NSString *)updataCity;
- (NSString *)updataCurrentDate;

@end
