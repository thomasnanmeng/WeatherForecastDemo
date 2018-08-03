//
//  MNCWeatherViewController.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/17.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCWeatherViewController.h"
#import "MNCCityViewController.h"
#import "MNCWeatherManager.h"
#import "MNCDetailWeatherViewController.h"
#import "MNCDetailWeatherData.h"
#import "MNCSimpleWeatherData.h"
#import "MNCWeatherPropertiesFile.h"
#import "MNCSimpleWeatherView.h"
#import "MNCHeader.h"


@interface MNCWeatherViewController ()<MNCDetailViewControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) MNCWeatherPropertiesFile *propertiesFile;
@property (strong, nonatomic) MNCWeatherManager *message;
@property (strong, nonatomic) MNCCityViewController *cityVC;
@property (strong, nonatomic) MNCDetailWeatherViewController *detailVC;
@property (strong, nonatomic) MNCSimpleWeatherData *simpleData;
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@property (strong, nonatomic) MNCSimpleWeatherView *tomorrowView;
@property (strong, nonatomic) MNCSimpleWeatherView *afterTomorrowView;
@property (weak  , nonatomic) IBOutlet UITextField *cityNameTextField;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;


@end

@implementation MNCWeatherViewController

#pragma mark - Lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityNameTextField.delegate = self;
    [self createImageView];
    [self initWeatherClassWithView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataSimpleData:)
                                                 name:kMNCWeatherPropertiesFileDidChangeNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSLog(@"视图加载完成调用");
//    [self.message useCityNameToRequestWeatherData:self.detailData.cityName];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)updataSimpleData:(MNCSimpleWeatherView *)simpleView withData:(NSDictionary *)weatherData {
    NSString *tmpMax = [weatherData valueForKey:kMNCWeatherPropertiesFileColumnsKeyTemperatureMax];
    NSString *tmpMin = [weatherData valueForKey:kMNCWeatherPropertiesFileColumnsKeyTemperatureMin];
    NSString *state = [weatherData valueForKey:kMNCWeatherPropertiesFileColumnsKeyConditionDay];
    if (1000 == simpleView.tag) {
        simpleView.dateLabel.text = @"明天";
    } else if (2000 == simpleView.tag) {
        simpleView.dateLabel.text = @"后天";
    }
    simpleView.tmpLabel.text = [NSString stringWithFormat:@"%d/%d℃",([tmpMax intValue] - 32) * 5 / 9,
                                ([tmpMin intValue] - 32) * 5 / 9];
    simpleView.stateLabel.text = [NSString stringWithFormat:@"%@",[self getChineseFromWeatherStatesString:state]];
    UIImage *image = [self updataWeatherIcon:state];
    simpleView.iconView.image = image;
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
    } else if ([state isEqualToString:MNCWeatherStateShowerRain]) {
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateOvercast]) {
        icon = [UIImage imageNamed:@"cloud.png"];
    } else if ([state isEqualToString:MNCWeatherStateSunnyClear]) {
        icon = [UIImage imageNamed:@"sunshine.png"];
    } else if ([state isEqualToString:MNCWeatherStatePartlyCloudy]) {
        icon = [UIImage imageNamed:@"cloud.png"];
    } else if ([state isEqualToString:MNCWeatherStateThundershower]) {
        icon = [UIImage imageNamed:@"thunder.png"];
    } else if ([state isEqualToString:MNCWeatherStateLightRain]) {
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateHeavyRain]) {
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateStorm]) {
        icon = [UIImage imageNamed:@"rainning.png"];
    } else if ([state isEqualToString:MNCWeatherStateLightSnow]) {
        icon = [UIImage imageNamed:@"snowwing.png"];
    } else if ([state isEqualToString:MNCWeatherStateHeavySnow]) {
        icon = [UIImage imageNamed:@"snowwing.png"];
    } else if ([state isEqualToString:MNCWeatherStateSleet]) {
        icon = [UIImage imageNamed:@"rainAndSnow.png"];
    } else if ([state isEqualToString:MNCWeatherStateSunnyClear]) {
        icon = [UIImage imageNamed:@"sunshine.png"];
    }
    return icon;
}

- (void)createImageView {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.backgroundImageView.image = nil;
    [self.view addSubview:self.backgroundImageView];
}

- (void)initWeatherClassWithView {
    self.propertiesFile = [MNCWeatherPropertiesFile sharedInstance];
    self.message = [MNCWeatherManager sharedInstance];
    self.cityVC = [[MNCCityViewController alloc] init];
    
    self.detailVC = [[MNCDetailWeatherViewController alloc] init];
    [self addChildViewController:self.detailVC];
    self.detailVC.delegate = self;
    self.detailVC.view.backgroundColor = nil;
    self.detailVC.view.frame = CGRectMake(0, kScreenH * 1 / 4, kScreenW, kScreenH / 2.5);
    [self.view addSubview:self.detailVC.view];
    
    self.tomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.tomorrowView.tag = 1000;
    self.tomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                             kScreenH * 3 / 4,
                                                             kScreenW / 2,
                                                             kScreenH / 4)];
    [self.leftView addSubview:self.tomorrowView];
    [self.view addSubview:self.leftView];
    self.afterTomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.afterTomorrowView.tag = 2000;
    self.afterTomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW / 2,
                                                              kScreenH * 3 / 4,
                                                              kScreenW / 2,
                                                              kScreenH / 4)];
    [self.rightView addSubview:self.afterTomorrowView];
    [self.view addSubview:self.rightView];
}

- (void)updataSubviewsFromView {
    [self.leftView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
    [self.rightView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
}

#pragma mark - Notification

- (void)updataSimpleData:(NSNotification *)notification {
    NSDictionary *tomorrowDict = notification.userInfo[kMNCWeatherClassifyTomorrow] ;
    NSDictionary *afterTomorrowDict = notification.userInfo[kMNCWeatherClassifyAfterTomorrow];
    [self updataSimpleData:self.tomorrowView withData: tomorrowDict];
    [self updataSimpleData:self.afterTomorrowView withData: afterTomorrowDict];
}


#pragma mark - IBAction/ClickActions

- (IBAction)searchButtonWithWeatherAPIDataDidclick:(id)sender {
    if (!self.cityNameTextField.text) {
        return;
    }
    [self.message useCityNameToRequestWeatherData:self.cityNameTextField.text];
}

#pragma mark - protocol

- (void)updataWeatherBackgroundImage:(NSString *)state {
    UIImage *image = nil;
    if ([state isEqualToString:MNCWeatherStateCloudy]) {//多云
        image = [UIImage imageNamed:@"partlyCloudy.jpg"];
    } else if ([state isEqualToString:MNCWeatherStateShowerRain]) {//阵雨
        image = [UIImage imageNamed:@"storm.jpeg"];
    } else if ([state isEqualToString:MNCWeatherStateOvercast]) { //阴
        image = [UIImage imageNamed:@"cloudy.png"];
    } else if ([state isEqualToString:MNCWeatherStateSunnyClear]) {//晴
        image = [UIImage imageNamed:@"sunny.jpg"];
    } else if ([state isEqualToString:MNCWeatherStatePartlyCloudy]) {//晴间多云
        image = [UIImage imageNamed:@"partlyCloudy.jpg"];
    } else if ([state isEqualToString:MNCWeatherStateThundershower]) {//雷阵雨
        image = [UIImage imageNamed:@"bigRain.jpeg"];
    } else if ([state isEqualToString:MNCWeatherStateLightRain]) {//小雨
        image = [UIImage imageNamed:@"rain.jpg"];
    } else if ([state isEqualToString:MNCWeatherStateHeavyRain]) { //大雨
        image = [UIImage imageNamed:@"bigRain.jpeg"];
    } else if ([state isEqualToString:MNCWeatherStateStorm]) {//暴雨
        image = [UIImage imageNamed:@"storm.jpeg"];
    } else if ([state isEqualToString:MNCWeatherStateLightSnow]) {//小雪
        image = [UIImage imageNamed:@"snow.jpg"];
    } else if ([state isEqualToString:MNCWeatherStateHeavySnow]) {//大雪
        image = [UIImage imageNamed:@"heavySnow.jpg"];
    } else if ([state isEqualToString:MNCWeatherStateSleet]) { //雨夹雪
        image = [UIImage imageNamed:@"heavySnow.jpg"];
    }
    image = [UIImage imageNamed:@"heavySnow.jpg"];
    
    self.backgroundImageView.image = image;
}

#pragma mark - UItextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //
}

#pragma mark - setter && getter

- (MNCWeatherPropertiesFile *)propertiesFile {
    if (!_propertiesFile) {
        _propertiesFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    return _propertiesFile;
}

- (MNCWeatherManager *)message {
    if (!_message) {
        _message = [[MNCWeatherManager alloc] init];
    }
    return  _message;
}

- (MNCDetailWeatherViewController *)detailVC {
    if (!_detailVC) {
        _detailVC = [[MNCDetailWeatherViewController alloc] init];
    }
    return _detailVC;
}

- (MNCSimpleWeatherData *)simpleData {
    if (!_simpleData) {
        _simpleData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleData;
}

- (MNCDetailWeatherData *)detailData {
    if (!_detailData) {
        _detailData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailData;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

