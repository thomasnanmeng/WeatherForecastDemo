//
//  MNCWeatherViewController.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/17.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCWeatherViewController.h"
#import "MNCDetailWeatherViewController.h"
#import "MNCCityViewController.h"
#import "MNCWeatherManager.h"
#import "MNCDetailWeatherData.h"
#import "MNCSimpleWeatherData.h"
#import "MNCWeatherPropertiesFile.h"
#import "MNCSimpleWeatherView.h"


@interface MNCWeatherViewController ()<MNCDetailViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MNCWeatherPropertiesFile *weatherPropertiesFile;
@property (nonatomic, strong) MNCWeatherManager *weatherMessage;
@property (nonatomic, strong) MNCCityViewController *cityViewController;
@property (nonatomic, strong) MNCDetailWeatherViewController *detailWeatherViewController;
@property (nonatomic, strong) MNCDetailWeatherData *detailWeatherData;
@property (nonatomic, strong) MNCSimpleWeatherData *simpleWeatherData;
@property (nonatomic, strong) MNCSimpleWeatherView *simpleWeatherView;
@property (nonatomic, strong) MNCSimpleWeatherView *tomorrowView;
@property (nonatomic, strong) MNCSimpleWeatherView *afterTomorrowView;
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextFIeld;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation MNCWeatherViewController

#pragma mark - Lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityNameTextFIeld.delegate = self;
    [self initImageView];
    [self initWeatherClass];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataSimpleUiData:) name:@"MNCSimpleWeatherFromWebNotification"
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"视图加载完成调用");
    [self.weatherMessage useCityNameToRequestWeatherData:[self.detailWeatherData updataCity]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)initImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:self.imageView];
}

- (void)initWeatherClass {
    self.simpleWeatherView = [[MNCSimpleWeatherView alloc] init];
    self.weatherPropertiesFile = [[MNCWeatherPropertiesFile alloc] init];
    self.weatherMessage = [MNCWeatherManager sharedInstance];
    self.cityViewController = [[MNCCityViewController alloc] init];
    
    self.detailWeatherViewController = [[MNCDetailWeatherViewController alloc] init];
    [self addChildViewController:self.detailWeatherViewController];
    self.detailWeatherViewController.delegate = self;
    self.detailWeatherViewController.view.frame = CGRectMake(self.view.bounds.origin.x,
                                                             kScreenH / 3,
                                                             kScreenW,
                                                             kScreenH / 3);
    self.detailWeatherViewController.view.backgroundColor = nil;
    [self.view addSubview:self.detailWeatherViewController.view];
    
    self.tomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.tomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.simpleLeftView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                   kScreenH * 3 / 4,
                                                                   kScreenW / 2,
                                                                   kScreenH / 4)];
    [self.tomorrowView createUIData:MNCTomorrowTag];
    [self.simpleLeftView addSubview:self.tomorrowView];
    [self.view addSubview:self.simpleLeftView];
    
    self.afterTomorrowView = [[MNCSimpleWeatherView alloc] init];
    self.afterTomorrowView.frame = CGRectMake(0, 0, 200, 120);
    self.simpleRightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW / 2,
                                                                    kScreenH * 3 / 4,
                                                                    kScreenW / 2,
                                                                    kScreenH / 4)];
    [self.afterTomorrowView createUIData:MNCAfterTomorrowTag];
    [self.simpleRightView addSubview:self.afterTomorrowView];
    [self.view addSubview:self.simpleRightView];
    
    [self updataDetailWeatherbackgroundImage:[self.detailWeatherData updataState]];
}

- (void)updataSubviewsFromShowLineImageView {
    [self.simpleRightView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
    [self.simpleLeftView.subviews makeObjectsPerformSelector:
     @selector(removeFromSuperview)];
}

#pragma mark - Notification
- (void)updataSimpleUiData:(NSNotification *)notification {
    self.simpleWeatherData = notification.object;
    [self.tomorrowView createUIData:MNCTomorrowTag];
    [self.afterTomorrowView createUIData:MNCAfterTomorrowTag];
    NSLog(@"更新simpli数据");
}

#pragma mark - IBAction/ClickActions
- (IBAction)selectWeatherFromCityAction:(id)sender {
    if (!self.cityNameTextFIeld.text) {
        return;
    }
    [self.weatherMessage useCityNameToRequestWeatherData:self.cityNameTextFIeld.text];
}

#pragma mark - protocol
- (void)updataDetailWeatherbackgroundImage:(NSString *)stata {
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
    self.imageView.image = image;
}

#pragma mark - UItextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //
}
#pragma mark - setter && getter
- (MNCWeatherPropertiesFile *)weatherPropertiesFile {
    if (!_weatherPropertiesFile) {
        _weatherPropertiesFile = [[MNCWeatherPropertiesFile alloc] init];
    }
    return _weatherPropertiesFile;
}

- (MNCWeatherManager *)weatherMessage {
    if (!_weatherMessage) {
        _weatherMessage = [[MNCWeatherManager alloc] init];
    }
    return  _weatherMessage;
}

- (MNCDetailWeatherViewController *)detailWeatherViewController {
    if (!_detailWeatherViewController) {
        _detailWeatherViewController = [[MNCDetailWeatherViewController alloc] init];
    }
    return _detailWeatherViewController;
}

- (MNCDetailWeatherData *)detailWeatherData {
    if (!_detailWeatherData) {
        _detailWeatherData = [[MNCDetailWeatherData alloc] init];
    }
    return _detailWeatherData;
}

- (MNCSimpleWeatherData *)simpleWeatherData {
    if (!_simpleWeatherData) {
        _simpleWeatherData = [[MNCSimpleWeatherData alloc] init];
    }
    return _simpleWeatherData;
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
