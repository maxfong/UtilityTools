//
//  MAXRequestController.h
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import <Cocoa/Cocoa.h>

@interface MAXRequestController : NSWindowController
{
    IBOutlet NSTextField    *txtfInterfaceURL;
    IBOutlet NSTextView     *txtvRequestInput;
    IBOutlet NSTextView     *txtvResponseOutput;
}

- (IBAction)didPressedSubmitRequest:sender;

@end
