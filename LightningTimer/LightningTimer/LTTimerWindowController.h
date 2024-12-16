#import <AppKit/AppKit.h>
#import "LTTimer.h"

@interface LTTimerWindowController: NSResponder
{
  IBOutlet NSTextField *_centsecTextField;
  IBOutlet NSTextField *_minutesTextField;
  IBOutlet NSTextField *_secondsTextField;
  IBOutlet NSButton *_startButton;
  LTTimer *_timer;
}

// MARK: Interface Builder
-(void)awakeFromNib;
-(IBAction)timerButtonClicked:(id)sender;
-(IBAction)timerTextChanged:(id)sender;

// MARK: Private
-(LTCentisecond)__centisecondValue;
-(void)__setCentisecondValue:(LTCentisecond)centiseconds
                   isPrecise:(BOOL)isPrecise;

@end

@interface LTTimerWindowController (Timer) <LTTimerDelegate>
-(IBAction)timerDidStart:(LTTimer*)timer;
-(IBAction)timerDidStop:(LTTimer*)timer;
-(IBAction)timerDidTick:(LTTimer*)timer;
@end
