# JHAccordion

Created helper for managing opend and closed sections in an accodion style table.

## Features

- Handles click event for section header views
- Manages opened and closed sections
- Configure to only allow one section open at a time or multiple
- Optional delegate to listen when sections open and close (so you can do cool animation thingies)

## Installation

### Drop-in Classes
Clone the repository and drop in the .h and .m files from the "Classes" directory into your project.

### CocoaPods

JSONAPI is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod 'JHAccordion', :git => 'git@github.com:joshdholtz/JHAccordion.git'

## Examples

To see full example click here: [ViewController.m](https://github.com/joshdholtz/JHAccordion/blob/master/JHAccordion/JHAccordion/ViewController.m)

### Open/Close/Toggle

````objc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initializes JHAccodion with table and sets delegate
    _accordion = [[JHAccordion alloc] initWithTableView:_tblAccordion];
    [_accordion setAllowOnlyOneOpenSection:YES];
    [_accordion setDelegate:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Just setting up the section header view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), 45.0f)];
    [view setBackgroundColor:[UIColor redColor]];
    
    // Just setting up the button to open/close a section
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 80.0f, 30.f)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button.titleLabel setTextColor:[UIColor blackColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [button setTitle:@"A Button" forState:UIControlStateNormal];
    [view addSubview:button];
    
    // Tells the button to send action to JHAccordion to handle opening/closing of sections of table
    // Note: the tag of the button must be set to the section number
    [button setTag:section];
    [button addTarget:_accordion action:@selector(onClickSection:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // This sets all rows in the closed sections to a height of 0 (so they won't be shown)
    // and the opened section to a height of 44.0
    return ( [_accordion isSectionOpened:indexPath.section] ? 44.0f : 0.0f);
}

#pragma mark - JHAccordionDelegate

- (void)accordionOpenedSection:(NSInteger)section {
    NSLog(@"Opened section - %d", section);
}

- (void)accordionClosedSection:(NSInteger)section {
    NSLog(@"Closed section - %d", section);
}

````

## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)
## License

JHAccordion is available under the MIT license. See the LICENSE file for more info.

