//
//  KDTableViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDTableViewController.h"

#import "KDFontSizeViewController.h"

@interface KDTableViewController ()
{
	NSMutableArray *_settingList;
	KDTableOption _option;
	UIBarButtonItem *_editButton;
	UIBarButtonItem *_resetFontButton;
	BOOL _editStatus;
}
@end

@implementation KDTableViewController
@synthesize delegate = _delegate;
@synthesize allOptions = _allOptions;

- (id)initWithOption:(KDTableOption)option {
	self = [super init];
	if (self) {

		_option = option;
		if (!_allOptions) _allOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"字体", @"", @"大小", @"", @"对齐方式", nil];
		if (KDTableOptionGeneral == option) {
			_settingList = [[NSMutableArray alloc] initWithObjects:@"字体", @"大小", @"对齐方式", nil];
			self.navigationItem.title = @"设置";
		}
		if (KDTableOptionFont == option) {
			NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
			[tDefaults synchronize];
			if (![tDefaults objectForKey:@"kTextEditorFontSet"]) {
				NSMutableArray *tFontSet = [[NSMutableArray alloc] initWithArray:[UIFont familyNames]];
				[tDefaults setObject:tFontSet forKey:@"kTextEditorFontSet"];
				[tDefaults synchronize];
				[tFontSet release];
			}
			_settingList = [[NSMutableArray alloc] initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
			self.navigationItem.title = @"字体";
		}
		if (KDTableOptionTextAlignment == option) {
			_settingList = [[NSMutableArray alloc] initWithObjects:@"左对齐", @"右对齐", @"居中", nil];
			self.navigationItem.title = @"对齐方式";
		}
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	if (KDTableOptionFont == _option) {
		_editButton = [[UIBarButtonItem alloc]
		               initWithTitle:@"编辑"
		                       style:UIBarButtonItemStylePlain
		                      target:self
		                      action:@selector(buttonClicked_edit:)];
		self.navigationItem.rightBarButtonItem = _editButton;
		_editStatus = YES;
	}
}

- (void)buttonClicked_edit:(id)sender {
	if (_editStatus) {
		_editButton.title = @"完成";
		_resetFontButton = [[UIBarButtonItem alloc]
		                    initWithTitle:@"重置"
		                            style:UIBarButtonItemStylePlain
		                           target:self
		                           action:@selector(buttonClicked_reset:)];
		self.navigationItem.leftBarButtonItem = _resetFontButton;
	}
	else {
		_editButton.title = @"编辑";
		self.navigationItem.leftBarButtonItem = nil;
	}
	[self.tableView setEditing:_editStatus animated:YES];
	_editStatus = !_editStatus;
}

- (void)buttonClicked_reset:(id)sender {
	NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
	[tDefaults synchronize];
	NSMutableArray *tFontSet = [[NSMutableArray alloc] initWithArray:[UIFont familyNames]];
	[tDefaults setObject:tFontSet forKey:@"kTextEditorFontSet"];
	[tDefaults synchronize];
	[tFontSet release];
	[_settingList release];
	_settingList = [[NSMutableArray alloc] initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
		[self.vcdelegete changeTextFont:_allOptions];
	}
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)optionSetForKey:(NSString *)key value:(NSString *)value {
	[_allOptions setObject:value forKey:key];
	[self.tableView reloadData];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [_settingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellWithIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithIdentifier] autorelease];
	}
	if (0 == indexPath.section) {
		NSUInteger row = [indexPath row];
		cell.textLabel.text = [_settingList objectAtIndex:row];

		if (KDTableOptionGeneral == _option) {
			cell.detailTextLabel.text = [_allOptions objectForKey:cell.textLabel.text];
		}
		else {
			NSString *tKey;
			if (KDTableOptionTextAlignment == _option)
				tKey = @"对齐方式";
			else {
				tKey = @"字体";
				cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:20.0];
			}
			if ([cell.textLabel.text isEqualToString:[_allOptions objectForKey:tKey]]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = @"";
		cell.detailTextLabel.text = @"";
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (KDTableOptionGeneral == _option) {
		if ((0 == [indexPath row]) || (2 == [indexPath row])) {
			KDTableOption option;
			if (0 == [indexPath row])
				option = KDTableOptionFont;
			else
				option = KDTableOptionTextAlignment;
			KDTableViewController *tTableVC = [[KDTableViewController alloc]
			                                   initWithOption:option];
			tTableVC.allOptions = self.allOptions;
			tTableVC.delegate = self;
			[self.navigationController pushViewController:tTableVC animated:YES];
			[tTableVC release];
		}
		if (1 == [indexPath row]) {
			CGFloat tSize = [[_allOptions objectForKey:@"大小"] floatValue];
			KDFontSizeViewController *tFontSizeVC = [[KDFontSizeViewController alloc] initWithSize:tSize];
			tFontSizeVC.delegate = self;
			[self.navigationController pushViewController:tFontSizeVC animated:YES];
			[tFontSizeVC release];
		}
	}
	else {
		NSString *tKey;
		if (KDTableOptionTextAlignment == _option)
			tKey = @"对齐方式";
		else tKey = @"字体";
		UITableViewCell *tOneCell = [tableView cellForRowAtIndexPath:indexPath];
		tOneCell.accessoryType = UITableViewCellAccessoryCheckmark;
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		NSString *tValue = tOneCell.textLabel.text;
		[self.delegate optionSetForKey:tKey value:tValue];

		[self.navigationController popViewControllerAnimated:YES];
	}

}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSUInteger tFromRow = [fromIndexPath row];
	NSUInteger tToRow = [toIndexPath row];

	id object = [[_settingList objectAtIndex:tFromRow] retain];
	[_settingList removeObject:object];
	[_settingList insertObject:object atIndex:tToRow];
	[object release];

	NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
	[tDefaults synchronize];
	[tDefaults setObject:_settingList forKey:@"kTextEditorFontSet"];
	[tDefaults synchronize];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSUInteger row = [indexPath row];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (UITableViewCellAccessoryCheckmark == cell.accessoryType) {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"警告" message:@"你无法删除已选字体" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil] autorelease];
			[alert show];
			return;
		}
		[_settingList removeObjectAtIndex:row];
		NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
		[tDefaults synchronize];
		[tDefaults setObject:_settingList forKey:@"kTextEditorFontSet"];
		[tDefaults synchronize];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)dealloc {
	[_allOptions release];
	[_settingList release];
	[_editButton release];
	[_resetFontButton release];
	[super dealloc];
}

/*
   // Override to support conditional editing of the table view.
   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
   {
    // Return NO if you do not want the specified item to be editable.
    return YES;
   }
 */
/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
 if (0 == [indexPath section])
 {
 if (UITableViewCellAccessoryCheckmark == cell.accessoryType) return NO;
 }
 return YES;
 }

*/
/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
