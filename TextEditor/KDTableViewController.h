//
//  KDTableViewController.h
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTextEditorDelegate.h"



@class KDFontSizeViewController;

@interface KDTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) id<KDTextEditorViewControllerDelegate> textEditorVCtrlDelegate;
@property (nonatomic, strong) UITableView *tableView;



@end
