{CompositeDisposable} = require 'atom'
{BufferedProcess} = require 'atom'

DFUManager = require './dfu-manager'

platforms = ['photon','P1','core']

module.exports =
  packageName: require('../package.json').name
  config:
    deviceType:
      type: 'string'
      default: 'photon'
      description: 'Type of Particle device to compile for (use the Particle menu to refresh and set this quickly)'
      enum: platforms
      order: 1
    particleCompilerPath:
      type: 'string'
      default: '~/github/spark-firmware/main'
      description: 'Location of the main subfolder where you installed spark-firmware'
      order: 2
    doUpload:
      type: 'boolean'
      description: 'Trigger DFU firmware upload immediately?'
      default: true
      order: 3
    serialPort:
      type: 'string'
      default: '/dev/tty.usbmodem'
      description: 'Serial port to upload firmware binaries to (use the Particle menu to refresh and set this quickly)'
      order: 4

  activate: ->
    @dfuMan = new DFUManager()

    atom.commands.add 'atom-workspace', "#{@packageName}:compile", => @compile()
    atom.commands.add 'atom-workspace', "#{@packageName}:compileOTA", => @compileOTA()
    atom.commands.add 'atom-workspace', "#{@packageName}:platformPhoton", => @setPlatform(0)
    atom.commands.add 'atom-workspace', "#{@packageName}:platformP1", => @setPlatform(1)
    atom.commands.add 'atom-workspace', "#{@packageName}:platformCore", => @setPlatform(2)
    atom.commands.add 'atom-workspace', "#{@packageName}:getPorts", => @dfuMan.getPorts()

    # populate DFU serial device list upon activation
    @dfuMan.getPorts()

  compileOTA: ->
    console.log("[compileOTA] wip")

  compile: ->
    @cwd = atom.project.getPaths()[0]
    @compilerPath = atom.config.get("#{@packageName}.particleCompilerPath")
    @platform = atom.config.get("#{@packageName}.deviceType")

    command = 'make'
    args = [
      'all',
      '-C', @compilerPath,
      'APPDIR='+@cwd,
      'TARGET_DIR='+@cwd+'/firmware/'+@platform,
      'PLATFORM='+@platform
    ]

    # append addition upload instructions if set by user
    if atom.config.get("#{@packageName}.doUpload")
      @serialPort = atom.config.get("#{@packageName}.serialPort")
      args.push 'program-dfu'
      args.push 'PARTICLE_SERIAL_DEV='+@serialPort

    # debug to console
    stdout = (output) -> console.log("[compile] STDOUT:", output)
    stderr = (err) -> console.log("[compile] STDERR:", err)
    exit = (code) -> console.log("[compile] Exited with #{code}")

    console.log("[compile] Command:", command,args.join(' '))
    @compileProcess = new BufferedProcess({command, args, stdout, stderr, exit})

  setPlatform: (devType) ->
    atom.config.set("#{@packageName}.deviceType",platforms[devType])
    console.log("[setPlatform]", platforms[devType])

  console: ->
    console.log("[console] Toggle console output panel (wip)")
