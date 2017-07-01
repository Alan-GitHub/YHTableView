//
//  YHTableViewDataSource.h
//  YHTableView
//
//  Created by Alan.Turing on 17/6/17.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YHTableView;
@class YHTableViewCell;
@class YHCellNode;

@protocol YHTableViewDataSource <NSObject>
@required
- (NSInteger)tableView:(YHTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (YHTableViewCell *)tableView:(YHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(YHTableView *)tableView;

@end
