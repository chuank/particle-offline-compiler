# particle-offline-compiler

An Atom / Particle Dev package for 100% offline code compilation for Particle Devices.

For situations where you *need* to compile and test Particle projects locally, and keep to a streamlined workflow.

This should be compatible with projects that connect to Particle.io, or if you're deploying your own local cloud.


## Requirements

1. __particle local compiler__  
   Install the Particle local compiler ([full instructions here](https://github.com/spark/firmware/tree/latest)), including dependencies.  

   This package also assumes that you have the latest `particle-cli` installed on your system – this will be required for OTA updates (coming soon)

2. __particle-cli__  
   To install particle-cli:  
   ```
   $ npm install -g particle-cli
   $ particle cloud login
   ```


## Installation
In `atom / Particle Dev > Preferences > Install`, search for `particle-offline-compiler` and install it.

Before using it, open up the settings on the package, and enter the Particle Compiler Path – this should point to the location where you downloaded and compiled the __particle local compiler__ (see instructions above). The __Device Type__ and __Serial Port__ can be left empty, as they can be set easily in the __Particle.offline__ user menu.

Once installed, you should see a __Particle.offline__ menubar with self-explanatory options listed.


## Usage Instructions
* If you're using the package in atom, ensure the following:
  * use `.cpp` file extensions, not `.ino`
  * declare `#include "application.h"` at the top of your main `.cpp` file
  * `*.cpp/*.h` libraries should be in the same folder as your main `.cpp` file
  * declare your C prototypes manually, either in a `.h` file of the same name as the main `.cpp` file, or alternatively at the beginning of your main `.cpp` file.
* The `[refresh DFU serial device list]` menu item under `Particle.offline > DFU serial port` needs to be manually refreshed to get the latest list of serial devices connected to your computer.
* If you are connecting multiple Particle devices to your computer at any one time, be sure to double-check the serial port that you are uploading to!
* Choose `Compile locally + DFU upload` to compile and upload your code. You might want to toggle the Console first to see the progress of the compilation and spot errors.


## OSX – Important note on environment variables:

In order for all of your PATH environment variables to be picked up, **launch Atom from the terminal**:

    $ open -a "/Applications/Atom.app"

or, if you have already installed the Atom Shell commands:

    $ atom

If you're using Particle Dev, launch the application similarly from Terminal:

    open -a "/Applications/Particle Dev.app"

If you skip this step, the compile will _not_ be able to find `arm-none-eabi-gcc` in your PATH environment variable, as the standard PATH launched from a Finder instance of Atom most likely excludes the gcc compiler location (default: /usr/local/bin).


## Work in progress!

This is a work in progress.

At this point the package is only tested on OSX ~~Yosemite~~ El Capitan, Atom ~~1.0.3+~~ 1.5.3 and Particle Dev 0.0.25. YMMV.

Compiler output is currently dumped out the Javascript console – sorry to those who prefer spiffier GUIs, but the console is good enough for now to figure out what's going on during the compile process. Perhaps a proper view with syntax coloring can be considered in the future.

`Dfu-util` has a bug where the conclusion of every firmware upload presents `STDERR: dfu-util: Error during download get_status`, despite the firmware uploading OK. This can be safely ignored.

Key features:
* Automatic DFU (Core/Photon) upload of firmware works – no need to put your device manually into DFU mode
* _(to implement)_ Core OTA updates
* _(to implement)_ Photon OTA updates


## Wait, isn't there Particle Dev that does the same thing?

Yes and no. [Particle Dev](https://www.particle.io/dev), which was built on top of Atom Shell a.k.a. Electron, is a fantastic project that addresses a specific need – quick, easy local __development__ (and storage) of code, with firmware builds/uploads still routed through Particle.io for ease of use. This same ease of use presents workflow obstacles when it comes to local cloud development, and slows down development massively.

There's also the more recent [Particle Dev Local Compiler](https://github.com/spark/particle-dev-local-compiler) which uses Docker VMs to install multiple local firmware builds, but it does not allow you to specify your own locally-modified `spark-firmware` – which is what this package is originally written for.

If you encounter any of these scenarios, I hope this package will be of help:

* You are developing a local cloud. Your current means of uploading new firmware is a combination of a) writing code in the Build Web IDE / Particle Dev, b) downloading the .bin files manually, before c) using `particle-cli` to send OTA updates to your Core(s), or perhaps, via DFU to your Photons. It's a slow process switching through these tasks just to get firmware uploaded.

* You want to try out the latest firmware releases from Particle.io and/or custom code libraries, but the Build Web IDE is still pegged to earlier, stable builds (for good reason), leaving you to build your own local compiler, but without a streamlined way to upload your binaries to your devices.

* You have forked and modified portions of `spark-firmware` and want an easier way to compile system and user firmware through the Atom GUI.

It's worth noting that Particle Dev (and the Particle platform at large) goes through continuous development, and will *eventually* implement much better development workflows. This tiny Atom package might be helpful for those who want an immediate, interim solution to a faster workflow for local-cloud and/or offline Particle projects.
