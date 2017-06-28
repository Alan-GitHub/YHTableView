//
//  YHTableViewDelegate.h
//  YHTableView
//
//  Created by Alan.Turing on 17/6/17.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHTableViewDelegate <NSObject>
@optional
// Variable height support

- (CGFloat)tableView:(YHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(YHTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(YHTableView *)tableView heightForFooterInSection:(NSInteger)section;

@end
