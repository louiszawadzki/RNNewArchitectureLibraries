# RUN

This run starts from the [feat/back-turbomodule-070](https://github.com/react-native-community/RNNewArchitectureLibraries/tree/feat/back-turbomodule-070) branch.
Start from there up to the `[TurboModule] Test the Turbomodule` section. Then, follow the steps below to move your logic to a Swift implementation file.

## Table of contents

* [[Setup] Update to 0.71-RC.3](#update)
* [[Setup] Update podspec](#update-podspec)
* [[Swift] Add Swift files](#swift)
* [[iOS] Update Calculator file](#update-calculator)
* [[Test] Test the swift TurboModule](#test-swift)

## Steps

### <a name="update" />[[Setup] Update to 0.71-RC.3]()

1. `cd NewArchitecture` - It has been created in this [step](https://github.com/react-native-community/RNNewArchitectureLibraries/tree/feat/back-turbomodule-070#tm-test).
2. `yarn add react-native@0.71.0-rc.3`

### <a name="update-podspec" />[[Setup] Update podspec]()

1. Open the `calculator/calculator.podspec` file
2. Update it as it follows:
```diff
require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

-folly_version = '2021.07.22.00'
-folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name            = "calculator"
  s.version         = package["version"]
  s.summary         = package["description"]
  s.description     = package["description"]
  s.homepage        = package["homepage"]
  s.license         = package["license"]
  s.platforms       = { :ios => "11.0" }
  s.author          = package["author"]
  s.source          = { :git => package["repository"], :tag => "#{s.version}" }

  s.source_files    = "ios/**/*.{h,m,mm,swift}"


+  install_modules_dependencies(s)
-  # This guard prevent to install the dependencies when we run `pod install` in the old architecture.
-  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
-      s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
-      s.pod_target_xcconfig    = {
-          "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
-          "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
-      }
-
-      s.dependency "React-Codegen"
-      s.dependency "RCT-Folly", folly_version
-      s.dependency "RCTRequired"
-      s.dependency "RCTTypeSafety"
-      s.dependency "ReactCommon/turbomodule/core"
-  end
end
```

### <a name="swift" />[[Swift] Add Swift files]()

1. Create a new file: `calculator/ios/calculator-Bridging-Header.h` with the following content
    ```c++
    //
    // Add the Objective-C headers that must imported by Swift files
    //
    #import <React/RCTBridgeModule.h>
    ```
    **Note:** This file is used to specify some headers files that the Swift code should be able to import. For this example, it will stay empty. However, it is required to properly build the project.
2. Create a new file `calculator/ios/Calculator.swift` with the implementation of the logic:
    ```swift
    import Foundation

    @objc(RNCalculator)
    class Calculator: NSObject {

      @objc(add:andB:withResolver:withRejecter:)
      func add(a: Int, b: Int, resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
        resolve(a+b);
      }
    }

    ```

### <a name="upadet-calculator" />[[iOS] Update Calculator file]()

1. Open the `calculator/ios/RNCalculator.mm` file and update the logic to invoke the Swift one
    ```diff
    - #import "RNCalculator.h"
    #ifdef RCT_NEW_ARCH_ENABLED
    #import "RNCalculatorSpec.h"
    #endif

    - @implementation RNCalculator
    -
    - RCT_EXPORT_MODULE(Calculator)
    + @interface RCT_EXTERN_MODULE(RNCalculator, NSObject)

    - RCT_REMAP_METHOD(add, addA:(NSInteger)a
    + RCT_EXTERN_METHOD(add:(NSInteger)a
                            andB:(NSInteger)b
                    withResolver:(RCTPromiseResolveBlock) resolve
                    withRejecter:(RCTPromiseRejectBlock) reject)
    - {
    -     NSNumber *result = [[NSNumber alloc] initWithInteger:a+b];
    -     resolve(result);
    - }

    - - (void)add:(double)a b:(double)b resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    -   NSNumber *result = @([Calculator addWithA:a b:b]);
    -   resolve(result);
    - }
    ```

2. Remove the `calculator/ios/RNCalculator.h` file

### <a name="test-swift" /> [[Test] Test the swift TurboModule]()

1. Navigate to the `NewArchitecture` root folder:
2. `yarn add ../calculator`
3. `cd ios`
4. `RCT_NEW_ARCH_ENABLED=1 bundle exec pod install`
5. `cd ..`
6. `yarn ios`
7. Click on Calculate and observe that the app is still working.

If you want to verify that the Swift code is invoked:
- Add a `print(">>> Calling from Swift")` statement in the `calculator/ios/Calculator.swift`.
- Open the `ios/NewArchitexture.xcworkspace` in Xcode.
- Run the app from Xcode.
- Observe the `>>> Calling from Swift` in the Xcode console.
