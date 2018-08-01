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

static NSString * const  MNCSimpleWeatherFromWebNotification = @"cityNameC";

@interface MNCWeatherViewController ()<MNCDetailViewControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) MNCWeatherPropertiesFile *propertiesFile;
@property (strong, nonatomic) MNCWeatherManager *Message;
@property (strong, nonatomic) MNCCityViewController *cityVC;
@property (strong, nonatomic) MNCDetailWeatherViewController *detailVC;
@property (strong, nonatomic) MNCDetailWeatherData *detailData;
@property (strong, nonatomic) MNCSimpleWeatherData *simpleData;
@property (strong, nonatomic) MNCSimpleWeatherView *simpleView;
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
    [self initWeatherClass];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataSimpleUiData:)  name:@"MNCSimpleWeatherFromWebNotification"
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"视图加载完成调用");
    [self.Message useCityNameToRequestWeatherData:self.detailData.cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)createImageView {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:self.backgroundImageView];
}

- (void)initWeatherClass {
    self.simpleView = [[MNCSimpleWeatherView alloc] init];
    self.propertiesFile = [[MNCWeatherPropertiesFile alloc] init];
    self.Message = [MNCWeatherManager sharedInstance];
    self.cityVC = [[MNCCityViewController alloc] init];
    
    self.detailVC = [[MNCDetailWeatherViewController alloc] init];
    [self addChildViewController:self.detailVC];
    self.detailVC.delegate = self;
    self.detailVC.view.frame = CGRectMake(self.view.bounds.origin.x,
                                                             kScreenH / 3,
                                                             kScreenW,
                                                             kScreenH / 3);
    self.detailVC.view.backgroundColor = nil;
    [self.view addSubview:self.detailVC.view];
    
    self.tomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.tomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                            kScreenH * 3 / 4,
                                                            kScreenW / 2,
                                                            kScreenH / 4)];
    [self.tomorrowView createUIData:self.simpleData];
    [self.leftView addSubview:self.tomorrowView];
    [self.view addSubview:self.leftView];
    
    self.afterTomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.afterTomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW / 2,
                                                            kScreenH * 3 / 4,
                                                            kScreenW / 2,
                                                            kScreenH / 4)];
    [self.afterTomorrowView createUIData:self.simpleData];
    [self.rightView addSubview:self.afterTomorrowView];
    [self.view addSubview:self.rightView];
    
    [self updataWeatherbackgroundImage:self.detailData.condTxtDay];
}

- (void)updataSubviewsFromShowLineImageView {
    [self.leftView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
    [self.rightView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
}

#pragma mark - Notification

- (void)updataSimpleUiData:(NSNotification *)notification {
    self.simpleData = notification.object;
    [self.tomorrowView createUIData:self.simpleData];
    [self.afterTomorrowView createUIData:self.simpleData];
    NSLog(@"更新simpli数据");
}

#pragma mark - IBAction/ClickActions

- (IBAction)selectWeatherFromCityAction:(id)sender {
    if (!self.cityNameTextField.text) {
        return;
    }
    [self.Message useCityNameToRequestWeatherData:self.cityNameTextField.text];
}

#pragma mark - protocol

- (void)updataWeatherbackgroundImage:(NSString *)stata {
    UIImage *image = nil;
    if ([stata isEqualToString:@"Cloudy"]) {//多云
        image = [UIImage imageNamed:@"partlyCloudy.jpg"];
    } else if ([stata isEqualToString:@"shower rain"]) {//阵雨
        image = [UIImage imageNamed:@"storm.jpeg"];
    } else if ([stata isEqualToString:@"Overcast"]) { //阴
        image = [UIImage imageNamed:@"cloudy.png"];
    } else if ([stata isEqualToString:@"Sunny/Clear"]) {//晴
        image = [UIImage imageNamed:@"sunny.jpg"];
    } else if ([stata isEqualToString:@"Partly Cloudy"]) {//晴间多云
        image = [UIImage imageNamed:@"partlyCloudy.jpg"];
    } else if ([stata isEqualToString:@"Thundershower"]) {//雷阵雨
        image = [UIImage imageNamed:@"bigRain.jpeg"];
    } else if ([stata isEqualToString:@"Light Rain"]) {//小雨
        image = [UIImage imageNamed:@"rain.jpg"];
    } else if ([stata isEqualToString:@"Heavy Rain"]) { //大雨
        image = [UIImage imageNamed:@"bigRain.jpeg"];
    } else if ([stata isEqualToString:@"Storm"]) {//暴雨
        image = [UIImage imageNamed:@"storm.jpeg"];
    } else if ([stata isEqualToString:@"Light Snow"]) {//小雪
        image = [UIImage imageNamed:@"snow.jpg"];
    } else if ([stata isEqualToString:@"Heavy Snow"]) {//大雪
        image = [UIImage imageNamed:@"heavySnow.jpg"];
    } else if ([stata isEqualToString:@"Sleet"]) { //雨夹雪
        image = [UIImage imageNamed:@"heavySnow.jpg"];
    }
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

- (MNCWeatherManager *)Message {
    if (!_Message) {
        _Message = [[MNCWeatherManager alloc] init];
    }
    return  _Message;
}

- (MNCDetailWeatherViewController *)detailVC {
    if (!_detailVC) {
        _detailVC = [[MNCDetailWeatherViewController alloc] init];
    }
    return _detailVC;
}

- (MNCDetailWeatherData *)detailData {
    if (!_detailData) {
        _detailData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailData;
}

- (MNCSimpleWeatherData *)simpleData {
    if (!_simpleData) {
        _simpleData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleData;
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
