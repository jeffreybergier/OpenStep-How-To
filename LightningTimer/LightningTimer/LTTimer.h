/* LTTimer.h created by me on Mon 16-Dec-2024 */

#import <AppKit/AppKit.h>
#import "sys/time.h"

typedef int LTCentisecond;
@class LTTimer;

@protocol LTTimerDelegate
-(IBAction)timerDidStart:(LTTimer*)timer;
-(IBAction)timerDidStop:(LTTimer*)timer;
-(IBAction)timerDidTick:(LTTimer*)timer;
@end

@interface LTTimer: NSObject
{
  struct timeval _startTime;
  LTCentisecond _duration;
  NSTimer *_fastTimer;
  NSTimer *_slowTimer;
  id<LTTimerDelegate> _delegate;
}

// MARK: Getting Info
-(LTCentisecond)duration;
-(LTCentisecond)remainingDuration;
-(BOOL)hasStarted;
-(BOOL)isPrecise;

// MARK: Operation
-(void)setDelegate:(id<LTTimerDelegate>)delegate;
-(void)setDuration:(LTCentisecond)duration;
-(void)start;
-(void)stop;

// MARK: Private
-(void)__configureTimer;
-(void)__timerDidFire:(NSTimer*)timer;
-(void)__applicationActiveChanged:(NSNotification*)aNotification;

@end
