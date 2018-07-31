//
//  MNCCityNameGroup.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCCityNameGroup.h"
@interface MNCCityNameGroup ()

@property (nonatomic, strong) NSArray *cityNameArray;

@end

@implementation MNCCityNameGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCityNameGroup];
    }
    return self;
}

- (void)initCityNameGroup {
    NSString *dir = [self getSaveFiledDir];
    NSString *path = [self getSaveFileName];
    [[NSFileManager defaultManager] createDirectoryAtPath: dir
                              withIntermediateDirectories:YES
                                               attributes: nil error: nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        _cityNameArray = [NSMutableArray arrayWithContentsOfFile: path];
    } else {
        NSString *initPath = [[NSBundle mainBundle] pathForResource: @"CityGroup"
                                                             ofType: @"plist"];
        _cityNameArray = [NSMutableArray arrayWithContentsOfFile: initPath];
        [_cityNameArray writeToFile: path atomically: YES];
    }
    _cityNameArray = [NSMutableArray arrayWithContentsOfFile: path];
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
    NSString *path = [dir stringByAppendingPathComponent:@"CityGroup.plist"];
    return path;
}



@end
