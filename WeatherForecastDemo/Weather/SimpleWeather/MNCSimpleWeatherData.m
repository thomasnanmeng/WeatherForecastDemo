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
@property (strong, nonatomic) MNCWeatherPropertiesFile *DataFile;
@end

@implementation MNCSimpleWeatherData

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _DataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)initSimpleWeatherPropertiesFromDic:(NSDictionary *)propretiesDic {
    if ([propretiesDic count]) {
        NSArray *propertiesArray = [propretiesDic allValues];
        self.temperatureMax = propertiesArray[2];
        self.temperatureMin = propertiesArray[15];
        self.condTxtDay = propertiesArray[10];
        self.condTxtNight = propertiesArray[11];
        self.Date = propertiesArray[12];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCSimpleWeatherFromWebNotification"
                                                        object:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#> userInfo:<#(nullable NSDictionary *)#>];
}

#pragma mark - Private methods

- (void)initWeatherPropertiesFromPlist:(MNCSimpleWeatherData *)simpleData {
    //是一个数组   self.weatherDataFile.weatherPropertiesInFiled
    if (![self.DataFile.dataArray count]) {
        self.DataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    //不能objectAtIndex = 1;
    NSMutableDictionary *dic = [self.DataFile.dataArray objectAtIndex:1];
    for (NSString *element in [dic allKeys]) {
        if ([element isEqualToString:@"cond_txt_d"]) {
            self.condTxtDay = [dic objectForKey:element];
        } else if ([element isEqualToString:@"cond_txt_n"]) {
            self.condTxtNight = [dic objectForKey:element];
        } else if ([element isEqualToString:@"tmp_max"]) {
            self.temperatureMax = [dic objectForKey:element];
        } else if ([element isEqualToString:@"tmp_min"]) {
            self.temperatureMin = [dic objectForKey:element];
        } else if ([element isEqualToString:@"date"]) {
            self.Date = [dic objectForKey:element];
        }
    }
}

@end
