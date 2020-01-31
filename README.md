# ADA Snake
## Presentation
Ada snake is an epita school project realised by students. It is part of a Ada competition organized by Adacore. We had to use Ada 2012 on a STM32F429-Discovery.

## Prerequisites
Before you start you need to install:
- [Gnat toolchain](https://www.adacore.com/download)
- [Stm32 driver for Ada](https://github.com/AdaCore/Ada_Drivers_Library)
- [St-link](https://github.com/texane/stlink)

## Usage
    $ git clone https://github.com/Pomsss/ada_snake.git
    $ cd ada_snake
    $ sed -i 'with "<PATH>/Ada_Drivers_Library/examples/shared/common/common.gpr"' prj.gpr
    $ sed -i 'with "<PATH>/Ada_Drivers_Library/boards/stm32f429_discovery/stm32f429_discovery_full.gpr"' prj.gpr
    $ touch env.sh
    $ echo 'export PATH=<PATH>/GNAT/2019-arm-elf/bin:<PATH>/GNAT/2019/bin:$HOME/stlink/build/Release:<PATH>/stlink/build/Release/src/gdbserver:$PATH' > env.sh
    $ echo 'export GPR_PROJECT_PATH=<PATH>/Ada_Drivers_Library:$GPR_PROJECT_PATH' >> env.sh
    $ source flash.sh

Don't forget to download the Prerequisites and to plug the __*STM32F429I_Discovery*__!


[-->Photo describing how it should look like.<--](https://i.imgur.com/X2yr1LU.jpg)

## Tests
For this project we used contract in *.ads for testing our code, the program should never crash.

## Authors

Pomes Hadrien\
Nanouche Hamza\
EPITA GISTRE
