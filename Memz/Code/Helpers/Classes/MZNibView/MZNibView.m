//
//  MZNibView.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZNibView.h"

@interface MZNibView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MZNibView
@synthesize contentView = _contentView;

- (id)init {
	if (self = [super init]) {
		[self createFromNib];
		[self doInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ([super initWithFrame:frame]) {
		[self createFromNib];
		[self doInit];
	}
	return self;
}

- (void)doInit {
}

- (NSString *)cellNibName {
	// Legacy code will override cellNibName, so it must still implement the default behavior
	return NSStringFromClass([self class]);
}

- (NSString *)nibName {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return [self cellNibName];
#pragma clang diagnostic pop
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[self createFromNib];
	[self doInit];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	[self layoutIfNeeded];
	[self updateContentFrame];
}

- (void)createFromNib {
	NSLog(@"Creating %@ from nib", NSStringFromClass([self class]));
	if (self.contentView == nil) {
		NSLog(@"Loading contentView from nib");
		[[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];

		[self updateContentFrame];

		[self addSubview:self.contentView];

		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	} else {
		NSLog(@"contentView already loaded, not loading it again");
	}
}

- (void)updateContentFrame {
	self.contentView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
	NSLog(@"Updating contentView frame to %@", [NSValue valueWithCGRect:self.contentView.frame]);
}

- (UIView *)contentCellView {
	return self.contentView;
}

- (void)setContentCellView:(UIView *)contentCellView {
	self.contentView = contentCellView;
}

@end
