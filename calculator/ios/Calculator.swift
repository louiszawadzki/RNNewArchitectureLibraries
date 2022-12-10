import Foundation

@objc(RNCalculator)
class Calculator: NSObject {

  @objc(add:andB:withResolver:withRejecter:)
  func add(a: Int, b: Int, resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    resolve(a+b);
  }
}
