//
//  KDTableViewController.h
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTextEditorDelegate.h"

typedef enum {
	KDTableOptionGeneral,
	KDTableOptionFont,
	KDTableOptionSize,
	KDTableOptionTextAlignment
} KDTableOption;

@class KDFontSizeViewController;
@interface KDTableViewController : UITableViewController <KDTableViewControllerDelegate>

@property (nonatomic, assign) NSObject <KDTableViewControllerDelegate> *delegate;
@property (nonatomic, retain) NSMutableDictionary *allOptions;
@property (nonatomic, assign) NSObject <KDTextEditorViewControllerDelegate> *vcdelegete;
- (id)initWithOption:(KDTableOption)option;


@end
