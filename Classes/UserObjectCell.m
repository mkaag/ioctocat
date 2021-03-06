#import "UserObjectCell.h"
#import "GHUser.h"


@interface UserObjectCell ()
@property(nonatomic,readonly)GHUser *object;
@end


@implementation UserObjectCell

+ (id)cell {
	return [[self.class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserObjectCellIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	self.textLabel.font = [UIFont systemFontOfSize:15];
	self.textLabel.highlightedTextColor = [UIColor whiteColor];
	self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
	self.detailTextLabel.font = [UIFont systemFontOfSize:13];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.layer.cornerRadius = 3;
	self.imageView.layer.masksToBounds = YES;
	return self;
}

- (void)dealloc {
	[self.userObject removeObserver:self forKeyPath:kGravatarKeyPath];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect textFrame = self.textLabel.frame;
	textFrame.origin.x = 50;
	self.textLabel.frame = textFrame;
	self.imageView.frame = CGRectMake(6, 6, 32, 32);
}

- (void)setUserObject:(id)userObject {
	[self.object removeObserver:self forKeyPath:kGravatarKeyPath];
	_userObject = userObject;
	[self.object addObserver:self forKeyPath:kGravatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
	self.textLabel.text = self.object.login;
	self.imageView.image = self.object.gravatar ? self.object.gravatar : [UIImage imageNamed:@"AvatarBackground32.png"];
	if (!self.object.gravatar && !self.object.gravatarURL) [self.object loadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kGravatarKeyPath] && self.object.gravatar) {
		self.imageView.image = self.object.gravatar;
	}
}

- (GHUser *)object {
	return _userObject;
}

@end