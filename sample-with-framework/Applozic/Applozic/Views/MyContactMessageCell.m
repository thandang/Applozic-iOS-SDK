//
//  MyContactMessageCell.m
//  Applozic
//
//  Created by apple on 06/06/19.
//  Copyright © 2019 applozic Inc. All rights reserved.
//

#import "MyContactMessageCell.h"


#define MT_INBOX_CONSTANT "4"
#define MT_OUTBOX_CONSTANT "5"
#define DATE_LABEL_SIZE 12

#import "ALContactMessageCell.h"
#import "ALUtilityClass.h"
#import "UIImageView+WebCache.h"
#import "ALApplozicSettings.h"
#import "ALConstant.h"
#import "ALContact.h"
#import "ALColorUtility.h"
#import "ALContactDBService.h"
#import "ALMessageService.h"
#import "ALMessageInfoViewController.h"
#import "ALChatViewController.h"
#import "ALVCardClass.h"
#import "ALMessageClientService.h"

#define BUBBLE_PADDING_X 13
#define BUBBLE_PADDING_X_OUTBOX 60
#define BUBBLE_PADDING_WIDTH 120
#define BUBBLE_PADDING_HEIGHT 190
#define BUBBLE_PADDING_HEIGHT_OUTBOX 180

#define DATE_PADDING_X 20
#define DATE_PADDING_WIDTH 20
#define DATE_HEIGHT 20
#define DATE_WIDTH 80

#define MSG_STATUS_WIDTH 20
#define MSG_STATUS_HEIGHT 20

#define CNT_PROFILE_X 10
#define CNT_PROFILE_Y 10
#define CNT_PROFILE_HEIGHT 50
#define CNT_PROFILE_WIDTH 50

#define CNT_PERSON_X 10
#define CNT_PERSON_HEIGHT 20

#define USER_CNT_Y 5
#define USER_CNT_HEIGHT 50

#define EMAIL_Y 5
#define EMAIL_HEIGHT 50

#define BUTTON_Y 50
#define BUTTON_WIDTH 20
#define BUTTON_HEIGHT 40

#define CHANNEL_PADDING_X 5
#define CHANNEL_PADDING_Y 2
#define CHANNEL_PADDING_WIDTH 5
#define CHANNEL_HEIGHT 20
#define CHANNEL_PADDING_HEIGHT 20
#define AL_CONTACT_PADDING_Y 20

static int  const AL_CONTACT_ADD_BUTTON_HEIGHT_PADDING = 230;


@interface MyContactMessageCell ()

@end

@implementation MyContactMessageCell
{
    NSURL *theUrl;
    CGFloat msgFrameHeight;
    ALVCardClass *vCardClass;
}
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.userInteractionEnabled = YES;

        self.contactProfileImage = [[UIImageView alloc] init];
        [self.contactProfileImage setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.contactProfileImage];

        self.userContact = [[UILabel alloc] init];
        [self.userContact setBackgroundColor:[UIColor clearColor]];
        [self.userContact setTextColor:[UIColor blackColor]];
        [self.userContact setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:14]];
        [self.userContact setNumberOfLines:2];
        [self.contentView addSubview:self.userContact];

        self.emailId = [[UILabel alloc] init];
        [self.emailId setBackgroundColor:[UIColor clearColor]];
        [self.emailId setTextColor:[UIColor blackColor]];
        [self.emailId setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:14]];
        [self.emailId setNumberOfLines:2];
        [self.contentView addSubview:self.emailId];

        self.contactPerson = [[UILabel alloc] init];
        [self.contactPerson setBackgroundColor:[UIColor clearColor]];
        [self.contactPerson setTextColor:[UIColor blackColor]];
        [self.contactPerson setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:14]];
        [self.contentView addSubview:self.contactPerson];

        if(!ALApplozicSettings.isAddContactButtonHiddenForSentMessage){

            self.addContactButton = [[UIButton alloc] init];
            [self.addContactButton setTitle: NSLocalizedStringWithDefaultValue(@"addContactButtonText", [ALApplozicSettings getLocalizableName],[NSBundle mainBundle], @"ADD CONTACT", @"") forState:UIControlStateNormal];
            [self.addContactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addContactButton.titleLabel setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:14]];
            [self.addContactButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [self.addContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.contentView addSubview:self.addContactButton];

            if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
                self.addContactButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            }
        }

        if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
            self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            self.userContact.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            self.emailId.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            self.contactPerson.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        }

        UITapGestureRecognizer * menuTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(proccessTapForMenu:)];
        [self.contentView addGestureRecognizer:menuTapGesture];

    }
    return self;
}

-(instancetype)populateCell:(ALMessage *) alMessage viewSize:(CGSize)viewSize
{
    self.mUserProfileImageView.alpha = 1;
    self.progresLabel.alpha = 0;
    self.mDowloadRetryButton.alpha = 0;

    [self addContactButtonEnable:NO];

    BOOL today = [[NSCalendar currentCalendar] isDateInToday:[NSDate dateWithTimeIntervalSince1970:[alMessage.createdAtTime doubleValue]/1000]];

    NSString * theDate = [NSString stringWithFormat:@"%@",[alMessage getCreatedAtTimeChat:today]];

    CGSize theDateSize = [ALUtilityClass getSizeForText:theDate maxWidth:150 font:self.mDateLabel.font.fontName fontSize:self.mDateLabel.font.pointSize];

    self.mMessage = alMessage;

    [self.mChannelMemberName setHidden:YES];
    [self.mNameLabel setHidden:YES];
    [self.mMessageStatusImageView setHidden:YES];
    [self.replyParentView setHidden:YES];

    [self.contactProfileImage setImage:[ALUtilityClass getImageFromFramworkBundle:@"ic_contact_picture_holo_light.png"]];
    [self.userContact setText:@"PHONE NO"];
    [self.emailId setText:@"EMAIL ID"];
    [self.contactPerson setText:@"CONTACT NAME"];
    [self.replyUIView removeFromSuperview];

    UITapGestureRecognizer *tapForOpenChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processOpenChat)];
    tapForOpenChat.numberOfTapsRequired = 1;
    [self.mUserProfileImageView setUserInteractionEnabled:YES];
    [self.mUserProfileImageView addGestureRecognizer:tapForOpenChat];

    if ([alMessage isSentMessage]){
        self.mUserProfileImageView.frame = CGRectMake(viewSize.width - USER_PROFILE_PADDING_X_OUTBOX, 0, 0, USER_PROFILE_HEIGHT);

        self.mBubleImageView.backgroundColor = [ALApplozicSettings getSendMsgColor];


        //Shift for message reply and channel name..

        int widthPadding =  (ALApplozicSettings.isAddContactButtonHiddenForSentMessage ?   AL_CONTACT_ADD_BUTTON_HEIGHT_PADDING: BUBBLE_PADDING_HEIGHT_OUTBOX );

        CGFloat requiredHeight = viewSize.width - widthPadding;

        CGFloat imageViewY =  self.mBubleImageView.frame.origin.y + CNT_PROFILE_Y;

        self.mBubleImageView.frame = CGRectMake((viewSize.width - self.mUserProfileImageView.frame.origin.x + BUBBLE_PADDING_X_OUTBOX), 0,
                                                viewSize.width - BUBBLE_PADDING_WIDTH, viewSize.width - widthPadding);

        if(alMessage.isAReplyMessage)
        {
            [self processReplyOfChat:alMessage andViewSize:viewSize];

            requiredHeight = requiredHeight + self.replyParentView.frame.size.height;
            imageViewY = imageViewY +  self.replyParentView.frame.size.height;

        }


        self.mBubleImageView.frame = CGRectMake((viewSize.width - self.mUserProfileImageView.frame.origin.x + BUBBLE_PADDING_X_OUTBOX), 0,
                                                viewSize.width - BUBBLE_PADDING_WIDTH, requiredHeight);

        [self.contactProfileImage setFrame:CGRectMake(self.mBubleImageView.frame.origin.x + CNT_PROFILE_X,
                                                      self.mBubleImageView.frame.origin.y + CNT_PROFILE_Y,
                                                      CNT_PROFILE_WIDTH, CNT_PROFILE_HEIGHT)];

        CGFloat widthName = self.mBubleImageView.frame.size.width - (self.contactProfileImage.frame.size.width + 25);

        [self.contactPerson setFrame:CGRectMake(self.contactProfileImage.frame.origin.x +
                                                self.contactProfileImage.frame.size.width + CNT_PERSON_X,
                                                self.contactProfileImage.frame.origin.y, widthName, CNT_PERSON_HEIGHT)];

        [self.userContact setFrame:CGRectMake(self.contactPerson.frame.origin.x,
                                              self.contactPerson.frame.origin.y + self.contactPerson.frame.size.height + USER_CNT_Y,
                                              widthName, USER_CNT_HEIGHT)];

        [self.emailId setFrame:CGRectMake(self.userContact.frame.origin.x, self.userContact.frame.origin.y +
                                          self.userContact.frame.size.height + EMAIL_Y,
                                          widthName, EMAIL_HEIGHT)];

        if(!ALApplozicSettings.isAddContactButtonHiddenForSentMessage){

            [self.addContactButton setFrame:CGRectMake(self.contactProfileImage.frame.origin.x,
                                                       self.mBubleImageView.frame.origin.y + self.mBubleImageView.frame.size.height - BUTTON_Y,
                                                       self.mBubleImageView.frame.size.width - BUTTON_WIDTH, BUTTON_HEIGHT)];

            msgFrameHeight = self.mBubleImageView.frame.size.height - (self.addContactButton.frame.size.height + self.addContactButton.frame.size.height/2);
            
            [self.addContactButton setBackgroundColor:[UIColor whiteColor]];

        }else{
            msgFrameHeight = self.mBubleImageView.frame.size.height;
        }

        [self.mMessageStatusImageView setHidden:NO];


        self.mDateLabel.textAlignment = NSTextAlignmentLeft;

        self.mDateLabel.frame = CGRectMake((self.mBubleImageView.frame.origin.x + self.mBubleImageView.frame.size.width)
                                           - theDateSize.width - DATE_PADDING_X,
                                           self.mBubleImageView.frame.origin.y + self.mBubleImageView.frame.size.height,
                                           theDateSize.width, DATE_HEIGHT);

        self.mMessageStatusImageView.frame = CGRectMake(self.mDateLabel.frame.origin.x + self.mDateLabel.frame.size.width,
                                                        self.mDateLabel.frame.origin.y,
                                                        MSG_STATUS_WIDTH, MSG_STATUS_HEIGHT);


    }

    if ([alMessage isSentMessage] && ((self.channel && self.channel.type != OPEN) || self.contact)) {

        self.mMessageStatusImageView.hidden = NO;
        NSString * imageName;

        switch (alMessage.status.intValue) {
            case DELIVERED_AND_READ :{
                imageName = @"ic_action_read.png";
            }break;
            case DELIVERED:{
                imageName = @"ic_action_message_delivered.png";
            }break;
            case SENT:{
                imageName = @"ic_action_message_sent.png";
            }break;
            default:{
                imageName = @"ic_action_about.png";
            }break;
        }
        self.mMessageStatusImageView.image = [ALUtilityClass getImageFromFramworkBundle:imageName];
    }

    self.mDateLabel.text = theDate;

    theUrl = nil;

    if (alMessage.imageFilePath != NULL)
    {
        NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * filePath = [docDir stringByAppendingPathComponent:alMessage.imageFilePath];
        theUrl = [NSURL fileURLWithPath:filePath];



        vCardClass = [[ALVCardClass alloc] init];
        [vCardClass vCardParser:filePath];

        [self.contactPerson setText:vCardClass.fullName];
        if(vCardClass.contactImage)
        {
            [self.contactProfileImage setImage:vCardClass.contactImage];
        }
        [self.emailId setText:vCardClass.userEMAIL_ID];
        [self.userContact setText:vCardClass.userPHONE_NO];

        [self addContactButtonEnable:YES];

    }
    else if((!alMessage.imageFilePath && alMessage.fileMeta.blobKey) || (alMessage.imageFilePath && !alMessage.fileMeta.blobKey))
    {
        [super.delegate downloadRetryButtonActionDelegate:(int)self.tag andMessage:self.mMessage];
    }

    self.contactProfileImage.layer.cornerRadius = self.contactProfileImage.frame.size.width/2;
    self.contactProfileImage.layer.masksToBounds = YES;

    self.mBubleImageView.layer.shadowOpacity = 0.3;
    self.mBubleImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.mBubleImageView.layer.shadowRadius = 1;
    self.mBubleImageView.layer.masksToBounds = NO;

    return self;
}

#pragma mark - Menu option tap Method -

-(void) proccessTapForMenu:(id)tap{

    [self processKeyBoardHideTap];

    UIMenuItem * messageForward = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"forwardOptionTitle", [ALApplozicSettings getLocalizableName],[NSBundle mainBundle], @"Forward", @"") action:@selector(messageForward:)];
    UIMenuItem * messageReply = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"replyOptionTitle", [ALApplozicSettings getLocalizableName],[NSBundle mainBundle], @"Reply", @"") action:@selector(messageReply:)];

    if ([self.mMessage.type isEqualToString:@MT_INBOX_CONSTANT]){
        [[UIMenuController sharedMenuController] setMenuItems: @[messageForward,messageReply]];
    }else if ([self.mMessage.type isEqualToString:@MT_OUTBOX_CONSTANT]){
        UIMenuItem * msgInfo = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"infoOptionTitle", [ALApplozicSettings getLocalizableName],[NSBundle mainBundle], @"Info", @"") action:@selector(msgInfo:)];
        [[UIMenuController sharedMenuController] setMenuItems: @[msgInfo,messageReply,messageForward]];
    }

    [[UIMenuController sharedMenuController] update];

}


-(void)addButtonAction
{
    @try
    {
        [vCardClass addContact:vCardClass];
    } @catch (NSException *exception) {

        ALSLog(ALLoggerSeverityInfo, @"CONTACT_EXCEPTION :: %@", exception.description);
    }
}

//==================================================================================================
#pragma mark - KAProgressLabel Delegate Methods
//==================================================================================================

-(void)cancelAction
{
    if ([self.delegate respondsToSelector:@selector(stopDownloadForIndex:andMessage:)])
    {
        [self.delegate stopDownloadForIndex:(int)self.tag andMessage:self.mMessage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)dowloadRetryActionButton
{
    [super.delegate downloadRetryButtonActionDelegate:(int)self.tag andMessage:self.mMessage];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ALFileMetaInfo *metaInfo = (ALFileMetaInfo *)object;
    [self setNeedsDisplay];
    self.progresLabel.startDegree = 0;
    self.progresLabel.endDegree = metaInfo.progressValue;
}

//==================================================================================================
//==================================================================================================


-(BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if([self.mMessage isSentMessage] && self.mMessage.groupId)
    {
        return (self.mMessage.isDownloadRequired? (action == @selector(delete:) || action == @selector(msgInfo:)):(action == @selector(delete:)|| action == @selector(msgInfo:)||  [self isForwardMenuEnabled:action]  ||  [self isMessageReplyMenuEnabled:action]));
    }

    return (self.mMessage.isDownloadRequired? (action == @selector(delete:)):
            (action == @selector(delete:) ||  [self isForwardMenuEnabled:action]  || [self isMessageReplyMenuEnabled:action]));
}


-(void) delete:(id)sender
{
    [self.delegate deleteMessageFromView:self.mMessage];
    [ALMessageService deleteMessage:self.mMessage.key andContactId:self.mMessage.contactIds withCompletion:^(NSString *string, NSError *error) {

        ALSLog(ALLoggerSeverityError, @"DELETE MESSAGE ERROR :: %@", error.description);
    }];
}

-(void)openUserChatVC
{
    [self.delegate processUserChatView:self.mMessage];
}

-(void) messageForward:(id)sender
{
    ALSLog(ALLoggerSeverityInfo, @"Message forward option is pressed");
    [self.delegate processForwardMessage:self.mMessage];

}

-(void) messageReply:(id)sender
{
    ALSLog(ALLoggerSeverityInfo, @"Message forward option is pressed");
    [self.delegate processMessageReply:self.mMessage];

}
- (void)msgInfo:(id)sender
{
    [self.delegate showAnimationForMsgInfo:YES];
    UIStoryboard *storyboardM = [UIStoryboard storyboardWithName:@"Applozic" bundle:[NSBundle bundleForClass:ALChatViewController.class]];
    ALMessageInfoViewController *msgInfoVC = (ALMessageInfoViewController *)[storyboardM instantiateViewControllerWithIdentifier:@"ALMessageInfoView"];

    msgInfoVC.VCardClass = vCardClass;

    __weak typeof(ALMessageInfoViewController *) weakObj = msgInfoVC;

    [msgInfoVC setMessage:self.mMessage andHeaderHeight:msgFrameHeight withCompletionHandler:^(NSError *error) {

        if(!error)
        {
            [self.delegate loadViewForMedia:weakObj];
        }
        else
        {
            [self.delegate showAnimationForMsgInfo:NO];
        }
    }];
}

-(BOOL)isForwardMenuEnabled:(SEL) action;
{
    return ([ALApplozicSettings isForwardOptionEnabled] && action == @selector(messageForward:));
}

-(BOOL)isMessageReplyMenuEnabled:(SEL) action
{
    return ([ALApplozicSettings isReplyOptionEnabled] && action == @selector(messageReply:));

}

-(void) processKeyBoardHideTap
{
    [self.delegate handleTapGestureForKeyBoard];
}

-(void)processOpenChat
{
    [self processKeyBoardHideTap];
    [self.delegate openUserChat:self.mMessage];
}


-(void)addContactButtonEnable:(BOOL)flag{
    if(!ALApplozicSettings.isAddContactButtonHiddenForSentMessage){
        [self.addContactButton setEnabled:flag];
    }
}

@end
