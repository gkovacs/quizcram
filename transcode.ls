fs = require 'fs'
async = require 'async'

{video_info} = require('./video_info')
{toSeconds} = require('./common_lib')
{makeSegment, callCommand} = require('./transcode_lib')

transcodeIfNeeded = (video, start, end, callback) ->
  video_base = video.split('.')[0]
  video_path = video
  output_file = video_base + '_' + start + '_' + end + '.webm'
  if not fs.existsSync('static')
    fs.mkdirSync('static')
  output_path = 'static/' + output_file
  if fs.existsSync(output_path)
    callback()
  else
    makeSegment video_path, start, end, output_path, ->
      callback()

tasks = []
for let vidname,vidinfo of video_info
  {filename, parts} = vidinfo
  for let {start, end} in parts
    start = toSeconds start
    end = toSeconds end
    tasks.push (callback) ->
      console.log '============================================='
      console.log filename + ' start: ' + start + ' end: ' + end
      console.log '============================================='
      transcodeIfNeeded(filename, start, end, -> callback(null))

async.series tasks, (err, results) ->
  console.log 'all complete!'
