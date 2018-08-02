//
//  MNCSimpleWeatherView.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCSimpleWeatherView.h"
#import "MNCSimpleWeatherData.h"
#import "MNCDetailWeatherData.h"
#import "MNCWeatherViewController.h"
#import "MNCHeader.h"

@interface MNCSimpleWeatherView ()
@property (strong, nonatomic) MNCWeatherViewController *weatherVC;
@end

@implementation MNCSimpleWeatherView

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    [self createUI];
    return self;
}

#pragma mark - Public methods

- (void)createUIData:(MNCSimpleWeatherData *)simpleData {
    
    NSString *tmpMax = simpleData.temperatureMax;
    NSString *tmpMin = simpleData.temperatureMax;
    NSString *state = simpleData.conditionDay;
    
    UILabel *tempLabel = (UILabel *)[self viewWithTag:101];
    tempLabel.text = [NSString stringWithFormat:@"%d/%d℃",([tmpMax intValue] - 32) * 5 / 9,
                   ([tmpMin intValue] - 32) * 5 / 9];
    
    UILabel *stateLabel = (UILabel *)[self viewWithTag:102];
    stateLabel.text = [NSString stringWithFormat:@"%@",[self getChineseFromWeatherStatesString:state]];
    
    UIImageView *iconView = (UIImageView *)[self viewWithTag:103];
    UIImage *image = [self updataWeatherIcon:state];
    iconView.image = image;
    
    UILabel *dateLabel = (UILabel *)[self viewWithTag:100];
        dateLabel.text = @"明天";
        dateLabel.text = @"后天";
}

- (NSString *)updataWeatherState:(MNCSimpleWeatherData *)simpleData {
    return simpleData.conditionDay;
}

#pragma mark - Private methods
- (void)createUI {
    //    UILabel *dateLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + 10,
    //                                   rect.origin.y + 10,
    //                                   (rect.size.width - 20) / 4,
    //                                   rect.size.height / 4)];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(10,0,50,50)];
    dateLabel.font = [UIFont fontWithName:@"Arial" size:20];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.tag = 100;
    [self addSubview:dateLabel];
    
    //    UILabel *tmpLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + dateLab.frame.size.width + 10,
    //                                   rect.origin.y + 10  ,
    //                                   (rect.size.width - 20) - 40,
    //                                   rect.size.height / 4)];
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(dateLabel.bounds.size.width,dateLabel.bounds.origin.y,150,50)];
    tmpLabel.font = [UIFont fontWithName:@"Arial" size:20];
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.tag = 101;
    [self addSubview:tmpLabel];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(10, 50 + 10,100,50)];
    stateLabel.font = [UIFont fontWithName:@"Arial" size:20];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.tag = 102;
    [self addSubview:stateLabel];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.tag = 103;
    iconView.frame = CGRectMake(stateLabel.bounds.size.width + 10 ,
                                    50 + 10,
                                    50,
                                    50);
    [self addSubview:iconView];
}

- (NSString *)getChineseFromWeatherStatesString:(NSString *)stateString {
    if ([stateString isEqualToString:MNCWeatherStateCloudy]) {//多云
        return @"多云";
    } else if ([stateString isEqualToString:MNCWeatherStateShowerRain]) {//阵雨
        return @"阵雨";
    } else if ([stateString isEqualToString:MNCWeatherStateOvercast]) { //阴
        return @"阴天";
    } else if ([stateString isEqualToString:MNCWeatherStateSunnyClear]) {//晴
        return @"晴天";
    } else if ([stateString isEqualToString:MNCWeatherStatePartlyCloudy]) {//晴间多云
        return @"晴间多云";
    } else if ([stateString isEqualToString:MNCWeatherStateThundershower]) {//雷阵雨
        return @"雷阵雨";
    } else if ([stateString isEqualToString:MNCWeatherStateLightRain]) {//小雨
        return @"小雨";
    } else if ([stateString isEqualToString:MNCWeatherStateHeavyRain]) { //大雨
        return @"大雨";
    } else if ([stateString isEqualToString:MNCWeatherStateStorm]) {//暴雨
        return @"暴雨";
    } else if ([stateString isEqualToString:MNCWeatherStateLightSnow]) {//小雪
        return @"小雪";
    } else if ([stateString isEqualToString:MNCWeatherStateHeavySnow]) {//大雪
        return @"大雪";
    } else if ([stateString isEqualToString:MNCWeatherStateSleet]) { //雨夹雪
        return @"雨夹雪";
    } else if ([stateString isEqualToString:MNCWeatherStateSunnyClear]) {
        return @"晴天";
    }
    return @"未知";
}

- (UIImage *)updataWeatherIcon:(NSString *)state {
    UIImage *icon = nil;
    if ([state isEqualToString:MNCWeatherStateCloudy]) {//多云
        icon = [UIImage imageNamed:@"cloud.png"];
    } else if ([state isEqualToString:MNCWeatherStateShowerRain]) {//阵雨
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateOvercast]) { //阴
        icon = [UIImage imageNamed:@"cloud.png"];
    } else if ([state isEqualToString:MNCWeatherStateSunnyClear]) {//晴
        icon = [UIImage imageNamed:@"sunshine.png"];
    } else if ([state isEqualToString:MNCWeatherStatePartlyCloudy]) {//晴间多云
        icon = [UIImage imageNamed:@"cloud.png"];
    } else if ([state isEqualToString:MNCWeatherStateThundershower]) {//雷阵雨
        icon = [UIImage imageNamed:@"thunder.png"];
    } else if ([state isEqualToString:MNCWeatherStateLightRain]) {//小雨
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateHeavyRain]) { //大雨
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateStorm]) {//暴雨
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateLightSnow]) {//小雪
        icon = [UIImage imageNamed:@"snowwing.png"];
    } else if ([state isEqualToString:MNCWeatherStateHeavySnow]) {//大雪
        icon = [UIImage imageNamed:@"snowwing.png"];
    } else if ([state isEqualToString:MNCWeatherStateSleet]) { //雨夹雪
        icon = [UIImage imageNamed:@"rainAndSnow.png"];
    } else if ([state isEqualToString:MNCWeatherStateSunnyClear]) {//晴
        icon = [UIImage imageNamed:@"sunshine.png"];
    }
    return icon;
}

#pragma mark setter && getter

- (MNCSimpleWeatherData *)simpleData {
    if (!_simpleData) {
        _simpleData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleData;
}

- (MNCWeatherViewController *)weatherVC {
    if (!_weatherVC) {
        _weatherVC = [[MNCWeatherViewController alloc] init];
    }
    return  _weatherVC;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
