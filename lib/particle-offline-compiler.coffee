#TODO ParticleOfflineCompileView = require './particle-offline-compiler-view'

{CompositeDisposable} = require 'atom'
{BufferedProcess} = require 'atom'

module.exports =
  packageName: require('../package.json').name
  config:
    deviceType:
      type: 'string'
      default: 'photon'
      description: 'type of Particle device to compile for'
      enum: ['photon','core','P1']
      order: 1
    particleCompilerPath:
      type: 'string'
      default: '~/github/spark-firmware/main'
      description: 'location of the main subfolder where you installed spark-firmware'
      order: 2
    doUpload:
      type: 'boolean'
      description: 'trigger DFU firmware upload immediately?'
      default: true
      order: 3
    serialPort:
      type: 'string'
      default: '/dev/tty.usbmodem1451'
      description: 'serial port to upload firmware binaries to'
      order: 4

    # TODO
    # dockCommandResultsToBottom:
    #   type: 'boolean'
    #   default: true

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add @serialDevice = new CompositeDisposable
    # @tasks = []

    atom.commands.add 'atom-workspace', "#{@packageName}:compile", => @compile()
    atom.commands.add 'atom-workspace', "#{@packageName}:compileOTA", => @compileOTA()
    atom.commands.add 'atom-workspace', "#{@packageName}:platformPhoton", => @platformPhoton()
    atom.commands.add 'atom-workspace', "#{@packageName}:platformP1", => @platformP1()
    atom.commands.add 'atom-workspace', "#{@packageName}:platformCore", => @platformCore()
    atom.commands.add 'atom-workspace', "#{@packageName}:getPorts", => @getPorts()
    atom.commands.add 'atom-workspace', "#{@packageName}:console", => @console()

    @getPorts()
  # TODO
  # collectResults: (output) =>
  #   # Found out that html objects still get renderend and they shouldn't, perform htmlEncode
  #   @commandResult += output.toString().replace(/&/g, '&amp;')
  #           .replace(/"/g, '&quot;')
  #           .replace(/'/g, '&#39;')
  #           .replace(/</g, '&lt;')
  #           .replace(/>/g, '&gt;')
    # @returnCallback()

  # returnCallback: =>
    # @callback(@command, @commandResult)

  deactivate: ->
    @subscriptions.dispose()

  compileOTA: ->
    console.log("wip, coming soon!")

  compile: ->
    @cwd = atom.project.getPaths()[0]
    @compilerPath = atom.config.get("#{@packageName}.particleCompilerPath")
    @platform = atom.config.get("#{@packageName}.deviceType")

    command = 'make'
    args = [
      'all',
      '-C', @compilerPath,
      'APPDIR='+@cwd,
      'PLATFORM='+@platform
    ]

    # append addition upload instructions if set by user
    if atom.config.get("#{@packageName}.doUpload")
      @serialPort = atom.config.get("#{@packageName}.serialPort")
      args.push 'program-dfu'
      args.push 'PARTICLE_SERIAL_DEV='+@serialPort

    # debug to console
    stdout = (output) -> console.log("STDOUT",output)
    stderr = (err) -> console.log("STDERR",err)

    exit = (code) -> console.log("exited with #{code}")

    # @commandResult = ''
    @compileProcess = new BufferedProcess({command, args, stdout, stderr, exit})

    console.log(command,args.join(' '))

    # TODO send data to prettified output panel
    # @compileProcess.process.stdout.on 'data', @collectResults
    # @compileProcess.process.stderr.on 'data', @collectResults

  platformPhoton: ->
    atom.config.set("#{@packageName}.deviceType",'photon')

  platformP1: ->
    atom.config.set("#{@packageName}.deviceType",'P1')

  platformCore: ->
    atom.config.set("#{@packageName}.deviceType",'core')

  getPorts: ->
    lsCmd = 'ls /dev/tty.usbmodem*'

    isWin = /^win/.test(process.platform)
    if (!isWin)
      command = '/bin/bash'
      args = [
        '-c',
        lsCmd,
        '-il'
      ]
    else
      input = lsCmd.split(/(\s+)/)
      command = input[0]
      args = input.slice(1)

    console.log("parsed command to list Serial ports:\t", command, args.join(' '))

    # debug to console
    devicelist = ''

    # stdout triggers when there's valid data comng back
    stdout = (output) => @processSerialList(output)

    # stderr only triggers if there's an error - useful for finding out what happened
    stderr = (err) -> console.log("STDERR",err)

    exit = (code) ->
      switch code
        when 1
          # no devices found, alert
          console.log("No DFU devices found!")
        when 2
          # some other error, alert
          console.log("Something weird happened. Sorry.")

    @getPortsProcess = new BufferedProcess({command, args, stdout, stderr, exit})

  processSerialList: (output) ->
    # regex to split lines if multiple devices are found
    devicelist = output.split(/\r?\n/)
    if(devicelist[devicelist.length-1]=='')
      devicelist.pop();
    console.log("Devices found:",devicelist)

    # iterate through all found devices
    it = 0
    while it < devicelist.length
      @dev = devicelist[it]
      @devShortName = @dev.substr(9)

      newSerialDevice = atom.menu.add [
        {
          label: 'Particle'
          submenu : [
            {
              'label': 'DFU serial port'
              'submenu': [
                {
                  type: 'radio'
                  'label': devicelist[0]
                  'command': "#{@packageName}:#{@devShortName}"
                }
              ]
            }
          ]
        }
      ]
      console.log("#{@packageName}:#{@devShortName}")
      newTaskCommand = atom.commands.add 'atom-workspace', "#{@packageName}:#{@devShortName}", => @setSerialPort(@dev)
      # @tasks.push {
      #   name: devicelist[0]
      #   serialDevice: newSerialDevice
      # }
      # @serialDevice.add newSerialDevice
      it++

  setSerialPort: (dev)->
    atom.config.set("#{@packageName}.serialPort",dev)
    console.log("Serial port changed to:",dev)

  console: ->
    console.log("toggle console output panel...")
