keyfinder_proto = Proto("KeyFinder", "KeyFinder")


PacketNo = ProtoField.new("Packet Number", "keyfinder.pktno", ftypes.UINT16)
KeyCount = ProtoField.new("Number of keys found", "keyfinder.keynum", ftypes.UINT8)

Cycles = ProtoField.new("Elapsed Cycles", "keyfinder.cycles", ftypes.BYTES)
Laps = ProtoField.new("Elapsed Laps", "keyfinder.laps", ftypes.UINT32)
PacketSize = ProtoField.new("Packet Size", "keyfinder.pktsize", ftypes.UINT16)

-- AES
AESKeyLen = ProtoField.new("AES Key Length", "aeskeyfinder.keysize", ftypes.UINT16)
AESKeyBitmap = ProtoField.new("KeySchedule Bitmap", "aeskeyfinder.keybitmap", ftypes.BYTES)
-- RSA
RSAKeyLen = ProtoField.new("RSA Key Length", "rsakeyfinder.keysize", ftypes.UINT16)
RSAFldLen = ProtoField.new("RSA Key Field Length", "rsakeyfinder.fieldlen", ftypes.UINT16)
-- ECDSA
ECDSAKeyLen = ProtoField.new("ECDSA Key Length", "ecdsakeyfinder.keysize", ftypes.UINT16)
ECDSAFldLen = ProtoField.new("ECDSA Key Field Length", "ecdsakeyfinder.fieldlen", ftypes.UINT16)
-- PKCS#8
PKCS8KeyLen = ProtoField.new("PKCS#8 Key Length", "pkcs8finder.keysize", ftypes.UINT16)
PKCS8FldLen = ProtoField.new("PKCS#8 Key Field Length", "pkcs8finder.fieldlen", ftypes.UINT16)

KeyAddr = ProtoField.new("Physical Address", "keyfinder.keyaddr", ftypes.BYTES)
KeyRaw = ProtoField.new("Raw Key", "keyfinder.keyraw", ftypes.BYTES)



keyfinder_proto.fields = {PacketNo, KeyCount, Cycles, Laps, PacketSize, AESKeyLen, AESKeyBitmap, RSAKeyLen, RSAFldLen, ECDSAKeyLen, ECDSAFldLen, PKCS8KeyLen, PKCS8FldLen, KeyAddr, KeyRaw}


function keyfinder_proto.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = "KeyFinder"

    local subtree = tree:add(keyfinder_proto, buffer())
    local buflen = buffer:captured_len()

    local key_data_offset = 2
    local key_count = 0
    local key_type = 0
    local length = 0


    subtree:add(PacketNo, buffer(0, 2))
    subtree:add(KeyCount, key_count)
    subtree:add(Cycles, buffer(buflen - 16, 8))
    subtree:add(Laps, buffer(buflen - 8, 4))
    subtree:add(PacketSize, buffer(buflen - 2, 2))


    local main_subtree = subtree:add("Key Information", buffer())


    while key_data_offset < buflen - 32 do
        local keytype = buffer(key_data_offset, 2):uint()

        if keytype == 0xa256 then
            length = 256
            key_type = 1
        elseif keytype == 0xa192 then
            length = 192
            key_type = 1
        elseif keytype == 0xa128 then
            length = 128
            key_type = 1
        elseif keytype == 0x8017 then
            length = 256
            key_type = 2
        elseif keytype == 0x5915 then
            length = 256
            key_type = 3
		elseif keytype == 0x5958 then
			length = 256
			key_type = 4
		end

        
        if key_type == 1 then
            local aes_subtree = main_subtree:add("AES Key", buffer(key_data_offset, length / 8))
            aes_subtree:add(AESKeyLen, length)
            aes_subtree:add(AESKeyBitmap, buffer(key_data_offset + 2, 2))
            aes_subtree:add(KeyAddr, buffer(key_data_offset + 11, 5))
            aes_subtree:add(KeyRaw, buffer(key_data_offset + 16, length / 8))
		elseif key_type == 2 then            
            local rsa_subtree = main_subtree:add("RSA Key", buffer(key_data_offset, length / 8))
            rsa_subtree:add(RSAKeyLen, length)
            rsa_subtree:add_le(RSAFldLen, buffer(key_data_offset + 2, 2))
            rsa_subtree:add(KeyAddr, buffer(key_data_offset + 11, 5))
            rsa_subtree:add(KeyRaw, buffer(key_data_offset + 16, length / 8))
		elseif key_type == 3 then            
            local ecdsa_subtree = main_subtree:add("ECDSA Key", buffer(key_data_offset, length / 8))
            ecdsa_subtree:add(ECDSAKeyLen, length)
            ecdsa_subtree:add_le(ECDSAFldLen, buffer(key_data_offset + 3, 1))
            ecdsa_subtree:add(KeyAddr, buffer(key_data_offset + 11, 5))
            ecdsa_subtree:add(KeyRaw, buffer(key_data_offset + 16, length / 8))
		elseif key_type == 4 then		
			local pkcs8_subtree = main_subtree:add("PKCS#8 Key", buffer(key_data_offset, length / 8))
			pkcs8_subtree:add(PKCS8KeyLen, length)
			pkcs8_subtree:add_le(PKCS8FldLen, buffer(key_data_offset + 2, 2))
			pkcs8_subtree:add(KeyAddr, buffer(key_data_offset + 11, 5))
			pkcs8_subtree:add(KeyRaw, buffer(key_data_offset + 16, length / 8))
		end
        key_data_offset = key_data_offset + (16 + length / 8)
        key_count = key_count + 1
    end


    if key_type == 1 then
        pinfo.cols.info = string.format("AES%d found! Key count=%d", length, key_count)
    elseif key_type == 2 then
        pinfo.cols.info = string.format("RSA found! Key count=%d", key_count)
    elseif key_type == 3 then
        pinfo.cols.info = string.format("ECDSA found! Key count=%d", key_count)		
	elseif key_type == 4 then
		pinfo.cols.info = string.format("PKCS#8 found! Key count=%d", key_count)		
	end

end


DissectorTable.get("ethertype"):add(0x7020, keyfinder_proto)

