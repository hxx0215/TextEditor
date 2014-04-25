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
	UIPickerView *_fontPicker;
	NSArray *_fontSizeList;
    NSString *_fontName;
	CGFloat _fontSize;
	CGFloat _textViewContentOffsetY;
	CGFloat _pickerY;
}
@end

@implementation KDTextEditorViewController
@synthesize textView = _textView;

- (id)init {
	self = [super init];
	if (self) {
		_fontSizeList = [[NSArray alloc]initWithObjects:@"8", @"9", @"10", @"11",
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
	CGSize tImgSize = CGSizeMake(20, 20);
	UIImage *tFonts = [self imageScale:[UIImage imageNamed:@"font"] toSize:tImgSize];
	UIBarButtonItem *tBtnFont = [[UIBarButtonItem alloc]
	                                  initWithImage:tFonts
	                                          style:UIBarButtonItemStylePlain
	                                         target:self
	                                         action:@selector(buttonClicked_Font)];
	self.navigationItem.rightBarButtonItem = tBtnFont;
	[tBtnFont release];

	_textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
	_textView.delegate = self;
	[self.view addSubview:_textView];
	_textViewContentOffsetY = INFINITY;

	//NSArray *array = [NSArray arrayWithObjects:@"左对齐", @"居中", @"右对齐", nil];
	UISegmentedControl *tSegment = [[UISegmentedControl alloc]initWithItems:nil];
	UIImage *tAlignLeft = [self imageScale:[UIImage imageNamed:@"paragraph-left.png"]
	                                toSize:tImgSize];
	UIImage *tAlignCenter = [self imageScale:[UIImage imageNamed:@"paragraph-center.png"]
	                                  toSize:tImgSize];
	UIImage *tAlignRight = [self imageScale:[UIImage imageNamed:@"paragraph-right.png"]
	                                 toSize:tImgSize];
	[tSegment insertSegmentWithImage:tAlignLeft atIndex:0 animated:YES];
	[tSegment insertSegmentWithImage:tAlignCenter atIndex:1 animated:YES];
	[tSegment insertSegmentWithImage:tAlignRight atIndex:2 animated:YES];
	tSegment.segmentedControlStyle = UISegmentedControlStyleBar;
	tSegment.frame = CGRectMake(0, 0, 60, 30);
	[tSegment addTarget:self
	              action:@selector(buttonClicked_Segment:)
	    forControlEvents:UIControlEventValueChanged];
	tSegment.selectedSegmentIndex = 0;
	self.navigationItem.titleView = tSegment;
	[tSegment release];

	UIImage *tFontSize = [self imageScale:[UIImage imageNamed:@"fontsize"]
	                               toSize:tImgSize];
	UIBarButtonItem *tBtnFontSize = [[UIBarButtonItem alloc]
	                                   initWithImage:tFontSize
	                                           style:UIBarButtonItemStylePlain
	                                          target:self
	                                          action:@selector(buttonClicked_FontSize)];
	self.navigationItem.leftBarButtonItem = tBtnFontSize;
	[tBtnFontSize release];

	_fontPicker = [[UIPickerView alloc] init];
	_fontPicker.showsSelectionIndicator = YES;
	_fontPicker.delegate = self;
	_fontPicker.dataSource = self;
	_fontPicker.hidden = YES;
    _fontPicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
	[_fontPicker selectRow:4 inComponent:0 animated:YES];
	[_textView addSubview:_fontPicker];
	if ([self isiPhone]) {
		[self addDismissButtontoKeyBoard];
	}
}

- (void)updateCurInterface:(UIInterfaceOrientation)toInterfaceOrientation {
	CGRect tScreen = [UIScreen mainScreen].bounds;
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		CGFloat tExchange = tScreen.size.height;
		tScreen.size.height = tScreen.size.width;
		tScreen.size.width = tExchange;
	}
	CGFloat tFontPickerHeight = 216;
	_pickerY = tScreen.size.height - tFontPickerHeight;
	CGFloat tPickerY = _pickerY + (_textView.contentOffset.y - _textViewContentOffsetY) >
	    100 ? _pickerY + (_textView.contentOffset.y - _textViewContentOffsetY) : _pickerY;
	_fontPicker.frame = CGRectMake(0, tPickerY, tScreen.size.width, tFontPickerHeight);

    _textView.frame = tScreen;
    
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


- (void)addDismissButtontoKeyBoard {
	UIToolbar *tTopView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	[tTopView setBarStyle:UIBarStyleBlack];

	UIBarButtonItem *tBtnSpace =
	    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
	                                                 target:self
	                                                 action:nil];

	UIBarButtonItem *tBtnDone = [[UIBarButtonItem alloc]
	                               initWithTitle:NSLocalizedString(@"DoneKeyboard", nil)
	                                       style:UIBarButtonItemStyleDone
	                                      target:self
	                                      action:@selector(dismissKeyBoard)];

	NSArray *buttonsArray = [NSArray arrayWithObjects:tBtnSpace, tBtnDone, nil];
	[tBtnDone release];
	[tBtnSpace release];

	[tTopView setItems:buttonsArray];
	[_textView setInputAccessoryView:tTopView];
	[tTopView release];
}


- (void)dismissKeyBoard {
	[_textView resignFirstResponder];
}

#pragma mark - ButtonClicked
- (void)buttonClicked_Font {
	KDTableViewController *tTableVC = [[KDTableViewController alloc] init];
	tTableVC.textEditorVCtrlDelegate = self;
    
	tTableVC.fontName = _fontName;
    
    
    
	KDTextEditorNavigationController *tNavController =
    [[KDTextEditorNavigationController alloc] initWithRootViewController:tTableVC];
	[tTableVC release];
    
	tNavController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:tNavController animated:YES completion:nil];
	//[self.navigationController pushViewController:tTableVC animated:YES];
	[tNavController release];
}

- (void)buttonClicked_Segment:(id)sender {
    if (!sender) return ;
	switch ([sender selectedSegmentIndex]) {
		case 0:
		{
			_textView.textAlignment = NSTextAlignmentLeft;
			[_textView resignFirstResponder];
			[_textView becomeFirstResponder];
		}
            break;
            
		case 1:
		{
			_textView.textAlignment = NSTextAlignmentCenter;
			[_textView resignFirstResponder];
			[_textView becomeFirstResponder];
		}
            break;
            
		case 2:
		{
			_textView.textAlignment = NSTextAlignmentRight;
			[_textView resignFirstResponder];
			[_textView becomeFirstResponder];
		}
            break;
            
		default:
			break;
	}
}

- (void)buttonClicked_FontSize {
	[_textView resignFirstResponder];
	_fontPicker.hidden = !_fontPicker.hidden;
}

#pragma mark - KDTextEditorViewControllerDelegate
- (void)textEditorViewControllerDidDismissModalView:(NSString *)font {
    if (font)
    {
        _fontName = font;
        _textView.font = [UIFont fontWithName:font size:_fontSize];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	_fontPicker.hidden = YES;
	return YES;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (INFINITY == _textViewContentOffsetY)
		_textViewContentOffsetY = _textView.contentOffset.y;
	CGRect tFrame = _fontPicker.frame;
	tFrame.origin.y = _pickerY + (_textView.contentOffset.y - _textViewContentOffsetY);
	_fontPicker.frame = tFrame;
}

#pragma mark - Rotate

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

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
	return [_fontSizeList count];
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
	return [_fontSizeList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
	_fontSize = [[_fontSizeList objectAtIndex:row] floatValue];
	_textView.font = [UIFont fontWithName:_fontName size:_fontSize];
}



#pragma mark - other method

- (BOOL)isiPhone {
	return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

- (UIImage *)imageScale:(UIImage *)img toSize:(CGSize)newsize {
	UIGraphicsBeginImageContext(newsize);
	[img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
	UIImage *scaleimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaleimg;
}

- (void)dealloc {
	[_textView release];
	[_fontPicker release];
	[_fontSizeList release];
	[super dealloc];
}

@end
