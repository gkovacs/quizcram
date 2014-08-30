async = require 'async'

{video_info} = require('./video_info')
{toSeconds} = require('./common_lib')
{transcodeIfNeeded} = require('./transcode_lib')

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
