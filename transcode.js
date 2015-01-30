(function(){
  var async, video_info, video_info_std, video_info_extra, toSeconds, transcodeIfNeeded, createTranscodeTasksForVideos, tasks;
  async = require('async');
  video_info = require('./video_info').video_info;
  video_info_std = require('./video_info_std').video_info_std;
  video_info_extra = require('./video_info_extra').video_info_extra;
  toSeconds = require('./common_lib').toSeconds;
  transcodeIfNeeded = require('./transcode_lib').transcodeIfNeeded;
  createTranscodeTasksForVideos = function(video_info){
    var tasks, i$;
    tasks = [];
    for (i$ in video_info) {
      (fn$.call(this, i$, video_info[i$]));
    }
    return tasks;
    function fn$(vidname, vidinfo){
      var filename, parts, i$, len$;
      filename = vidinfo.filename, parts = vidinfo.parts;
      for (i$ = 0, len$ = parts.length; i$ < len$; ++i$) {
        (fn$.call(this, parts[i$]));
      }
      function fn$(arg$){
        var start, end;
        start = arg$.start, end = arg$.end;
        start = 0;
        end = toSeconds(end);
        tasks.push(function(callback){
          console.log('=============================================');
          console.log(filename + ' start: ' + start + ' end: ' + end);
          console.log('=============================================');
          return transcodeIfNeeded(filename, start, end + 1, function(){
            return callback(null);
          });
        });
      }
    }
  };
  tasks = createTranscodeTasksForVideos(video_info).concat(createTranscodeTasksForVideos(video_info_std), createTranscodeTasksForVideos(video_info_extra));
  async.series(tasks, function(err, results){
    return console.log('all complete!');
  });
}).call(this);
