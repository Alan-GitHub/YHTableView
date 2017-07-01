//
//  YHTableViewCell.h
//  YHTableView
//
//  Created by Alan.Turing on 17/6/16.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHCellNode;

@interface YHTableViewCell : UIView
@property (nonatomic, assign, readwrite) float cellHeight; //cell高度
@property (nonatomic, assign, readwrite) float cellUpEdge; //cell上边对应的坐标Y轴
@property (nonatomic, assign, readwrite) float cellDownEdge;  //cell下边对应的坐标Y轴
@property (nonatomic, assign, readwrite) NSUInteger cellIndex;  //cell在所有行数中的索引 0 － 总行数减去1
@property(nonatomic, retain) YHCellNode* cellNodePointer;
@end


