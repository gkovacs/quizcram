(function(){
  var express, path, fs, app, exec, toSeconds, ref$, transcodeIfNeeded, getPlatform, bodyParser, MongoClient, getMongoDbReal, getMongoDb, getLogsCollectionReal, getLogsCollection, userToLogidx, getLogIdxForUsernameReal, getLogIdxForUsername, padTo10, get_portal, get_index, spawn, serverRootStatic, segmentVideo, makeSnapshot, portnum;
  express = require('express');
  path = require('path');
  fs = require('fs');
  app = express();
  exec = require('child_process').exec;
  toSeconds = require('./common_lib').toSeconds;
  ref$ = require('./transcode_lib'), transcodeIfNeeded = ref$.transcodeIfNeeded, getPlatform = ref$.getPlatform;
  bodyParser = require('body-parser');
  MongoClient = require('mongodb').MongoClient;
  root.isdevel = false;
  if (__dirname.indexOf('quizcram-development') !== -1) {
    root.isdevel = true;
  }
  getMongoDbReal = function(callback){
    var mongourl, ref$;
    mongourl = (ref$ = process.env.MONGOHQ_URL) != null
      ? ref$
      : (ref$ = process.env.MONGOLAB_URI) != null
        ? ref$
        : process.env.MONGOSOUP_URL;
    if (mongourl == null) {
      mongourl = JSON.parse(fs.readFileSync('mongologinlocal.json', 'utf-8')).mongourl;
    }
    return MongoClient.connect(mongourl, {
      auto_reconnect: true,
      poolSize: 20,
      socketOptions: {
        keepAlive: 1
      }
    }, function(err, db){
      if (err) {
        console.log('error getting mongodb');
      }
      return callback(db);
    });
  };
  getMongoDb = function(callback){
    if (root.mongoDb != null) {
      return callback(root.mongoDb);
    } else {
      return getMongoDbReal(function(db){
        root.mongoDb = db;
        return callback(db);
      });
    }
  };
  getLogsCollectionReal = function(callback){
    return getMongoDb(function(db){
      if (root.isdevel) {
        return callback(db.collection('logsdevel'), db);
      } else {
        return callback(db.collection('logs'), db);
      }
    });
  };
  getLogsCollection = getLogsCollectionReal;
  app.use(bodyParser.json());
  app.use(express['static'](path.join(__dirname, '')));
  app.set('view engine', 'jade');
  app.set('views', __dirname);
  app.locals.pretty = true;
  app.get('/ipaddress', function(req, res){
    return res.send(req.ip);
  });
  app.post('/clearlog', function(req, res){
    var username;
    username = req.body.username;
    if (username == null) {
      res.send('need to provide username');
      return;
    }
    return getLogsCollection(function(logs){
      return logs.remove({
        username: username
      }, function(err, docs){
        if (userToLogidx[username] != null) {
          delete userToLogidx[username];
        }
        return res.send('done');
      });
    });
  });
  app.post('/testpost', function(req, res){
    return res.send('yay post! you sent: ' + JSON.stringify(req.body));
  });
  userToLogidx = {};
  getLogIdxForUsernameReal = function(username, callback){
    return getLogsCollection(function(logs){
      return logs.find({
        username: username
      }).sort({
        logidx: 1
      }).toArray(function(err, results){
        var topidx, i$, len$, val;
        topidx = -1;
        if (results != null) {
          for (i$ = 0, len$ = results.length; i$ < len$; ++i$) {
            val = results[i$];
            if (val.logidx === topidx + 1) {
              topidx = val.logidx;
            }
          }
        }
        if (topidx >= 0) {
          userToLogidx[username] = topidx;
        }
        return callback(topidx);
      });
    });
  };
  getLogIdxForUsername = function(username, callback){
    if (userToLogidx[username] != null) {
      callback(userToLogidx[username]);
      return;
    }
    return getLogIdxForUsernameReal(username, function(topidx){
      return callback(topidx);
    });
  };
  app.get('/getlogidx', function(req, res){
    var username;
    username = req.query.username;
    return getLogIdxForUsername(username, function(topidx){
      return res.send(topidx.toString());
    });
  });
  padTo10 = function(num){
    var s, i$, ref$, len$, i;
    s = num + '';
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      i = ref$[i$];
      s = '0' + s;
    }
    return s;
    function fn$(){
      var i$, results$ = [];
      for (i$ = s.length; i$ < 10; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  app.post('/addlog', function(req, res){
    var logidx, username;
    logidx = req.body.logidx;
    username = req.body.username;
    if (logidx == null) {
      res.send('need to provide logidx');
      return;
    }
    if (username == null) {
      res.send('need to provide username');
      return;
    }
    if (req.body.ip == null) {
      req.body.ip = req.ip;
    }
    if (req.body._id == null) {
      req.body._id = username + '_' + padTo10(logidx);
    }
    return getLogIdxForUsername(username, function(topidx){
      if (logidx !== topidx + 1) {
        res.send(topidx.toString());
        return;
      }
      return getLogsCollection(function(logs){
        return logs.insert(req.body, function(err, docs){
          if (err == null) {
            userToLogidx[username] = logidx;
            return res.send(logidx.toString());
          } else {
            console.log('mongodb error on insertion:');
            console.log(err);
            return getLogIdxForUsernameReal(username, function(topidx){
              return res.send(topidx.toString());
            });
          }
        });
      });
    });
  });
  app.get('/viewlog', function(req, res){
    if (req.query.username == null) {
      res.send('need to provide username');
      return;
    }
    return getLogsCollection(function(logs){
      return logs.find({
        username: req.query.username
      }).sort({
        _id: 1
      }).toArray(function(err, results){
        return res.send(JSON.stringify(results));
      });
    });
  });
  app.get('/viewlogall', function(req, res){
    return getLogsCollection(function(logs){
      return logs.find().sort({
        _id: 1
      }).toArray(function(err, results){
        return res.send(JSON.stringify(results));
      });
    });
  });
  get_portal = function(req, res){
    return res.render('portal', {});
  };
  app.get('/portal', get_portal);
  app.get('/portal.html', get_portal);
  app.get('/front', get_portal);
  app.get('/instructions', get_portal);
  get_index = function(req, res){
    return res.render('index', {});
  };
  app.get('/', get_index);
  app.get('/index.html', get_index);
  spawn = require('child_process').spawn;
  serverRootStatic = 'http://educrowd.stanford.edu/';
  segmentVideo = function(req, res){
    var video, start, end;
    console.log('segmentvideo');
    video = req.query.video;
    start = req.query.start;
    end = req.query.end;
    start = toSeconds(start);
    end = toSeconds(end);
    return transcodeIfNeeded(video, start, end, function(output_path){
      return res.redirect(serverRootStatic + output_path.split('static/').join(''));
    });
  };
  app.get('/segmentvideo', segmentVideo);
  makeSnapshot = function(video, time, thumbnail_path, width, height, callback){
    var command;
    command = './ffmpeg -ss ' + time + ' -i ' + video + ' -y -vframes 1 -s ' + width + 'x' + height + ' ' + thumbnail_path;
    return exec(command, function(){
      if (callback != null) {
        return callback();
      }
    });
  };
  app.get('/thumbnail', function(req, res){
    var video, time, width, height, thumbnail_file, thumbnail_path;
    video = req.query.video;
    time = toSeconds(req.query.time);
    width = parseInt(req.query.width);
    if (width == null || isNaN(width)) {
      width = 400;
    }
    height = parseInt(req.query.height);
    if (height == null || isNaN(height)) {
      height = 450;
    }
    if (video == null || time == null || isNaN(time)) {
      res.send('need video and time parameters');
    }
    thumbnail_file = video + '_' + time + '_' + width + 'x' + height + '.png';
    thumbnail_path = 'thumbnails/' + thumbnail_file;
    console.log(thumbnail_path);
    if (fs.existsSync(thumbnail_path)) {
      return res.sendFile(path.join(__dirname, thumbnail_path));
    } else {
      return makeSnapshot(video, time, thumbnail_path, width, height, function(){
        return res.sendFile(path.join(__dirname, thumbnail_path));
      });
    }
  });
  app.get('/overlay', function(req, res){
    var video, time, width, height, overlayx, overlayy, overlayw, overlayh;
    video = req.query.video;
    time = toSeconds(req.query.time);
    width = parseFloat(req.query.width);
    if (width == null || isNaN(width)) {
      width = 800;
    }
    height = parseFloat(req.query.height);
    if (height == null || isNaN(height)) {
      height = 450;
    }
    if (video == null || time == null || isNaN(time)) {
      res.send('need video and time parameters');
    }
    overlayx = parseFloat(req.query.overlayx);
    if (overlayx == null || isNaN(overlayx)) {
      res.send('need overlayx parameter');
    }
    overlayy = parseFloat(req.query.overlayy);
    if (overlayy == null || isNaN(overlayy)) {
      res.send('need overlayy parameter');
    }
    overlayw = parseFloat(req.query.overlayw);
    if (overlayw == null || isNaN(overlayw)) {
      res.send('need overlayw parameter');
    }
    overlayh = parseFloat(req.query.overlayh);
    if (overlayh == null || isNaN(overlayh)) {
      res.send('need overlayh parameter');
    }
    return res.render('overlay', {
      video: video,
      time: time,
      width: width,
      height: height,
      overlayx: overlayx,
      overlayy: overlayy,
      overlayw: overlayw,
      overlayh: overlayh
    });
  });
  app.get('/mkoverlay', function(req, res){
    var video, time, width, height;
    video = req.query.video;
    time = toSeconds(req.query.time);
    width = parseFloat(req.query.width);
    if (width == null || isNaN(width)) {
      width = 800;
    }
    height = parseFloat(req.query.height);
    if (height == null || isNaN(height)) {
      height = 450;
    }
    if (video == null || time == null || isNaN(time)) {
      res.send('need video and time parameters');
    }
    return res.render('mkoverlay', {
      video: video,
      time: time,
      width: width,
      height: height
    });
  });
  portnum = 8080;
  if (root.isdevel) {
    portnum = 8081;
  }
  if (process.env.PORT != null) {
    portnum = process.env.PORT;
  }
  app.listen(portnum, '0.0.0.0');
  console.log('Listening on port ' + portnum);
}).call(this);
