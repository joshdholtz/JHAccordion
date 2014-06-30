//
//  JHAccordion.m
//  JHAccordion
//
//  Created by Josh Holtz on 1/6/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "JHAccordion.h"

#define kInvalidSection -1

@interface JHAccordion()

@property (nonatomic, strong) NSMutableArray *selectedSections;

@end

@implementation JHAccordion {
    CGSize _lastContentSize;
    NSInteger _lastOpenedSection;
}

#pragma mark - Initializers

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"init");
        self.selectedSections = [@[] mutableCopy];
    }
    return self;
}

- (id)initWithTableView:(UITableView *)tableView {
    self = [self init];
    if (self) {
        self.tableView = tableView;
        _lastContentSize = _tableView.contentSize;
    }
    return self;
}

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - Properities

- (void)setTableView:(UITableView *)tableView {
    if (_tableView && [_tableView isEqual:tableView]) {
        return;
    }
    
    [self willChangeValueForKey:@"tableView"];
    
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:@"contentSize"];
    }
    
    _tableView = tableView;
    
    if (_tableView) {
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior context:NULL];
    }
    
    [self didChangeValueForKey:@"tableView"];
}

- (void)setDelegate:(id<JHAccordionDelegate>)delegate {
    if (_delegate && [_delegate isEqual:delegate]) {
        return;
    }
    
    [self willChangeValueForKey:@"delegate"];

    _delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(accordionShouldAllowOnlyOneOpenSection:)]) {
        self.allowOnlyOneOpenSection = [_delegate accordionShouldAllowOnlyOneOpenSection:self];
    }
    
    [self didChangeValueForKey:@"delegate"];
}

#pragma mark - Public

- (void)openSection:(NSInteger)section {
    if (![self isSectionOpened:section]) {
        [self toggleSection:section];
    }
}

- (void)closeSection:(NSInteger)section {
    _lastOpenedSection = kInvalidSection;
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
    
    // Completion block to run delegates
    void (^completionBlock)(void) = ^void() {
        if ([_delegate respondsToSelector:@selector(accordion:closedSection:)]) {
            if (_allowOnlyOneOpenSection == NO && isPreviouslyOpened == YES) {
                [_delegate accordion:self closedSection:selectedSection];
            } else if (_allowOnlyOneOpenSection == YES) {
                for (NSNumber *previouslyOpenedSection in previouslyOpenedSections) {
                    [_delegate accordion:self closedSection:previouslyOpenedSection.integerValue];
                }
            }
        }
        
        if (isPreviouslyOpened == NO) {
            _lastOpenedSection = selectedSection;
            if ([_delegate respondsToSelector:@selector(accordion:openedSection:)]) {
                [_delegate accordion:self openedSection:selectedSection];
            }
        }
        
        if ([_delegate respondsToSelector:@selector(accordion:didUpdateTableView:)]) {
            [_delegate accordion:self didUpdateTableView:_tableView];
        }
    };
    
    if ([_delegate respondsToSelector:@selector(accordion:willUpdateTableView:)]) {
        [_delegate accordion:self willUpdateTableView:_tableView];
    }
    
    static NSString *lock = @"LOCK";
    @synchronized(lock) {
        // Run table animation in a CATransaction to provide a completion block
        [CATransaction begin];
        [CATransaction setCompletionBlock:completionBlock];
        [_tableView beginUpdates];
        [_tableView endUpdates];
        [CATransaction commit];
    }
    
    // Doing delegates
    if ([_delegate respondsToSelector:@selector(accordion:closingSection:)]) {
        if (_allowOnlyOneOpenSection == NO && isPreviouslyOpened == YES) {
            [_delegate accordion:self closingSection:selectedSection];
        } else if (_allowOnlyOneOpenSection == YES) {
            for (NSNumber *previouslyOpenedSection in previouslyOpenedSections) {
                [_delegate accordion:self closingSection:previouslyOpenedSection.integerValue];
            }
        }
    }
    
    if (isPreviouslyOpened == NO && [_delegate respondsToSelector:@selector(accordion:openingSection:)]) {
        [_delegate accordion:self openingSection:selectedSection];
    }
}

- (BOOL)isSectionOpened:(NSInteger)section {
    return [_selectedSections containsObject:[NSNumber numberWithInteger:section]];
}

- (void)onClickSection:(UIView*)sender {
    [self toggleSection:sender.tag];
}

- (void)slideUpSection:(NSInteger)section inTableView:(UITableView *)tableView {
    if (!tableView) { return; }
    CGRect headerFrame = [tableView rectForHeaderInSection:section];
    CGFloat headerBottom = headerFrame.origin.y + CGRectGetHeight(headerFrame);
    CGFloat topInset = tableView.contentInset.top;
    
    // max content offset is the scrolling limit based on the content height and table height adjusting for bottom inset
    CGFloat maxContentOffset = MAX(0, tableView.contentSize.height - CGRectGetHeight(tableView.frame) + tableView.contentInset.bottom);
    
    // the target offset is a fraction of the height of the table view adjusted for the top inset
    CGFloat targetOffset = (headerBottom - topInset) - (CGRectGetHeight(tableView.frame) * 0.5);
    CGFloat newOffset = MIN(maxContentOffset, targetOffset);
    
    // only scroll up
    if (targetOffset > tableView.contentOffset.y) {
        [tableView setContentOffset:CGPointMake(0.0, newOffset) animated:TRUE];
    }
}

- (void)slideUpLastOpenedSection {
    if (_lastOpenedSection >= 0 && [self isSectionOpened:_lastOpenedSection]) {
        NSInteger numberOfSections = [_tableView numberOfSections];
        if (numberOfSections > 0) {
            NSInteger numberOfRowsInSection = [_tableView numberOfRowsInSection:_lastOpenedSection];
            if (numberOfRowsInSection > 0) {
                [self slideUpSection:_lastOpenedSection inTableView:_tableView];
            }
        }
    }
}

#pragma mark - Private

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (_lastContentSize.width != _tableView.contentSize.width || _lastContentSize.height != _tableView.contentSize.height) {
            _lastContentSize = _tableView.contentSize;
            if ([_delegate respondsToSelector:@selector(accordion:contentSizeChanged:)]) {
                [_delegate accordion:self contentSizeChanged:_lastContentSize];
            }
        }
    }
}

@end
