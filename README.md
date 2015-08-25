# particle-offline-compiler

An Atom package for 100% offline code compilation for Particle Devices.

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
In `atom > Preferences > Install`, search for `particle-offline-compiler` and install it.

If you prefer the manual approach, download the package from Github and place it in your `~/.atom/packages` folder.

Before using it, open up the settings on the package, and enter the Particle Compiler Path – this should point to the location where you downloaded and compiled the __particle local compiler__. The __Device Type__ and __Serial Port__ can be left empty, as they can be set easily in the __Particle.offline__ user menu.

Once installed you should see a Particle.offline menubar with all the relevant, self-explanatory options listed.


## Usage Instructions
* If you're using the package in atom, ensure that your code:
  * uses `.cpp` file extensions, not `.ino`
  * declares `#include "application.h"` at the top of your main .cpp file
  * `*.cpp/*.h` libraries should be in the same folder as your main cpp file
  * declare your C prototypes manually, either in a `.h` file of the same name as the main `.cpp` file, or alternatively at the beginning of your main `.cpp` file.
* The `[refresh DFU serial device list]` menu item under `Particle.offline > DFU serial port` needs to be manually refreshed to get the latest list of serial devices connected to your computer.
* If you are connecting multiple Particle devices to your computer at any one time, be sure to double-check the serial port that you are uploading to!
* Choose `Compile locally + DFU upload` to compile and upload your code. You might want to toggle the Console first to see the progress of the compilation and spot errors.


## OSX – Important note on environment variables:

In order for all of your PATH environment variables to be picked up, **launch Atom from the terminal**:

    $ open -a "/Applications/Atom.app"

or, if you have already installed the Atom Shell commands:

    $ atom

If you skip this step, `arm-none-eabi-gcc` et al will *not* compile, as the standard PATH launched from a GUI instance of Atom most likely excludes the gcc compiler location.


## Work in progress!

This is a work in progress.

At this point the package is only tested on OSX Yosemite, Atom 1.0.3+. YMMV.

Compiler output is currently dumped out the Javascript console – sorry to those who prefer spiffier GUIs, but the console is good enough for now to figure out what's going on during the compile process. Perhaps a proper view with syntax coloring can be considered in the future.

The key features:
* Automatic DFU (Core/Photon) upload of firmware works – no need to put your device manually into DFU mode
* _(to implement)_ Core OTA updates
* _(to implement)_ Photon OTA updates, currently not supported in the 0.4.3rc2 firmware of the Photon devices for local clouds, so we'll have to wait until Particle releases a major update to `particle-server`


## Wait, isn't there Particle Dev that does the same thing?

Yes and no. [Particle Dev](https://www.particle.io/dev), which was built on top of Atom Shell a.k.a. Electron, is a fantastic project that addresses a specific need – quick, easy local __development__ (and storage) of code, with firmware builds/uploads still routed through Particle.io for ease of use. This same ease of use presents workflow obstacles when it comes to local cloud development, and slows down development massively.

This package was developed to improve workflow bottlenecks of the existing official Particle IDEs (Build Web IDE and Particle Dev).

If you encounter any of these scenarios, I hope this package will be of help:

* You are developing a local cloud. Your current means of uploading new firmware is a combination of a) writing code in the Build Web IDE / Particle Dev, b) downloading the .bin files manually, before c) using `particle-cli` to send OTA updates to your Core(s), or perhaps, via DFU to your Photons. It's a slow process switching through these tasks just to get firmware uploaded.

* You want to try out the latest firmware releases from Particle.io and/or custom code libraries, but the Build Web IDE is still pegged to earlier, stable builds (for good reason), leaving you to build your own local compiler, but without a streamlined way to upload your binaries to your devices.

It's worth noting that Particle Dev (and the Particle platform at large) goes through continuous development, and will *eventually* implement much better development workflows. This tiny Atom package might be helpful for those who want an immediate, interim solution to a faster workflow for local-cloud and/or offline Particle projects.
