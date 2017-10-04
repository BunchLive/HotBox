//
//  HotBoxSubscriber.h
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

#import <React/RCTView.h>

@interface HotBoxSubscriber : RCTView
@property (nonatomic, strong) NSString *streamId;
@property (nonatomic, assign) CGFloat talkingBorderWidth;
@property (nonatomic, assign) BOOL useAlpha;
@property (nonatomic, assign) CGFloat alphaTimer;
@property (nonatomic, assign) CGFloat alphaTransition;
@property (nonatomic, assign) CGFloat talkingAlphaThreshold;
@property (nonatomic, assign) CGFloat maxAlpha;
@property (nonatomic, assign) CGFloat minAlpha;
@end
