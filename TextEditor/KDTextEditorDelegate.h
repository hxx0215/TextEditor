//
//  KDTableViewControllerDelegate.h
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KDTextEditorViewControllerDelegate <NSObject>

- (void)changeTextFont:(NSMutableDictionary *)dict;

@end

@protocol KDTableViewControllerDelegate <NSObject>
- (void)optionSetForKey:(NSString *)key value:(NSString *)value;
@end
