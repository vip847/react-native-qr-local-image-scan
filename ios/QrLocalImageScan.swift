import Vision

@objc(scanCodes:withResolver:withRejecter:)
func scanCodes(path: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
  
  // 1
  guard let url = URL(string: path),
        let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) else {
      reject("", "Cannot get image from path: \(path)", nil)
      return
  }
  guard let cgImage = image.cgImage else {
    reject("", "Cannot get cgImage from image", nil)
    return
  }
  
  // 2
  let request = VNDetectBarcodesRequest { request, error in
    guard let results = request.results as? [VNBarcodeObservation], error == nil else {
      reject("", "Cannot get result from VNDetectBarcodesRequest", nil)
      return
    }
    
    let qrCodes = results.compactMap { $0.payloadStringValue }
    resolve(qrCodes)
  }
  request.symbologies = [.qr]
  
  // 3
  #if targetEnvironment(simulator)
    request.revision = VNDetectBarcodesRequestRevision1
  #endif
  
  // 4
  let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
  do {
      try handler.perform([request])
  } catch {
    reject("", "Error when performing request on VNImageRequestHandler: \(error.localizedDescription)", nil)
  }
}