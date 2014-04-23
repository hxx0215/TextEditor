//
//  KDTextEditorViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-20.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDTextEditorViewController.h"
#import "KDTableViewController.h"
#import "KDTextEditorNavigationController.h"

@interface KDTextEditorViewController ()
{
	NSMutableDictionary *_allOptions;
	UIPickerView *_fontPicker;
	NSArray *_pickerArray;
	CGFloat _fontSize;
	NSString *_fontName;
}
@end

@implementation KDTextEditorViewController
@synthesize textView = _textView;

- (id)init {
	self = [super init];
	if (self) {
		_pickerArray = [[NSArray alloc]initWithObjects:@"8", @"9", @"10", @"11",
		                @"12", @"14", @"16", @"18",
		                @"20", @"22", @"24", @"26",
		                @"28", @"36", @"48", @"72", nil];
		_fontSize = 12;
		_fontName = @"Helvetica";
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"TextEditor";

	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]
	                                  initWithTitle:@"字体"
	                                          style:UIBarButtonItemStylePlain
	                                         target:self
	                                         action:@selector(buttonClicked_Font:)];

	self.navigationItem.rightBarButtonItem = settingButton;
	[settingButton release];

	self.textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
	self.textView.delegate = self;
	[self.view addSubview:self.textView];

	NSArray *array = [NSArray arrayWithObjects:@"左对齐", @"居中", @"右对齐", nil];
	UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:array];
	segmented.segmentedControlStyle = UISegmentedControlSegmentCenter;
	[segmented addTarget:self
	              action:@selector(buttonClicked_Segment:)
	    forControlEvents:UIControlEventValueChanged];
	segmented.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segmented;
    [segmented release];

	UIBarButtonItem *fontSizeButton = [[UIBarButtonItem alloc]
	                                   initWithTitle:@"字体大小"
	                                           style:UIBarButtonItemStylePlain
	                                          target:self
	                                          action:@selector(buttonClicked_FontSize:)];
	self.navigationItem.leftBarButtonItem = fontSizeButton;
	[fontSizeButton release];

	_fontPicker = [[UIPickerView alloc] init];
	_fontPicker.showsSelectionIndicator = YES;
	_fontPicker.delegate = self;
	_fontPicker.dataSource = self;
    _fontPicker.hidden = YES;
	[_fontPicker selectRow:4 inComponent:0 animated:YES];
	[self.textView addSubview:_fontPicker];
	[self addDismissButtontoKeyBoard];
}

- (void)updateCurInterface:(UIInterfaceOrientation)toInterfaceOrientation {
    CGRect tScreen = [UIScreen mainScreen].bounds;
    CGFloat tFontPickerHeight = 216;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        CGFloat exchange = tScreen.size.height;
        tScreen.size.height = tScreen.size.width;
        tScreen.size.width = exchange;
    }
    
    _fontPicker.frame = CGRectMake(0, tScreen.size.height -tFontPickerHeight, tScreen.size.width, tFontPickerHeight);
    
    self.textView.frame = tScreen;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	UIInterfaceOrientation tToInterfaceO = [UIApplication sharedApplication].statusBarOrientation;
	[self updateCurInterface:tToInterfaceO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)buttonClicked_Font:(id)sender {
	KDTableViewController *tTableVC = [[KDTableViewController alloc] init];
	tTableVC.fontNameDelegate = self;

	tTableVC.fontName = _fontName;
    
    tTableVC.modalViewdelegate = self;
    
    KDTextEditorNavigationController *navController = [[KDTextEditorNavigationController alloc] initWithRootViewController:tTableVC];
    [tTableVC release];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
	//[self.navigationController pushViewController:tTableVC animated:YES];
    [navController release];
}

- (void)buttonClicked_Segment:(id)sender {
	switch ([sender selectedSegmentIndex]) {
		case 0:
		{
			self.textView.textAlignment = NSTextAlignmentLeft;
			[self.textView resignFirstResponder];
			[self.textView becomeFirstResponder];
		}
		break;

		case 1:
		{
			self.textView.textAlignment = NSTextAlignmentCenter;
			[self.textView resignFirstResponder];
			[self.textView becomeFirstResponder];
		}
		break;

		case 2:
		{
			self.textView.textAlignment = NSTextAlignmentRight;
			[self.textView resignFirstResponder];
			[self.textView becomeFirstResponder];
		}
		break;

		default:
			break;
	}
}

- (void)buttonClicked_FontSize:(id)sender {
	[self.textView resignFirstResponder];
    _fontPicker.hidden = NO;
}

- (void)addDismissButtontoKeyBoard {
	UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	[topView setBarStyle:UIBarStyleBlack];

	UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];

	NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
	[doneButton release];
	[btnSpace release];

	[topView setItems:buttonsArray];
	[self.textView setInputAccessoryView:topView];
	[topView release];
}

- (void)dismissPicker:(id)sender {
}

- (void)dismissKeyBoard {
	[self.textView resignFirstResponder];
}

#pragma mark - KDTextEditorViewControllerDelegate
- (void)changeTextFont:(NSString *)font {
	_fontName = font;
	self.textView.font = [UIFont fontWithName:font size:_fontSize];
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _fontPicker.hidden = YES;
	return YES;
}

#pragma mark - rotate

- (BOOL)shouldAutorotate {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
	[self updateCurInterface:toInterfaceOrientation];
}

#pragma mark - Picker DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [_pickerArray count];
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [_pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_fontSize = [[_pickerArray objectAtIndex:row] floatValue];
	self.textView.font = [UIFont fontWithName:_fontName size:_fontSize];
}

#pragma mark - Modal View Delegate
- (void)didDismissModalView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
	[_allOptions release];
	[_textView release];
	[super dealloc];
}

@end
