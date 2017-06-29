//
//  YHTableView.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/15.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "YHTableView.h"

#define sectionIndex 0
#define ID @"CELL"

@implementation YHTableView

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor redColor];
        self.secNumInTableView = 1;
        self.contentWidth = ScreenWidth;
        self.contentHeight = 0;
        self.firstCreate = true;
        self.topCell = 0;
        self.buttomCell = 0;
        self.visibleCells = [NSMutableArray array];
        self.reusedCells = [NSMutableDictionary dictionary];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] init];
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    
    return self;
}

- (void) handlePanGesture:(UIPanGestureRecognizer*) panGesture
{
    NSLog(@"handlePanGesture");
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        self.prevOrigin = self.bounds.origin;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGesture translationInView:self];
        
        CGFloat newOriginX = self.prevOrigin.x;
        CGFloat newOriginY = self.prevOrigin.y - point.y;
        
        
        [UIView animateWithDuration:0.75 animations:^{
            CGRect rect = self.bounds;
            rect.origin = CGPointMake(newOriginX, newOriginY);
            self.bounds = rect;
        }];
        
//        [panGesture setTranslation:CGPointZero inView:self];
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [panGesture translationInView:self];
        
        CGFloat newOriginX = self.prevOrigin.x;
        CGFloat newOriginY = self.prevOrigin.y - point.y;
        
        if (newOriginY < 0 || self.contentHeight < ScreenHeight) {
            newOriginY = 0;
        } else if (newOriginY > (self.contentHeight - ScreenHeight)) {   //up drag and contentHeight > screenHeight
            newOriginY = self.contentHeight - ScreenHeight;
        }
  
        [UIView animateWithDuration:0.75 animations:^{
            CGRect rect = self.bounds;
            rect.origin = CGPointMake(newOriginX, newOriginY);
            self.bounds = rect;
        }];
    }
    
    NSLog(@"handlePanGesture %zd", (NSUInteger)self.bounds.origin.y);
}

- (void) dynAddRemoveCell:(CGFloat) originY
{
    NSLog(@"dynAddRemoveCell");
    YHCellNode* firstNodeTableView = nil;
    YHCellNode* lastNodeInTableView = nil;
    YHCellNode* iterater = [self.reusedCells valueForKey:ID];
    
    for (NSUInteger i = 0; i < self.visibleCells.count; i++) {
        if (firstNodeTableView != nil && lastNodeInTableView != nil)
            break;
        
        if (self.topCell == self.visibleCells[i].cell.cellIndex) {
            firstNodeTableView = self.visibleCells[i];
        }
        
        if (self.buttomCell == self.visibleCells[i].cell.cellIndex) {
            lastNodeInTableView = self.visibleCells[i];
        }
    }
    
    if (originY > firstNodeTableView.cell.cellDownEdge) {
        self.topCell = firstNodeTableView.cell.cellIndex + 1;
        [firstNodeTableView.cell removeFromSuperview];
        
        [self.reusedCells setValue:firstNodeTableView forKey:ID];
        firstNodeTableView.pointer = iterater;
        
        [self.visibleCells removeObject:firstNodeTableView];
    }
    
    else if(originY < firstNodeTableView.cell.cellUpEdge && originY > 0)
    {
        
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.topCell - 1) inSection:sectionIndex];
        
        YHCellNode* node = nil;
        if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            node = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        }
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = self.topCell - 1;
        node.cell.cellDownEdge = firstNodeTableView.cell.cellUpEdge;
        node.cell.cellUpEdge = node.cell.cellDownEdge - node.cell.cellHeight;
        self.topCell = node.cell.cellIndex;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node.cell];
        
        [self.reusedCells setValue:node.pointer forKey:ID];
        
        [self.visibleCells addObject:node];
    }
    
    YHCellNode* iterater1 = [self.reusedCells valueForKey:ID];
    
    if (originY + ScreenHeight < lastNodeInTableView.cell.cellUpEdge) {
        self.buttomCell = lastNodeInTableView.cell.cellIndex - 1;
        [lastNodeInTableView.cell removeFromSuperview];
        
        [self.reusedCells setValue:lastNodeInTableView forKey:ID];
        lastNodeInTableView.pointer = iterater1;
        
        [self.visibleCells removeObject:lastNodeInTableView];
    }
    else if(originY + ScreenHeight > lastNodeInTableView.cell.cellDownEdge && lastNodeInTableView.cell.cellIndex < self.rowNumInSection)
    {
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.buttomCell + 1) inSection:sectionIndex];
        
        YHCellNode* node = nil;
        if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            node = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        }
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = self.buttomCell + 1;
        node.cell.cellUpEdge = lastNodeInTableView.cell.cellDownEdge;
        node.cell.cellDownEdge = node.cell.cellUpEdge + node.cell.cellHeight;
        self.buttomCell = node.cell.cellIndex;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node];
        
        [self.visibleCells addObject:node];
        [self.reusedCells setValue:node.pointer forKey:ID];
    }
}

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews*****");
    [super layoutSubviews];
    
    if(self.dataSource)
       [self executeDataSourceMethod];
    
    if(self.delegate)
       [self executeDelegateMethod];

    if (self.firstCreate) {
        self.firstCreate = false;
        [self createCell];
    }
    
//    NSLog(@"layoutSubviews %zd", (NSUInteger)self.bounds.origin.y);
    
    [self dynAddRemoveCell:self.bounds.origin.y];
    
}

- (void) executeDataSourceMethod
{
    self.secNumInTableView = [self.dataSource numberOfSectionsInTableView:self];  //default is 1
    self.rowNumInSection = [self.dataSource tableView:self numberOfRowsInSection:sectionIndex];
}

- (void) executeDelegateMethod
{    
    
}

- (void) createCell
{
    //NSInteger needCreateRowNum;
//    CGFloat visibleTableHeightCurrent = 0;  //it's Y value is cell bottom.
    
    NSInteger i = 0;
        
    for (; (i < self.rowNumInSection) && (self.contentHeight < ScreenHeight); i++) { //row number in section
//    for (; i < self.rowNumInSection; i++) {
    
        YHCellNode* node = [[YHCellNode alloc] init];
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = i;
        node.cell.cellUpEdge = self.contentHeight;
        node.cell.cellDownEdge = node.cell.cellUpEdge + node.cell.cellHeight;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node.cell];
        
        [self.visibleCells addObject:node];
    
        self.contentHeight += node.cell.cellHeight;
    }
    
    self.buttomCell = i - 1;
    
}

@end
