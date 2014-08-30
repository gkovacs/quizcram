root = exports ? this

spawn = require('child_process').spawn

callCommand = (command, options, callback) ->
  ffmpeg = spawn command, options
  ffmpeg.stdout.on 'data', (data) ->
    console.log 'stdout:' + data
  ffmpeg.stderr.on 'data', (data) ->
    console.log 'stderr:' + data
  ffmpeg.on 'exit', (code) ->
    console.log 'exited with code:' + code
    callback() if callback?

makeSegment = root.makeSegment = (video, start, end, output, callback) ->
  extra_options = []
  if output.indexOf('.webm') != -1
    extra_options = <[ -c:v libvpx -b:v 1M -c:a libvorbis -cpu-used -5 ]>
    #extra_options = <[ -codec:video vp9 ]>
    #extra_options = <[ -c:v libvpx -b:v 1M -c:a libvorbis -cpu-used -5 -deadline realtime ]>
  if output.indexOf('.mp4') != -1
    extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -threads 0 -strict -2 -codec:a aac ]>
  #  #extra_options = <[ -strict experimental ]>
  #  #extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=-1:480 -threads 0 -codec:a aac ]>
  command = './ffmpeg'
  #command = 'avconv'
  options = ['-ss', start, '-t', (end - start), '-i', video] ++ extra_options ++ ['-y', output]
  callCommand command, options, callback
  #callCommand command, options, ->
  #  callCommand 'qtfaststart', [output], callback
