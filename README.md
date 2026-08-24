<!-- pam:product-page:start -->
<div align="center">

# PAM Native 3D

**Native 3D scenes without moving a render loop through PHP.**

Render product previews, animated models, and immersive native scenes through Filament on Android and RealityKit on iOS.

[![Latest version](https://img.shields.io/packagist/v/pushinbr/pam-native-3d?style=flat-square&label=stable)](https://packagist.org/packages/pushinbr/pam-native-3d)
[![CI](https://img.shields.io/github/actions/workflow/status/push-in/pam-native-3d/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/push-in/pam-native-3d/actions)
![PHP](https://img.shields.io/badge/PHP-8.5-777BB4?style=flat-square&logo=php&logoColor=white)
![Android](https://img.shields.io/badge/Android-API%2026%2B-3DDC84?style=flat-square&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-15%2B-000000?style=flat-square&logo=apple&logoColor=white)

**[Documentation](https://push-in.github.io/pam-docs/native/overview/) · [Quick start](#quick-start) · [What you can build](#what-you-can-build) · [PAM ecosystem](https://push-in.github.io/pam-docs/ecosystem/) · [Issues](https://github.com/push-in/pam-native-3d/issues)**

</div>

---

## Why PAM Native 3D

Render product previews, animated models, and immersive native scenes through Filament on Android and RealityKit on iOS. The public API is strictly typed for PHP 8.5; expensive or frame-sensitive work stays in Rust or the platform SDK instead of crossing the application boundary every frame.

| | |
| --- | --- |
| **Best for** | A focused capability you can add to any PAM Native application |
| **Native path** | Google Filament · RealityKit |
| **Application model** | Composer package + generated native integration |
| **Design rule** | Independent module; no feed, vertical, or application template bundled |

## What you can build

- Interactive product and property previews
- Animated characters, education, and data visualization
- High-fidelity 3D surfaces embedded in ordinary native screens

## Quick start

Already have a PAM Native project? Add only this capability:

```bash
pam composer require pushinbr/pam-native-3d
pam doctor --fix
```

New to PAM? Follow the **[five-minute PAM Native setup](https://push-in.github.io/pam-docs/native/overview/)** once, then return here. Your application stays a normal Composer project with a committed lockfile.
<!-- pam:product-page:end -->

## See it in action

This package renders a real-time 3D asset with Google Filament on Android and RealityKit on iOS.
It is independent from canvas, raw GPU shaders, AR, games, and application templates. Render and
animation loops remain native.

```php
use Pam\Native\ThreeD\Scene3D;
use Pam\Native\ThreeD\SceneAsset;

return Scene3D::make(new SceneAsset(
    androidGlb: 'models/robot.glb',
    iosUsdz: 'models/robot.usdz',
    animation: 0,
));
```

Assets are application-sandbox relative: GLB on Android and USDZ on iOS. Use an asset pipeline to
generate both formats from one source model. Platform support: Android API 26+, iOS 15+, PHP 8.5+,
and PAM Native 0.8.x. Filament is Apache-2.0 licensed.

- [PAM introduction](https://push-in.github.io/pam-docs/introduction/)
- [PAM Native overview](https://push-in.github.io/pam-docs/native/overview/)
- [Report an issue](https://github.com/push-in/pam-native-3d/issues)
