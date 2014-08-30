root = exports ? this

{existsSync, mkdirSync, unlinkSync, renameSync} = require 'fs'
{spawn} = require 'child_process'

callCommand = (command, options, callback) ->
  ffmpeg = spawn command, options
  ffmpeg.stdout.on 'data', (data) ->
    console.log 'stdout:' + data
  ffmpeg.stderr.on 'data', (data) ->
    console.log 'stderr:' + data
  ffmpeg.on 'exit', (code) ->
    console.log 'exited with code:' + code
    callback() if callback?

toFolderAndFileName = (filepath) ->
  ridx = filepath.lastIndexOf('/')
  if ridx == -1
    return ['', filepath]
  else
    foldername = filepath.substring(0, ridx + 1)
    filename = filepath.substring(ridx + 1)
    return [foldername, filename]

makeSegment = root.makeSegment = (video, start, end, output, callback) ->
  extra_options = []
  if output.indexOf('.webm') != -1
    extra_options = <[ -c:v libvpx -b:v 500K -c:a libvorbis -cpu-used -5 -deadline realtime ]>
    #extra_options = <[ -c:v libvpx -b:v 500K -c:a libvorbis -cpu-used -5 ]>
    #extra_options = <[ -codec:video vp9 ]>
    #extra_options = <[ -c:v libvpx -b:v 1M -c:a libvorbis -cpu-used -5 -deadline realtime ]>
  if output.indexOf('.mp4') != -1
    extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -threads 0 -strict -2 -codec:a aac ]>
  #  #extra_options = <[ -strict experimental ]>
  #  #extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=-1:480 -threads 0 -codec:a aac ]>
  command = './ffmpeg'
  #command = 'avconv'
  [output_folder, output_filename] = toFolderAndFileName output
  output_tmp = output_folder + 'tmp_' + output_filename
  if existsSync(output_tmp)
    unlinkSync(output_tmp)
  options = ['-ss', start, '-t', (end - start), '-i', video] ++ extra_options ++ ['-y', output_tmp]
  callCommand command, options, ->
    renameSync(output_tmp, output)
    if output.indexOf('.mp4') != -1
      callCommand 'qtfaststart', [output], callback
    else
      callback()

transcodeIfNeeded = root.transcodeIfNeeded = (video, start, end, callback) ->
  video_base = video.split('.')[0]
  video_path = video
  output_file = video_base + '_' + start + '_' + end + '.webm'
  if not existsSync('static')
    mkdirSync('static')
  output_path = 'static/' + output_file
  if existsSync(output_path)
    callback(output_path)
  else
    makeSegment video_path, start, end, output_path, ->
      callback(output_path)