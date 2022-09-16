
# Details of the test environment
### Vagrant version

```bash
$ vagrant version
Installed Version: 2.3.0
Latest Version: 2.3.0
```

### Host operating system

-   MacOS Montery - Version: 12.6 (21G115)
-   VirtualBox - Version 6.1.38 r153438 (Qt5.6.3)


# Issue
Note:** Verify that the `~/.vagrant.d/boxes` directory where the boxes used for the "GOAD" lab are stored is clean, otherwise **The problem will not occur, because you have already downloaded the boxes**, this problem occurs when you deploy the lab from scratch.


**Problem**: I was following the steps for GOAD deployment "from scratch, i.e. the boxes had to be downloaded" and the console gave me an error when I executed the following command `vagrant up`.


```bash
$ pwd
~/Projects/Pentesting/GOAD

$ ls
LICENSE     README.md   Vagrantfile ad          ansible     docs        vagrant

$ vagrant up
Bringing machine 'DC01' up with 'virtualbox' provider...
Bringing machine 'DC02' up with 'virtualbox' provider...
Bringing machine 'DC03' up with 'virtualbox' provider...
Bringing machine 'SRV02' up with 'virtualbox' provider...
Bringing machine 'SRV03' up with 'virtualbox' provider...
==> DC01: Box 'StefanScherer/windows_2019' could not be found. Attempting to find and install...
    DC01: Box Provider: virtualbox
    DC01: Box Version: 2021.05.15
The box 'StefanScherer/windows_2019' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Vagrant Cloud, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://vagrantcloud.com/StefanScherer/windows_2019"]
Error: SSL certificate problem: self signed certificate in certificate chain
```

**Error**

```bash
The box 'StefanScherer/windows_2019' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Vagrant Cloud, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://vagrantcloud.com/StefanScherer/windows_2019"]
Error: SSL certificate problem: self signed certificate in certificate chain
```

**After some research, I found the solution** in this post from [Stackoverflow](https://stackoverflow.com/questions/42718527/vagrant-up-command-throwing-ssl-error), which is related to insecure box downloads, so I added the following line `target.vm.box_download_insecure = box[:box]` in the `Vagrantfile` file

```ruby
.
.
# BOX
target.vm.box_download_insecure = box[:box]  # nueva linea agregada
.
.
```
# New features 

This is for aesthetics, the names of the virtual machines when created in VirtualBox have a long name, as shown in the following image.


![im1](https://github.com/xllauca/dotfiles/blob/master/attachments/Pasted%20image%2020220915191533.png)

What was done was to add the following lines of code in the `Vagrantfile` file, so that it is displayed as follows. 

**Lines of code added**.

```ruby
# BOX
target.vm.provider "virtualbox" do |v| #new linea 1
	v.name = box[:name]                #new linea 2
end                                    #new linea 3
```

**New display on VirtualBox**

![im2](https://github.com/xllauca/dotfiles/blob/master/attachments/Pasted%20image%2020220915201746.png)

Greetings
