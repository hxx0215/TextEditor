//
//  KDTextEditorViewController.h
//  TextEditor
//
//  Created by hxx on 14-4-20.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTextEditorDelegate.h"

@class KDTableViewController;

@interface KDTextEditorViewController : UIViewController <KDTextEditorViewControllerDelegate,
	                                                      ModalViewControllerDelegate,
	                                                      UIPickerViewDelegate,
	                                                      UIPickerViewDataSource,
	                                                      UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end
