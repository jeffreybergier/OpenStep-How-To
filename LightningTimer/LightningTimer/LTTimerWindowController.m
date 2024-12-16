#import "LTTimerWindowController.h"

@implementation LTTimerWindowController

// MARK: Interface Builder

-(void)awakeFromNib;
{
  NSParameterAssert(_minutesTextField);
  NSParameterAssert(_secondsTextField);
  NSParameterAssert(_centsecTextField);
  NSParameterAssert(_startButton);
  
  _timer = [[LTTimer alloc] init];
  [_timer setDelegate:self];
}

-(IBAction)timerButtonClicked:(id)sender;
{
  if ([_timer hasStarted]) {
    [_timer stop];
  } else {
    [_timer setDuration:[self __centisecondValue]];
    [_timer start];
  }
}

-(IBAction)timerTextChanged:(id)sender
{
  [self __setCentisecondValue:[self __centisecondValue]
                    isPrecise:YES];
}

// MARK: Private

-(LTCentisecond)__centisecondValue;
{
  int minutes = 0;
  int seconds = 0;
  int centsec = 0;
  minutes = [_minutesTextField intValue];
  seconds = [_secondsTextField intValue];
  centsec = [_centsecTextField intValue];
  return (minutes * 60 * 100) + (seconds * 100) + centsec;
}

-(void)__setCentisecondValue:(LTCentisecond)_centiseconds
                   isPrecise:(BOOL)isPrecise;
{
  int remainingSec = 0;
  int minutes = 0;
  int seconds = 0;
  int centsec = 0;
  LTCentisecond centiseconds = abs(_centiseconds);
  BOOL isEllapsed = _centiseconds < 0;
  NSString *minutesString = nil;
  NSString *secondsString = nil;
  NSString *centsecString = nil;

  remainingSec = centiseconds % 6000;
  minutes = centiseconds / 6000;
  seconds = remainingSec / 100;
  centsec = remainingSec % 100;

  minutesString = (minutes < 10)
                ? [NSString stringWithFormat:@"0%d", minutes]
                : [NSString stringWithFormat:@"%d",  minutes];

  secondsString = (seconds < 10)
                ? [NSString stringWithFormat:@"0%d", seconds]
                : [NSString stringWithFormat:@"%d",  seconds];

  centsecString = (centsec < 10)
                ? [NSString stringWithFormat:@"0%d", centsec]
                : [NSString stringWithFormat:@"%d",  centsec];

  if (isEllapsed) {
    [_minutesTextField setBackgroundColor:[NSColor redColor]];
    [_secondsTextField setBackgroundColor:[NSColor redColor]];
    [_centsecTextField setBackgroundColor:[NSColor redColor]];
  } else {
    [_minutesTextField setBackgroundColor:[NSColor whiteColor]];
    [_secondsTextField setBackgroundColor:[NSColor whiteColor]];
    [_centsecTextField setBackgroundColor:[NSColor whiteColor]];
  }

  if (isPrecise) {
    [_minutesTextField setStringValue:minutesString];
    [_secondsTextField setStringValue:secondsString];
    [_centsecTextField setStringValue:centsecString];
  } else {
    [_minutesTextField setStringValue:minutesString];
    [_secondsTextField setStringValue:secondsString];
    [_centsecTextField setStringValue:@""];
    [_centsecTextField setBackgroundColor:[NSColor controlColor]];
  }
}

-(void)dealloc;
{
  [_timer release];
  [super dealloc];
}

@end

@implementation LTTimerWindowController (Timer)
-(IBAction)timerDidStart:(LTTimer*)timer;
{
  [_startButton setTitle:@"Stop"];
}

-(IBAction)timerDidStop:(LTTimer*)timer;
{
  [_startButton setTitle:@"Start"];
}

-(IBAction)timerDidTick:(LTTimer*)timer;
{
  [self __setCentisecondValue:[timer remainingDuration]
                    isPrecise:[timer isPrecise]];
}

@end
