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
#import "MNCHeader.h"

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
    [self downloadedDataFromAPINotification:dataDic];
}

- (void)downloadedDataFromAPINotification:(NSDictionary *)dataDic {
    if ([dataDic count]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMNCDownloadedDataFromWeatherAPINotification object:self userInfo:dataDic];
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
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0,
                              kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", pinYin);
            pinYinStr = [NSString stringWithString:pinYin];
            pinYinStr = [pinYinStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"pinyin: %@", pinYinStr);
        }
    }
    return pinYinStr;
}

@end
