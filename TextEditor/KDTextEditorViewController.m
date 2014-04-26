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
    CGRect _originalContentViewFrame;
    CGFloat _originalContentOffsetY;
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
	UIImage *tImgFonts = [self imageScale:[UIImage imageNamed:@"font"] toSize:tImgSize];
	UIBarButtonItem *tBtnFontList = [[UIBarButtonItem alloc]
	                                  initWithImage:tImgFonts
	                                          style:UIBarButtonItemStylePlain
	                                         target:self
	                                         action:@selector(buttonClicked_Font)];
	self.navigationItem.rightBarButtonItem = tBtnFontList;
	[tBtnFontList release];
    
    UIImage *tImgFontSize = [self imageScale:[UIImage imageNamed:@"fontsize"]
                                      toSize:tImgSize];
	UIBarButtonItem *tBtnFontSize = [[UIBarButtonItem alloc]
                                     initWithImage:tImgFontSize
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(buttonClicked_FontSize)];
	self.navigationItem.leftBarButtonItem = tBtnFontSize;
	[tBtnFontSize release];

	_textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
	_textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsZero;
	[self.view addSubview:_textView];
	_textViewContentOffsetY = INFINITY;

    [self segmentedInit];
    
    [self fontPickerInit];
    
    [self registerForKeyboardNotifications];
    
	if ([self isiPhone]) {
		[self addDismissButtontoKeyBoard];
	}
}

- (void)segmentedInit{
    CGSize tImgSize = CGSizeMake(20, 20);
    UISegmentedControl *tSegment = [[UISegmentedControl alloc]initWithItems:nil];
	UIImage *tImgAlignLeft = [self imageScale:[UIImage imageNamed:@"paragraph-left.png"]
                                       toSize:tImgSize];
	UIImage *tImgAlignCenter = [self imageScale:[UIImage imageNamed:@"paragraph-center.png"]
                                         toSize:tImgSize];
	UIImage *tImgAlignRight = [self imageScale:[UIImage imageNamed:@"paragraph-right.png"]
                                        toSize:tImgSize];
	[tSegment insertSegmentWithImage:tImgAlignLeft atIndex:0 animated:YES];
	[tSegment insertSegmentWithImage:tImgAlignCenter atIndex:1 animated:YES];
	[tSegment insertSegmentWithImage:tImgAlignRight atIndex:2 animated:YES];
	tSegment.segmentedControlStyle = UISegmentedControlStyleBar;
	tSegment.frame = CGRectMake(0, 0, 60, 30);
	[tSegment addTarget:self
                 action:@selector(buttonClicked_Segment:)
       forControlEvents:UIControlEventValueChanged];
	tSegment.selectedSegmentIndex = 0;
	self.navigationItem.titleView = tSegment;
	[tSegment release];
}

- (void)fontPickerInit{
    _fontPicker = [[UIPickerView alloc] init];
	_fontPicker.showsSelectionIndicator = YES;
	_fontPicker.delegate = self;
	_fontPicker.dataSource = self;
	_fontPicker.hidden = YES;
    _fontPicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
	[_fontPicker selectRow:4 inComponent:0 animated:YES];
	[_textView addSubview:_fontPicker];
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
    _originalContentViewFrame = _textView.frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation tToInterfaceO = [UIApplication sharedApplication].statusBarOrientation;
	[self updateCurInterface:tToInterfaceO];
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

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWasShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillBeHidden:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

- (void)unregisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:UIKeyboardDidShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
}
- (void)keyboardWasShow:(NSNotification *)notification {
    // 取得键盘的frame，注意，因为键盘在window的层面弹出来的，所以它的frame坐标也是对应window窗口的。
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint endOrigin = endRect.origin;
    // 把键盘的frame坐标系转换到与UITextView一致的父view上来。
    if ([UIApplication sharedApplication].keyWindow && self.textView.superview) {
        endOrigin = [self.textView.superview convertPoint:endRect.origin
                                                 fromView:[UIApplication sharedApplication].keyWindow];
    }
    _originalContentViewFrame = self.textView.frame;
    _originalContentOffsetY = self.textView.contentOffset.y;
    
    CGFloat adjustHeight = _originalContentViewFrame.origin.y + _originalContentViewFrame.size.height;
    // 根据相对位置调整一下大小，自己画图比划一下就知道为啥要这样计算。
    // 当然用其他的调整方式也是可以的，比如取UITextView的orgin，origin到键盘origin之间的高度作为UITextView的高度也是可以的。
    adjustHeight -= endOrigin.y;
    if (adjustHeight > 0) {
        
        CGRect newRect = _originalContentViewFrame;
        newRect.size.height -= adjustHeight;
        [UIView beginAnimations:nil context:nil];
        self.textView.frame = newRect;
        NSLog(@"%@",NSStringFromCGPoint(_textView.contentOffset));
        [UIView commitAnimations];
    }
    /*NSValue *keyboardFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    
    UIEdgeInsets contentInsets = self.textView.contentInset;
    contentInsets.bottom = CGRectGetHeight(keyboardFrame);
    
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;*/
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    // 恢复原理的大小
    NSLog(@"%@",NSStringFromCGPoint(_textView.contentOffset));
    [UIView beginAnimations:nil context:nil];
    CGRect tTextViewFrame = self.textView.frame;
    if (tTextViewFrame.origin.y>tTextViewFrame.size.height)
    _originalContentViewFrame.origin.y = tTextViewFrame.origin.y +
        _textView.contentOffset.y - _originalContentOffsetY;
    self.textView.frame = _originalContentViewFrame;

    [UIView commitAnimations];
    /*UIEdgeInsets contentInsets = self.textView.contentInset;
    contentInsets.bottom = .0;
    
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;*/
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
    [self unregisterForKeyboardNotifications];
	[super dealloc];
}

@end
