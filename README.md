# Custom Windows Deployment
This repo is a collection of custom configs/scripts that I have created to make deploying Windows as a technician a lot easier.

My config is based on the open-source multi-boot project called [Ventoy](https://github.com/ventoy/ventoy).  Ventoy makes it easy to boot multiple operating systems from a single USB. I have added my own tweaks to make deploying easier for myself and decided to upload it here to let others use my configs.

Please see the below notes explaining how my config works.

---

## Setup Instructions:
### 1. How to Setup a USB?
Before you can start using my config you will need to first prep a USB with the latest Ventoy build. The main developer over there has made this process very simple for users, You can download the latest release from [here](https://github.com/ventoy/Ventoy/releases).

As Ventoy already has some great documentation covering how to prep a USB I won't cover this here but you can check out the documentation for your respective OS [here](https://www.ventoy.net/en/doc_start.html)

**Please note that when installing Ventoy it will completely remove any data that is currently stored on it so please make sure that any data that you wish to keep is backed up correctly. As I will not be responsible for any data loss!**

If you are wanting test this config inside a virtual environment such as Hyper-V you can create a Virtual Disk (.vhd) and install Ventoy directly to that. (You will then need to modify the answer files to install to `<DiskID>1</DiskID>` instead as Disk `0` would be the booted VHD)

### 2. Adding Config to Ventoy.
After completing step 1 above you are now ready to copy my config to the USB.
You will then need to download this repo, you can use the green button located at the top of this page or using this [link](https://github.com/AdamKearn/windows-10-unattended-install/archive/refs/heads/master.zip).

Once you have downloaded the files you can then extract the ZIP onto the root of your USB drive.
You should end up with something looking like the below screenshot.

![](https://i.imgur.com/KnJw1CS.png)

### 3. Adding Operating Systems.
Now that the config files have been copied over to the USB, you are now ready to start adding operating systems.  My configs located in this repo are only for Windows 10 deployments but if you wanted to also deploy other operating systems on your USB drive you can. ([See Ventoy's supported images list](https://www.ventoy.net/en/isolist.html))

For windows deployments, you only need to drop your Windows ISO's into the `/images/Microsoft/` folder and the scripts/answer files will automatically be applied to the images.

If you wanted to include other images such as Linux ISOs or other bootable tools you can drop them into another folder and Ventoy will automatically detect them and allow booting.

e.g. `/images/linux/ubuntu-20.04.iso` or `/images/tools/clonezilla.iso`

### 4. Booting the USB
On most computers, you will need to disable secure boot if not already done so.
You should then be able to boot the USB and select the appropriate answer file.

As soon as the ISO is loaded into the system you will be presented with a prompt asking for the appropriate information. In my config, I only needed the computer to prompt for the computer name. If you need access to more information in your environment you can modify the `/scripts/edit_unattend.bat` file accordingly.

![](https://i.imgur.com/tJeiOGa.png)

As you can see from the image above it will show the MAC Address and Serial Number of the device you are booting off.

If the device **does not** have Bitlocker enabled it will also be able to extract the previous computer name directly from the registry. This can be helpful when re-installing Windows and you want to keep your previous naming conventions.

---

## Modifying my config for your own needs:
### Modifying the unattended answer file (XML)
If you need to make any modifications to my config such as setting a custom password for the local admin account you can access the answer files that are used in the `/images/Microsoft/unattended/` folder.  Here you should see two answer files `BIOS` and `UEFI`.

Please note that the XML files should only be modified using the Windows SIM tool. You can download this from the [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install).

Please note if you decide to create a new answer file you will have to also modify the `/ventoy/ventoy.json` file to include this XML file for unattended installs.

### Including custom programs/scripts.
If you are needing to also include some custom programs and scripts into the windows image you can drop any files into the `/scripts/C_ROOT/` folder and they will be transferred to the root of the `C:\` drive on the finished image.

For example, if you wanted to include your own RMM Client for managing the computers after deployment you could create a `temp` folder inside the `C_ROOT` folder and drop the installer in there. And modify the answer file to run the application/script. See the below example.

E.g. `/scripts/C_ROOT/temp/rmm_agent.exe` ==> `C:\temp\rmm_agent.exe`
```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <Order>1</Order>
        <CommandLine>cmd /c C:\temp\rmm_agent.exe /install /silent</CommandLine>
        <Description>Install RMM Agent</Description>
        <RequiresUserInput>false</RequiresUserInput>
    </SynchronousCommand>
</FirstLogonCommands>
```

Another example of deploying RMM Clients that I have implemented at my workplace is a way to deploy different RMM Clients depending on the device name.

Such as if you decided to call the device `SOUTH-HR-OFFICE` it will install the `SOUTH.exe` agent and if you call the device `NORTH-WORKSTATION` it would then install the `NORTH.exe` agent instead.

For this to work you will need to modify the `/scripts/edit_unattend.bat` file and include the below code at the end before the `:EOF` line.

```batch
:RMM_AGENT
for /f "tokens=1 delims=-" %%a in ("%PCNAME%") do (set site_name=%%a)
for /f "delims=" %%a in ('dir /s /b %ventoy%:\agents\%site_name%*.exe') do (copy "%%a" X:\scripts\C_ROOT\temp\rmm_agent.exe /y)
```

![](https://i.imgur.com/f3bz8Ts.png)

### Custom Start Menu / Taskbar layout.
In my generic config, I include a custom XML file that would remove all windows start tiles and only show Microsoft Edge and File Explorer in the taskbar.

If you wish to edit this you can edit the file located under `/scripts/C_ROOT/Windows/OEM/LayoutModification.xml`

For any modifications made to this file please refer to [Microsofts Documentation](https://docs.microsoft.com/en-us/windows/configuration/start-layout-xml-desktop)

---

Thanks for checking out my project.  If you have any questions or edits that you would like me to make to the config please let me know by posting a comment in the Issues section. [Link to issues](https://github.com/AdamKearn/windows-10-unattended-install/issues)

A special thanks to Longpanda as this would not have been possible without having [Ventoy](https://github.com/ventoy/ventoy).
