//
//  SettingViewController.m
//  Zhuajiu
//
//  Created by smartrookie on 16/9/9.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "SettingViewController.h"
#import "DataSource.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation SettingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithArray:self.dataFromLastPage];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addItem:(id)sender {
    
    [[DataSource shareDB] addItem:self.textField.text];
    if ([self.dataSource containsObject:self.textField.text]) {
        return;
    } else {
        [self.dataSource addObject:self.textField.text];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataUpdate" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除"
                                              handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                  
                                                  NSString *item = self.dataSource[indexPath.row];
                                                  [[DataSource shareDB] deleteItem:item];
                                                  [self.dataSource removeObjectAtIndex:indexPath.row];
                                                  
                                                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"dataUpdate" object:nil];

                                              }]];
}


@end
