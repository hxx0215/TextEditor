//
//  KDTableViewControllerDelegate.h
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KDTextEditorViewControllerDelegate <NSObject>

@optional
- (void)changeTextFont:(NSString *)font;

@end

@protocol ModalViewControllerDelegate <NSObject>

@optional
- (void)didDismissModalView;
@end

