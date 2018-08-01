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
    NSString *stata = simpleData.condTxtDay;
    
    UILabel *tempLab = (UILabel *)[self viewWithTag:101];
    tempLab.text = [NSString stringWithFormat:@"%d/%d℃",([tmpMax intValue] - 32) * 5 / 9,
                   ([tmpMin intValue] - 32) * 5 / 9];
    
    UILabel *stataLab = (UILabel *)[self viewWithTag:102];
    stataLab.text = [NSString stringWithFormat:@"%@",[self chineseFromString:stata]];
    
    UIImageView *ImageIcon = (UIImageView *)[self viewWithTag:103];
    UIImage *image = [self updataWeatherImageIcon:stata];
    ImageIcon.image = image;
    
    UILabel *dateLab = (UILabel *)[self viewWithTag:100];
        dateLab.text = @"明天";
        dateLab.text = @"后天";
}

- (NSString *)updataWeatherStata:(MNCSimpleWeatherData *)simpleData {
    return simpleData.condTxtDay;
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
    
    UILabel *stataLab = [[UILabel alloc] initWithFrame:
                           CGRectMake(10, 50 + 10,100,50)];
    stataLab.font = [UIFont fontWithName:@"Arial" size:20];
    stataLab.textAlignment = NSTextAlignmentLeft;
    stataLab.tag = 102;
    [self addSubview:stataLab];
    
    UIImageView *ImagViewIcon = [[UIImageView alloc] init];
    ImagViewIcon.tag = 103;
    ImagViewIcon.frame = CGRectMake(stataLab.bounds.size.width + 10 ,
                                    50 + 10,
                                    50,
                                    50);
    [self addSubview:ImagViewIcon];
}

- (void)updataSubviewsFromShowLineImageView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (NSString *)chineseFromString:(NSString *)string {
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

- (UIImage *)updataWeatherImageIcon:(NSString *)stata {
    UIImage *image = nil;
    if ([stata isEqualToString:@"Cloudy"]) {//多云
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([stata isEqualToString:@"shower rain"]) {//阵雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([stata isEqualToString:@"Overcast"]) { //阴
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([stata isEqualToString:@"Sunny"]) {//晴
        image = [UIImage imageNamed:@"sunshine.png"];
    } else if ([stata isEqualToString:@"Partly Cloudy"]) {//晴间多云
        image = [UIImage imageNamed:@"cloud.png"];
    } else if ([stata isEqualToString:@"Thundershower"]) {//雷阵雨
        image = [UIImage imageNamed:@"thunder.png"];
    } else if ([stata isEqualToString:@"Light Rain"]) {//小雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([stata isEqualToString:@"Heavy Rain"]) { //大雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([stata isEqualToString:@"Storm"]) {//暴雨
        image = [UIImage imageNamed:@"rainning.png"];
    } else if ([stata isEqualToString:@"Light Snow"]) {//小雪
        image = [UIImage imageNamed:@"snowwing.png"];
    } else if ([stata isEqualToString:@"Heavy Snow"]) {//大雪
        image = [UIImage imageNamed:@"snowwing.png"];
    } else if ([stata isEqualToString:@"Sleet"]) { //雨夹雪
        image = [UIImage imageNamed:@"rainAndSnow.png"];
    } else if ([stata isEqualToString:@"Sunny/Clear"]) {//晴
        image = [UIImage imageNamed:@"sunshine.png"];
    }
    
    return image;
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
