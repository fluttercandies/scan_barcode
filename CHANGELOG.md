# CHANGELOG

## 0.3.2

- 添加应用生命周期管理，优化相机资源使用  
  _Add application lifecycle management to optimize camera resource usage_
- 当应用进入后台时自动暂停相机，回到前台时恢复  
  _Automatically pause camera when app enters background and resume when back to foreground_
- 升级 Android Gradle 插件到 8.7.0  
  _Upgrade Android Gradle plugin to 8.7.0_
- 升级 Gradle 到 8.13  
  _Upgrade Gradle to 8.13_
- 更新 Android 构建配置，支持 Java 17 和 Kotlin 1.9.21  
  _Update Android build configuration to support Java 17 and Kotlin 1.9.21_
- 移除 example 中的 camera_android 显式依赖  
  _Remove explicit camera_android dependency in example_
- 更新 Android 目标 SDK 到 34  
  _Update Android target SDK to 34_

## 0.3.1

- Upgrade dependencies version.  
  _升级依赖版本。_

## 0.3.0

- Remove an unused field.  
  _移除未使用的字段。_
- Add `BarcodeController` to control the barcode scanner to start, stop handle barcodes.  
  _添加 `BarcodeController` 来控制条码扫描器开始、停止处理条码。_

## 0.2.1

- fix: A aspectRatio bug on `CameraImageWidget`.  
  _修复：`CameraImageWidget` 的 aspectRatio 错误。_
- Because the code is not compatible with 3.0.5, upgrade the constraints of flutter to 3.3.0  
  _由于代码与 3.0.5 不兼容，升级 flutter 的约束到 3.3.0_

## 0.2.0

- Bump version  
  _升级版本_

## 0.1.0

The first version.  
_第一个版本。_

- Base on [mlkit](https://developers.google.com/ml-kit/vision/barcode-scanning).  
  _基于 [mlkit](https://developers.google.com/ml-kit/vision/barcode-scanning)。_
- Support Android and iOS.  
  _支持 Android 和 iOS。_
- Support scan barcode and QR code.  
  _支持扫描条码和二维码。_
- Support scan multiple barcode and QR code.  
  _支持扫描多个条码和二维码。_
- Custom scan view.  
  _自定义扫描视图。_
