# particle-offline-compiler

Atom-integrated, 100% offline code compiler utility for Particle Devices.

For situations where you *need* to compile and test Particle projects locally, and keep to a streamlined workflow.


### Requirements

Install the Particle local compiler (instructions here: https://github.com/spark/firmware/tree/latest), including the dependencies.



### Instructions

Install **particle-offline-compiler** as you would any regular atom package.

Before using it, be sure to access the settings on the package and fill in the relevant paths and build options for your firmware – follow the prompts in the settings.

#### Important note on environment variables, especially Yosemite:
**Launch Atom from Terminal**, in order for all of your PATH environment variables to be picked up. `arm-none-eabi-gcc` et al will not compile as the standard PATH launched from a GUI instance of Atom most likely will not point to where the gcc compiler is installed.


### Work in progress!

This is a work in progress.

At this point the package is only tested on OSX Yosemite, Atom 1.0.3.

Compiler output is currently dumped out the Javascript console – sorry to those who prefer spiffier GUIs, but the console is good enough to figure out what's going on during the compile process. Perhaps a proper view can be considered in the future.

* DFU (Core/Photon) upload of firmware works
* OTA (Core) update within Atom is planned, which should make this tool a complete, single solution for uploading to Particle Devices
* OTA (Photon) update is currently not supported in the 0.4.3rc2 firmware of the Photon devices for local clouds, so we'll have to wait until Particle releases a major update to `particle-server`.


### Wait, isn't there Particle Dev that does the same thing?

Yes and no. Particle Dev, which was built on top of Atom Shell a.k.a. Electron, is a fantastic project that addresses a specific need – quick, easy local development (and storage) of code, with firmware builds/uploads still routed through Particle.io for ease of use. This same ease of use presents workflow obstacles when it comes to local cloud development, and slows down development massively.

This package was developed to resolve the following workflow bottlenecks of the existing official Particle IDEs (Build Web IDE and Particle Dev):

* You are developing a local cloud. Your current means of uploading new firmware is a combination of a) writing code in the Build Web IDE / Particle Dev, b) downloading the .bin files manually, before c) using `particle-cli` to send OTA updates to your Core(s), or perhaps, via DFU to your Photons. It's a slow process switching through these tasks just to get firmware uploaded.

* You want to try out the latest firmware releases from Particle and/or custom libraries, but the Build Web IDE is still pegged to earlier, stable builds, leaving you to build your own local compiler, but without a streamlined way to upload your binaries to your devices.

It's worth noting that Particle Dev (and the Particle platform at large) goes through continuous development, and will *eventually* implement much better development workflows. This tiny Atom package might be helpful for those who want an immediate, interim solution to a faster workflow for local-cloud and/or offline Particle projects.
