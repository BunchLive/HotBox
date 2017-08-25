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
@property (nonatomic, assign) CGFloat borderWidth;
//@property (nonatomic, assign) Boolean useAlpha;
@end
