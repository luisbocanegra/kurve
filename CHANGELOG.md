# Changelog

## [2.0.0](https://github.com/luisbocanegra/kurve/compare/v1.2.0...v2.0.0) (2025-09-21)


### ⚠ BREAKING CHANGES

* If you are using the equalizer feature you will need to enable it in the CAVA tab

### Features

* add option to disable EQ and disable it by default ([f6306b0](https://github.com/luisbocanegra/kurve/commit/f6306b02873c72448c0d380d819d3d09d4077155))
* allow to disable widget left click ([b247034](https://github.com/luisbocanegra/kurve/commit/b247034c4e69aa2c0711324aab4870cbee8f9879))
* cava&gt;=0.10.6 pipewire settings [input] virtual, active, remix, channel ([86d86e1](https://github.com/luisbocanegra/kurve/commit/86d86e103dd367d3e067185e6d96b86e1b70f330))
* raise maximum value for bar width and gap ([42945e0](https://github.com/luisbocanegra/kurve/commit/42945e04211d4d898c1493f7433981a033adadea))


### Bug Fixes

* stop cava from right click menu not working ([3d13183](https://github.com/luisbocanegra/kurve/commit/3d13183ed6a0080fd44ebf70751a58da8678e19c))

## [1.2.0](https://github.com/luisbocanegra/kurve/compare/v1.1.0...v1.2.0) (2025-08-07)


### Features

* button to copy support information ([ca4cc45](https://github.com/luisbocanegra/kurve/commit/ca4cc4525f25067af3ebdd23fc71d1446996733c))
* stop & start cava from widget settings ([f110161](https://github.com/luisbocanegra/kurve/commit/f110161af352c73d98c4b4c7d3d5b77edaace8c9))


### Bug Fixes

* read-only propery error ([76111fe](https://github.com/luisbocanegra/kurve/commit/76111fec3c86f9c772294181304823633d02d869))

## [1.1.0](https://github.com/luisbocanegra/kurve/compare/v1.0.0...v1.1.0) (2025-07-19)


### Features

* control cava sleep mode ([6cba407](https://github.com/luisbocanegra/kurve/commit/6cba407ad3ddea3857bd3e5a4f5809c78411c1e0))


### Bug Fixes

* source names with spaces getting truncated ([a7d861d](https://github.com/luisbocanegra/kurve/commit/a7d861d864e25acd5499523f05c2cfba6f28b2cc))
* widget resize starting multiple instances of cava in fallback mode ([98453a4](https://github.com/luisbocanegra/kurve/commit/98453a4211ebc87e670f5334e6929f0b985f3cb1))

## [1.0.0](https://github.com/luisbocanegra/kurve/compare/v0.4.0...v1.0.0) (2025-07-15)


### ⚠ BREAKING CHANGES

* make visualizer fit widget fixed/auto width/height
* Number of bars option has been disabled for the current visualizer styles (bars, wave), it's now is automatically calculated based on the widget width or height

### Features

* add option to disable widget tooltip ([330d335](https://github.com/luisbocanegra/kurve/commit/330d33503ff8d6df133009685f26d6c4a467c531))
* allow to change visualizer orientation ([a016c73](https://github.com/luisbocanegra/kurve/commit/a016c732a2ab75da4a1d754a75ad02c69e7553d3))
* control cava [input] sample_rate, sample_bits, channels, autoconnect ([a6f7617](https://github.com/luisbocanegra/kurve/commit/a6f76173ccf00fba0651ec4a357afd7824824f75))
* control cava [output] channels, mono channel, reverse frequencies ([094b6ab](https://github.com/luisbocanegra/kurve/commit/094b6ab830085a989a88d84db02d268af5b6444c))
* control cava equalizer ([63570e9](https://github.com/luisbocanegra/kurve/commit/63570e90d5dd6696503bf4024a9c6a4ab17335fb))
* control cava frequency range ([4e0ec29](https://github.com/luisbocanegra/kurve/commit/4e0ec2932618040cb14fa8785313ccdb9cbeda50))
* control cava input method and source ([e2f5a87](https://github.com/luisbocanegra/kurve/commit/e2f5a87cbf0a85563e0c9ba49e9a8d9a85cf2688))
* control cava sensitivity ([4582842](https://github.com/luisbocanegra/kurve/commit/4582842b723694d30520e1f999ecc627f2f3a5a2))
* make time to hide when idle configurable ([773616b](https://github.com/luisbocanegra/kurve/commit/773616b98a1c20d1b4397fa4904de069b5ded1fa))
* make visualizer fit widget fixed/auto width/height ([a256305](https://github.com/luisbocanegra/kurve/commit/a2563052da2e6636324e344de81e6ed7a4da5595))
* show ProcessMonitor loading errors ([37dfdba](https://github.com/luisbocanegra/kurve/commit/37dfdbab81397a2a54a71fbe4fe8e289a1d25546))
* support vertical panels ([a256305](https://github.com/luisbocanegra/kurve/commit/a2563052da2e6636324e344de81e6ed7a4da5595))


### Bug Fixes

* use versionless QML imports ([85a5244](https://github.com/luisbocanegra/kurve/commit/85a5244114965ca6ad9efa1b80ca03ed9ec9733f))

## [0.4.0](https://github.com/luisbocanegra/kurve/compare/v0.3.1...v0.4.0) (2025-06-30)


### Features

* rename project to 'Kurve' ([e9757f7](https://github.com/luisbocanegra/kurve/commit/e9757f70ce36129d686126910ba845df6710f94c))
* split configuration into tabs ([a8be687](https://github.com/luisbocanegra/kurve/commit/a8be68712fa80d1929ac5259afccfe91f79600b8))


### Bug Fixes

* typo in monstercat configuration option ([bb605fe](https://github.com/luisbocanegra/kurve/commit/bb605fe06231eb681e6a4dd32e0b7da1a13d6c90))

## [0.3.1](https://github.com/luisbocanegra/kurve/compare/v0.3.0...v0.3.1) (2025-06-29)


### Miscellaneous Chores

* release 0.3.1 ([8d243a5](https://github.com/luisbocanegra/kurve/commit/8d243a5bcb28f5e5539d1e72288db3bb44e41c34))

## [0.3.0](https://github.com/luisbocanegra/plasma-audio-visualizer/compare/v0.2.0...v0.3.0) (2025-06-29)


### Features

* debug mode ([86b7698](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/86b76987e78d272cad71d4b3ce657f4773718b41))
* display errors and support information in widget popup ([90b9df8](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/90b9df8f119e32ea7599dee0a9a1976c034a39ff))
* fallback to WebSocketServer if C++ plugin is not found ([57716cb](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/57716cb1dc95386f1b7e72f84007d69efc289094))
* show if cava is running and allow stopping/starting it ([2993dab](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/2993dab7739cd3cdbeba92653f60d589c69d97bb))
* update default configuration ([1edb732](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/1edb7322c0daf410ca97eb10e231530ee731c200))
* wave fill color ([87d8b4d](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/87d8b4d8623f6d0ed4420a4881e7dbf7a1133706))


### Bug Fixes

* blurry bars ([b5be93a](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b5be93a4e9e695286b254135c846eda140b20996))
* don't force WebSocketServer fallback by default ([8c17b0a](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/8c17b0a0c9f7a25fe29557b9e267e3a0e94d5f6c))
* force a minimum of two bars for wave and 1 for bar width ([b7f60e7](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b7f60e76a382c4616828c04de69ff5ed4f6b657a))
* improve wave pixel alignment ([b827d52](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b827d5217bb80df4302ebec7ef84857eaea73988))
* inverted gradient direction ([ab360ae](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/ab360aefb5229f98cb4a6f178a3b98b2e465c2ca))
* missing executable permission for the fallback commandMonitor ([3f99eb8](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/3f99eb8e1bd5b5320a5efc625bcae054a30ea67a))


### Performance Improvements

* create gradient once instead of on each paint ([4197892](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/4197892a8f6a36d8437c6e05697e6c8a8d67a754))

## [0.2.0](https://github.com/luisbocanegra/plasma-audio-visualizer/compare/v0.1.0...v0.2.0) (2025-06-29)


### Features

* debug mode ([86b7698](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/86b76987e78d272cad71d4b3ce657f4773718b41))
* display errors and support information in widget popup ([90b9df8](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/90b9df8f119e32ea7599dee0a9a1976c034a39ff))
* fallback to WebSocketServer if C++ plugin is not found ([57716cb](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/57716cb1dc95386f1b7e72f84007d69efc289094))
* show if cava is running and allow stopping/starting it ([2993dab](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/2993dab7739cd3cdbeba92653f60d589c69d97bb))
* update default configuration ([1edb732](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/1edb7322c0daf410ca97eb10e231530ee731c200))
* wave fill color ([87d8b4d](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/87d8b4d8623f6d0ed4420a4881e7dbf7a1133706))


### Bug Fixes

* blurry bars ([b5be93a](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b5be93a4e9e695286b254135c846eda140b20996))
* don't force WebSocketServer fallback by default ([8c17b0a](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/8c17b0a0c9f7a25fe29557b9e267e3a0e94d5f6c))
* force a minimum of two bars for wave and 1 for bar width ([b7f60e7](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b7f60e76a382c4616828c04de69ff5ed4f6b657a))
* improve wave pixel alignment ([b827d52](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/b827d5217bb80df4302ebec7ef84857eaea73988))
* inverted gradient direction ([ab360ae](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/ab360aefb5229f98cb4a6f178a3b98b2e465c2ca))
* missing executable permission for the fallback commandMonitor ([3f99eb8](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/3f99eb8e1bd5b5320a5efc625bcae054a30ea67a))


### Performance Improvements

* create gradient once instead of on each paint ([4197892](https://github.com/luisbocanegra/plasma-audio-visualizer/commit/4197892a8f6a36d8437c6e05697e6c8a8d67a754))
