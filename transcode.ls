async = require 'async'

{video_info} = require('./video_info')
{video_info_std} = require('./video_info_std')
{video_info_extra} = require('./video_info_extra')
{toSeconds} = require('./common_lib')
{transcodeIfNeeded} = require('./transcode_lib')

createTranscodeTasksForVideos = (video_info) ->
  tasks = []
  for let vidname,vidinfo of video_info
    {filename, parts} = vidinfo
    for let {start, end} in parts
      start = 0 # toSeconds start
      end = toSeconds end
      tasks.push (callback) ->
        console.log '============================================='
        console.log filename + ' start: ' + start + ' end: ' + end
        console.log '============================================='
        transcodeIfNeeded(filename, start, end + 1, -> callback(null))
  return tasks

tasks = createTranscodeTasksForVideos(video_info) ++ createTranscodeTasksForVideos(video_info_std) ++ createTranscodeTasksForVideos(video_info_extra)

async.series tasks, (err, results) ->
  console.log 'all complete!'
