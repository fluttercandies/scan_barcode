part of 'config.dart';

class CameraConfig {
  const CameraConfig({
    this.isAutoFocus = true,
    this.clickToFocus = true,
    this.cameraControllerCreator = defaultCameraControllerCreator,
    this.camera,
    this.preset = ResolutionPreset.high,
  });

  final bool isAutoFocus;
  final bool clickToFocus;
  final CameraDescription? camera;
  final CameraControllerCreator cameraControllerCreator;
  final ResolutionPreset preset;

  CameraConfig copyWith({
    bool? isAutoFocus,
    bool? clickToFocus,
    CameraControllerCreator? cameraControllerCreator,
    CameraDescription? camera,
    ResolutionPreset? preset,
  }) {
    return CameraConfig(
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      clickToFocus: clickToFocus ?? this.clickToFocus,
      cameraControllerCreator:
          cameraControllerCreator ?? this.cameraControllerCreator,
      camera: camera ?? this.camera,
      preset: preset ?? this.preset,
    );
  }
}

Future<CameraController?> defaultCameraControllerCreator(
  CameraConfig config,
) async {
  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    return null;
  }

  CameraDescription? desc = config.camera;
  if (desc == null) {
    desc = cameras.first;
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        desc = camera;
        break;
      }
    }
  }

  return CameraController(
    desc!,
    config.preset,
    enableAudio: false,
  );
}
