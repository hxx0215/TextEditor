//
//  KDFontSizeViewController.h
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTextEditorDelegate.h"

@interface KDFontSizeViewController : UIViewController

@property (nonatomic, assign) NSObject <KDTableViewControllerDelegate> *delegate;

- (id)initWithSize:(CGFloat)size;
@end
