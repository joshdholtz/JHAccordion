//
//  JHAccordion.m
//  JHAccordion
//
//  Created by Josh Holtz on 1/6/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "JHAccordion.h"

@interface AsyncOperation : NSOperation

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, copy) void (^block)(AsyncOperation* operation);

- (id)initWithBlock:(void (^)(AsyncOperation* operation))block;
- (void)finish;

@end

@interface JHAccordion()

@property (nonatomic, strong) NSMutableArray *openedSections;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation JHAccordion {
    CGSize _lastContentSize;
    NSInteger _lastOpenedSection;
}

#pragma mark - Initializers

- (id)init {
    self = [super init];
    if (self) {
        _openedSections = [@[] mutableCopy];
        
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
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

#pragma mark - New Public

- (void)openSection:(NSInteger)section {
    // Queue up operation
    AsyncOperation *operation = [[AsyncOperation alloc] initWithBlock:^(AsyncOperation *operation) {
        
    }];
    [_operationQueue addOperation:operation];
    
}

- (void)closeSection:(NSInteger)section {
    // Queue up operation
    AsyncOperation *operation = [[AsyncOperation alloc] initWithBlock:^(AsyncOperation *operation) {
        
    }];
    [_operationQueue addOperation:operation];
}

- (void)openSections:(NSArray *)sections {
    if (_allowOnlyOneOpenSection && sections.count > 1) {
        return;
    }
    
    // Queue up operation
    AsyncOperation *operation = [[AsyncOperation alloc] initWithBlock:^(AsyncOperation *operation) {
        
    }];
    [_operationQueue addOperation:operation];
}

- (void)closeSections:(NSArray *)sections {
    if (_allowOnlyOneOpenSection && sections.count > 1) {
        return;
    }
    
    // Queue up operation
    AsyncOperation *operation = [[AsyncOperation alloc] initWithBlock:^(AsyncOperation *operation) {
        
    }];
    [_operationQueue addOperation:operation];
}

//#pragma mark - Old Public
//
//- (void)openSection:(NSInteger)section {
//    if (![self isSectionOpened:section]) {
//        [self toggleSection:section];
//    }
//}
//
//- (void)closeSection:(NSInteger)section {
//    _lastOpenedSection = NSNotFound;
//    if ([self isSectionOpened:section]) {
//        [self toggleSection:section];
//    }
//}
//
//- (void)toggleSection:(NSInteger)selectedSection {
//    BOOL isPreviouslyOpened = [self isSectionOpened:selectedSection];
//    NSArray *previouslyOpenedSections = [_openedSections copy];
//
//    if (isPreviouslyOpened == NO) {
//        if (_allowOnlyOneOpenSection == YES) {
//            [_openedSections removeAllObjects];
//        }
//        
//        [_openedSections addObject:[NSNumber numberWithInteger:selectedSection]];
//    } else {
//        [_openedSections removeObject:[NSNumber numberWithInteger:selectedSection]];
//    }
//    
//    // Completion block to run delegates
//    void (^completionBlock)(void) = ^void() {
//        if ([_delegate respondsToSelector:@selector(accordion:closedSection:)]) {
//            if (_allowOnlyOneOpenSection == NO && isPreviouslyOpened == YES) {
//                [_delegate accordion:self closedSection:selectedSection];
//            } else if (_allowOnlyOneOpenSection == YES) {
//                for (NSNumber *previouslyOpenedSection in previouslyOpenedSections) {
//                    [_delegate accordion:self closedSection:previouslyOpenedSection.integerValue];
//                }
//            }
//        }
//        
//        if (isPreviouslyOpened == NO) {
//            _lastOpenedSection = selectedSection;
//            if ([_delegate respondsToSelector:@selector(accordion:openedSection:)]) {
//                [_delegate accordion:self openedSection:selectedSection];
//            }
//        }
//        
//        if ([_delegate respondsToSelector:@selector(accordion:didUpdateTableView:)]) {
//            [_delegate accordion:self didUpdateTableView:_tableView];
//        }
//    };
//    
//    if ([_delegate respondsToSelector:@selector(accordion:willUpdateTableView:)]) {
//        [_delegate accordion:self willUpdateTableView:_tableView];
//    }
//    
//    static NSString *lock = @"LOCK";
//    @synchronized(lock) {
//        // Run table animation in a CATransaction to provide a completion block
//        [CATransaction begin];
//        [CATransaction setCompletionBlock:completionBlock];
//        [_tableView beginUpdates];
//        [_tableView endUpdates];
//        [CATransaction commit];
//    }
//    
//    // Doing delegates
//    if ([_delegate respondsToSelector:@selector(accordion:closingSection:)]) {
//        if (_allowOnlyOneOpenSection == NO && isPreviouslyOpened == YES) {
//            [_delegate accordion:self closingSection:selectedSection];
//        } else if (_allowOnlyOneOpenSection == YES) {
//            for (NSNumber *previouslyOpenedSection in previouslyOpenedSections) {
//                [_delegate accordion:self closingSection:previouslyOpenedSection.integerValue];
//            }
//        }
//    }
//    
//    if (isPreviouslyOpened == NO && [_delegate respondsToSelector:@selector(accordion:openingSection:)]) {
//        [_delegate accordion:self openingSection:selectedSection];
//    }
//}
//
//- (BOOL)isSectionOpened:(NSInteger)section {
//    return [_openedSections containsObject:[NSNumber numberWithInteger:section]];
//}
//
//- (void)onClickSection:(UIView*)sender {
//    [self toggleSection:sender.tag];
//}
//
//- (void)slideUpSection:(NSInteger)section inTableView:(UITableView *)tableView {
//    if (!tableView) { return; }
//    CGRect headerFrame = [tableView rectForHeaderInSection:section];
//    CGFloat headerBottom = headerFrame.origin.y + CGRectGetHeight(headerFrame);
//    CGFloat topInset = tableView.contentInset.top;
//    
//    // max content offset is the scrolling limit based on the content height and table height adjusting for bottom inset
//    CGFloat maxContentOffset = MAX(0, tableView.contentSize.height - CGRectGetHeight(tableView.frame) + tableView.contentInset.bottom);
//    
//    // the target offset is a fraction of the height of the table view adjusted for the top inset
//    CGFloat targetOffset = (headerBottom - topInset) - (CGRectGetHeight(tableView.frame) * 0.5);
//    CGFloat newOffset = MIN(maxContentOffset, targetOffset);
//    
//    // only scroll up
//    if (targetOffset > tableView.contentOffset.y) {
//        [tableView setContentOffset:CGPointMake(0.0, newOffset) animated:TRUE];
//    }
//}
//
//- (void)slideUpLastOpenedSection {
//    if (_lastOpenedSection != NSNotFound && [self isSectionOpened:_lastOpenedSection]) {
//        NSInteger numberOfSections = [_tableView numberOfSections];
//        if (numberOfSections > 0) {
//            NSInteger numberOfRowsInSection = [_tableView numberOfRowsInSection:_lastOpenedSection];
//            if (numberOfRowsInSection > 0) {
//                [self slideUpSection:_lastOpenedSection inTableView:_tableView];
//            }
//        }
//    }
//}
//
//- (void)immediatelyResetOpenedSections:(NSArray *)openedSections {
//    _lastOpenedSection = NSNotFound;
//    _openedSections = openedSections.mutableCopy;
//    [_tableView reloadData];
//}

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

#pragma mark - AsyncOperation

@implementation AsyncOperation

- (id)initWithBlock:(void (^)(AsyncOperation* operation))block {
    self = [super init];
    if (self == nil)
        return nil;

    _isExecuting = NO;
    _isFinished = NO;
    _block = block;
    
    return self;
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if (_block) {
        _block(self);
    }

    if (_isFinished) {
        [self finish];
    }
}


- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
