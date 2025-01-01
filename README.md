# Waydroid Installation Script

This script automates the installation and configuration of Waydroid, a project that allows you to run Android in a container on a Linux system, specifically Arch Linux. The script will set up necessary dependencies, install Waydroid and related components, and guide you through the initial setup process.

## Prerequisites

- An Arch Linux system
- Root privileges (you may need to use `sudo`)
- Internet connection

## Usage

1. **Clone the Repository**: You can either save the script in a file and run it or copy the commands from the script to your terminal.

2. **Run the Script**: Execute the script as follows:
   ```sh Waydroid_in_boxes/wib.sh```

## Script Breakdown

### Updates and Installations
- The script switches to the `arch` user.
- Updates the package database and installs required packages (`base-devel`, `git`, etc.).
- Clones and installs `yay`, an AUR helper.
- Uses `yay` to install `preload`, `waydroid`, `gdm`, `cage`, and `xfce4-terminal`.

### Service Configuration
- Enables and starts various system services including:
  - `systemd-oomd.service`
  - `preload`
  - `waydroid-container.service`
  - `gdm`

### Waydroid Initialization
- Modifies Waydroid properties for compatibility.
- Initializes Waydroid and starts a session.

### Aurora Store Installation
- Clones a GitHub repository that provides additional functionalities for Waydroid.
- Sets up a Python virtual environment and installs requirements.

### User Instructions
- Prompts you to select specific options during the installation process of Android.
- Provides further instructions on how to download and install the Aurora Store within Waydroid.

## Important Notes
- The script modifies some system configurations; make sure you understand the changes before running it.
- Ensure you have backups of important data, especially in case changes lead to an unexpected system state.
- This script has been tailored for Arch Linux; use with caution on other distributions.

## Troubleshooting
If you encounter any issues:
- Ensure your system is fully updated before running the script.
- Check the output logs for any error messages.
- Consult the respective documentation for any of the tools or packages that are being installed.

## License
This project is licensed under the fuckit_idc-license.

## Contributing
Feel free to fork this repository and submit pull requests. For any major issues, please open an issue for discussion before submitting contributions.
