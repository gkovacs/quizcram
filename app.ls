express = require 'express'
path = require 'path'
fs = require 'fs'
app = express()
exec = require('child_process').exec

{toSeconds} = require './common_lib'
{transcodeIfNeeded, getPlatform} = require './transcode_lib'

bodyParser = require 'body-parser'

MongoClient = require(\mongodb).MongoClient

getMongoDbReal = (callback) ->
  {mongourl} = JSON.parse(fs.readFileSync(\mongologin.json, \utf-8))
  #mongourl = 
  MongoClient.connect mongourl, (err, db) ->
    if err
      throw err
    callback db

getMongoDb = (callback) ->
  if root.mongo-db?
    callback root.mongo-db
  else
    getMongoDbReal (db) ->
      root.mongo-db = db
      callback db

getLogsCollectionReal = (callback) ->
  getMongoDb (db) ->
    callback db.collection('logs')

getLogsCollection = (callback) ->
  if root.logs-collection?
    callback root.logs-collection
  else
    getLogsCollectionReal (logs) ->
      root.logs-collection = logs
      callback logs

app.use(bodyParser.json())

app.use(express.static(path.join(__dirname, ''))) #  "public" off of current is root

#app.use(require('stylus').middleware(__dirname))

app.set 'view engine', 'jade'
app.set 'views', __dirname

app.locals.pretty = true

app.get '/ipaddress', (req, res) ->
  res.send req.ip

app.post '/clearlog', (req, res) ->
  username = req.body.username
  if not username?
    res.send 'need to provide username'
    return
  getLogsCollection (logs) ->
    logs.remove {username: username}, (err, docs) ->
      if user-to-logidx[username]?
        delete user-to-logidx[username]
      res.send 'done'

app.post '/testpost', (req, res) ->
  res.send 'yay post! you sent: ' + JSON.stringify(req.body)

user-to-logidx = {}

getLogIdxForUsernameReal = (username, callback) ->
  getLogsCollection (logs) ->
    logs.find({username: username}).sort({logidx: 1}).toArray (err, results) ->
      topidx = -1
      if results?
        for val in results
          if val.logidx == topidx + 1
            topidx = val.logidx
      if topidx >= 0
        user-to-logidx[username] = topidx
      callback topidx

getLogIdxForUsername = (username, callback) ->
  if user-to-logidx[username]?
    callback(user-to-logidx[username])
    return
  getLogIdxForUsernameReal username, (topidx) ->
    callback topidx

app.get '/getlogidx', (req, res) ->
  username = req.query.username
  getLogIdxForUsername username, (topidx) ->
    res.send topidx.toString()

padTo10 = (num) ->
  s = num + ''
  for i in [s.length til 10]
    s = '0' + s
  return s

app.post '/addlog', (req, res) ->
  #if Object.keys(req.body).length == 0
  #  res.send 'need to provide data'
  #  return
  logidx = req.body.logidx
  username = req.body.username
  if not logidx?
    res.send 'need to provide logidx'
    return
  if not username?
    res.send 'need to provide username'
    return
  if not req.body.ip?
    req.body.ip = req.ip
  if not req.body._id?
    req.body._id = username + '_' + padTo10(logidx)
  getLogIdxForUsername username, (topidx) ->
    if logidx != topidx + 1
      #res.send 'out of order'
      res.send topidx.toString()
      return
    getLogsCollection (logs) ->
      logs.insert req.body, (err, docs) ->
        # res.send JSON.stringify(req.body)
        if not err?
          user-to-logidx[username] = logidx
          res.send logidx.toString()
        else
          console.log 'mongodb error on insertion:'
          console.log err
          getLogIdxForUsernameReal username, (topidx) ->
            res.send topidx.toString()

          

app.get '/viewlog', (req, res) ->
  if not req.query.username?
    res.send 'need to provide username'
    return
  getLogsCollection (logs) ->
    logs.find({username: req.query.username}).sort({_id: 1}).toArray (err, results) ->
      res.send JSON.stringify(results)

app.get '/viewlogall', (req, res) ->
  getLogsCollection (logs) ->
    logs.find().sort({_id: 1}).toArray (err, results) ->
      res.send JSON.stringify(results)

get_index = (req, res) ->
  res.render 'index', {}

app.get '/', get_index
app.get '/index.html', get_index

#app.get '/'

spawn = require('child_process').spawn

serverRootStatic = 'http://10.172.99.36:80/'

segmentVideo = (req, res) ->
  console.log 'segmentvideo'
  video = req.query.video
  start = req.query.start
  end = req.query.end
  start = toSeconds start
  end = toSeconds end
  transcodeIfNeeded video, start, end, (output_path) ->
    switch getPlatform()
    | 'osx' => res.sendFile(path.join(__dirname, output_path))
    | _ => res.sendFile(path.join(__dirname, output_path))
    #| _ => res.redirect(serverRootStatic + output_path)

app.get '/segmentvideo', segmentVideo
#app.get '/segmentvideo*', segmentVideo

makeSnapshot = (video, time, thumbnail_path, width, height, callback) ->
  command = './ffmpeg -ss ' + time + ' -i ' + video + ' -y -vframes 1 -s ' + width + 'x' + height + ' ' + thumbnail_path
  exec command, ->
    callback() if callback?

app.get '/thumbnail', (req, res) ->
  video = req.query.video
  time = toSeconds(req.query.time)
  width = parseInt(req.query.width)
  if not width? or isNaN(width)
    width = 400
  height = parseInt(req.query.height)
  if not height? or isNaN(height)
    height = 450
  if not video? or not time? or isNaN(time)
    res.send 'need video and time parameters'
  thumbnail_file = video + '_' + time + '_' + width + 'x' + height + '.png'
  thumbnail_path = 'thumbnails/' + thumbnail_file
  console.log thumbnail_path
  if fs.existsSync(thumbnail_path)
    res.sendFile path.join(__dirname, thumbnail_path)
  else
    makeSnapshot video, time, thumbnail_path, width, height, ->
      res.sendFile path.join(__dirname, thumbnail_path)

app.get '/overlay', (req, res) ->
  video = req.query.video
  time = toSeconds(req.query.time)
  width = parseFloat(req.query.width)
  if not width? or isNaN(width)
    width = 800
  height = parseFloat(req.query.height)
  if not height? or isNaN(height)
    height = 450
  if not video? or not time? or isNaN(time)
    res.send 'need video and time parameters'
  overlayx = parseFloat req.query.overlayx
  if not overlayx? or isNaN overlayx
    res.send 'need overlayx parameter'
  overlayy = parseFloat req.query.overlayy
  if not overlayy? or isNaN overlayy
    res.send 'need overlayy parameter'
  overlayw = parseFloat req.query.overlayw
  if not overlayw? or isNaN overlayw
    res.send 'need overlayw parameter'
  overlayh = parseFloat req.query.overlayh
  if not overlayh? or isNaN overlayh
    res.send 'need overlayh parameter'
  res.render 'overlay', {
    video: video
    time: time
    width: width
    height: height
    overlayx: overlayx
    overlayy: overlayy
    overlayw: overlayw
    overlayh: overlayh
  }

app.get '/mkoverlay', (req, res) ->
  video = req.query.video
  time = toSeconds(req.query.time)
  width = parseFloat(req.query.width)
  if not width? or isNaN(width)
    width = 800
  height = parseFloat(req.query.height)
  if not height? or isNaN(height)
    height = 450
  if not video? or not time? or isNaN(time)
    res.send 'need video and time parameters'
  res.render 'mkoverlay', {
    video: video
    time: time
    width: width
    height: height
  }

app.listen(8080, '0.0.0.0')
console.log('Listening on port 8080')

