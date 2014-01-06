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
        self.selectedSection = -1;
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

- (void)setSelectedSection:(NSInteger)selectedSection {
    NSInteger previouslyOpenedSection = _selectedSection;
    
    NSInteger section = selectedSection;
    if (_selectedSection == section) section = -1;
    
    _selectedSection = section;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    if (previouslyOpenedSection != -1 && [_delegate respondsToSelector:@selector(accordionClosedSection:)]) {
        [_delegate accordionClosedSection:previouslyOpenedSection];
    }
    if (_selectedSection != -1 && [_delegate respondsToSelector:@selector(accordionOpenedSection:)]) {
        [_delegate accordionOpenedSection:_selectedSection];
    }
}

- (void)onClickSection:(UIView*)sender {
    [self setSelectedSection:sender.tag];
}

@end
