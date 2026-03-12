# Project Structure

```plaintext
├── README.md
├── aeskeyfinder.lua    # Lua script for wireshark to interpret Periodic-AESKeyFinder packets
├── linux
└── windows
```


## aeskeyfinder.lua
<!-- 
WiresharkがPeriodic-AESKeyFinderの出力パケットを解析できるように、luaスクリプトをWiresharkプラグインのディレクトリに配置する必要があります。
luaスクリプトの置き場所は環境次第ですが、我々のUbuntu 22.04では、下記のパスでした。
-->
To allow Wireshark to analyze the output packets of Periodic-AESKeyFinder, you need to place the Lua script in Wireshark’s plugin directory.
The location of the Lua script depends on the environment, but on our Ubuntu 22.04 system, the path was as follows.
```plaintext
/usr/lib/x86_64-linux-gnu/wireshark/plugins
```

