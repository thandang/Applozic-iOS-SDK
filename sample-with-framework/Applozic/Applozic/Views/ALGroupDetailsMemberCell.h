//
//  ALGroupDetailsMemberCell.h
//  Applozic
//
//  Created by apple on 03/12/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALGroupDetailsMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *alphabeticLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adminLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameNSLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
