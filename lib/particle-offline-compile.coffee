#TODO ParticleOfflineCompileView = require './particle-offline-compiler-view'

{CompositeDisposable} = require 'atom'
{BufferedProcess} = require 'atom'

module.exports =
  config:
    particleCompilerPath:
      type: 'string'
      default: '~/github/spark-firmware/main'
      description: 'location of the main subfolder where you installed spark-firmware'
    deviceType:
      type: 'string'
      default: 'photon'
      description: 'possible values: photon, core, P1'

    # TODO
    # dockCommandResultsToBottom:
    #   type: 'boolean'
    #   default: true

  activate: ->
    atom.commands.add 'atom-workspace', "particle-offline-compiler:compile", => @compile()

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

  compile: ->

    @cwd = atom.project.getPaths()[0]
    @compilerPath = atom.config.get('particle-offline-compiler.particleCompilerPath')
    @platform = atom.config.get('particle-offline-compiler.deviceType')

    command = 'make'
    args = ['-C', @compilerPath, 'APPDIR='+@cwd, 'PLATFORM='+@platform]

    # debug to console
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("exited with #{code}")

    # @commandResult = ''
    @process = new BufferedProcess({command, args, stdout, exit})

    console.log(command,args)

    # TODO send data to prettified output panel
    # @process.process.stdout.on 'data', @collectResults
    # @process.process.stderr.on 'data', @collectResults
