//
//  MNCDetailWeatherData.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCDetailWeatherData.h"
#import "MNCWeatherPropertiesFile.h"
@interface MNCDetailWeatherData ()
@property (strong, nonatomic) NSString *cityLatitude;     //城市纬度
@property (strong, nonatomic) NSString *cityLongitude;    //城市经度
@property (strong, nonatomic) NSString *parentCity;       //该城市的上级城市
@property (strong, nonatomic) NSString *administrationZone;   //所属行政区域
@property (strong, nonatomic) NSString *country;          //城市所属国家名称
@property (strong, nonatomic) NSString *cityTimeZone;     //城市所在时区
@property (strong, nonatomic) NSString *windDirection;    //风向
@property (strong, nonatomic) NSString *windSpeed;        //风速 公里/小时
@property (strong, nonatomic) NSString *precipitation;    //降水量
@property (strong, nonatomic) NSString *pressure;         //大气压强
@property (strong, nonatomic) NSString *visibility;       //能见度

@property (strong, nonatomic) MNCWeatherPropertiesFile *dataFile;
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@end

@implementation MNCDetailWeatherData

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    return self;
}

#pragma mark - Overridden methods

- (NSString *)description {
    return [NSString stringWithFormat: @"location: %@, cnty: %@, tz: %@, adminArea: %@, cityLon: %@, cityLat: %@, parentCity: %@, temperatureMax: %@, hum: %@, windSpeed: %@, pres: %@, vis: %@, windDirection: %@, condTxtDay: %@, condTxtNight: %@, currentTime: %@, temperatureMin: %@, windForce: %@", self.cityName, self.country, self.cityTimeZone, self.administrationZone, self.cityLongitude, self.cityLatitude, self.parentCity, self.temperatureMax, self.humidity, self.windSpeed, self.pressure, self.visibility, self.windDirection, self.conditionDay, self.conditionNight, self.date, self.temperatureMin, self.windForce];
}

#pragma mark - Public methods

- (void)initDetailWeatherPropertiesFromDic:(NSDictionary *)propretiesDic info:(NSString *)flag {
    if ([flag isEqualToString:@"basic"]) {
        [self initBisicWeatherProperties:propretiesDic];
    } else {
        [self initDetailWeatherProperties:propretiesDic];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCDetailWeatherDataNotification"
                                                        object:self];
}

#pragma mark - Private methods

//初始化基本参数 basic
- (void)initBisicWeatherProperties:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.cityName = propertiesArray[0];
        self.cityName = propertiesArray[1];
        self.cityTimeZone = propertiesArray[2];
        self.administrationZone = propertiesArray[3];
        self.cityLongitude = propertiesArray[4];
        self.cityLatitude = propertiesArray[5];
        self.parentCity = propertiesArray[6];
    }
}

//初始化today相关参数
- (void)initDetailWeatherProperties:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.temperatureMax = propertiesArray[2];
        self.humidity = propertiesArray[3];
        self.windSpeed = propertiesArray[4];
        self.pressure = propertiesArray[6];
        self.visibility = propertiesArray[8];
        self.windDirection = propertiesArray[9];
        self.conditionDay = propertiesArray[10];
        self.conditionNight = propertiesArray[11];
        self.date = propertiesArray[12];
        self.temperatureMin = propertiesArray[15];
        self.windForce = propertiesArray[16];
    }
}

- (void)initDetailWeatherPropertiesFromPlist {
    //是一个数组   self.weatherDataFile.weatherPropertiesInFiled
    if (![self.dataFile.dataArray count]) {
        self.dataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    NSMutableDictionary *dic = [self.dataFile.dataArray objectAtIndex:0];
    for (NSString *weatherProperty in [dic allKeys]) {
        if ([weatherProperty isEqualToString:@"admin_area"]) {
            self.administrationZone = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"cond_txt_d"]) {
            self.conditionDay = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"cond_txt_n"]) {
            self.conditionNight = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"date"]) {
            self.date = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"wind_sc"]) {
            self.windForce = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"location"]) {
            self.cityName = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_max"]) {
            self.temperatureMax = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_min"]) {
            self.temperatureMin = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"pcpn"]) {
            self.precipitation = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"vis"]) {
            self.visibility = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"hum"]) {
            self.humidity = [dic objectForKey:weatherProperty];
        }
    }
}

@end
