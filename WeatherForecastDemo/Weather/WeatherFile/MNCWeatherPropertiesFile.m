//
//  MNCWeatherPropertiesFile.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCWeatherPropertiesFile.h"
#import "MNCHeader.h"

@interface MNCWeatherPropertiesFile ()

@end

@implementation MNCWeatherPropertiesFile

#pragma mark - Lift cycle

- (instancetype)init {
    if (!self) {
        self = [super init];
    }
    [self initWeatherDataFromFile];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataWeacherDataToFiled:) name:kMNCDownloadedDataFromWeatherAPINotification
                                               object:nil];
    return self;
}

#pragma mark - Public methods

- (void)changeWeatherPropertiesToFiled:(NSArray *)dataArray{
    //传进来的是所有拉下来的数据 ，格式为 arra  里面为几个dic
    if ([dataArray count]) {
        NSDictionary *weatherProperty = nil;
        for (NSDictionary *dic in dataArray) { //一共有四个dic
            if (dic[kMNCWeatherPropertiesAPIClassifyKeyBasic]) {
                weatherProperty = (NSDictionary *)dic[kMNCWeatherPropertiesAPIClassifyKeyBasic];
                [self changePropertiyToFile:weatherProperty
                                                        info:kMNCWeatherPropertiesAPIClassifyKeyBasic];
            }
            if (dic[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast]) {
                for (NSUInteger index = 0; index < 3; index ++)
                weatherProperty = (NSDictionary *)[dic[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast] objectAtIndex:index];
                [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyToday];
                weatherProperty = (NSDictionary *)[dic[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast] objectAtIndex:1];
                [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyTomorrow];
                weatherProperty = (NSDictionary *)[dic[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast] objectAtIndex:2];
                [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyAfterTomorrow];
            }
        }
    }
    NSLog(@"写入文件");
}

#pragma mark - Private methods

- (void)initWeatherDataFromFile {
    NSString *dir = [self getSaveFiledDir];
    NSString *path = [self getSaveFileName];
    [[NSFileManager defaultManager] createDirectoryAtPath: dir
                              withIntermediateDirectories:YES
                                               attributes: nil error: nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        _dataArray = [NSMutableArray arrayWithContentsOfFile: path];
    } else {
        NSString *initPath = [[NSBundle mainBundle] pathForResource: @"MNCWeatherPropertiesDataList"
                                                             ofType: @"plist"];
        _dataArray = [NSMutableArray arrayWithContentsOfFile: initPath];
        [_dataArray writeToFile: path atomically: YES];
    }
    _dataArray = [NSMutableArray arrayWithContentsOfFile: path];
}

- (void)addPropertyToFile:(NSString *)key value:(NSString *)value indix:(NSUInteger) index {
    if(key) {
        [[self.dataArray objectAtIndex:index] setValue:value forKey:key];
    }
    [self.dataArray writeToFile:[self getSaveFileName] atomically:YES];
}

- (void)deletePropertyFromFiled:(NSString *)key {
    if (key) {
        for (NSUInteger i = 0; i< self.dataArray.count; i++) {
            [[self.dataArray objectAtIndex:i] removeObjectForKey:key];
        }
        [self.dataArray writeToFile:[self getSaveFileName] atomically:YES];
    }
}

- (void)changePropertiyToFile:(NSDictionary *)weatherProperty info:(NSString *)flag {
    if ([weatherProperty count]) {
        NSUInteger i = 0;
        NSDictionary *dic = nil;
        if ([flag isEqualToString:kMNCWeatherClassifyTomorrow]) {
            i  = 1;
        } else if ([flag isEqualToString:kMNCWeatherClassifyAfterTomorrow]) {
            i = 2;
        }
        dic = [self.dataArray objectAtIndex:i];
        for (NSString *weatherKey in [dic allKeys]) {
            for (NSString *weatherPropertyKey in [weatherProperty allKeys]) {
                if ([weatherKey isEqualToString:weatherPropertyKey]) {
                    NSString * value = [weatherProperty objectForKey:weatherKey];
                    [self addPropertyToFile:weatherKey value:value indix:i];
                    break;
                }
            }
        }
    }
}

- (NSString *)getSaveFiledDir {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                                       NSUserDomainMask, YES)[0];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *dir = [documentsDirectory stringByAppendingPathComponent: bundleId];
    return dir;
}

- (NSString *)getSaveFileName {
    NSString *dir = [self getSaveFiledDir];
    NSString *path = [dir stringByAppendingPathComponent:@"MNCWeatherPropertiesDataList.plist"];
    return path;
}

#pragma mark - Notification

- (void)updataWeacherDataToFiled:(NSNotification *)notification {
    //NSArray *responsArray = dataDic[kMNCWeatherPropertiesAPIHeaderKeyHeWeather6];
    [self changeWeatherPropertiesToFiled:notification.object];
}

@end
