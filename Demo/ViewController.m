//
//  ViewController.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/15.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "ViewController.h"

#define ID @"CELL"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];

    YHTableView* tableview = [[YHTableView alloc] init];
    tableview.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:tableview];
    
    tableview.dataSource = self;
    tableview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(YHTableView *)tableView
{
//    NSLog(@"numberOfSectionsInTableView %@", tableView);
    return 1;
}

- (NSInteger)tableView:(YHTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"numberOfRowsInSection");
    
    return 20;
}

- (YHTableViewCell *)tableView:(YHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[YHCellNode alloc] init].cell;
    }
    
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (CGFloat)tableView:(YHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 10 + [indexPath row] * 10;
    
    return 50;
}

@end
