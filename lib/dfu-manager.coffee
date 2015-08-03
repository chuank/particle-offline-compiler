{CompositeDisposable} = require 'atom'
{BufferedProcess} = require 'atom'

module.exports =
class DFUManager
  packageName: require('../package.json').name

  constructor: ->
      @_ports = []

  # gets all serial ports with the '/dev/tty.usbmodem*' name as possible candidates
  getPorts: ->

    # clear previous port listing first
    @clearPorts()

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
      # windows untested!
      input = lsCmd.split(/(\s+)/)
      command = input[0]
      args = input.slice(1)

    console.log("[getPorts] parsed command:\t", command, args.join(' '))

    # stdout triggers only when there's valid data coming back
    stdout = (output) => @processSerialList(output)

    # stderr triggers only if there's an error - useful for finding out what happened!
    stderr = (err) -> console.log("[getPorts] STDERR:", err)
    exit = (code) ->
      switch code
        when 1
          # no devices found, alert
          console.log("[getPorts] No DFU devices found!")
        when 2
          # some other error, alert
          console.log("[getPorts] Something weird happened. Sorry.")

    @_getPortsProcess = new BufferedProcess({command, args, stdout, stderr, exit})

  processSerialList: (output) =>
    # regex to split lines if multiple devices are found
    devicelist = output.split(/\r?\n/)
    if(devicelist[devicelist.length-1]=='')
      devicelist.pop();
    numDevices = devicelist.length

    console.log("[processSerialList] Devices found:", devicelist)

    # iterate through all found devices
    for devName in devicelist
      devShortName = devName.substring(9)

      newSerialDeviceMenu = atom.menu.add [
        {
          label: 'Particle'
          submenu : [
            {
              'label': 'DFU serial port'
              'submenu': [
                {
                  type: 'radio'
                  'label': devShortName
                  'command': "#{@packageName}:#{devShortName}"
                }]}]}
      ]

      # FIXME setSerialPort does not take a unique devName for each iterated device?!?!?! All menu items take on the last devName?!@#$%?#!@!
      console.log("#{@packageName}:#{devShortName}", devName)
      newSerialCommand = atom.commands.add 'atom-workspace', "#{@packageName}:#{devShortName}", => @setSerialPort(devName)

      @_ports.push {
        name: devName
        shortname: devShortName
        serialDevice: newSerialDeviceMenu
        serialCommand: newSerialCommand
      }
      # end for...loop

    if numDevices == 1
      @setSerialPort(devicelist[0])

  setSerialPort: (devName) ->
    console.log("@_ports:", devName, @_ports)
    # console.log("Serial port changed to:", devName)
    atom.config.set("#{@packageName}.serialPort", devName)

  clearPorts: ->
    # console.log("@serialDevices:", @serialDevices)
    while @_ports.length > 0
      dev = @_ports[@_ports.length-1]
      console.log("[clearPorts] disposing", dev)
      dev.serialDevice.dispose()
      dev.serialCommand.dispose()
      @_ports.pop()

    console.log("[clearPorts] @_ports is now:", @_ports)
