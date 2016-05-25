//
//  MZFeedViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZFeedViewController.h"
#import "MZArticleViewController.h"
#import "MZFeedTableViewCell.h"
#import "MZSettingsViewController.h"
#import "MZRemoteServerCoordinator.h"
#import "NSManagedObject+MemzCoreData.h"
#import "UIViewController+MemzAdditions.h"
#import "UIImage+MemzAdditions.h"
#import "MZNavigationController.h"
#import "MZTutorialView.h"
#import "MZLoaderView.h"
#import "MZUser.h"

NSString * const kFeedTableViewCellIdentifier = @"MZFeedTableViewCellIdentifier";
NSString * const kPresentArticleViewControllerSegueIdentifier = @"MZPresentArticleViewControllerSegueIdentifier";

NSString * const kHasApplicationAlreadyOpened = @"MZHasApplicationAlreadyOpened";

@interface MZFeedViewController () <UITableViewDataSource,
UITableViewDelegate,
MZTutorialViewProtocol>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray<MZArticle *> *tableViewData;
@property (nonatomic, strong) MZArticle *selectedArticle;
@property (nonatomic, assign) BOOL hasApplicationAlreadyOpened;

@end

@implementation MZFeedViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.tableFooterView = [[UIView alloc] init];

	if ([MZUser currentUser]) {
		[self setupTableViewData];
	}

	[[NSNotificationCenter defaultCenter] addObserverForName:MZUserDidAuthenticateNotification
																										object:nil
																										 queue:[NSOperationQueue mainQueue]
																								usingBlock:
	 ^(NSNotification *notification) {
		 [self setupTableViewData];

		 // TODO: Would be amazing if the blurred background behind was updating live
		 if (!self.hasApplicationAlreadyOpened) {
			 [MZTutorialView showInView:self.view withType:MZTutorialViewTypeAddWord delegate:self];
			 self.hasApplicationAlreadyOpened = YES;
		 };
	 }];

	[[NSNotificationCenter defaultCenter] addObserverForName:MZSettingsDidChangeLanguageNotification
																										object:nil
																										 queue:[NSOperationQueue mainQueue]
																								usingBlock:
	 ^(NSNotification *notification) {
		 [self setupTableViewData];
	 }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kPresentArticleViewControllerSegueIdentifier]) {
		MZNavigationController *navigationController = [segue.destinationViewController safeCastToClass:[MZNavigationController class]];
		MZArticleViewController *articleController = [navigationController.viewControllers.firstObject safeCastToClass:[MZArticleViewController class]];
		articleController.article = self.selectedArticle;
	}
}

- (void)setupTableViewData {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[MZLoaderView showInView:self.view];	// TODO: Fix where the slight delay comes from
	});

	[MZRemoteServerCoordinator fetchFeedWithCompletionHandler:^(NSArray<MZArticle *> *articles, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[MZLoaderView hideAllLoadersFromView:self.view];

			if (error) {
				[self presentError:error];
				return;
			}

			self.tableViewData = articles;
			[self.tableView reloadData];
		});
	}];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tutorial View Handling

- (void)tutorialView:(MZTutorialView *)view didRequestDismissForType:(MZTutorialViewType)type {
	switch (type) {
		case MZTutorialViewTypeAddWord:
			[view setType:MZTutorialViewTypeSettings animated:YES];
			break;
		case MZTutorialViewTypeSettings:
			[view dismiss];
			break;
		default:
			break;
	}
}

- (BOOL)hasApplicationAlreadyOpened {
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kHasApplicationAlreadyOpened] boolValue];
}

- (void)setHasApplicationAlreadyOpened:(BOOL)hasApplicationAlreadyOpened {
	[[NSUserDefaults standardUserDefaults] setObject:@(hasApplicationAlreadyOpened) forKey:kHasApplicationAlreadyOpened];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedTableViewCellIdentifier
																															forIndexPath:indexPath];

	cell.cellTitle = self.tableViewData[indexPath.row].title;
	cell.cellSubTitle = self.tableViewData[indexPath.row].subTitle;
	cell.backgroundImageURL = self.tableViewData[indexPath.row].imageUrl;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedArticle = self.tableViewData[indexPath.row];
	[self performSegueWithIdentifier:kPresentArticleViewControllerSegueIdentifier sender:nil];  // TODO: Set cell as sender
}

@end
