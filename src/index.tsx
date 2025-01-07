import QrLocalImageScan from './NativeQrLocalImageScan';

export function scanCodes(path: string): Promise<string[]> {
  return QrLocalImageScan.scanCodes(path);
}