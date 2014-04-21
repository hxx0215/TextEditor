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

@end

@implementation KDTextEditorViewController
@synthesize textView = _textView;

- (id)init {
	self = [super init];
	if (self) {
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

	[settingButton release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)buttonClicked_setting:(id)sender {
	KDTableViewController *tTableVC = [[KDTableViewController alloc] initWithOption:KDTableOptionGeneral];
	[self.navigationController pushViewController:tTableVC animated:YES];
	NSArray *t = [UIFont familyNames];
	NSLog(@"%@", t);
    [tTableVC release];
}

@end
