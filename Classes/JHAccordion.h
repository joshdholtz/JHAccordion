//
//  JHAccordion.h
//  JHAccordion
//
//  Created by Josh Holtz on 1/6/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JHAccordionDelegate;

@interface JHAccordion : NSObject

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet id<JHAccordionDelegate> delegate;

@property (nonatomic, assign) BOOL allowOnlyOneOpenSection;

- (id)initWithTableView:(UITableView*)tableView;

- (void)openSection:(NSInteger)section;
- (void)closeSection:(NSInteger)section;
- (void)toggleSection:(NSInteger)section;
- (BOOL)isSectionOpened:(NSInteger)section;
- (void)onClickSection:(UIView*)sender;
- (void)slideUpSection:(NSInteger)section inTableView:(UITableView *)tableView;
- (void)slideUpLastOpenedSection;
- (void)immediatelyResetOpenedSections:(NSArray *)openedSections;

@end

@protocol JHAccordionDelegate <NSObject>

@optional

- (BOOL)accordionShouldAllowOnlyOneOpenSection:(JHAccordion*)accordion;
- (void)accordion:(JHAccordion*)accordion openingSection:(NSInteger)section;
- (void)accordion:(JHAccordion*)accordion closingSection:(NSInteger)section;
- (void)accordion:(JHAccordion*)accordion openedSection:(NSInteger)section;
- (void)accordion:(JHAccordion*)accordion closedSection:(NSInteger)section;
- (void)accordion:(JHAccordion*)accordion contentSizeChanged:(CGSize)contentSize;
- (void)accordion:(JHAccordion*)accordion willUpdateTableView:(UITableView *)tableView;
- (void)accordion:(JHAccordion*)accordion didUpdateTableView:(UITableView *)tableView;

@end
