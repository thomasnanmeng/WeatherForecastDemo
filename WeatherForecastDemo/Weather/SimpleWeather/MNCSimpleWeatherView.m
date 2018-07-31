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

@interface MNCSimpleWeatherView ()
@property (nonatomic, strong) MNCWeatherViewController *weatherViewController;
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
- (void)createUIData:(NSUInteger)index {
    
    NSString *tmpMax = [self.simpleWeatherData updataTmpMaxData:index];
    NSString *tmpMin = [self.simpleWeatherData updataTmpMinData:index];
    NSString *condStata = [self.simpleWeatherData updataWeatherState:index];
    
    UILabel *tmpLab = (UILabel *)[self viewWithTag:101];
    tmpLab.text = [NSString stringWithFormat:@"%d/%d℃",([tmpMax intValue] - 32) * 5 / 9,
                   ([tmpMin intValue] - 32) * 5 / 9];
    
    UILabel *weatherLab = (UILabel *)[self viewWithTag:102];
    weatherLab.text = [NSString stringWithFormat:@"%@",[self pinYinFromString:condStata]];
    
    UIImageView *weatherImage = (UIImageView *)[self viewWithTag:103];
    UIImage *image = [self updataWeatherImageIcon:condStata];
    weatherImage.image = image;
    
    UILabel *dateLab = (UILabel *)[self viewWithTag:100];
    if (MNCTomorrowTag == index) {
        dateLab.text = @"明天";
        [self.weatherViewController.simpleLeftView addSubview:self];
    } else {
        dateLab.text = @"后天";
    }
    [self.weatherViewController.simpleRightView addSubview:self];
}
#pragma mark - Private methods
- (void)createUI {
    //    UILabel *dateLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + 10,
    //                                   rect.origin.y + 10,
    //                                   (rect.size.width - 20) / 4,
    //                                   rect.size.height / 4)];
    UILabel *dateLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(10,0,50,50)];
    dateLab.font = [UIFont fontWithName:@"Arial" size:20];
    dateLab.textAlignment = NSTextAlignmentLeft;
    dateLab.tag = 100;
    [self addSubview:dateLab];
    
    //    UILabel *tmpLab = [[UILabel alloc] initWithFrame:
    //                        CGRectMake(rect.origin.x + dateLab.frame.size.width + 10,
    //                                   rect.origin.y + 10  ,
    //                                   (rect.size.width - 20) - 40,
    //                                   rect.size.height / 4)];
    UILabel *tmpLab = [[UILabel alloc] initWithFrame:
                       CGRectMake(dateLab.bounds.size.width,dateLab.bounds.origin.y,150,50)];
    tmpLab.font = [UIFont fontWithName:@"Arial" size:20];
    tmpLab.textAlignment = NSTextAlignmentCenter;
    tmpLab.tag = 101;
    [self addSubview:tmpLab];
    
    UILabel *weatherLab = [[UILabel alloc] initWithFrame:
                           CGRectMake(10, 50 + 10,100,50)];
    weatherLab.font = [UIFont fontWithName:@"Arial" size:20];
    weatherLab.textAlignment = NSTextAlignmentLeft;
    weatherLab.tag = 102;
    [self addSubview:weatherLab];
    
    UIImageView *weatherImagV = [[UIImageView alloc] init];
    weatherImagV.tag = 103;
    weatherImagV.frame = CGRectMake(weatherLab.bounds.size.width + 10 ,
                                    50 + 10,
                                    50,
                                    50);
    [self addSubview:weatherImagV];
}
- (void)updataSubviewsFromShowLineImageView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (NSString *)pinYinFromString:(NSString *)string {
    if ([string isEqualToString:@"Cloudy"]) {//多云
        return @"多云";
    } else if ([string isEqualToString:@"shower rain"]) {//阵雨
        return @"阵雨";
    } else if ([string isEqualToString:@"Overcast"]) { //阴
        return @"阴天";
    } else if ([string isEqualToString:@"Sunny"]) {//晴
        return @"晴天";
    } else if ([string isEqualToString:@"Partly Cloudy"]) {//晴间多云
        return @"晴间多云";
    } else if ([string isEqualToString:@"Thundershower"]) {//雷阵雨
        return @"雷阵雨";
    } else if ([string isEqualToString:@"Light Rain"]) {//小雨
        return @"小雨";
    } else if ([string isEqualToString:@"Heavy Rain"]) { //大雨
        return @"大雨";
    } else if ([string isEqualToString:@"Storm"]) {//暴雨
        return @"暴雨";
    } else if ([string isEqualToString:@"Light Snow"]) {//小雪
        return @"小雪";
    } else if ([string isEqualToString:@"Heavy Snow"]) {//大雪
        return @"大雪";
    } else if ([string isEqualToString:@"Sleet"]) { //雨夹雪
        return @"雨夹雪";
    } else if ([string isEqualToString:@"Sunny/Clear"]) {
        return @"晴天";
    }
    return @"未知";
}

- (UIImage *)updataWeatherImageIcon:(NSString *)condTextDay {
    UIImage *image = nil;
    if ([condTextDay isEqualToString:@"Cloudy"]) {//多云
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([condTextDay isEqualToString:@"shower rain"]) {//阵雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([condTextDay isEqualToString:@"Overcast"]) { //阴
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([condTextDay isEqualToString:@"Sunny"]) {//晴
        image = [UIImage imageNamed:@"sunshine.png"];
    } else if ([condTextDay isEqualToString:@"Partly Cloudy"]) {//晴间多云
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([condTextDay isEqualToString:@"Thundershower"]) {//雷阵雨
        image = [UIImage imageNamed:@"thunder.png"];
    } else if ([condTextDay isEqualToString:@"Light Rain"]) {//小雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([condTextDay isEqualToString:@"Heavy Rain"]) { //大雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([condTextDay isEqualToString:@"Storm"]) {//暴雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([condTextDay isEqualToString:@"Light Snow"]) {//小雪
        image = [UIImage imageNamed:@"snowwing.png"];
    } else if ([condTextDay isEqualToString:@"Heavy Snow"]) {//大雪
        image = [UIImage imageNamed:@"snowwing.png"];
    } else if ([condTextDay isEqualToString:@"Sleet"]) { //雨夹雪
        image = [UIImage imageNamed:@"rainAndSnow.png"];
    } else if ([condTextDay isEqualToString:@"Sunny/Clear"]) {//晴
        image = [UIImage imageNamed:@"sunshine.png"];
    }
    
    return image;
}
#pragma mark setter && getter
- (MNCSimpleWeatherData *)simpleWeatherData {
    if (!_simpleWeatherData) {
        _simpleWeatherData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleWeatherData;
}

- (MNCWeatherViewController *)weatherViewController {
    if (!_weatherViewController) {
        _weatherViewController = [[MNCWeatherViewController alloc] init];
    }
    return  _weatherViewController;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
