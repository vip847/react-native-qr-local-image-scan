#import "QrLocalImageScan.h"

@implementation QrLocalImageScan
RCT_EXPORT_MODULE()

- (void)scanCodes:(NSString *)path
          withResolver:(RCTPromiseResolveBlock)resolve
          withRejecter:(RCTPromiseRejectBlock)reject {

    // 1
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];

    if (!image) {
        reject(@"", [NSString stringWithFormat:@"Cannot get image from path: %@", path], nil);
        return;
    }

    CGImageRef cgImage = image.CGImage;
    if (!cgImage) {
        reject(@"", @"Cannot get cgImage from image", nil);
        return;
    }

    // 2
    VNDetectBarcodesRequest *request = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
        if (error) {
            reject(@"", @"Cannot get result from VNDetectBarcodesRequest", error);
            return;
        }

        NSArray<VNBarcodeObservation *> *results = request.results;
        NSMutableArray<NSString *> *qrCodes = [NSMutableArray array];
        for (VNBarcodeObservation *observation in results) {
            if (observation.payloadStringValue) {
                [qrCodes addObject:observation.payloadStringValue];
            }
        }
        resolve(qrCodes);
    }];

    request.symbologies = @[VNBarcodeSymbologyQR];

    // 3
    #if TARGET_OS_SIMULATOR
        request.revision = VNDetectBarcodesRequestRevision1;
    #endif

    // 4
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage options:@{}];
    @try {
        [handler performRequests:@[request] error:nil];
    } @catch (NSError *error) {
        reject(@"", [NSString stringWithFormat:@"Error when performing request on VNImageRequestHandler: %@", error.localizedDescription], error);
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeQrLocalImageScanSpecJSI>(params);
}

@end
