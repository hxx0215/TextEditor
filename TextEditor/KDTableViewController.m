//
//  KDTableViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-21.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDTableViewController.h"
//#import "KDTableViewControllerDelegate.h"
#import "KDFontSizeViewController.h"

@interface KDTableViewController ()
{
    NSArray *_settingList;
    KDTableOption _option;

}
@end

@implementation KDTableViewController
@synthesize delegate = _delegate;
@synthesize allOptions = _allOptions;

- (id)initWithOption:(KDTableOption)option
{
    self = [super init];
    if (self) {
        // Custom initialization
        _option = option;
        if (KDTableOptionGeneral == option)
        {
            _settingList = [[NSArray alloc] initWithObjects:@"字体",@"大小",@"字体样式", nil];
            self.navigationItem.title = @"设置";
            if (nil==_allOptions) _allOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"字体",@"",@"大小",@"",@"字体样式", nil];
        }
        if (KDTableOptionFont == option)
        {
            _settingList = [[NSArray alloc] initWithArray:[UIFont familyNames]];
            self.navigationItem.title = @"字体";
            
        }

        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_settingList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithIdentifier] autorelease];
    }
    if (0==indexPath.section)
    {
        NSUInteger row = [indexPath row];
        cell.textLabel.text = [_settingList objectAtIndex:row];
        //cell.detailTextLabel.text = @"详细信息";
        if (KDTableOptionGeneral == _option)
        {
            cell.detailTextLabel.text = [_allOptions objectForKey:cell.textLabel.text];
        }
        if (KDTableOptionFont == _option)
        {
            
            if ([cell.textLabel.text  isEqualToString:[_allOptions objectForKey:@"字体"]])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (KDTableOptionGeneral==_option)
    {
        if (0==[indexPath row])
        {
            KDTableViewController *tTableVC = [[KDTableViewController alloc]
                                               initWithOption:KDTableOptionFont];
            tTableVC.allOptions = self.allOptions;
            tTableVC.delegate = self;
            [self.navigationController pushViewController:tTableVC animated:YES];
            [tTableVC release];
        }
        if (1==[indexPath row])
        {
            CGFloat tSize = [[_allOptions objectForKey:@"大小"] floatValue];
            KDFontSizeViewController *tFontSizeVC = [[KDFontSizeViewController alloc] initWithSize:tSize];
            tFontSizeVC.delegate = self;
            [self.navigationController pushViewController:tFontSizeVC animated:YES];
            [tFontSizeVC release];
        }
    }
    if (KDTableOptionFont == _option)
    {
        UITableViewCell *tOneCell = [tableView cellForRowAtIndexPath: indexPath];
        tOneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *tKey = @"字体";
        NSString *tValue = tOneCell.textLabel.text;
        [self.delegate optionSetForKey:tKey value:tValue];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[tableView reloadData];
}

- (void)optionSetForKey:(NSString *)key value:(NSString *)value
{
    [_allOptions setObject:value forKey:key];
    [self.tableView reloadData];
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
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
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
