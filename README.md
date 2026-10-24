# negligence

This shell script will help Linux users connect to "eduroam", "VGTU", "VILNIUS TECH" without configuring the [network settings](https://vilniustech.lt/en/itsc/it-services/wifi/) for each instance.

## to use
```bash
# install eduroam.sh file and make it executable
chmod +x eduroam.sh
# and run it
./eduroam.sh
```


<details>  
  <summary>click to see the poster image</summary>    
  <div class="image-container">    
  <img width="480" height="640" alt="Untitled" src="https://github.com/user-attachments/assets/332c6eae-a9c5-48c9-8851-d50001a66f5f" />
  </div>    
</details>

[QArt Coder](https://research.swtch.com/qr/draw/) was used to generate the "qr-kot" for the poster



### why it doesn't work by default

Vilnius Tech (VGTU) still uses TLS 1.1 for their wifi and I have no idea why. Modern Linux distributions reject anything below TLS 1.2, you won't connect to any of them without a hassle. The solution is to turn off the policy for those specific instances

### how to reproduce
Thanks to Gleb K. for finding this solution
```bash
# lower the security level for this connection profile to accept >= TLS 1.0
nmcli con mod [wifiName] 802-1x.openssl-ciphers "DEFAULT@SECLEVEL=0"

# 32 is a decimal value of a flag 0x20 "TLS_1_0_ENABLE"
nmcli con mod [wifiName] 802-1x.phase1-auth-flags 32
```
