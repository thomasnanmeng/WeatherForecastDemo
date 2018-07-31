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

@property (nonatomic, strong) NSString *cityLat;    //城市维度
@property (nonatomic, strong) NSString *cityLon;    //城市经度
@property (nonatomic, strong) NSString *parentCity; //该城市的上级城市
@property (nonatomic, strong) NSString *adminArea;  //所属行政区域
@property (nonatomic, strong) NSString *cnty;       //城市所属国家名称
@property (nonatomic, strong) NSString *tz;         //城市所在时区
@property (nonatomic, strong) NSString *windDeg;         //风向360角度
@property (nonatomic, strong) NSString *windDirection;   //风向
@property (nonatomic, strong) NSString *windSpeed;       //风速 公里/小时
@property (nonatomic, strong) NSString *pcpn;            //降水量
@property (nonatomic, strong) NSString *pop;             //降水概率
@property (nonatomic, strong) NSString *pres;            //大气压强
@property (nonatomic, strong) NSString *vis;             //能见度

@property (nonatomic, strong) MNCWeatherPropertiesFile *weatherDataFile;
@property (nonatomic, strong) MNCDetailWeatherData *detailWeatherData;
@end

@implementation MNCDetailWeatherData
#pragma mark - Lift cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.weatherDataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    return self;
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
- (NSString *)updataTempMax {
    if (!self.temperatureMax) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.temperatureMax;
}

- (NSString *)updataTempMin {
    if (!self.temperatureMin) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.temperatureMin;
}

- (NSString *)updataHum {
    if (!self.hum) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.hum;
}

- (NSString *)updataState {
    if (!self.condTxtDay) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.condTxtDay;
}

- (NSString *)updataWindForce {
    if (!self.windForce) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.windForce;
}
- (NSString *)updataCity {
    if (!self.location) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.location;
}
- (NSString *)updataCurrentDate {
    if (!self.currentTime) {
        [self initDetailWeatherPropertiesFromPlist];
    }
    return self.currentTime;
}

#pragma mark - Private methods
//初始化基本参数 basic
- (void)initBisicWeatherProperties:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.location = propertiesArray[0];
        self.cnty = propertiesArray[1];
        self.tz = propertiesArray[2];
        self.adminArea = propertiesArray[3];
        self.cityLon = propertiesArray[4];
        self.cityLat = propertiesArray[5];
        self.parentCity = propertiesArray[6];
    }
}

//初始化today相关参数
- (void)initDetailWeatherProperties:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.condCodeDay = propertiesArray[1];
        self.temperatureMax = propertiesArray[2];
        self.hum = propertiesArray[3];
        self.windSpeed = propertiesArray[4];
        self.pres = propertiesArray[6];
        self.vis = propertiesArray[8];
        self.windDirection = propertiesArray[9];
        self.condTxtDay = propertiesArray[10];
        self.condTxtNight = propertiesArray[11];
        self.currentTime = propertiesArray[12];
        self.temperatureMin = propertiesArray[15];
        self.windForce = propertiesArray[16];
        self.windDeg = propertiesArray[18];
        self.condCodeNight = propertiesArray[20];
        self.pop = propertiesArray[22];
        self.pcpn = propertiesArray[21];
    }
}
- (void)initDetailWeatherPropertiesFromPlist {
    //是一个数组   self.weatherDataFile.weatherPropertiesInFiled
    if (![self.weatherDataFile.weatherPropertiesInFiled count]) {
        self.weatherDataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    NSMutableDictionary *dic = [self.weatherDataFile.weatherPropertiesInFiled objectAtIndex:0];
    for (NSString *weatherProperty in [dic allKeys]) {
        if ([weatherProperty isEqualToString:@"admin_area"]) {
            self.adminArea = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"cond_txt_d"]) { //白天天气状况
            self.condTxtDay = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"cond_txt_n"]) {//晚上天气状况
            self.condTxtNight = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"date"]) {//时间
            self.currentTime = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"wind_sc"]) {//风力
            self.windForce = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"location"]) {//地区
            self.location = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_max"]) {//温度最高
            self.temperatureMax = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_min"]) {//温度最低
            self.temperatureMin = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"pcpn"]) {//降水量
            self.pcpn = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"vis"]) {//能见度
            self.vis = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"hum"]) { //相对湿度
            self.hum = [dic objectForKey:weatherProperty];
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat: @"location: %@, cnty: %@, tz: %@, adminArea: %@, cityLon: %@, cityLat: %@, parentCity: %@, condCodeDay: %@, temperatureMax: %@, hum: %@, windSpeed: %@, pres: %@, vis: %@, windDirection: %@, condTxtDay: %@, condTxtNight: %@, currentTime: %@, temperatureMin: %@, windForce: %@, windDeg: %@, condCodeNight: %@, pop: %@, pcpn: %@,", self.location, self.cnty, self.tz, self.adminArea, self.cityLon, self.cityLat, self.parentCity, self.condCodeDay, self.temperatureMax, self.hum, self.windSpeed, self.pres, self.vis, self.windDirection, self.condTxtDay, self.condTxtNight, self.currentTime, self.temperatureMin, self.windForce, self.windDeg, self.condCodeNight, self.pop, self.pcpn];
}


@end
