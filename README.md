# Waydroid in Boxes

A README on how to set up an Arch Linux VM to run a Waydroid instance. (This README uses the Aurora Store in place of Google Play Store and services. For details on how to set up Waydroid GAPPS see the bottom of the README FIRST before starting the install, the INIT process is different.)

## Setup

First, download an ISO of [Arch Linux](https://archlinux.org/download/) and install Gnome Boxes by running:

```bash
sudo apt install gnome-boxes || sudo pacman -S gnome-boxes
Open Gnome Boxes and click the "+" in the top left, then select "Install from file." Select the Arch Linux ISO you just downloaded and give it 4GB RAM and 20GB disk space. Then boot.
Install
Once the VM has booted, run:
archinstall
When the menu appears, configure the Mirrors option. Next, select "Disk configuration" then "Partitioning" and "Use a best-effort default partition layout."
Select the virtual drive and then, when prompted for the filesystem, select "XFS". You will be shown your config, just scroll down and hit "back."
Set your user account name to "arch" (for simplicity of future scripts.)
Set "Profile" type to "minimum" and hit "back."
Set "Audio" to "pulsewire" and commit the change again with "back."
Set "Network configuration" to "Copy ISO network configuration to installation."
Set the Timezone and hit install.
Configure
Once the installation is complete, switch to the user Arch you just created by running:
su arch
Next, update and install the basic packages to build our toolchain; run:
sudo pacman -Syyu --needed base-devel git --noconfirm
Move to Arch's home directory via:
cd ~/
Now clone the package from the AUR using git by running the following command:
git clone https://aur.archlinux.org/yay.git
Then move into the yay folder and build the package by running:
cd yay && makepkg -si
Follow the prompts and, when asked, answer yes to if you want to "Clean Build."
Now use yay to install our desktop environment by running:
yay -Syyu preload waydroid-git gdm cage xfce4-terminal --noconfirm
Enable the following services:
sudo systemctl enable systemd-oomd.service --now
sudo systemctl enable preload --now
sudo systemctl enable waydroid-container.service --now
It is ABSOLUTELY ESSENTIAL that you run the next two commands or your VM WILL NOT DISPLAY WAYDROID'S UI. To disable hardware acceleration in Waydroid run:
sudo sed -i 's/gbm/default/g' /var/lib/waydroid/waydroid_base.prop
sudo sed -i 's/mesa/swiftshader/g' /var/lib/waydroid/waydroid_base.prop
Now add Waydroid's startup to our bash profile so it starts at boot by running:
echo "waydroid session start" >> .profile
Init
Now we will launch our greeter, which will force us to log back in as Arch and will start our Wayland session necessary to run Waydroid when we do:
sudo systemctl enable gdm --now
Then log back in.
To download the Android system image and Lineage OS's vendor image run:
sudo waydroid --init
Start the Android session in the background:
waydroid session start &
Now we can install ARM support for apps by running:
git clone https://github.com/casualsnek/waydroid_script
When that is done:
cd waydroid_script
Then run:
python3 -m venv venv && venv/bin/pip install -r requirements.txt
Keep answering "y" to install all the dependencies, then run:
sudo venv/bin/python3 main.py
to launch the script. When open, select "Android 11", then select "Install" and pick "libndk" and "libhoudini".
The Aurora Store
Once in Waydroid, you will want to navigate to the built-in web browser and search for the exact string "apk pure aurora store 4.2.5".
Halfway down the page will be a green link (screenshot); click to download and, when prompted, authorize the browser to save files to the device. Once the download has completed, click again on the grey "click here" link that offers to redownload if the first download failed and download the file again.
Now click on the Android menu and select the downloaded APK (you will notice there is a .bin file that you downloaded the first time. You can remove that in "Files" before or after installing the APK), then grant permission to install files to the device to your browser.
Install Aurora Store and launch it. When prompted, pick "Session Type" downloads and continue through the rest of the prompts. If you get stuck after granting permissions, just hit the in-app "back button" (not the Android back button), then hit "next" and "finish."
Launch the Aurora Store. You will be prompted to upgrade the app. DON'T! IT WILL BREAK! Instead, ignore the update and select your login method (Google is not recommended. If you want full Google Play support, there is a similar but slightly more complicated process detailed at the bottom of the README) and begin installing your apps.
When installing, it is important to remember that when Aurora is set to session type, APKs are first downloaded and then installed. Be prepared for longer than normal install times. If your app doesn't appear after install, reboot the VM.
Afterwards
Once your VM is set up with your preferred store, you can shut down the VM.
Right-click on the VM and go to preferences, then lower the maximum memory from 4GB to 2.5GB.
You can make a snapshot of the VM in its initial state under the snapshot tab, just in case something breaks.
You can also clone this VM in the Boxes menu by right-clicking on the VM and selecting clone.
NOTE: If you are using GAPPS, just remember Google tracks the machine ID, which will be identical if you clone the VM. If you want to run multiple GAPPS VMs, you need to manually install them or create a snapshot prior to the Waydroid init sequence; this way, when you init each VM's image, they don’t end up with the same device ID.
GAPPS
During the Init process, step 2 change:
sudo waydroid --init
to:
sudo waydroid --init -S GAPPS
During the last command of the Init process, after selecting "Android 11", also select "microg" and when prompted, pick "UNLP". This will install a trimmed version of Google's Play Store.
After installing microg, libndk, and libhoudini, run:
sudo venv/bin/python3 main.py
again and select the last option to get your device certified. Follow the instructions on screen to open the link in the new window, then copy the ID generated in the script to the box on the page, and then prove you aren't a robot.
Reboot. You will see a ton of notifications that your device is not protected by Play Protect. Ignore it. Skip the Aurora Store section of this walkthrough. It can take up to 10 minutes before you can sign into Google in the VM; however, when you do go to "Settings" and select "Google", then "Sign in". Afterwards, go to the Play Store and update all apps; this will update Google Play Services to its current version.
Note: The script wib.sh is only for vanilla Lineage OS; it does not have the ability to set up GAPPS for you. If you want, you can edit the script yourself to change waydroid --init to waydroid --init -s GAPPS and once the script is done, run:
sudo venv/bin/python3 main.py
again to proceed to the Google authentication step.

### Summary
The above Markdown code represents the entire provided content, formatted appropriately for a Markdown file. Copy and paste this into a file with a `.md` extension, and it should display correctly in any Markdown viewer or editor. If you need any changes or additional sections, let me know!
