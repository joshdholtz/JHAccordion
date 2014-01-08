//
//  JHAccordion.m
//  JHAccordion
//
//  Created by Josh Holtz on 1/6/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "JHAccordion.h"

@interface JHAccordion()

@end

@implementation JHAccordion

- (id)init {
    self = self = [super init];
    if (self) {
        self.selectedSections = [NSMutableArray array];
    }
    return self;
}

- (id)initWithTableView:(UITableView *)tableView {
    self = [self init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (void)openSection:(NSInteger)section {
    if (![self isSectionOpened:section]) {
        [self toggleSection:section];
    }
}

- (void)closeSection:(NSInteger)section {
    if ([self isSectionOpened:section]) {
        [self toggleSection:section];
    }
}

- (void)toggleSection:(NSInteger)selectedSection {
    BOOL isPreviouslyOpened = [self isSectionOpened:selectedSection];
    NSArray *previouslyOpenedSections = [_selectedSections copy];

    if (isPreviouslyOpened == NO) {
        if (_allowOnlyOneOpenSection == YES) {
            [_selectedSections removeAllObjects];
        }
        
        [_selectedSections addObject:[NSNumber numberWithInteger:selectedSection]];
    } else {
        [_selectedSections removeObject:[NSNumber numberWithInteger:selectedSection]];
    }
    
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    if ([_delegate respondsToSelector:@selector(accordionClosedSection:)]) {
        if (_allowOnlyOneOpenSection == NO && isPreviouslyOpened == YES) {
            [_delegate accordionClosedSection:selectedSection];
        } else if (_allowOnlyOneOpenSection == YES) {
            for (NSNumber *previouslyOpenedSection in previouslyOpenedSections) {
                [_delegate accordionClosedSection:previouslyOpenedSection.integerValue];
            }
        }
    }
    
    if (isPreviouslyOpened == NO && [_delegate respondsToSelector:@selector(accordionOpenedSection:)]) {
        [_delegate accordionOpenedSection:selectedSection];
    }
}

- (BOOL)isSectionOpened:(NSInteger)section {
    return [_selectedSections containsObject:[NSNumber numberWithInteger:section]];
}

- (void)onClickSection:(UIView*)sender {
    [self toggleSection:sender.tag];
}

@end
