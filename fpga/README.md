# Periodic-AESKeyFinder のソースコード

`KeyFinder` ディレクトリには、Periodic-AESKeyFinder の IP コアを構成する Verilog ソースコードが含まれています。  
`KR260`、`AXKU062`、`AXKU3` の各ディレクトリには、それぞれ我々が試した FPGA ボードごとのプロジェクトが含まれています。  

プロジェクトは **「mkproj」で始まる Tcl スクリプト** で記述しています。  
これらのコードは **Vivado v2023.2.2** で利用可能です。  

---

# KR260 プロジェクトの生成と Vivado プロジェクトモード起動

```bash
cd ./KR260
vivado -source mkproj_KR260_Periodic-AESKeyFinder.tcl

---

# Build方法

プロジェクトを既に開いている場合は、Flow NavigatorからIMPLEMENTATIONメニューの「Run Implementation」を実行してください。

プロジェクトの生成からビルドまで一気に実行するスクリプトも用意しました。
以下のコマンドはKR260のプロジェクトを生成し、FPGAのImplementationまで実行するコマンドです。

```bash
cd ./KR260
vivado -source build.tcl


