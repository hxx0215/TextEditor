//
//  KDTextEditorViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-20.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDTextEditorViewController.h"
#import "KDTableViewController.h"
@interface KDTextEditorViewController ()
{
	NSMutableDictionary *_allOptions;
}
@end

@implementation KDTextEditorViewController
@synthesize textView = _textView;

- (id)init {
	self = [super init];
	if (self) {
		_allOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Helvetica", @"字体", @"12", @"大小", @"左对齐", @"对齐方式", nil];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"TextEditor";

	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]
	                                  initWithTitle:@"settings"
	                                          style:UIBarButtonItemStylePlain
	                                         target:self
	                                         action:@selector(buttonClicked_setting:)];

	self.navigationItem.rightBarButtonItem = settingButton;

	self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.textView];
	[self addDismissButtontoKeyBoard];

	[settingButton release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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

- (void)dismissKeyBoard {
	[self.textView resignFirstResponder];
}

- (void)buttonClicked_setting:(id)sender {
	KDTableViewController *tTableVC = [[KDTableViewController alloc] initWithOption:KDTableOptionGeneral];
	tTableVC.vcdelegete = self;

	tTableVC.allOptions = _allOptions;
	[self.navigationController pushViewController:tTableVC animated:YES];
	[tTableVC release];
}

- (void)changeTextFont:(NSMutableDictionary *)dict {
	//NSLog(@"protocol");
	NSString *tFont = [dict objectForKey:@"字体"];
	CGFloat tSize = [[dict objectForKey:@"大小"] floatValue];
	NSString *tAlignment = [dict objectForKey:@"对齐方式"];
	if (!tFont) {
		tFont = @"Helvetica";
		[dict setObject:@"Helvetica" forKey:@"字体"];
	}
	if (tSize == 0) {
		tSize = 12.0;
		[dict setObject:@"12" forKey:@"大小"];
	}
	if (!tAlignment) {
		tAlignment = @"左对齐";
		[dict setObject:@"左对齐" forKey:@"对齐方式"];
	}
	self.textView.font = [UIFont fontWithName:tFont size:tSize];
	if ([tAlignment isEqualToString:@"左对齐"]) {
		self.textView.textAlignment = NSTextAlignmentLeft;
	}
	if ([tAlignment isEqualToString:@"居中"]) {
		self.textView.textAlignment = NSTextAlignmentCenter;
	}
	if ([tAlignment isEqualToString:@"右对齐"]) {
		self.textView.textAlignment = NSTextAlignmentRight;
	}
	_allOptions = dict;
}

- (void)dealloc {
	[_allOptions release];
	[_textView release];
	[super dealloc];
}

@end
