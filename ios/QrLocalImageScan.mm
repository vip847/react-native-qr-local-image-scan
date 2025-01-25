#import "QrLocalImageScan.h"

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(QrLocalImageScan, NSObject)

RCT_EXTERN_METHOD(scanCodes:(NSString*)path
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeQrLocalImageScanSpecJSI>(params);
}

@end
