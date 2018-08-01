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
@property (strong, nonatomic) NSDictionary *basicPropertise;
@property (strong, nonatomic) NSDictionary *todaydataDic;
@property (strong, nonatomic) NSDictionary *tomorrowDataDic;
@property (strong, nonatomic) NSDictionary *afterTomorrowDataDic;
@property (strong, nonatomic) NSMutableArray *weatherDateArray;
@property (strong, nonatomic) MNCDetailWeatherData *detailWeatherData;
@property (strong, nonatomic) MNCSimpleWeatherData *simpleWeatherData;
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
        self.simpleWeatherData = [[MNCSimpleWeatherData alloc] init];
        self.detailWeatherData = [[MNCDetailWeatherData alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)useCityNameToRequestWeatherData:(NSString *)cityName {
    NSString *strUrl = [NSString stringWithFormat:@"https://free-api.heweather.com/s6/weather/forecast?location=%@&key=cbd779e2141b45938d845a2a8cb2345c&lang=en&unit=i",cityName];
    //创建URL时，如果是中文则不能请求，必须转换
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:strUrl]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData: data encoding: gbkEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self JsonStringToDicString:responseStr];
        });
    }];
    [dataTask resume];
}

#pragma mark - Private methods

- (void)JsonStringToDicString:(NSString *)jsonString {
    if (!jsonString) {
        return ;
    }
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    if (error) {
        NSLog(@"解析失败 error = %@",error);
        return ;
    }
    [self responseDicToPropretiesDic:responseDic];
}

- (void)responseDicToPropretiesDic:(NSDictionary *)responseDic {
    NSArray *responsArray = responseDic[@"HeWeather6"];
    if ([responsArray count]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MNCWeatherPropertiesFileNotification" object:responsArray];

        for (NSDictionary *dic in responsArray) { //一共有四个dic
            if (dic[@"basic"]) {
                self.basicPropertise = (NSDictionary *)dic[@"basic"];
                [self.detailWeatherData initDetailWeatherPropertiesFromDic:self.basicPropertise
                                                                      info:@"basic"];
            }
            if (dic[@"daily_forecast"]) {
                self.tomorrowDataDic = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:0];
                [self.detailWeatherData initDetailWeatherPropertiesFromDic:self.tomorrowWeatherDataDic info:@"today"];
                self.tomorrowDataDic = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:1];
                [self.simpleWeatherData initSimpleWeatherPropertiesFromDic:self.tomorrowDataDic];
                self.afterTomorrowDataDic = (NSDictionary *)[dic[@"daily_forecast"] objectAtIndex:2];
                [self.simpleWeatherData initSimpleWeatherPropertiesFromDic:self.afterTomorrowDataDic];
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

- (MNCDetailWeatherData *)detailWeatherData {
    if (!_detailWeatherData) {
        _detailWeatherData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailWeatherData;
}

- (MNCSimpleWeatherData *)simpleWeatherData {
    if (!_simpleWeatherData) {
        _simpleWeatherData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleWeatherData;
}


@end
