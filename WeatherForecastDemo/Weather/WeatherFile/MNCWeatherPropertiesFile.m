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
@property (strong, nonatomic) NSDictionary *tomorrowDict;
@property (strong, nonatomic) NSDictionary *afterTomorrowDict;
@end

@implementation MNCWeatherPropertiesFile

#pragma mark - Lift cycle

+ (MNCWeatherPropertiesFile *)sharedInstance {
    static MNCWeatherPropertiesFile *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MNCWeatherPropertiesFile alloc] init];
    });
    return instance;
}

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
    if ([dataArray count]) {
        NSDictionary *weatherProperty = nil;
        for (NSDictionary *dict in dataArray) {
            if (dict[kMNCWeatherPropertiesAPIClassifyKeyBasic]) {
                weatherProperty = (NSDictionary *)dict[kMNCWeatherPropertiesAPIClassifyKeyBasic];
                [self changePropertiyToFile:weatherProperty
                                       info:kMNCWeatherPropertiesAPIClassifyKeyBasic];
            }
            if (dict[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast]) {
                for (NSUInteger index = 0; index < 3; index ++) {
                    weatherProperty = (NSDictionary *)[dict[kMNCWeatherPropertiesAPIClassifyKeyDailyForecast] objectAtIndex:index];
                    if (0 == index) {
                        [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyToday];
                    }
                    if (1 == index) {
                        [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyTomorrow];
                        self.tomorrowDict = weatherProperty;
                    }
                    if (2 == index) {
                        [self changePropertiyToFile:weatherProperty info:kMNCWeatherClassifyAfterTomorrow];
                        self.afterTomorrowDict = weatherProperty;
                    }
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMNCWeatherPropertiesFileDidChangeToDetailNotification
                                                        object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMNCWeatherPropertiesFileDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"tomorrow":_tomorrowDict,@"afterTomorrow":_afterTomorrowDict}];
    
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

- (void)changePropertiyToFile:(NSDictionary *)weatherProperty info:(NSString *)flag {
    if ([weatherProperty count]) {
        NSDictionary *dict = [self.dataArray objectAtIndex:0];
        NSMutableDictionary *selectDict = dict[kMNCWeatherClassifyToday];
        if ([flag isEqualToString:dict[kMNCWeatherClassifyToday]]) {
            for (NSString *dictKey in [selectDict allKeys]) {
                NSString *value = [weatherProperty valueForKey:dictKey];
                [[self.dataArray objectAtIndex:0][kMNCWeatherClassifyToday] setValue:value forKey:dictKey];
            }
        }
        if ([flag isEqualToString:kMNCWeatherClassifyAfterTomorrow]) {
            selectDict = dict[kMNCWeatherClassifyAfterTomorrow];
            for (NSString *dictKey in [selectDict allKeys]) {
                NSString *value = [weatherProperty valueForKey:dictKey];
                [[self.dataArray objectAtIndex:0][kMNCWeatherClassifyAfterTomorrow] setValue:value forKey:dictKey];
            }
        }
        if ([flag isEqualToString:kMNCWeatherClassifyTomorrow]){
            selectDict = dict[kMNCWeatherClassifyTomorrow];
            for (NSString *dictKey in [selectDict allKeys]) {
                NSString *value = [weatherProperty valueForKey:dictKey];
                [[self.dataArray objectAtIndex:0][kMNCWeatherClassifyTomorrow] setValue:value forKey:dictKey];
            }
        }
        [self.dataArray writeToFile:[self getSaveFileName] atomically:YES];
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
    NSDictionary *dataDict = notification.userInfo;
    [self initWeatherDataFromFile];
    NSArray *dataArray = dataDict[kMNCWeatherPropertiesAPIHeaderKeyHeWeather6];
    [self changeWeatherPropertiesToFiled:dataArray];
}

@end
