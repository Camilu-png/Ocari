#!/bin/bash
# Ejecuta este script desde la raíz de tu proyecto Ocari
# cd /ruta/a/tu/proyecto/Ocari && bash fix_gitignore.sh

cat > .gitignore << 'GITIGNORE'
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.build/
.buildlog/
.history
.svn/
.swiftpm/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# iOS CocoaPods
ios/Pods/
ios/Podfile.lock
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
ios/.symlinks/
ios/Flutter/Debug.xcconfig
ios/Flutter/Release.xcconfig
ios/Flutter/Generated.xcconfig
ios/Flutter/flutter_export_environment.sh

# macOS CocoaPods
macos/Pods/
macos/Podfile.lock
macos/.symlinks/
macos/Flutter/Flutter-Debug.xcconfig
macos/Flutter/Flutter-Release.xcconfig
macos/Flutter/GeneratedPluginRegistrant.swift

# Linux generated
linux/flutter/generated_plugin_registrant.cc
linux/flutter/generated_plugins.cmake

# Windows generated
windows/flutter/generated_plugin_registrant.cc
windows/flutter/generated_plugins.cmake

# Dart generated
lib/generated_plugin_registrant.dart
GITIGNORE

echo "✓ .gitignore reescrito correctamente"

# Limpiar caché de git y re-agregar solo lo que corresponde
git rm -r --cached .
git add .

echo ""
echo "Archivos que quedarán en el commit:"
git status --short

echo ""
echo "Listo. Revisá que no aparezcan archivos generados arriba."
echo "Si todo se ve bien, ejecutá:"
echo "  git commit -m 'chore(repo): corregir .gitignore y limpiar archivos generados'"