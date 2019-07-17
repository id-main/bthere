//
//  SuggestiveTextField.m
//  SuggestiveTextField
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.wordpress.com . All rights reserved.
//

#import "SuggestiveTextField.h"
#define DEFAULT_ROW_HEIGHT 30.0

@interface SuggestiveDelegate : NSObject <UITextFieldDelegate>
@property(weak) SuggestiveTextField *textField;
@end

@implementation SuggestiveDelegate

//////////////////////////////////////////////////
#pragma mark - Handling TextField Delegate
//////////////////////////////////////////////////


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    
    [self.textField matchStrings:text];
    [self.textField showSuggestionTableView];
    
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.textField dismissSuggestionTableView];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

@end



@interface SuggestiveTextField () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *stringsArray;
@property(nonatomic, strong) NSArray *placesIdArray;
@property(nonatomic, strong) NSArray *matchedStrings;
@property(nonatomic, strong) NSArray *matchedPlaceId;
@property(nonatomic, strong) NSArray *placeId;
@property(nonatomic, strong) UITableViewController *controller;
@property(nonatomic, strong) SuggestiveDelegate *midDelegate;

@property CGSize tableViewMaxSize;




@property(nonatomic, strong) UIPopoverController *popOver; // iPad
@end



@implementation SuggestiveTextField

//////////////////////////////////////////////////
#pragma mark - Setup
//////////////////////////////////////////////////





- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}
- (id)init {
    
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.midDelegate = [SuggestiveDelegate new];
    self.midDelegate.textField = self;
    self.delegate = self.midDelegate;
    
    self.matchedStrings = [NSArray array];
    self.controller = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.controller.tableView.delegate = self;
    self.controller.tableView.dataSource = self;
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.tableViewMaxSize = CGSizeMake(self.frame.size.width, 150);
    
//    if (self.isiPad) {
//        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.controller];
//        self.popOver.popoverContentSize = self.tableViewMaxSize;
//
//
//    }

    // Default values
    self.shouldHideOnSelection = YES;
    
    // Table view configs
    self.controller.tableView.backgroundColor = [UIColor whiteColor];
    
    self.controller.tableView.layer.cornerRadius = 0;
    self.controller.tableView.layer.borderWidth = 0;
    self.controller.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.controller.tableView.bounces = YES;
    self.controller.tableView.alwaysBounceVertical = YES;
    self.controller.tableView.showsVerticalScrollIndicator = YES;
    self.controller.tableView.showsHorizontalScrollIndicator = NO;
    self.controller.tableView.rowHeight = DEFAULT_ROW_HEIGHT;
    self.controller.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // Hide the unnecessary separator lines
    self.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"combox"]];
    self.leftViewMode  = UITextFieldViewModeAlways;
    
}

- (void) dismissSuggestionTableView{
//    if (self.isiPad) {
//        [_popOver dismissPopoverAnimated:YES];
//    }
//    else{
        [self.controller.tableView removeFromSuperview];
 //   }
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = CGRectMake(bounds.origin.x + 10, 8, 12, 10);
    return rightBounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 5);
}

//////////////////////////////////////////////////
#pragma mark - Modifiers
//////////////////////////////////////////////////

- (void)setSuggestions:(NSArray *)suggestionStrings {
    self.stringsArray = suggestionStrings;
}

// Set suggestions list of PlacesId.
- (void)setSuggestionsPlacesId:(NSArray *)suggestionPlacesId
{
    self.placesIdArray = suggestionPlacesId;
}

- (void)setPopoverSize:(CGSize)size {
    self.tableViewMaxSize = size;
    self.popOver.popoverContentSize = size;
}

//////////////////////////////////////////////////
#pragma mark - Matching strings and Popover
//////////////////////////////////////////////////

- (CGFloat)tableHeight{
    return [self.matchedStrings count] * DEFAULT_ROW_HEIGHT ;//> self.tableViewMaxSize.height ? self.tableViewMaxSize.height : [self.matchedStrings count] * DEFAULT_ROW_HEIGHT;
}

- (void)updateTableViewFrameHeight
{
//    if (!self.isiPad) {
        CGRect currentFrame = self.controller.tableView.frame;
        currentFrame.size.height = [self tableHeight];
        self.controller.tableView.frame = currentFrame;
//    }
//    else{
     //  [self setPopoverSize:CGSizeMake(self.tableViewMaxSize.width, [self tableHeight])];
   // }
}

- (void)matchStrings:(NSString *)letters
{
    if (_stringsArray.count > 0) {
        
        self.matchedStrings = [_stringsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self contains[cd] %@", letters]];
        self.matchedPlaceId = [_placesIdArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self contains[cd] %@", letters]];
        
        [_controller.tableView reloadData];
        
        [self updateTableViewFrameHeight];
        
    }
}

- (void)showSuggestionTableView {
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"client.jpg"]];
    
    self.controller.tableView.backgroundColor = background;
    
    if (_matchedStrings.count == 0){
        [self dismissSuggestionTableView];
    }
    
//    else if (!_popOver.isPopoverVisible && self.isiPad){
//        NSLog(@"origin frame %f %f %0f %f", self.frame.size.height,  self.frame.size.width, self.frame.origin.x, self.frame.origin.y);
//        [_popOver presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//
//    }
    else if (!self.isTableViewVisible )  //&& !self.isiPad)
    {
        if (!self.referenceView) { // if the reference view is not set, then it has the default window.
            self.referenceView = self.window;
        }
        
        CGPoint origin = [self.referenceView convertPoint:self.frame.origin fromView:self.superview];
        CGRect rect;
        rect.origin = CGPointMake(origin.x, origin.y + self.frame.size.height);
        rect.size = CGSizeMake(self.frame.size.width, [self tableHeight]);
        
        self.controller.tableView.frame = rect;
        [self.referenceView addSubview: self.controller.tableView];
    }
    else
    {
        CGPoint origin = [self.referenceView convertPoint:self.frame.origin fromView:self.superview];
        CGRect rect;
        rect.origin = CGPointMake(origin.x, origin.y + self.frame.size.height);
        rect.size = CGSizeMake(self.frame.size.width, [self tableHeight]);
        self.controller.tableView.frame = rect;
    }
}

- (BOOL)isTableViewVisible{
    return self.controller.tableView.superview != nil;
}

-(BOOL)isiPad{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

//////////////////////////////////////////////////
#pragma mark - TableView Delegate & DataSource
//////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _matchedStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_matchedStrings objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = self.textAlignment;
    
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSansHebrew-Light" size:16]];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexSelect = (int)indexPath.row;
    [self setTextColor:[UIColor blackColor]];
    [self setText:[_matchedStrings objectAtIndex:indexPath.row]];
    
    self.restorationIdentifier = [_placesIdArray objectAtIndex:indexPath.row];
    
    
    if (_shouldHideOnSelection) {
        [self dismissSuggestionTableView];
        [self resignFirstResponder];
        
    }
}

@end
