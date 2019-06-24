//
//  MyContactMessageCell.h
//  Applozic
//
//  Created by apple on 06/06/19.
//  Copyright © 2019 applozic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMessage.h"
#import "ALMediaBaseCell.h"

@interface MyContactMessageCell : ALMediaBaseCell


@property (nonatomic, strong) UIImageView * contactProfileImage;
@property (nonatomic, strong) UILabel * userContact;
@property (nonatomic, strong) UILabel * contactPerson;
@property (nonatomic, strong) UILabel * emailId;
@property (nonatomic, strong) UIButton * addContactButton;

-(instancetype)populateCell:(ALMessage *) alMessage viewSize:(CGSize)viewSize;

@end
