#Script to scan for networks

switch="0"
time=60
rm -rf scan1
mkdir scan1
chmod 777 scan1
cd scan1

sudo airmon-ng start wlan1
sudo iwconfig > iwconfig.txt

grep Monitor iwconfig.txt > monitor.txt
cut -b 29-35 monitor.txt > new.txt
echo "Monitor" > test.txt
diff new.txt test.txt > check.txt

if [ -s check.txt ]
then
	switch = "1"
else
	echo "Monitor mode activated!"
	sleep 10
fi

cd ..
airmon-ng start wlan1

if [ $switch == 1 ]
then
	echo "Abort mission..."
else
	rm -f bigData-01.csv
	timeout $time sudo airodump-ng -w bigData --output-format csv wlan1
	chmod 777 bigData-01.csv
	echo "Your data file has been created in the CapstoneApplication/app directory"
	echo "Select the WiFi you wish to attack..."
	#scp m212442@172.20.10.9:/user/kali/scripts/bigData-01.csv data.csv
fi
