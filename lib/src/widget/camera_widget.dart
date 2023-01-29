import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
    required this.onImageCaptured,
  }) : super(key: key);

  final Function(CameraDescription camera, CameraImage image) onImageCaptured;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;

  CameraController get controller => _controller!;

  late CameraDescription camera;

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    camera = cameras.first;

    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        this.camera = camera;
        break;
      }
    }

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();

    await controller.startImageStream((image) {
      widget.onImageCaptured(camera, image);
    });

    setState(() {
      isInit = true;
    });
  }

  var isInit = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await controller.stopImageStream();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInit) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: GestureDetector(
        onTapDown: (details) async {
          // // 对焦, point 是相对于屏幕的坐标
          // final x = details.localPosition.dx / context.size!.width;
          // final y = details.localPosition.dy / context.size!.height;
          // controller.setFocusPoint(Offset(x, y));

          // 自动对焦
          await controller.setFocusMode(FocusMode.locked);
          await controller.setFocusMode(FocusMode.auto);
        },
        child: CameraPreview(
          controller,
        ),
      ),
    );
  }
}
