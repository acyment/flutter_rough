import 'package:flutter/material.dart';
import 'package:rough/rough.dart';

class DecorationExamplePage extends StatelessWidget {
  const DecorationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('RoughDecorator example')),
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            children: const <Widget>[
              NiceBox(),
              SizedBox(height: 32),
              HighlightedText(),
              SizedBox(height: 32),
              CircledIcon(),
              SizedBox(height: 32),
              SecretText(),
            ],
          ),
        ));
  }
}

class NiceBox extends StatelessWidget {
  const NiceBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RoughBoxDecoration(
          shape: RoughBoxShape.rectangle,
          borderStyle: const RoughDrawingStyle(
            width: 4,
            color: Colors.orange,
          ),
          filler: DotFiller(FillerConfig.build(hachureGap: 15, fillWeight: 10)),
          fillStyle: RoughDrawingStyle(
            width: 2,
            color: Colors.blue[100],
          )),
      child: const Text(
        'BoxDecorator\ndecorating\na nice\nbox with text',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: RoughBoxDecoration(
        shape: RoughBoxShape.rectangle,
        filler: ZigZagFiller(FillerConfig.defaultConfig
            .copyWith(hachureGap: 6, hachureAngle: 110)),
        fillStyle: RoughDrawingStyle(color: Colors.yellow[600], width: 6),
      ),
      child: const Text(
        'Text remarked with a highlighter',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CircledIcon extends StatelessWidget {
  const CircledIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: RoughBoxDecoration(
        shape: RoughBoxShape.circle,
        drawConfig: DrawConfig.build(
          roughness: 2,
          curveTightness: 0.1,
          curveFitting: 1,
          curveStepCount: 6,
        ),
        filler: SolidFiller(FillerConfig.defaultConfig),
        borderStyle: const RoughDrawingStyle(
          color: Colors.lightGreen,
          width: 6,
        ),
      ),
      child: const Icon(Icons.format_paint),
    );
  }
}

class SecretText extends StatelessWidget {
  const SecretText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 18),
        text: 'This text has a ',
        children: <InlineSpan>[
          WidgetSpan(
              child: Container(
            decoration: RoughBoxDecoration(
                shape: RoughBoxShape.rectangle,
                drawConfig: DrawConfig.build(),
                filler: HatchFiller(FillerConfig.build(
                  hachureAngle: 20,
                  hachureGap: 5,
                  drawConfig: DrawConfig.build(roughness: 3),
                )),
                fillStyle: const RoughDrawingStyle(
                  color: Colors.brown,
                  width: 2,
                )),
            child: const Text(
              'secret text',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          )),
          const TextSpan(text: ' that you can not read'),
        ],
      ),
    );
  }
}
