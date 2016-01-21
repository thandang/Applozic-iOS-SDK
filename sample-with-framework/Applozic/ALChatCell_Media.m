//
//  ALChatCell_Media.m
//  Applozic
//
//  Created by devashish on 20/01/2016.
//  Copyright © 2016 applozic Inc. All rights reserved.
//

#import "ALChatCell_Media.h"

// Constants
#define MT_INBOX_CONSTANT "4"
#define MT_OUTBOX_CONSTANT "5"
#define DATE_LABEL_SIZE 12

@interface ALChatCell_Media()

-(NSString *)getProgressOfTrack;
-(void) mediaButtonAction;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void) setupProgressValueX:(CGFloat)cooridinateX andY:(CGFloat)cooridinateY;
-(void) dowloadRetryButtonAction;
-(void) cancelAction;

@property (nonatomic) int count;

@end

@implementation ALChatCell_Media

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.bubbleImageView = [[UIImageView alloc] init];
        [self.bubbleImageView setBackgroundColor:[UIColor whiteColor]];
        self.bubbleImageView.layer.cornerRadius = 5;
        self.bubbleImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bubbleImageView];
        
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setTextColor:[UIColor blackColor]];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:DATE_LABEL_SIZE]];
        [self.dateLabel setNumberOfLines:1];
        [self.contentView addSubview:self.dateLabel];
        
        self.userProfileImageView = [[UIImageView alloc] init];
        self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userProfileImageView.clipsToBounds = YES;
        self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width/2;
        self.userProfileImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userProfileImageView];
        
        self.playPauseStop = [[UIButton alloc] init];
        [self.playPauseStop addTarget:self action:@selector(mediaButtonAction) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:self.playPauseStop];
        
        self.mediaTrackProgress = [[UIProgressView alloc] init];
        [self.contentView addSubview:self.mediaTrackProgress];
        
        self.mediaTrackLength = [[UILabel alloc] init];
        [self.contentView addSubview:self.mediaTrackLength];
        
        self.count = 1;
    }
    
    return self;
    
}

-(void) addShadowEffects
{
    self.bubbleImageView.layer.shadowOpacity = 0.3;
    self.bubbleImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.bubbleImageView.layer.shadowRadius = 1;
    self.bubbleImageView.layer.masksToBounds = NO;
}

-(instancetype) populateCell:(ALMessage*) alMessage viewSize:(CGSize)viewSize
{
    
    if([alMessage.type isEqualToString:@MT_INBOX_CONSTANT])
    {
        [self.userProfileImageView setFrame:CGRectMake(5, 5, 45, 45)];
        [self.bubbleImageView setFrame:CGRectMake(self.userProfileImageView.frame.origin.x + self.userProfileImageView.frame.size.width + 13, self.userProfileImageView.frame.origin.y, 100, 70)];
        [self.dateLabel setFrame:CGRectMake(self.bubbleImageView.frame.origin.x, self.bubbleImageView.frame.origin.x + self.bubbleImageView.frame.size.width + 5, 80, 20)];
        
        ALContactDBService *theContactDBService = [[ALContactDBService alloc] init];
        ALContact *alContact = [theContactDBService loadContactByKey:@"userId" value: alMessage.to];
        
        if (alContact.localImageResourceName)
        {
            self.userProfileImageView.image = [ALUtilityClass getImageFromFramworkBundle:alContact.localImageResourceName];
        }
        else if(alContact.contactImageUrl)
        {
            NSURL * theUrl1 = [NSURL URLWithString:alContact.contactImageUrl];
            [self.userProfileImageView sd_setImageWithURL:theUrl1];
        }
        else
        {
            self.userProfileImageView.image = [ALUtilityClass getImageFromFramworkBundle:@"ic_contact_picture_holo_light.png"];
        }
        
        [self setupProgressValueX: (self.bubbleImageView.frame.size.width - 55) andY: (self.bubbleImageView.frame.origin.y + 10)];
        [self.playPauseStop setFrame:CGRectMake(self.bubbleImageView.frame.origin.x + 10, self.bubbleImageView.frame.origin.y + 10, 45, 45)];
        
        [self.mediaTrackProgress setFrame:CGRectMake(self.playPauseStop.frame.origin.x + self.playPauseStop.frame.size.width + 10, self.bubbleImageView.frame.origin.y, 50, 30)];
        
         [self.mediaTrackProgress setProgress:self.audioPlayer.currentTime];
        [self.mediaTrackLength setText: [self getProgressOfTrack]];
    }
    else
    {
        if([ALApplozicSettings isUserProfileHidden])
        {
            [self.userProfileImageView setFrame:CGRectMake(viewSize.width - 45 - 5 , 5, 45, 45)];
        }
        else
        {
            [self.userProfileImageView setFrame:CGRectMake(viewSize.width - 45 - 5 , 5, 0, 45)];
        }
        
        [self.bubbleImageView setFrame:CGRectMake(viewSize.width - 100 - 13, self.userProfileImageView.frame.origin.y, 100, 70)];
        
        [self setupProgressValueX: (self.bubbleImageView.frame.origin.x + 10) andY: (self.bubbleImageView.frame.origin.y + 10)];
        [self.playPauseStop setFrame:CGRectMake(self.progresLabel.frame.origin.x + self.progresLabel.frame.size.width + 10, self.bubbleImageView.frame.origin.y + 10, 45, 45)];
        [self.mediaTrackProgress setFrame:CGRectMake(self.playPauseStop.frame.origin.x + self.playPauseStop.frame.size.width + 10, self.bubbleImageView.frame.origin.y, 50, 30)];
        
         [self.mediaTrackProgress setProgress:self.audioPlayer.currentTime];
        [self.mediaTrackLength setText: [self getProgressOfTrack]];
    }
    
   
    [self addShadowEffects];
    
    return self;
}


-(BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(delete:));
}

-(void) delete:(id)sender
{
    [self.delegate deleteMessageFromView:self.alMessage];
    
    [ALMessageService deleteMessage:self.alMessage.key andContactId:self.alMessage.contactIds withCompletion:^(NSString* string,NSError* error) {
        
        if(!error)
        {
            NSLog(@"DELETE MEDIA Successfully!!!");
        }
        else
        {
            NSLog(@"ERROR IN DELETING MEDIA");
        }
        
    }];
    
}

-(void) cancelAction
{
    
    if ([self.delegate respondsToSelector:@selector(stopDownloadForIndex:andMessage:)])
    {
        [self.delegate stopDownloadForIndex:(int)self.tag andMessage:self.alMessage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) dowloadRetryButtonAction
{
    [_delegate downloadRetryButtonActionDelegate:(int)self.tag andMessage:self.alMessage];
}

- (void) dealloc
{
    if(self.alMessage.fileMeta){
        [self.alMessage.fileMeta removeObserver:self forKeyPath:@"progressValue" context:nil];
    }
}

-(void) setupProgressValueX:(CGFloat)cooridinateX andY:(CGFloat)cooridinateY
{
    self.progresLabel = [[KAProgressLabel alloc] init];
    [self.progresLabel setFrame:CGRectMake(cooridinateX, cooridinateY, 45, 45)];
    self.progresLabel.delegate = self;
    [self.progresLabel setTrackWidth: 4.0];
    [self.progresLabel setProgressWidth: 4];
    [self.progresLabel setStartDegree:0];
    [self.progresLabel setEndDegree:0];
    [self.progresLabel setRoundedCornersWidth:1];
    self.progresLabel.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3];
    self.progresLabel.trackColor = [UIColor colorWithRed:104.0/255 green:95.0/255 blue:250.0/255 alpha:1];
    self.progresLabel.progressColor = [UIColor whiteColor];
    [self.contentView addSubview: self.progresLabel];
    
}

-(void)setAlMessage:(ALMessage *)alMessage
{
    if(self.alMessage.fileMeta){
        [self.alMessage.fileMeta removeObserver:self forKeyPath:@"progressValue" context:nil];
    }
    self.alMessage = alMessage;
    [self.alMessage.fileMeta addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ALFileMetaInfo *metaInfo = (ALFileMetaInfo *)object;
    [self setNeedsDisplay];
    self.progresLabel.startDegree = 0;
    self.progresLabel.endDegree = metaInfo.progressValue;
}

-(void) mediaButtonAction
{
//     NSString *soundFilePath = [NSString stringWithFormat:@"%@/test.m4a",[[NSBundle mainBundle] resourcePath]];
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], self.alMessage.fileMeta.name];// add name  herefrom almessage from
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops = 1; // for Infinite set it to -1
    
    if(self.count)
    {
        [self.playPauseStop setImage:[ALUtilityClass getImageFromFramworkBundle:@"PLAY.png"] forState: UIControlStateNormal];
        [self.audioPlayer play];
        self.count = 0;
    }
    else
    {
        [self.playPauseStop setImage:[ALUtilityClass getImageFromFramworkBundle:@"PAUSE.png"] forState: UIControlStateNormal];
        [self.audioPlayer pause];
        self.count = 1;
    }
}

-(NSString *) getProgressOfTrack
{
    int minutes = self.audioPlayer.currentTime / 60;
    float seconds = (int)(self.audioPlayer.currentTime) % 60;
    
    if(minutes > 0)
    {
        return [NSString stringWithFormat:@"%.2d:%.00f", minutes, seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"00:%f", self.audioPlayer.currentTime];
    }
}

@end
