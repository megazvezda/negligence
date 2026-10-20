#!/bin/bash


CON_IFACE=$(nmcli -t -f DEVICE,TYPE device | grep ':wifi' | cut -d: -f1 | head -n 1)

if [[ -z "$CON_IFACE" ]]; then
  echo "no wifi device found"
  exit 1
fi

credID=""
read -p "enter your student id: " credID
credPassword=""
read -s -p "enter your password: " credPass


echo "select the wifi network: "
networks=("eduroam" "VGTU" "VILNIUS TECH")

select SSID in "${networks[@]}"; do
	case "$SSID" in
		"eduroam")
			domain="vgtu.lt"
			anonID=$credID"@vilniustech.lt"
			username=$credID"@vilniustech.lt"
			break
			;;
		"VGTU")
			domain="vgtu.lt"
			anonID=$credID
			username=$credID
			break
			;;
		"VILNIUS TECH")
			domain="vilniustech.lt"
			anonID=$credID
			username=$credID
			break
			;;
		*)
			echo "invalid selection, enter a number from 1 to 3."
			;;
		esac
	done

nmcli connection delete id "$SSID" 2>/dev/null || true

nmcli connection add \
  type wifi \
  con-name "$SSID" \
  ifname "$CON_IFACE" \
  ssid "$SSID" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase2-auth mschapv2 \
  802-1x.anonymous-identity "$anonID" \
  802-1x.identity "$username" \
  802-1x.password "$credPass" \
  802-1x.domain-suffix-match "$domain" \
  802-1x.system-ca-certs no \
  802-1x.password-flags 0

nmcli con mod "$SSID" 802-1x.openssl-ciphers "DEFAULT@SECLEVEL=0"
nmcli con mod "$SSID" 802-1x.phase1-auth-flags 32

nmcli con up "$SSID"
