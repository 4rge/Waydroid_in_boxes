<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Waydroid in Boxes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
            color: #333;
        }
        h2 {
            font-size: 2em;
            margin-top: 30px;
            margin-bottom: 15px;
            color: #555;
        }
        h3 {
            font-size: 1.5em;
            margin-top: 25px;
            margin-bottom: 10px;
            color: #777;
        }
        p {
            margin-bottom: 15px;
            color: #444;
        }
        code {
            background-color: #e8e8e8;
            padding: 2px 4px;
            border-radius: 4px;
            font-family: monospace;
        }
        pre {
            background-color: #e8e8e8;
            padding: 10px;
            border-radius: 5px;
            overflow-x: auto;
        }
        ul {
            margin-left: 20px;
            margin-bottom: 15px;
        }
        li {
            margin-bottom: 10px;
        }
        footer {
            margin-top: 30px;
            font-size: 0.85em;
            color: #666;
        }
    </style>
</head>
<body>

    <h1>Waydroid in Boxes</h1>
    <p>A README on how to set up an Arch Linux VM to run a Waydroid instance. (This README uses the Aurora Store in place of Google Play Store and services. For details on how to set up Waydroid GAPPS see the bottom of the README FIRST before starting the install, the INIT process is different.)</p>

    <h2>Setup</h2>
    <p>First, download an ISO of <a href="https://archlinux.org/download/">Arch Linux</a> and install Gnome Boxes by running:</p>
    <pre><code>sudo apt install gnome-boxes || sudo pacman -S gnome-boxes</code></pre>
    <p>Open Gnome Boxes and click the "+" in the top left, then select "Install from file."</p>
    <p>Select the Arch Linux ISO you just downloaded and give it 4GB RAM and 20GB disk space. Then boot.</p>

    <h2>Install</h2>
    <p>Once the VM has booted, run:</p>
    <pre><code>archinstall</code></pre>
    <p>When the menu appears, configure the Mirrors option. Next, select "Disk configuration" then "Partitioning" and "Use a best-effort default partition layout."</p>
    <p>Select the virtual drive and then, when prompted for the filesystem, select "XFS". You will be shown your config, just scroll down and hit "back."</p>
    <p>Set your user account name to "arch" (for simplicity of future scripts.)</p>
    <p>Set "Profile" type to "minimum" and hit "back."</p>
    <p>Set "Audio" to "pulsewire" and commit the change again with "back."</p>
    <p>Set "Network configuration" to "Copy ISO network configuration to installation."</p>
    <p>Set the Timezone and hit install.</p>

    <h2>Configure</h2>
    <p>Once the installation is complete, switch to the user Arch you just created by running:</p>
    <pre><code>su arch</code></pre>
    <p>Next, update and install the basic packages to build our toolchain; run:</p>
    <pre><code>sudo pacman -Syyu --needed base-devel git --noconfirm</code></pre>
    <p>Move to Arch's home directory via:</p>
    <pre><code>cd ~/</code></pre>
    <p>Now clone the package from the AUR using git by running the following command:</p>
    <pre><code>git clone https://aur.archlinux.org/yay.git</code></pre>
    <p>Then move into the yay folder and build the package by running:</p>
    <pre><code>cd yay && makepkg -si</code></pre>
    <p>Follow the prompts and, when asked, answer yes to if you want to "Clean Build."</p>
    <p>Now use yay to install our desktop environment by running:</p>
    <pre><code>yay -Syyu preload waydroid-git gdm cage xfce4-terminal --noconfirm</code></pre>
    <p>Enable the following services:</p>
    <pre><code>sudo systemctl enable systemd-oomd.service --now
sudo systemctl enable preload --now
sudo systemctl enable waydroid-container.service --now</code></pre>
    <p>It is ABSOLUTELY ESSENTIAL that you run the next two commands or your VM WILL NOT DISPLAY WAYDROID'S UI. To disable hardware acceleration in Waydroid run:</p>
    <pre><code>sudo sed -i 's/gbm/default/g' /var/lib/waydroid/waydroid_base.prop
sudo sed -i 's/mesa/swiftshader/g' /var/lib/waydroid/waydroid_base.prop</code></pre>
    <p>Now add Waydroid's startup to our bash profile so it starts at boot by running:</p>
    <pre><code>echo "waydroid session start" >> .profile</code></pre>

    <h2>Init</h2>
    <p>Now we will launch our greeter, which will force us to log back in as Arch and will start our Wayland session necessary to run Waydroid when we do:</p>
    <pre><code>sudo systemctl enable gdm --now</code></pre>
    <p>Then log back in.</p>
    <p>To download the Android system image and Lineage OS's vendor image run:</p>
    <pre><code>sudo waydroid --init</code></pre>
    <p>Start the Android session in the background:</p>
    <pre><code>waydroid session start &</code></pre>
    <p>Now we can install ARM support for apps by running:</p>
    <pre><code>git clone https://github.com/casualsnek/waydroid_script</code></pre>
    <p>When that is done:</p>
    <pre><code>cd waydroid_script</code></pre>
    <p>Then run:</p>
    <pre><code>python3 -m venv venv && venv/bin/pip install -r requirements.txt</code></pre>
    <p>Keep answering "y" to install all the dependencies, then run:</p>
    <pre><code>sudo venv/bin/python3 main.py</code></pre>
    <p>to launch the script. When open, select "Android 11", then select "Install" and pick "libndk" and "libhoudini".</p>

    <h2>The Aurora Store</h2>
    <p>Once in Waydroid, you will want to navigate to the built-in web browser and search for the exact string "apk pure aurora store 4.2.5".</p>
    <p>Halfway down the page will be a green link (screenshot); click to download and, when prompted, authorize the browser to save files to the device. Once the download has completed, click again on the grey "click here" link that offers to redownload if the first download failed and download the file again.</p>
    <p>Now click on the Android menu and select the downloaded APK (you will notice there is a .bin file that you downloaded the first time. You can remove that in "Files" before or after installing the APK), then grant permission to install files to the device to your browser.</p>
    <p>Install Aurora Store and launch it. When prompted, pick "Session Type" downloads and continue through the rest of the prompts. If you get stuck after granting permissions, just hit the in-app "back button" (not the Android back button), then hit "next" and "finish."</p>
    <p>Launch the Aurora Store. You will be prompted to upgrade the app. DON'T! IT WILL BREAK! Instead, ignore the update and select your login method (Google is not recommended. If you want full Google Play support, there is a similar but slightly more complicated process detailed at the bottom of the README) and begin installing your apps.</p>
    <p>When installing, it is important to remember that when Aurora is set to session type, APKs are first downloaded and then installed. Be prepared for longer than normal install times. If your app doesn't appear after install, reboot the VM.</p>

    <h2>Afterwards</h2>
    <p>Once your VM is set up with your preferred store, you can shut down the VM.</p>
    <p>Right-click on the VM and go to preferences, then lower the maximum memory from 4GB to 2.5GB.</p>
    <p>You can make a snapshot of the VM in its initial state under the snapshot tab, just in case something breaks.</p>
    <p>You can also clone this VM in the Boxes menu by right-clicking on the VM and selecting clone.</p>

    <p>NOTE: If you are using GAPPS, just remember Google tracks the machine ID, which will be identical if you clone the VM. If you want to run multiple GAPPS VMs, you need to manually install them or create a snapshot prior to the Waydroid init sequence, this way when you init each VM's image, they don’t end up with the same device ID.</p>

    <h3>GAPPS</h3>
    <p>During the Init process, step 2 change:</p>
    <pre><code>sudo waydroid --init</code></pre>
    <p>to:</p>
    <pre><code>sudo waydroid --init -S GAPPS</code></pre>
    <p>During the last command of the Init process, after selecting "Android 11", also select "microg" and when prompted, pick "UNLP". This will install a trimmed version of Google's Play Store.</p>
    <p>After installing microg, libndk, and libhoudini, run:</p>
    <pre><code>sudo venv/bin/python3 main.py</code></pre>
    <p>again and select the last option to get your device certified. Follow the instructions on screen to open the link in the new window, then copy the ID generated in the script to the box on the page, then prove you aren't a robot.</p>
    <p>Reboot. You will see a ton of notifications that your device is not protected by Play Protect. Ignore it. Skip the Aurora Store section of this walkthrough. It can take up to 10 minutes before you can sign into Google in the VM; however, when you do, go to "Settings" and select "Google", then "Sign in". Afterwards, go to the Play Store and update all apps; this will update Google Play Services to its current version.</p>
    
    <hr>
    <p>Note: The script <code>wib.sh</code> is only for vanilla Lineage OS; it does not have the ability to set up GAPPS for you. If you want, you can edit the script yourself to change <code>waydroid --init</code> to <code>waydroid --init -s GAPPS</code> and once the script is done, run:</p>
    <pre><code>sudo venv/bin/python3 main.py</code></pre>
    <p>again to proceed to the Google authentication step.</p>

    <footer>
        <p>&copy; 2023 Your Name. All rights reserved.</p>
    </footer>

</body>
</html>
