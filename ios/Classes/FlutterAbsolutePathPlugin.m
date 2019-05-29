#import "FlutterAbsolutePathPlugin.h"
#import <flutter_absolute_path/flutter_absolute_path-Swift.h>

@implementation FlutterAbsolutePathPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAbsolutePathPlugin registerWithRegistrar:registrar];
}
@end
