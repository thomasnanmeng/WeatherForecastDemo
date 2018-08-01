//
//  MNCDetailWeatherViewController.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCDetailWeatherViewController.h"
#import "MNCDetailWeatherData.h"

@interface MNCDetailWeatherViewController ()
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MNCDetailWeatherViewController

#pragma mark - Lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createUIData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataDetailWeatherUIData:)
                                                 name:@"MNCDetailWeatherDataNotification"
                                               object:nil];
    
    //self.todayWeatherData = [[MNCTodayWeatherData alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)createUI {
    CGRect rect= self.view.bounds;
    UILabel *cityNameLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(rect.origin.x + 100,
                                    rect.origin.y + 30,
                                    (rect.size.width - 200) / 2 + 100,
                                    50)];
    cityNameLabel.tag = 100;
    cityNameLabel.font = [UIFont fontWithName:@"Arial" size:40];
    cityNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:cityNameLabel];
    
    UILabel *temperatureLab = [[UILabel alloc] initWithFrame:
                            CGRectMake(rect.origin.x + 100,
                                       rect.origin.y + 70,
                                       (rect.size.width - 200) / 2 + 100,
                                       rect.size.height / 6)];
    temperatureLab.tag = 101;
    temperatureLab.font = [UIFont fontWithName:@"Arial" size:40];
    temperatureLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:temperatureLab];
    
    UILabel *moreElementLab = [[UILabel alloc] initWithFrame:
                                       CGRectMake(rect.origin.x,
                                                  rect.origin.y + 30 + temperatureLab.bounds.size.height,
                                                  rect.size.width + 30,
                                                  50)];
    moreElementLab.font = [UIFont fontWithName:@"Arial" size:17];
    moreElementLab.textAlignment = NSTextAlignmentCenter;
    moreElementLab.tag = 102;
    [self.view addSubview:moreElementLab];
}

- (void)createUIData {
    NSString *cityname = self.detailWeatherData.cityName;
    NSString *temperatureMax = self.detailWeatherData.temperatureMax;
    NSString *temperatureMin = self.detailWeatherData.temperatureMin;
    NSString *humidity = self.detailWeatherData.humidity;
    NSString *State = self.detailWeatherData.humidity;
    NSString *WindForce = self.detailWeatherData.windForce;
    
    UILabel *cityNameLab = (UILabel *)[self.view viewWithTag:100];
    cityNameLab.text = [NSString stringWithFormat:@"%@",[self pinYinToChinese:cityname]];
    
    UILabel *tempMaxLab = (UILabel *)[self.view viewWithTag:101];
    tempMaxLab.text = [NSString stringWithFormat:@"%d℃",(([temperatureMax intValue] - 32) * 5 / 9)];
    
    UILabel *moreElementLab = (UILabel *)[self.view viewWithTag:102];
    moreElementLab.text = [NSString stringWithFormat:@"温度:%d/%d℃  湿度:%@ 风力:%@ %@",
                                   (([temperatureMax intValue] - 32) * 5 / 9),
                                   (([temperatureMin intValue] - 32) * 5 / 9),
                                   humidity,
                                   WindForce,
                                   State];
}

- (NSString *)pinYinToChinese:(NSString *)pinYin {
    if (!pinYin) {
        return @"未知城市";
    } else if ([pinYin isEqualToString:@"xian"]) {
        return @"西安";
    } else if ([pinYin isEqualToString:@"shenzhen"]) {
        return @"深圳";
    } else if ([pinYin isEqualToString:@"wuhan"]) {
        return @"武汉";
    } else if ([pinYin isEqualToString:@"zhengzhou"]) {
        return @"郑州";
    } else if ([pinYin isEqualToString:@"shanghai"]) {
        return @"上海";
    } else if ([pinYin isEqualToString:@"beijing"]) {
        return @"北京";
    } else if (([pinYin isEqualToString:@"guangzhou"])) {
        return @"广州";
    } else if (([pinYin isEqualToString:@"hangzhou"])) {
        return @"杭州";
    } else {
        return pinYin;
    }
}

#pragma mark - Notification

- (void)updataDetailUIData {
    [self createUIData];
}

- (void)updataDetailWeatherUIData:(NSNotification *)notification {
    self.detailData = notification.object;
    [_delegate updataWeatherbackgroundImage:self.detailData.condTxtDay];
    [self updataDetailUIData];
    NSLog(@"更新Detail数据");
}

- (void)removeNotificationAction {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"kMarketPlateUpdataNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter && getter

- (MNCDetailWeatherData *)detailData {
    if (!_detailData) {
        _detailData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailData;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

