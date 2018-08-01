//
//  MNCWeatherManager.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/17.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCWeatherManager.h"
#import "MNCDetailWeatherData.h"
#import "MNCSimpleWeatherData.h"

@interface MNCWeatherManager ()
@property (strong, nonatomic) NSMutableDictionary *basicData;
@property (strong, nonatomic) NSMutableDictionary *todayData;
@property (strong, nonatomic) NSMutableDictionary *tomorrowData;
@property (strong, nonatomic) NSMutableDictionary *afterTomorrowData;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@property (strong, nonatomic) MNCSimpleWeatherData *simpleData;
@end

@implementation MNCWeatherManager

#pragma mark - Lift cycle

+ (MNCWeatherManager *)sharedInstance {
    static MNCWeatherManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MNCWeatherManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (!self) {
        self = [super init];
        _simpleData = [[MNCSimpleWeatherData alloc] init];
        _detailData = [[MNCDetailWeatherData alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)useCityNameToRequestWeatherData:(NSString *)cityName {
    NSString *strURL = [NSString stringWithFormat:@"https://free-api.heweather.com/s6/weather/forecast?location=%@&key=cbd779e2141b45938d845a2a8cb2345c&lang=en&unit=i",cityName];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:strURL]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData: data encoding: gbkEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jsonStringToDataDic:responseStr];
        });
    }];
    [dataTask resume];
}

#pragma mark - Private methods

- (void)jsonStringToDataDic:(NSString *)jsonString {
    if (!jsonString) {
        return ;
    }
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    if (error) {
        NSLog(@"解析失败 error = %@",error);
        return ;
    }
    [self responseDicToPropretiesDic:dataDic];
}

- (void)responseDicToPropretiesDic:(NSDictionary *)dataDic {
    NSArray *responsArray = dataDic[@"HeWeather6"];
    if ([responsArray count]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCWeatherPropertiesFileNotification" object:responsArray];
        for (NSDictionary *dic in responsArray) { //一共有四个dic
            if (dic[@"basic"]) {
                self.basicData = (NSMutableDictionary *)dic[@"basic"];
                [self.detailData initDetailWeatherPropertiesFromDic:self.basicData
                                                                      info:@"basic"];
            }
            if (dic[@"daily_forecast"]) {
                self.tomorrowData = (NSMutableDictionary *)[dic[@"daily_forecast"] objectAtIndex:0];
                [self.detailData initDetailWeatherPropertiesFromDic:self.tomorrowData info:@"today"];
                self.tomorrowData = (NSMutableDictionary *)[dic[@"daily_forecast"] objectAtIndex:1];
                [self.simpleData initSimpleWeatherPropertiesFromDic:self.tomorrowData];
                self.afterTomorrowData = (NSMutableDictionary *)[dic[@"daily_forecast"] objectAtIndex:2];
                [self.simpleData initSimpleWeatherPropertiesFromDic:self.afterTomorrowData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCWeatherPropertiesFileNotification" object:self userInfo:@{@"key1":self.detailWeatherData,@"key2": self.simpleWeatherData}];
            }
        }
    }
}

- (NSString *)pinYinWithChineseString:(NSString *)chineseStr {
    NSString *pinYinStr = [NSString string];
    if (chineseStr.length){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:chineseStr];
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0,
                              kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", pinYin);
        }
        //再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0,
                              kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", pinYin);
            //再去除空格，将拼音连在一起
            pinYinStr = [NSString stringWithString:pinYin];
            // 去除掉首尾的空白字符和换行字符
            pinYinStr = [pinYinStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            // 去除掉其它位置的空白字符和换行字符
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"pinyin: %@", pinYinStr);
        }
    }
    return pinYinStr;
}

#pragma mark - setter && getter

- (MNCDetailWeatherData *)detailData {
    if (!_detailData) {
        _detailData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailData;
}

- (MNCSimpleWeatherData *)simpleData {
    if (!_simpleData) {
        _simpleData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleData;
}


@end
