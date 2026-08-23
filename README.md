# PAM Native 3D

## Start here

```bash
curl --proto '=https' --proto-redir '=https' --tlsv1.2 \
    --connect-timeout 15 --max-time 60 --max-filesize 1048576 -fsSL \
    https://github.com/push-in/pam/releases/latest/download/install.sh | sh
pam init my-app --template native
cd my-app
pam composer require pushinbr/pam-native-3d
pam doctor --fix
```

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
