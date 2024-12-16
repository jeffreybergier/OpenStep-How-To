/* LTTimer.m created by me on Mon 16-Dec-2024 */

#import "LTTimer.h"

@implementation LTTimer

// MARK: Getting Info
-(LTCentisecond)duration;
{
  return _duration;
}

-(LTCentisecond)remainingDuration;
{
  struct timeval _nowTime;
  long long startTime;
  long long nowTime;
  LTCentisecond centiEllapsed;
  LTCentisecond remaining;

  if (gettimeofday(&_nowTime, NULL) != 0) {
    [NSException raise:@"TIMEFAIL" format:@"TIMEFAIL: gettimeofday"];
    return -1;
  }
  
  startTime = _startTime.tv_sec * 1000000LL + _startTime.tv_usec;
  nowTime   = _nowTime.tv_sec   * 1000000LL + _nowTime.tv_usec;

  centiEllapsed = (nowTime / 10000) - (startTime / 10000);
  remaining = _duration - centiEllapsed;
  
  return remaining;
}

-(BOOL)hasStarted;
{
  return (_fastTimer || _slowTimer) ? YES : NO;
}

-(BOOL)isPrecise;
{
  return _fastTimer != nil;
}

// MARK: Operation

-(void)setDelegate:(id<LTTimerDelegate>)delegate;
{
  _delegate = delegate;
}

-(void)setDuration:(LTCentisecond)duration;
{
  _duration = duration;
}

-(void)start;
{
  if (gettimeofday(&_startTime, NULL) != 0) {
    [NSException raise:@"TIMEFAIL" format:@"TIMEFAIL: gettimeofday"];
    return;
  }
  [self __configureTimer];
  [_delegate timerDidStart:self];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(__applicationActiveChanged:)
                                               name:@"NSApplicationDidBecomeActiveNotification"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(__applicationActiveChanged:)
                                               name:@"NSApplicationDidResignActiveNotification"
                                             object:nil];
}

-(void)stop;
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_fastTimer invalidate];
  [_slowTimer invalidate];
  [_fastTimer release];
  [_slowTimer release];
  _fastTimer = nil;
  _slowTimer = nil;
  [_delegate timerDidStop:self];
}

// MARK: Internal

-(void)__configureTimer;
{
  [_fastTimer invalidate];
  [_slowTimer invalidate];
  [_fastTimer release];
  [_slowTimer release];
  _fastTimer = nil;
  _slowTimer = nil;
  
  if ([[NSApplication sharedApplication] isActive]) {
    _fastTimer = [[NSTimer scheduledTimerWithTimeInterval:0.01
                                                   target:self
                                                 selector:@selector(__timerDidFire:)
                                                 userInfo:nil
                                                  repeats:YES] retain];
  } else {
    _slowTimer = [[NSTimer scheduledTimerWithTimeInterval:1.00
                                                   target:self
                                                 selector:@selector(__timerDidFire:)
                                                 userInfo:nil
                                                  repeats:YES] retain];
  }
}

-(void)__timerDidFire:(NSTimer*)timer;
{
  [_delegate timerDidTick:self];
}

-(void)__applicationActiveChanged:(NSNotification*)aNotification;
{
  if (![self hasStarted]) { return; }
  [self __configureTimer];
  [_delegate timerDidTick:self];
}

-(void)dealloc;
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_fastTimer invalidate];
  [_slowTimer invalidate];
  [_fastTimer release];
  [_slowTimer release];
  [super dealloc];
}

@end
