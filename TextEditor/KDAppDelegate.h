//
//  KDAppDelegate.h
//  TextEditor
//
//  Created by hxx on 14-4-20.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDTextEditorViewController;
@class KDNavigationViewController;

@interface KDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KDTextEditorViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@end
