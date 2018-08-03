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
                                                 selector:@selector(updataPropertiesFromPlist:)
                                                     name:kMNCWeatherPropertiesFileDidChangeNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Private methods

- (void)initPropertiesFromPlist {
    if (![self.dataFile.dataArray count]) {
        self.dataFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    for (NSUInteger i = 0; i < self.dataFile.dataArray.count; i ++) {
        NSMutableDictionary *dic = [self.dataFile.dataArray[i] objectAtIndex:1];
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
}

#pragma mark - Notification

- (void)updataPropertiesFromPlist:(NSNotification *)notification {
    self.dataFile = notification.object;
}

@end

