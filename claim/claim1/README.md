# Claim 1
<!--
ここでは、論文のセクション4.3で示した設計が特定のFPGAボードに対して実装可能なファイルを揃えていることを示します。
runスクリプトは3つのFPGAボードごとに用意し、VivadoがなくてもGitHubのActionsタブから結果を確認できるようにしました。
-->
Here, we demonstrate that the design presented in Section 4.3 of the paper includes all necessary files to be implemented on specific FPGA boards.  
Run scripts are provided for each of the three FPGA boards, and even without Vivado installed, the results can be reviewed via the GitHub Actions tab.  




# expected
<!--
KR260の場合、下記のファイルが出力されていればFPGAのビットストリームが生成されたと確認できます。
KR260/KR260_Periodic-AESKeyFinder/KR260_Periodic-AESKeyFinder.runs/impl_1/design_1_wrapper.bit
それ以外のボードの場合はKR260をボード名に置き換えてください。

結果は、VvivadoでImplementationを実行し、Utilizationレポートを確認し、表5から7の結果にほぼ一致することが確認できます。
UtilizationレポートはKR260/KR260_Periodic-AESKeyFinder/KR260_Periodic-AESKeyFinder.runs/impl_1/design_1_wrapper_utilization_placed.rptのパスに存在し、Actionsでは「Run script」の最後に表示しています。
-->
For the KR260 board, the FPGA bitstream is considered successfully generated if the following file is produced:  
`KR260/KR260_Periodic-AESKeyFinder/KR260_Periodic-AESKeyFinder.runs/impl_1/design_1_wrapper.bit`  

For other boards, replace `KR260` with the corresponding board name.  

The results can be verified by running the implementation in Vivado, checking the utilization report, and confirming that they closely match the results shown in Tables 5–7.  
The utilization report is located at:  
`KR260/KR260_Periodic-AESKeyFinder/KR260_Periodic-AESKeyFinder.runs/impl_1/design_1_wrapper_utilization_placed.rpt`  
In GitHub Actions, this report is displayed at the end of the “Run script” step.  
