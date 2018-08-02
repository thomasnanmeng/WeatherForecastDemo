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
    [self initWeatherClassWithView];
    [self updataWeatherBackgroundImage:self.detailData.conditionDay];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataSimpleUIData:)  name:@"MNCSimpleWeatherFromWebNotification"
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

- (void)createImageView {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.backgroundImageView.image = nil;
    [self.view addSubview:self.backgroundImageView];
}

- (void)initWeatherClassWithView {
    self.simpleView = [[MNCSimpleWeatherView alloc] init];
    self.propertiesFile = [[MNCWeatherPropertiesFile alloc] init];
    self.message = [MNCWeatherManager sharedInstance];
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
}

- (void)updataSubviewsFromView {
    [self.leftView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
    [self.rightView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
}

#pragma mark - Notification

- (void)updataSimpleUIData:(NSNotification *)notification {
    self.simpleData = notification.object;
    [self.tomorrowView createUIData:self.simpleData];
    [self.afterTomorrowView createUIData:self.simpleData];
    NSLog(@"更新simpli数据");
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
