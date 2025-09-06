# Periodic-AESKeyFinderのソースコード

KeyFinderディレクトリには、Periodic-AESKeyFinderのIPコアを構成するVerilogソースコードが含まれています。
KR260、AXKU062、AXKU3のディレクトリは、それぞれ我々が試したFPGAボードごとのプロジェクトが含まれるディレクトリです。
プロジェクトは「mkpoj」で始まるTclスクリプトで記述しています。

下記はKR260のプロジェクトを生成してVivadoのプロジェクトモードに入るコマンドです。

cd ./KR260
vivado -source mkproj_KR260_Periodic-AESKeyFinder.tcl


# Build方法

Vivado v2023.2.2 でビルドできます。
プロジェクトを既に開いている場合は、Flow NavigatorからIMPLEMENTATIONメニューの「Run Implementation」を実行してください。

プロジェクトの生成からビルドまで一気に実行するスクリプトも用意しました。
以下のコマンドはKR260のプロジェクトを生成し、FPGAのImplementationまで実行するコマンドです。

cd ./KR260
vivado -source build.tcl

