//
//  MNCSimpleWeatherData.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCSimpleWeatherData.h"
#import "MNCWeatherPropertiesFile.h"
#import "MNCHeader.h"

@interface MNCSimpleWeatherData ()
@property (strong, nonatomic) MNCWeatherPropertiesFile *dataFile;
@end

@implementation MNCSimpleWeatherData

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initWeatherPropertiesFromPlist:)
                                                     name:kMNCWeatherPropertiesFileDidChangeNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Private methods

- (void)initWeatherPropertiesFromPlist:(NSNotification *)notificion {
    //是一个数组   self.weatherDataFile.weatherPropertiesInFiled
    if (![self.dataFile.dataArray count]) {
        self.dataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    //不能objectAtIndex = 1;
    NSMutableDictionary *dic = [self.dataFile.dataArray objectAtIndex:1];
    for (NSString *element in [dic allKeys]) {
        if ([element isEqualToString:kMNCWeatherPropertiesFileColumnsKeyConditionDay]) {
            self.conditionDay = [dic objectForKey:element];
        } else if ([element isEqualToString:kMNCWeatherPropertiesFileColumnsKeyConditionNight]) {
            self.conditionNight = [dic objectForKey:element];
        } else if ([element isEqualToString:kMNCWeatherPropertiesFileColumnsKeyTemperatureMax]) {
            self.temperatureMax = [dic objectForKey:element];
        } else if ([element isEqualToString:kMNCWeatherPropertiesFileColumnsKeyAdministrationZone]) {
            self.temperatureMin = [dic objectForKey:element];
        } else if ([element isEqualToString:kMNCWeatherPropertiesFileColumnsKeyDate]) {
            self.date = [dic objectForKey:element];
        }
    }
}

@end
