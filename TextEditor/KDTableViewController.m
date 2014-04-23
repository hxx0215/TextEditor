//
//  KDTableViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDTableViewController.h"


@interface KDTableViewController ()
{
	NSMutableArray *_fontList;
	UIBarButtonItem *_editButton;
	UIBarButtonItem *_resetFontButton;
    UIBarButtonItem *_cancelButton;
	BOOL _editStatus;
}
@end

@implementation KDTableViewController

@synthesize fontName = _fontName;

- (id)init {
	self = [super init];
	if (self) {
		_fontName = @"";
		NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
		[tDefaults synchronize];
		if (![tDefaults objectForKey:@"kTextEditorFontSet"]) {
			NSMutableArray *tFontSet = [[NSMutableArray alloc] initWithArray:[UIFont familyNames]];
			[tDefaults setObject:tFontSet forKey:@"kTextEditorFontSet"];
			[tDefaults synchronize];
			[tFontSet release];
		}
		_fontList = [[NSMutableArray alloc] initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
		self.navigationItem.title = @"字体";
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_editButton = [[UIBarButtonItem alloc]
	               initWithTitle:@"编辑"
	                       style:UIBarButtonItemStylePlain
	                      target:self
	                      action:@selector(buttonClicked_Edit:)];
    _cancelButton = [[UIBarButtonItem alloc]
                     initWithTitle:@"取消"
                     style:UIBarButtonItemStylePlain
                     target:self
                     action:@selector(buttonClicked_Cancel:)];
    
	self.navigationItem.rightBarButtonItem = _editButton;
    self.navigationItem.leftBarButtonItem = _cancelButton;
    
	_editStatus = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClicked

- (void)buttonClicked_Edit:(id)sender {
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
	[_fontList release];
	_fontList = nil;
	_fontList = [[NSMutableArray alloc] initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
	[self.tableView reloadData];
}

- (void)buttonClicked_Cancel:(id)sender
{
    [_modalViewdelegate didDismissModalView];
}



#pragma mark - rotate

- (BOOL)shouldAutorotate {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_fontList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellWithIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithIdentifier] autorelease];
	}
	if (0 == indexPath.section) {
		NSUInteger row = [indexPath row];
		cell.textLabel.text = [_fontList objectAtIndex:row];
        cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:20.0];

		if ([cell.textLabel.text isEqualToString:_fontName]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
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
	UITableViewCell *tOneCell = [tableView cellForRowAtIndexPath:indexPath];
	tOneCell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self.fontNameDelegate changeTextFont:[_fontList objectAtIndex:[indexPath row]]];

	//[self.navigationController popViewControllerAnimated:YES];
    [self.modalViewdelegate didDismissModalView];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSUInteger tFromRow = [fromIndexPath row];
	NSUInteger tToRow = [toIndexPath row];

	id object = [[_fontList objectAtIndex:tFromRow] retain];
	[_fontList removeObject:object];
	[_fontList insertObject:object atIndex:tToRow];
	[object release];

	NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
	[tDefaults setObject:_fontList forKey:@"kTextEditorFontSet"];
	[tDefaults synchronize];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSUInteger row = [indexPath row];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (UITableViewCellAccessoryCheckmark == cell.accessoryType) {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"警告"
			                                                 message:@"你无法删除已选字体"
			                                                delegate:nil
			                                       cancelButtonTitle:@"好"
			                                       otherButtonTitles:nil] autorelease];
			[alert show];
			return;
		}
		[_fontList removeObjectAtIndex:row];
		NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
		[tDefaults setObject:_fontList forKey:@"kTextEditorFontSet"];
		[tDefaults synchronize];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)dealloc {
    _modalViewdelegate = nil;
    _fontNameDelegate =nil;
	[_fontList release];
	[_editButton release];
    [_cancelButton release];
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
