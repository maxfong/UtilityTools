//
//  MAXConvertTools.m
//  MAXConvertTools
//
//  Created by maxfong on 14-7-15.
//  
//

#import "MAXConvertTools.h"
#import "MAXPluginController.h"

static MAXConvertTools *sharedPlugin;

@interface MAXConvertTools()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) MAXPluginController *windowController;

@end

@implementation MAXConvertTools

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init])
    {
        self.bundle = plugin;
        
        if ( ![NSBundle loadNibNamed:@"MAXConvertTools" owner:self] )
            NSLog( @"MAXConvertTools: Could not load interface." );
        
        NSMenuItem *productMenu = [[NSApp mainMenu] itemWithTitle:@"Product"];
        if (productMenu)
        {
            [[productMenu submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"ConvertTools" action:NULL keyEquivalent:@""];
            [menuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [menuItem setSubmenu:self.subMenu];
            
            [[productMenu submenu] addItem:menuItem];
        }
    }
    return self;
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    if (self.windowController.window.isVisible)
    {
        [self.windowController.window close];
    }
    else
    {
        if (!self.windowController)
        {
            MAXPluginController *vc = [[MAXPluginController alloc] initWithWindowNibName:@"MAXPluginController"];
            self.windowController = vc;
        }
        [self.windowController.window makeKeyAndOrderFront:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
