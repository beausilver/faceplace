//
//  MyTBC.m
//  FaceReplace
//
//  Created by beau silver on 3/3/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MyTBC.h"
#import <AVFoundation/AVFoundation.h>

@interface MyTBC ()

@property (nonatomic) AVAudioPlayer* bgAudioPlayer;
@property (nonatomic) AVAudioPlayer* sfxAudioPlayer;

@end

@implementation MyTBC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/song.mp3", [[NSBundle mainBundle] resourcePath]]];
    //NSError *error;
    
    //self.bgAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	//self.bgAudioPlayer.numberOfLoops = -1;
    //[self.bgAudioPlayer setVolume: 0.3];
	
	//if (self.bgAudioPlayer)
	//	[self.bgAudioPlayer play];

    
    //url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hit.aiff", [[NSBundle mainBundle] resourcePath]]];

    //self.sfxAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	//if (self.sfxAudioPlayer)
    //    [self.sfxAudioPlayer prepareToPlay];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //I realize this is not 'ideal' for triggering a sound quickly, such
    //as the tab bars
    //ToDo: use a different audio lib for this
    
    //if (self.sfxAudioPlayer)
    //    if(self.sfxAudioPlayer.isPlaying){
    //        [self.sfxAudioPlayer stop];
    //    }
	//	[self.sfxAudioPlayer play];
}


@end
