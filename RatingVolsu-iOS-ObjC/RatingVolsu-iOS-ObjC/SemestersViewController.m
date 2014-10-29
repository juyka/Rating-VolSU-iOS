//
//  SemestersViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "SemestersViewController.h"
#import "NSManagedObject+Extensions.h"
#import "RatingsViewController.h"
#import "RecentViewController.h"
#import "RecentItem+Mappings.h"

@interface SemestersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *dataSource;


@end

@implementation SemestersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.dataSource = @[@1, @2, @3];
	
	Group *group = self.student.group;
	[Semester request:group.groupId withHandler:^(NSArray *dataList) {
		
		self.dataSource = dataList;
		[self.tableView reloadData];
	}];
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	NSNumber *year = [Group find:@"groupId == %@", self.student.group.groupId].year;
	
	year = [NSNumber numberWithInteger:year.intValue + indexPath.row / 2];
	
	NSNumber *object = self.dataSource[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@ - %d)", object.description, year, year.intValue + 1];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SemesterCell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self performSegueWithIdentifier:@"UnwindToRecentController" sender:self.dataSource[indexPath.row]];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"UnwindToRecentController"]) {
		
		NSNumber *recentId = [[NSNumber alloc] initWithInt:self.student.studentId.intValue * 100 + [sender intValue]];
		RecentItem *item = [RecentItem findOrCreate:@{@"itemId" : recentId}];
		[item update:@{
					   @"student" : self.student,
					   @"semester" : sender,
					   @"date" : [NSDate date],
					   @"isFavorite" : @NO
					   }];
		_selectedItem = item;
	}
}


@end
