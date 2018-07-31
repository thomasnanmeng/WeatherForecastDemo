//
//  MNCCityViewController.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/17.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCCityViewController.h"
#import "MNCCityNameGroup.h"

//plist中保存的三个Key值
NSString * const kCityNameCKey = @"cityNameC";

@interface MNCCityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MNCCityNameGroup *cityNameGroup;
@property (weak, nonatomic) IBOutlet UITableView *cityTable;

@end

@implementation MNCCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityNameGroup = [[MNCCityNameGroup alloc] init];
    self.cityTable.dataSource = self;
    self.cityTable.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
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
