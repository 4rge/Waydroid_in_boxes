#!/usr/env sh

su arch
sudo pacman -Syyu --needed base-devel git --noconfirm
cd ~/
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -Syyu preload waydroid gdm cage xfce4-terminal --noconfirm
sudo systemctl enable systemd-oomd.service --now
sudo systemctl enable preload --now
sudo systemctl enable waydroid-container.service --now
sudo sed -i 's/gbm/default/g' /var/lib/waydroid/waydroid_base.prop
sudo sed -i 's/mesa/swiftshader/g' /var/lib/waydroid/waydroid_base.prop
sudo systemctl enable gdm --now
sudo waydroid init
waydroid session start
git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv && venv/bin/pip install -r requirements.txt

echo "When the script launches select 'Android 11'\nThen 'Install'\nFinally select 'libndk and libhoudini"
read -p "Understood?" yn
sudo venv/bin/python3 main.py
echo "waydroid session start\nwaydroid show-full-ui" >> .profile
echo "Once in waydroid you will want to navigate to the built in web browser and search for the exact string 'apk pure aurora store 4.2.5.'\nHalfway down the page will be a green link saying something like 'click to download;' click it.\nWhen prompted authorize the browser to save files to the device\nOnce the download has completed click on the android menu and select the downloaded apk then grant permission to install files to device (the first dl is a bin, the second is an apk, dl it twice and install the apk then delete the bin in files if you want)\nInstall aurora store, when prompted pick 'session type' downloads\nIf you get stuck after granting permissions just hit the in-app 'back button' (not the android back button) then hit 'next' and 'finish'"
read -P "Hit y when done" yn
