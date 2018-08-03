//
//  MNCDetailWeatherViewController.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/23.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCDetailWeatherViewController.h"
#import "MNCDetailWeatherData.h"
#import "MNCDetailWeatherView.h"
#import "MNCHeader.h"
@interface MNCDetailWeatherViewController ()
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@property (strong, nonatomic) MNCDetailWeatherView *detailView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MNCDetailWeatherViewController

#pragma mark - Lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDetailView];
    [self updataDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataDetailDataNotify:)
                                                 name:kMNCDetailDataDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)createDetailView {
    self.detailView = [[MNCDetailWeatherView alloc] init];
    self.detailView.frame = CGRectMake(0, 0, kScreenW, kScreenH / 2.5);
    //self.detailView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.detailView];
}

- (void)updataDetailData {
    NSString *cityName = self.detailData.cityName;
    NSString *temperatureMax = self.detailData.temperatureMax;
    NSString *temperatureMin = self.detailData.temperatureMin;
    NSString *humidity = self.detailData.humidity;
    NSString *state = self.detailData.humidity;
    NSString *windForce = self.detailData.windForce;
    self.detailView.cityNameLabel.text = [NSString stringWithFormat:@"%@",[self pinYinToChinese:cityName]];
    self.detailView.temperatureLabel.text = [NSString stringWithFormat:@"%d℃",(([temperatureMax intValue] - 32) * 5 / 9)];
    self.detailView.moreElementLabel.text = [NSString stringWithFormat:@"温度:%d/%d℃  湿度:%@ 风力:%@ %@",
                                             (([temperatureMax intValue] - 32) * 5 / 9),
                                             (([temperatureMin intValue] - 32) * 5 / 9),
                                             humidity,
                                             windForce,
                                             state];
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

- (void)updataDetailDataNotify:(NSNotification *)notification {
    self.detailData = notification.object;
    [self updataDetailData];
    [_delegate updataWeatherBackgroundImage:self.detailData.conditionDay];
}

- (void)removeNotification {
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

