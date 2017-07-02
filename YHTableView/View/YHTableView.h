//
//  YHTableView.h
//  YHTableView
//
//  Created by Alan.Turing on 17/6/15.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTableViewDataSource.h"
#import "YHTableViewDelegate.h"
#import "YHTableViewCell.h"
#import "YHCellNode.h"




#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define CellVerticalSpacing 0


@interface YHTableView : UIView
@property (nonatomic, weak, nullable) id <YHTableViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <YHTableViewDelegate> delegate;
@property (nonatomic, nullable) NSMutableArray<__kindof YHTableViewCell *> *visibleCells;
@property (nonatomic, nullable) NSMutableDictionary<__kindof NSString*,  __kindof YHCellNode *> * reusedCells;
//@property (nonatomic) NSMutableDictionary *reusedCells;


@property (nonatomic, assign, readwrite) NSInteger rowNumInSection;
@property (nonatomic, assign, readwrite) NSInteger secNumInTableView;


@property(nonatomic)         CGPoint                      contentOffset;                  // default CGPointZero
@property(nonatomic)         CGSize                       contentSize;                    // default CGSizeZero
@property(nonatomic)         UIEdgeInsets                 contentInset;                   // default UIEdgeInsetsZero. add additional scroll area around content
@property(nonatomic)         CGFloat                      contentHeight;
@property(nonatomic)         CGFloat                      contentWidth;
@property(nonatomic)         CGPoint                      prevOrigin;
@property(nonatomic)         bool                         firstCreate;
@property(nonatomic)         NSUInteger                   topCell;     //tableview上显示出来的第一个cell
@property(nonatomic)         NSUInteger                   buttomCell;  //tableview上显示出来的最后一个cell
@property(nonatomic, retain, nullable) YHTableViewCell* firstCellInTableView;
@property(nonatomic, retain, nullable) YHTableViewCell* lastCellInTableView;
@property(nonatomic) bool foundFirstCellInTableView;
@property(nonatomic) bool foundLastCellInTableView;

- (nonnull YHTableViewCell*) dequeueReusableCellWithIdentifier:(nonnull NSString*) identifier ;
- (void) enqueueReusableCellWithIdentifier:(nonnull YHCellNode*) node forKey:(nonnull NSString*) identifier;
@end

