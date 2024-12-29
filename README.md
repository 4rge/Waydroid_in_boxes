# Waydroid_in_boxes
A readme on how to setup an arch linux vm to run a waydroid instance.
(This readme uses the Aurora Store in place of google play store and services. For details on how to set up waydroid GAPPS see the bottom of the readme FIRST before starting the install, the INIT process is different.)

<h2>Setup</h2>
First, download an iso of <a href="https://archlinux.org/download/">ArchLinux</a> and install GnomeBoxes by running</br><pre><code>sudo apt install gnome-boxes || sudo pacman -S gnome-boxes</code></pre>
Open Gnome Boxes and click the "+" in the top left, then select "Install from file."</br>
Select the ArchLinux.iso you just downloaded and give it 4GB ram and 20GB disk spacei. Then boot.</br>

<h2>Install</h2>
Once the vm has booted run<pre><code>archinstall</code></pre>
When the menu appears configure the Mirrors option.</br>
Next select "Disk configuration" then "Partioning" and "Use a best-effort default partition layout."</br>
Select the virtual drive and then when prompted for the filesystem select "XFS". You will be shown your config, just scroll down and hit "back."</br>
Set your user account name to "arch" (for simplicity of future scripts.)</br>
Set "Profile" type to "minimum" and hit "back."</br>
Set "Audio" to "pulsewire" and commit the change again with "back."</br>
Set "Network configuration" to "Copy ISO network configuration to installation."</br>
Set the Timezone and hit install.</br>

<h2>Configure</h2>
Once the installation is complete switch to the user Arch you just created by running<code><pre>su arch</code></pre>
Next update and install the basic packages to build our toolchain; run<code><pre>sudo pacman -Syyu --needed base-devel git --noconfirm</code></pre>
Move to Arch's home directory via<code><pre>cd ~/</code></pre>
Now clone the package from the aur using git by running the following command<code><pre>git clone https://aur.archlinux.org/yay.git</code></pre>
Then move into the yay folder and build the package by running<code><pre>cd yay && makepkg -si</code></pre> Follow the prompts and when asked answer yes to if you want to "Clean Build".</br>
Now use yay to install our desktop environment by running<code><pre>yay -Syyu preload waydroid-git gdm cage xfce4-terminal --noconfirm</code></pre>
Enable the following services<code><pre>sudo systemctl enable systemd-oomd.service --now
sudo systemctl enable preload --now
sudo systemctl enable waydroid-container.service --now
</code></pre>
It is ABSOLUTELY ESSENTIAL that you run the next two commnds or your vm WILL NOT DISPLAY WAYDROID'S UI. To disable hardware acceleration in waydroid run<code><pre>sudo sed -i 's/gbm/default/g' /var/lib/waydroid/waydroid_base.prop
sudo sed -i 's/mesa/swiftshader/g' /var/lib/wydroid/waydroid_base.prop</code></pre>
Now add waydroid's startup to our bash profile so it starts at boot by running<code><pre>echo "waydroid session start" >> .profile</code></pre>

<h2>Init</h2>
Now we will launch our greeter, which will force us to log back in as Arch and will start our wayland session necessary to run waydroid when we do. <code><pre>sudo systemctl enable gdm --now</code></pre> Then log back in.</br>
To download the android system image and lineage os's vendor image run <code><pre>sudo waydroid --init</pre></code>
Start the android session in the background. <code><pre>waydroid session start &</code></pre>
Now we can install arm support for apps by running <code><pre>git clone https://github.com/casualsnek/waydroid_script</code></pre>
When that is done<code><pre>cd waydroid_script</code></pre> Then run<code><pre>python3 -m venv venv && venv/bin/pip install -r requirements.txt</code></pre>Keep answering "y" to install all the depends then run<code><pre>sudo venv/bin/python3 main.py</code></pre>to launch the script.</br>
When open select "Android 11", then select "Install" and pick "libndk" and "libhoudini".</br>

<h2>The Aurora Store</h2>
Once in waydroid you will want to navigate to the built in web browser and search for the exact string "apk pure aurora store 4.2.5"</br>
Halfway down the page will be a green link (screenshot) click to download and when prompted authorize the browser to save files to the device. Once the download has completed click again on the grey "click here" link that offers to redownload if the first download failed and download the file again.</br>
Now click on the android menu and select the downloaded apk (you will notice there is a .bin file that you downloaded the first time. You can remove that in "Files" before or after installing the apk) then grant permission to install files to device to your browser.</br>
Install aurora store and launch it. When prompted pick "Session Type" downloads and continue through the rest of the prompts. If you get stuck after granting permissions just hit the in-app "back button" (not the android back button) then hit "next" and "finish."</br>
Launch the Aurora store. You will be prompted to upgrade the app DON'T! IT WILL BREAK! Instead ignore the update and select your login method (Google is not recommended. If you want full google play support there is a simular but slightly more complicated process detailed at the bottom of the README.) and begin installing your apps.
When installing it is important to remember when Aurora is set to session type apks are first downloaded and then installed. Be prepared for longer then normal install times. If your app dosen't appear after install reboot the vm.</br>

<h2>Afterwards</h2>
Once your vm is setup with your prefered store you can shut down the vm.</br>
Right click on the vm and go to prefrences, then lower the maximum memory from 4GB to 2.5GB.</br>
You can make a snapshot of the vm in it's inital state under the snapshot tab, just in case something breaks.</br>
You can also clone this vm in the Boxes menu by right clicking on the vm and selecting clone.</br>

NOTE: If you are using GAPPS just remember google tracks the machine id, which will be identical if you clone the vm. If you want to run multiple GAPPS vm's you need to manually install them or create a snapshot prior the waydroid init sequence, this way when you init each vm's image they dont end up with the same device id.</br>
</br>
</hr>
<h3>GAAPS</h3>
During the Init process, step 2 change<code><pre>sudo waydroid --init</code></pre> to <code><pre>sudo waydroid --init -S GAPPS</code></pre>
During the last command of the Init process after selecting "Android 11" also select "microg" and when prompted pick "UNLP". This will install a trimmed verson of googles play store.</br>
After installing microg, libndk and libhoudini run<code><pre>sudo venv/bin/python3 main.py</code></pre> again and select the last option to get your device certified. Follow the instructions on screen to open the link in the new window then copy the id generated in the script to the box on the page then prove you aren't a robot.</br>
Reboot. You will see a ton of notifications that your device is not protected by play protect. Ignore it. Skip the Aurora Store section of this walk through. It can take up to 10 min before you can sign into google in the vm, however when you do go to "Settings" and select "Google" then "Sign in". Afterwards go to the play store and update all apps, this will update google play services to it's current version.</br>
<hr>
Note: The script wib.sh is only for vanilla lineage os, it does not have the ability to set up GAPPS for you. If you want you can edit the script yourself to change waydroid --init to waydroid --init -s GAPPS and once the script is done run <pre><code>sudo venv/bin/python3 main.py</code></pre> again to proceede to the google authentication step.
