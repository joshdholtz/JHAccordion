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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, assign) id<JHAccordionDelegate> delegate;

- (id)initWithTableView:(UITableView*)tableView;
- (void)onClickSection:(UIView*)sender;

@end

@protocol JHAccordionDelegate <NSObject>

- (void)accordionOpenedSection:(NSInteger)section;
- (void)accordionClosedSection:(NSInteger)section;

@end
