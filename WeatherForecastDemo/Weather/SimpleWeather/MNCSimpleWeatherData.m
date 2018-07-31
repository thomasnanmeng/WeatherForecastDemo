//
//  MNCSimpleWeatherData.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCSimpleWeatherData.h"
#import "MNCWeatherPropertiesFile.h"

@interface MNCSimpleWeatherData ()
@property (strong, nonatomic) MNCWeatherPropertiesFile *weatherDataFile;

@end

@implementation MNCSimpleWeatherData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.weatherDataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    
    return self;
}


- (void)initSimpleWeatherPropertiesFromDic:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.simpleTmpMax = propertiesArray[2];
        self.simpleTmpMin = propertiesArray[15];
        self.simpleCondTextDay = propertiesArray[10];
        self.simpleCondTextNight = propertiesArray[11];
        self.simpleCurrentDate = propertiesArray[12];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCSimpleWeatherFromWebNotification"
                                                        object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#> userInfo:<#(nullable NSDictionary *)#>];
}

- (void)initWeatherPropertiesFromPlist:(NSUInteger) index {
    //是一个数组   self.weatherDataFile.weatherPropertiesInFiled
    if (![self.weatherDataFile.weatherPropertiesInFiled count]) {
        self.weatherDataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    NSMutableDictionary *dic = [self.weatherDataFile.weatherPropertiesInFiled objectAtIndex:index];
    for (NSString *weatherProperty in [dic allKeys]) {
        if ([weatherProperty isEqualToString:@"cond_txt_d"]) {
            self.simpleWeatherCondTextDay = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"cond_txt_n"]) {
            self.simpleWeatherCondTextNight = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_max"]) {
            self.simpleWeatherTmpMax = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"tmp_min"]) {
            self.simpleWeatherTmpMin = [dic objectForKey:weatherProperty];
        } else if ([weatherProperty isEqualToString:@"date"]) {
            self.simpleWeatherCurrentDate = [dic objectForKey:weatherProperty];
        }
    }
}

- (NSString *)updataTmpMaxData:(NSUInteger)index {
    if (!self.simpleWeatherTmpMax) {
        [self initWeatherPropertiesFromPlist:index];
    }
    return self.simpleWeatherTmpMax;
}
- (NSString *)updataTmpMinData:(NSUInteger)index {
    if (!self.simpleWeatherTmpMin) {
        [self initWeatherPropertiesFromPlist:index];
    }
    return self.simpleWeatherTmpMin;
}
//晴雨
- (NSString *)updataWeatherState:(NSUInteger)index {
    if (!self.simpleWeatherCondTextDay) {
        [self initWeatherPropertiesFromPlist:index];
    }
    return self.simpleWeatherCondTextDay;
}

- (NSString *)updataDateData:(NSUInteger)index {
    if (!self.simpleWeatherCurrentDate) {
        [self initWeatherPropertiesFromPlist:index];
    }    return self.simpleWeatherCurrentDate;
}
@end
