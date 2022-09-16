
# Detalles del ambiente de pruebas
### Vagrant version

```bash
$ vagrant version
Installed Version: 2.3.0
Latest Version: 2.3.0
```

### Host operating system

-   MacOS Montery - Version: 12.6 (21G115)
-   VirtualBox - Version 6.1.38 r153438 (Qt5.6.3)


# Problema
**Nota:** Verifique que el directorio de  `~/.vagrant.d/boxes` donde se almacenan las cajas utilizadas para el laboratorio de "GOAD" , este limpio, caso contrario **El problema no se presentara, debido a que ya tiene descargado las cajas**, este problema esta presenta cuando se despliega el laboratorio desde cero.


**Problema**: Estaba siguiendo  los pasos para el despliegue de GOAD "desde cero, es decir la cajas tenian que ser descargadas" y  la consola me arrojo un error cuando ejecute el siguiente comando `vagrant up`


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

**Después de investigar, di con con la solución** que encontre en este post de [Stackoverflow](https://stackoverflow.com/questions/42718527/vagrant-up-command-throwing-ssl-error),  el mismo que esta relacionado a las descargas de cajas inseguras,  por lo cual se agrego la siguiente linea`target.vm.box_download_insecure = box[:box]`en el archivo de `Vagrantfile`

```ruby
.
.
# BOX
target.vm.box_download_insecure = box[:box]  # nueva linea agregada
.
.
```

# Nuevas características 
Esto es por estética, los nombres de las maquinas virtuales cuando se crean en VirtualBox tienen un nombre largo, como se muestra en la siguiente imagen.


![im1](https://github.com/xllauca/dotfiles/blob/master/attachments/Pasted%20image%2020220915191533.png)

Lo que se realizo fue agregar las siguientes lineas de código en el archivo de `Vagrantfile`, para que se visualize de las siguiente manera. 

**Lineas de codigo agregadas**
```ruby
# BOX
target.vm.provider "virtualbox" do |v| #new linea 1
	v.name = box[:name]                #new linea 2
end                                    #new linea 3
```

**Nueva visualización**
![im2](https://github.com/xllauca/dotfiles/blob/master/attachments/Pasted%20image%2020220915201746.png)

Saludos
