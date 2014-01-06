//
//  ViewController.m
//  JHAccordion
//
//  Created by Josh Holtz on 1/3/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "JHAccordion.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, JHAccordionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAccordion;

@property (nonatomic, strong) JHAccordion *accordion;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _accordion = [[JHAccordion alloc] initWithTableView:_tblAccordion];
    [_accordion setAllowOnlyOneOpenSection:YES];
    [_accordion setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SomeCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:8675309];
    [label setText:[NSString stringWithFormat:@"Section %d, Row %d", indexPath.section, indexPath.row]];;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), 45.0f)];
    [view setBackgroundColor:[UIColor redColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 80.0f, 30.f)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button.titleLabel setTextColor:[UIColor blackColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [button setTitle:@"A Button" forState:UIControlStateNormal];
    
    // Sets up for JHAccordion
    [button setTag:section];
    [button addTarget:_accordion action:@selector(onClickSection:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ( [_accordion isSectionOpened:indexPath.section] ? 44.0f : 0.0f);
}

#pragma mark - JHAccordionDelegate

- (void)accordionOpenedSection:(NSInteger)section {
    NSLog(@"Opened section - %d", section);
}

- (void)accordionClosedSection:(NSInteger)section {
    NSLog(@"Closed section - %d", section);
}

@end
