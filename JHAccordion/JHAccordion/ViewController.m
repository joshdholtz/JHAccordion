//
//  ViewController.m
//  JHAccordion
//
//  Created by Josh Holtz on 1/3/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "JHAccordion.h"

#define kNumberOfSections 5
#define kNumberOfRows 5

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, JHAccordionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAccordion;

@property (nonatomic, strong) JHAccordion *accordion;

@end

@implementation ViewController {
    BOOL _disableSlidingUp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _accordion = [[JHAccordion alloc] initWithTableView:_tblAccordion];
    [_accordion setAllowOnlyOneOpenSection:YES];
    [_accordion setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_accordion immediatelyResetOpenedSections:@[]];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

- (IBAction)oneButtonTapped:(id)sender {
    _disableSlidingUp = TRUE;
    
    // open all sections
    NSMutableArray *sections = @[].mutableCopy;
    for (NSUInteger i=0; i<kNumberOfSections; i++) {
        [sections addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    [_accordion openSections:sections];
}

- (IBAction)twoButtonTapped:(id)sender {
    _disableSlidingUp = TRUE;
    
    // open odd sections
    NSMutableArray *sections = @[].mutableCopy;
    for (NSUInteger i=0; i<kNumberOfSections; i++) {
        if (i % 2 == 1) {
            [sections addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    }
    [_accordion openSections:sections];
}

- (IBAction)threeButtonTapped:(id)sender {
    _disableSlidingUp = TRUE;
    
    // close all sections
    NSMutableArray *sections = @[].mutableCopy;
    for (NSUInteger i=0; i<kNumberOfSections; i++) {
        [sections addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    [_accordion closeSections:sections];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SomeCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:8675309];
    label.text = [NSString stringWithFormat:@"Section %ld, Row %ld", (long)indexPath.section+1, (long)indexPath.row+1];
    
    cell.clipsToBounds = TRUE;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_accordion openSection:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionHeader"];
    UIView *view = vc.view;
    
    UILabel *label = (UILabel *)[view viewWithTag:1];
    UIButton *button = (UIButton *)[view viewWithTag:2];
    
    label.text = [NSString stringWithFormat:@"Section %lu", section+1];
    
    // Sets up for JHAccordion
    [button setTag:section];
    [button addTarget:_accordion action:@selector(onClickSection:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_accordion isSectionOpened:indexPath.section] ? 44.0f : 0.0f;
}

#pragma mark - JHAccordionDelegate

- (BOOL)accordionShouldAllowOnlyOneOpenSection:(JHAccordion*)accordion {
    return NO;
}

- (void)accordion:(JHAccordion*)accordion contentSizeChanged:(CGSize)contentSize {
    if (!_disableSlidingUp) {
        [_accordion slideUpLastOpenedSection];
    }
    else {
        _disableSlidingUp = FALSE;
    }
}

- (void)accordion:(JHAccordion *)accordion willUpdateTableView:(UITableView *)tableView {
    NSLog(@"Will update table view");
}

- (void)accordion:(JHAccordion *)accordion didUpdateTableView:(UITableView *)tableView {
    NSLog(@"Did update table view");
}

- (void)accordion:(JHAccordion*)accordion openingSection:(NSInteger)section {
    NSLog(@"Opening section - %ld", (long)section);
}

- (void)accordion:(JHAccordion*)accordion closingSection:(NSInteger)section {
    NSLog(@"Closing section - %ld", (long)section);
}

- (void)accordion:(JHAccordion*)accordion openedSection:(NSInteger)section {
    NSLog(@"Opened section - %ld", (long)section);
}

- (void)accordion:(JHAccordion*)accordion closedSection:(NSInteger)section {
    NSLog(@"Closed section - %ld", (long)section);
}

@end
