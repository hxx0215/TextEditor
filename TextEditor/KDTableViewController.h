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

@interface KDTableViewController : UITableViewController 


@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) id<KDTextEditorViewControllerDelegate> fontNameDelegate;
@property (nonatomic, assign) id<ModalViewControllerDelegate> modalViewdelegate;



@end
