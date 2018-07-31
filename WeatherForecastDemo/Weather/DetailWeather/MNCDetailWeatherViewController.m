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
@property (nonatomic, strong) MNCDetailWeatherData *detailWeatherData;
@property (nonatomic, strong) UIImageView *imageView;

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
    UILabel *cityName = [[UILabel alloc] initWithFrame:
                         CGRectMake(rect.origin.x + 100,
                                    rect.origin.y + 30,
                                    (rect.size.width - 200) / 2 + 100,
                                    50)];
    //cityName.backgroundColor = [UIColor blackColor];
    cityName.tag = 100;
    cityName.font = [UIFont fontWithName:@"Arial" size:40];
    cityName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:cityName];
    
    UILabel *weatherTemp = [[UILabel alloc] initWithFrame:
                            CGRectMake(rect.origin.x + 100,
                                       rect.origin.y + 70,
                                       (rect.size.width - 200) / 2 + 100,
                                       rect.size.height / 6)];
    //weatherTemp.backgroundColor = [UIColor redColor];
    weatherTemp.tag = 101;
    weatherTemp.font = [UIFont fontWithName:@"Arial" size:40];
    weatherTemp.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weatherTemp];
    
    UILabel *weatherPropertiseLable = [[UILabel alloc] initWithFrame:
                                       CGRectMake(rect.origin.x,
                                                  rect.origin.y + 30 + weatherTemp.bounds.size.height,
                                                  rect.size.width + 30,
                                                  50)];
    //weatherPropertiseLable.backgroundColor = [UIColor blackColor];
    weatherPropertiseLable.font = [UIFont fontWithName:@"Arial" size:17];
    weatherPropertiseLable.textAlignment = NSTextAlignmentCenter;
    weatherPropertiseLable.tag = 102;
    [self.view addSubview:weatherPropertiseLable];
}

- (void)createUIData {
    NSString *weatherCity = [self.detailWeatherData updataCity];
    NSString *weatherTempMax = [self.detailWeatherData updataTempMax];
    NSString *weatherTempMin = [self.detailWeatherData updataTempMin];
    NSString *weatherHum = [self.detailWeatherData updataHum];
    NSString *weatherState = [self.detailWeatherData updataState];
    NSString *weatherWindForce = [self.detailWeatherData updataWindForce];
    
    UILabel *cityName = (UILabel *)[self.view viewWithTag:100];
    cityName.text = [NSString stringWithFormat:@"%@",[self pinYinToChinese:weatherCity]];
    
    UILabel *weatherTemp = (UILabel *)[self.view viewWithTag:101];
    weatherTemp.text = [NSString stringWithFormat:@"%d℃",(([weatherTempMax intValue] - 32) * 5 / 9)];
    
    UILabel *weatherPropertiseLable = (UILabel *)[self.view viewWithTag:102];
    weatherPropertiseLable.text = [NSString stringWithFormat:@"温度:%d/%d℃  湿度:%@ 风力:%@ %@",
                                   (([weatherTempMax intValue] - 32) * 5 / 9),
                                   (([weatherTempMin intValue] - 32) * 5 / 9),
                                   weatherHum,
                                   weatherWindForce,
                                   weatherState];
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
    self.detailWeatherData = notification.object;
    [_delegate updataDetailWeatherbackgroundImage:[self.detailWeatherData updataState]];
    [self updataDetailUIData];
    NSLog(@"更新Detail数据");
}
- (void)removeNotificationAction {
    //移除指定的通知，不然会造成内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"kMarketPlateUpdataNotification"
                                                  object:nil];
    //移除viewController中所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - setter && getter
- (MNCDetailWeatherData *)detailWeatherData {
    if (!_detailWeatherData) {
        _detailWeatherData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailWeatherData;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

