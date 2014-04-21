//
//  KDFontSizeViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDFontSizeViewController.h"

@interface KDFontSizeViewController ()
{
	UILabel *_sample;
	UISlider *_slider;
	CGFloat _size;
}
@end

@implementation KDFontSizeViewController
@synthesize delegate = _delegate;

- (id)init {
	self = [super init];
	if (self) {
		// Custom initialization
		self.navigationItem.title = @"字体大小";
	}
	return self;
}

- (id)initWithSize:(CGFloat)size {
	self = [self init];

	if (size > 20.0f)
		_size = 20.0f;
	else if (size < 10.0f)
		_size = 10.0f;
	else _size = size;

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	_slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 200, 200, 20)];
	_slider.minimumValue = 10.0f;
	_slider.maximumValue = 20.0f;
	_slider.value = _size;
	[_slider   addTarget:self
	              action:@selector(updateValue_Slider:)
	    forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:_slider];

	_sample = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 300, 20)];
	_sample.text = @"字体大小随slider变化";
	_sample.font = [UIFont systemFontOfSize:_size];
	[self.view addSubview:_sample];
}

- (void)updateValue_Slider:(id)sender {
	_sample.font = [UIFont systemFontOfSize:_slider.value];
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
		NSString *tValue = [NSString stringWithFormat:@"%.1f", _slider.value];
		[self.delegate optionSetForKey:@"大小" value:tValue];
	}
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[_slider release];
	[_sample release];
	[super dealloc];
}

@end
