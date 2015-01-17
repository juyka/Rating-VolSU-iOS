//
//  GroupRatingWithPickerViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 10/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingWithPickerViewController.h"
#import "RatingItem+Mappings.h"

@interface GroupRatingWithPickerViewController()
<
UITableViewDataSource,
UITableViewDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property(weak,nonatomic) IBOutlet UIPickerView *pickerView;
@property(weak,nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupRatingWithPickerViewController {

	NSArray *dataSource;
	NSArray *subjects;
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[self addSubjects];

	Subject *subject = subjects.first;
	[self addData:subject.subjectId];
	
	[self groupRequest];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return dataSource.count;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = dataSource[indexPath.row];
	cell.textLabel.text = item.semester.student.number;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ б.", item.total];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
	return subjects.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	Subject *subject = subjects[row];
	
	return subject.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	Subject *subject = subjects[row];
	[self addData:subject.subjectId];
}


- (void)groupRequest {
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		[self addSubjects];
		Subject *subject = subjects[[self.pickerView selectedRowInComponent:0]];
		[self addData:subject.subjectId];
	}];
}

- (void)addSubjects {
	
	RatingItem *item = [RatingItem find:@{@"semester.student.group.name" : self.semester.student.group.name,
										  @"semester.number" : self.semester.number}];
	subjects = [[item.semester.ratings allObjects] map:^id(RatingItem *rating) {
		return rating.subject;
	}];
}

- (void)addData:(NSString*)subjectId {
	
	dataSource = [RatingItem where:@{@"semester.student.group.name" : self.semester.student.group.name,
									 @"semester.number" : self.semester.number,
									 @"subject.subjectId" : subjectId}];
	[self.tableView reloadData];
}


@end
