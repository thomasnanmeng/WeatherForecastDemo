//
//  MNCWeatherPropertiesFile.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCWeatherPropertiesFile.h"

#define MNCWeatherBasic @"basic"
#define MNCWeatherToday @"today"
#define MNCWeatherTomorrow @"tomorrow"
#define MNCWeatherAfterTomorrow @"afterTomorrow"

@interface MNCWeatherPropertiesFile ()

@end

@implementation MNCWeatherPropertiesFile
#pragma mark - Lift cycle
- (instancetype)init {
    if (!self) {
        self = [super init];
    }
    [self initWeatherData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataWeacherDataToFiled:) name:@"MNCWeatherPropertiesFileNotification"
                                               object:nil];
    return self;
}

#pragma mark - Overridden methods
#pragma mark - Public methods
- (void)changeWeatherPropertiesToFiled:(NSArray *)weatherPropertyArray{
    //传进来的是所有拉下来的数据 ，格式为 arra  里面为几个dic
    if ([weatherPropertyArray count]) {
        NSDictionary *weatherProperty = nil;
        for (NSDictionary *dic in weatherPropertyArray) { //一共有四个dic
            if (dic[@"basic"]) {
                weatherProperty = (NSDictionary *)dic[@"basic"];
                [self changeWeatherPropertiesToFiledInDetail:weatherProperty info:@"basic"];
            }
            if (dic[@"daily_forecast"]) {
                weatherProperty = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:0];
                [self changeWeatherPropertiesToFiledInDetail:weatherProperty info:@"today"];
                weatherProperty = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:1];
                [self changeWeatherPropertiesToFiledInDetail:weatherProperty info:@"tomorrow"];
                weatherProperty = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:2];
                [self changeWeatherPropertiesToFiledInDetail:weatherProperty info:@"afretTomorrow"];
            }
        }
    }
    NSLog(@"写入文件");
}
#pragma mark - Private methods
- (void)initWeatherData {
    NSString *dir = [self getSaveFiledDir];
    NSString *path = [self getSaveFileName];
    [[NSFileManager defaultManager] createDirectoryAtPath: dir
                              withIntermediateDirectories:YES
                                               attributes: nil error: nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        _weatherPropertiesInFiled = [NSMutableArray arrayWithContentsOfFile: path];
    } else {
        NSString *initPath = [[NSBundle mainBundle] pathForResource: @"MNCWeatherPropertiesDataFile"
                                                             ofType: @"plist"];
        _weatherPropertiesInFiled = [NSMutableArray arrayWithContentsOfFile: initPath];
        [_weatherPropertiesInFiled writeToFile: path atomically: YES];
    }
    _weatherPropertiesInFiled = [NSMutableArray arrayWithContentsOfFile: path];
}

- (void)addWeatherPropertiesToFiled:(NSString *)key value:(NSString *)value
                              indix:(NSUInteger) index {
    if(key) {
        [[self.weatherPropertiesInFiled objectAtIndex:index] setValue:value forKey:key];
    }
    [self.weatherPropertiesInFiled writeToFile:[self getSaveFileName] atomically:YES];
}

- (void)deleteWeatherPropertiesToFiled:(NSString *)key {
    if (key) {
        for (NSUInteger i = 0; i< self.weatherPropertiesInFiled.count; i++) {
            [[self.weatherPropertiesInFiled objectAtIndex:i] removeObjectForKey:key];
        }
        [self.weatherPropertiesInFiled writeToFile:[self getSaveFileName] atomically:YES];
    }
}

- (void)changeWeatherPropertiesToFiledInDetail:(NSDictionary *)weatherProperty info:(NSString *)flag {
    if ([weatherProperty count]) {
        NSUInteger i = 0;
        NSDictionary *dic = nil;
        if ([flag isEqualToString:@"tomorrow"]) {
            i  = 1;
            dic = [self.weatherPropertiesInFiled objectAtIndex:i];
        } else if ([flag isEqualToString:@"afretTomorrow"]) {
            i = 2;
            dic = [self.weatherPropertiesInFiled objectAtIndex:i];
        } else {
            dic = [self.weatherPropertiesInFiled objectAtIndex:i];
        }
        //dic为文件里面的所有key
        for (NSString *weatherKey in [dic allKeys]) {
            for (NSString *weatherPropertyKey in [weatherProperty allKeys]) {
                if ([weatherKey isEqualToString:weatherPropertyKey]) {
                    NSString * value = [weatherProperty objectForKey:weatherKey];
                    //[self deleteWeatherPropertiesToFiled:weatherKey];
                    [self addWeatherPropertiesToFiled:weatherKey value:value indix:i];
                    break;
                }
            }
        }
    }
}

- (NSString *)getSaveFiledDir {
    //常用的沙盒路径
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                                       NSUserDomainMask, YES)[0];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *dir = [documentsDirectory stringByAppendingPathComponent: bundleId];
    NSLog(@"dir : %@",dir);
    return dir;
}

- (NSString *)getSaveFileName {
    NSString *dir = [self getSaveFiledDir];
    NSString *path = [dir stringByAppendingPathComponent:@"MNCWeatherPropertiesDataFile.plist"];
    return path;
}

#pragma mark - Notification
- (void)updataWeacherDataToFiled:(NSNotification *)notification {
    NSLog(@"我收到通知了");
    [self changeWeatherPropertiesToFiled:notification.object];
}

@end
