//
//  MNCHeader.h
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/8/1.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#ifndef MNCHeader_h
#define MNCHeader_h

//宏定义
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

/**
 天气API属性常量定义
 */

static NSString * const kMNCWeatherPropertiesFileColumnsKeyAdministrationZone = @"admin_area";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyConditionNight = @"cond_txt_d";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyConditionDay = @"cond_txt_n";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyDate = @"date";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyWindForce = @"wind_sc";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyCityLatitude = @"cityLat";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyCityName = @"location";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyTemperatureMax = @"tmp_max";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyTemperatureMin = @"tmp_min";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyVisibility = @"vis";
static NSString * const kMNCWeatherPropertiesFileColumnsKeyHumidity = @"hum";

/**
 天气API头部常量定义
 */

static NSString * const kMNCWeatherPropertiesAPIHeaderKeyHeWeather6 = @"HeWeather6";

/**
 天气API属性分类常量定义
 */

static NSString * const kMNCWeatherPropertiesAPIClassifyKeyBasic = @"basic";
static NSString * const kMNCWeatherPropertiesAPIClassifyKeyDailyForecast = @"daily_forecast";
static NSString * const kMNCWeatherClassifyToday = @"today";
static NSString * const kMNCWeatherClassifyTomorrow = @"tomorrow";
static NSString * const kMNCWeatherClassifyAfterTomorrow = @"afterTomorrow";


/**
 weatherState
 */

static NSString * const MNCWeatherStateCloudy = @"Cloudy";
static NSString * const MNCWeatherStateShowerRain = @"shower rain";
static NSString * const MNCWeatherStateOvercast = @"Overcast";
static NSString * const MNCWeatherStateSunnyClear = @"Sunny/Clear";
static NSString * const MNCWeatherStatePartlyCloudy = @"Partly Cloudy";
static NSString * const MNCWeatherStateThundershower = @"Thundershower";
static NSString * const MNCWeatherStateLightRain = @"Light Rain";
static NSString * const MNCWeatherStateHeavyRain = @"Heavy Rain";
static NSString * const MNCWeatherStateStorm = @"Storm";
static NSString * const MNCWeatherStateLightSnow = @"Light Snow";
static NSString * const MNCWeatherStateHeavySnow = @"Heavy Snow";
static NSString * const MNCWeatherStateSleet = @"Sleet";

/**
 城市Tab下plist文件中城市属性Key
 */

static NSString * const  kMNCCityGroupFileColumnsKeyCityNameChinese = @"cityNameC";

/**
 NSNotification
 */

static NSString * const kMNCWeatherPropertiesFileDidChangeNotification = @"fileDataDidChange";
static NSString * const kMNCDownloadedDataFromWeatherAPINotification = @"downloadDataFromWeatherAPI";


#endif /* MNCHeader_h */
