saboteur.me puppet configuration
===
Repository for educational purposes. That will contain configuration for server which is currently running my [blog](https://saboteur.me).

What's included?
---

1. PHP (FPM) 5.6.x
2. MariaDB 10.x
3. nginx 1.10.x

How to run
---
1. Install [VirtualBox](https://www.virtualbox.org/) & [Vagrant](https://www.vagrantup.com/);
2. install [Landrush with](https://github.com/vagrant-landrush/landrush) with `vagrant plugin install landrush`;
3. install [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) with `vagrant plugin install vagrant-vbguest` ;
4. run image with `vagrant up`;
5. change profiles and update configuration with `vagrant provision`.
