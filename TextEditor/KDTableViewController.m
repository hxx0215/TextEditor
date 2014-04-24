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
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
    [tDefaults synchronize];
    if (![tDefaults objectForKey:@"kTextEditorFontSet"]) {
        NSMutableArray *tFontSet = [[NSMutableArray alloc]
                                    initWithArray:[UIFont familyNames]];
        [tDefaults setObject:tFontSet forKey:@"kTextEditorFontSet"];
        [tDefaults synchronize];
        [tFontSet release];
    }
    _fontList = [[NSMutableArray alloc]
                 initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
    
    
    self.navigationItem.title = NSLocalizedString(@"Fonts", nil);
    
	_editButton = [[UIBarButtonItem alloc]
	               initWithTitle:NSLocalizedString(@"Edit", nil)
	                       style:UIBarButtonItemStylePlain
	                      target:self
	                      action:@selector(buttonClicked_Edit:)];
	_cancelButton = [[UIBarButtonItem alloc]
	                 initWithTitle:NSLocalizedString(@"Cancel", nil)
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
		_editButton.title = NSLocalizedString(@"Done", nil);
		_resetFontButton = [[UIBarButtonItem alloc]
		                    initWithTitle:NSLocalizedString(@"Reset", nil)
		                            style:UIBarButtonItemStylePlain
		                           target:self
		                           action:@selector(buttonClicked_Reset:)];
		self.navigationItem.leftBarButtonItem = _resetFontButton;
	}
	else {
		_editButton.title = NSLocalizedString(@"Edit", nil);
		self.navigationItem.leftBarButtonItem = _cancelButton;
	}
	[self.tableView setEditing:_editStatus animated:YES];
	_editStatus = !_editStatus;
}

- (void)buttonClicked_Reset:(id)sender {
	NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *tFontSet = [[NSMutableArray alloc] initWithArray:[UIFont familyNames]];
	[tDefaults setObject:tFontSet forKey:@"kTextEditorFontSet"];
	[tDefaults synchronize];
	[tFontSet release];
	[_fontList release];
	_fontList = nil;
	_fontList = [[NSMutableArray alloc]
	             initWithArray:[tDefaults objectForKey:@"kTextEditorFontSet"]];
	[self.tableView reloadData];
}

- (void)buttonClicked_Cancel:(id)sender {
    if (self.textEditorVCtrlDelegate && [self.textEditorVCtrlDelegate respondsToSelector:@selector(textEditorViewControllerDidDismissModalView:)])
    {
        [self.textEditorVCtrlDelegate textEditorViewControllerDidDismissModalView:nil];
    }
}

#pragma mark - Rotate

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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tCellWithIdentifier = @"Cell";
	UITableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:tCellWithIdentifier];
	if (!tCell) {
		tCell = [[[UITableViewCell alloc]
		         initWithStyle:UITableViewCellStyleSubtitle
		                           reuseIdentifier:tCellWithIdentifier]
		        autorelease];
	}
	if (0 == indexPath.section) {
		NSUInteger row = [indexPath row];
		tCell.textLabel.text = [_fontList objectAtIndex:row];
		tCell.textLabel.font = [UIFont fontWithName:tCell.textLabel.text size:20.0];

		if ([tCell.textLabel.text isEqualToString:_fontName]) {
			tCell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			tCell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else {
		tCell.accessoryType = UITableViewCellAccessoryNone;
		tCell.textLabel.text = @"";
		tCell.detailTextLabel.text = @"";
	}

	return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *tCell = [tableView cellForRowAtIndexPath:indexPath];
	tCell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.textEditorVCtrlDelegate  && [self.textEditorVCtrlDelegate respondsToSelector:@selector(textEditorViewControllerDidDismissModalView:)]) {
        [self.textEditorVCtrlDelegate
         textEditorViewControllerDidDismissModalView:[_fontList objectAtIndex:[indexPath row]]];
    }
	
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)     tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath {
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

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSUInteger tRow = [indexPath row];
		UITableViewCell *tCell = [self.tableView cellForRowAtIndexPath:indexPath];
		if (UITableViewCellAccessoryCheckmark == tCell.accessoryType) {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
			                                                 message:NSLocalizedString(@"AlertMessage", nil)
			                                                delegate:nil
			                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
			                                       otherButtonTitles:nil] autorelease];
			[alert show];
			return;
		}
		[_fontList removeObjectAtIndex:tRow];
		NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
		[tDefaults setObject:_fontList forKey:@"kTextEditorFontSet"];
		[tDefaults synchronize];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)dealloc {
	_textEditorVCtrlDelegate = nil;
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
