(function(){
  var root, ref$, existsSync, readFileSync, mkdirSync, unlinkSync, renameSync, spawn, getPlatform, callCommand, toFolderAndFileName, makeSegment, transcodeIfNeeded;
  root = typeof exports != 'undefined' && exports !== null ? exports : this;
  ref$ = require('fs'), existsSync = ref$.existsSync, readFileSync = ref$.readFileSync, mkdirSync = ref$.mkdirSync, unlinkSync = ref$.unlinkSync, renameSync = ref$.renameSync;
  spawn = require('child_process').spawn;
  root.platformName = null;
  getPlatform = root.getPlatform = function(){
    var platform;
    if (root.platformName != null) {
      return root.platformName;
    }
    if (existsSync('platform.json')) {
      platform = JSON.parse(readFileSync('platform.json', 'utf-8'));
      root.platformName = platform.name;
    } else {
      root.platformName = 'default';
    }
    return root.platformName;
  };
  callCommand = function(command, options, callback){
    var ffmpeg;
    ffmpeg = spawn(command, options);
    ffmpeg.stdout.on('data', function(data){
      return console.log('stdout:' + data);
    });
    ffmpeg.stderr.on('data', function(data){
      return console.log('stderr:' + data);
    });
    return ffmpeg.on('exit', function(code){
      console.log('exited with code:' + code);
      if (callback != null) {
        return callback();
      }
    });
  };
  toFolderAndFileName = function(filepath){
    var ridx, foldername, filename;
    ridx = filepath.lastIndexOf('/');
    if (ridx === -1) {
      return ['', filepath];
    } else {
      foldername = filepath.substring(0, ridx + 1);
      filename = filepath.substring(ridx + 1);
      return [foldername, filename];
    }
  };
  makeSegment = root.makeSegment = function(video, start, end, output, callback){
    var extra_options, command, ref$, output_folder, output_filename, output_tmp, options;
    extra_options = [];
    if (output.indexOf('.webm') !== -1) {
      extra_options = ['-c:v', 'libvpx', '-b:v', '500K', '-c:a', 'libvorbis', '-cpu-used', '-5', '-deadline', 'realtime'];
    }
    if (output.indexOf('.mp4') !== -1) {
      extra_options = ['-codec:v', 'libx264', '-profile:v', 'high', '-preset', 'ultrafast', '-threads', '0', '-strict', '-2', '-codec:a', 'aac'];
    }
    command = (function(){
      switch (getPlatform()) {
      case 'osx':
        return 'ffmpeg';
      default:
        return './ffmpeg';
      }
    }());
    ref$ = toFolderAndFileName(output), output_folder = ref$[0], output_filename = ref$[1];
    output_tmp = output_folder + 'tmp_' + output_filename;
    if (existsSync(output_tmp)) {
      unlinkSync(output_tmp);
    }
    options = ['-ss', start, '-t', end - start, '-i', video].concat(extra_options, ['-y', output_tmp]);
    return callCommand(command, options, function(){
      renameSync(output_tmp, output);
      if (output.indexOf('.mp4') !== -1) {
        return callCommand('qtfaststart', [output], callback);
      } else {
        return callback();
      }
    });
  };
  transcodeIfNeeded = root.transcodeIfNeeded = function(video, start, end, callback){
    var video_base, video_path, output_file, output_path;
    video_base = video.split('.')[0];
    video_path = video;
    output_file = video_base + '_' + start + '_' + end + '.webm';
    if (!existsSync('static')) {
      mkdirSync('static');
    }
    output_path = 'static/' + output_file;
    console.log('existsSync');
    console.log(existsSync);
    console.log('callback');
    console.log(callback);
    if (existsSync(output_path)) {
      return callback(output_path);
    } else {
      return makeSegment(video_path, start, end, output_path, function(){
        return callback(output_path);
      });
    }
  };
}).call(this);
