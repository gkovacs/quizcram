express = require 'express'
path = require 'path'
fs = require 'fs'
app = express()
exec = require('child_process').exec

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

app.post '/addlog', (req, res) ->
  if Object.keys(req.body).length == 0
    res.send 'need to provide data'
  if not req.body.ip?
    req.body.ip = req.ip
  getLogsCollection (logs) ->
    logs.insert req.body, (err, docs) ->
      #res.send JSON.stringify(req.body)
      res.send 'done'

app.get '/addlogget', (req, res) ->
  if Object.keys(req.query).length == 0
    res.send 'need to provide data'
  if not req.query.ip?
    req.query.ip = req.ip
  getLogsCollection (logs) ->
    logs.insert req.query, (err, docs) ->
      #res.send JSON.stringify(req.query)
      res.send 'done'

app.get '/viewlog', (req, res) ->
  if not req.query.username?
    res.send 'need to provide username'
  getLogsCollection (logs) ->
    logs.find({username: req.query.username}).toArray (err, results) ->
      res.send JSON.stringify(results)

app.get '/viewlogall', (req, res) ->
  getLogsCollection (logs) ->
    logs.find().toArray (err, results) ->
      res.send JSON.stringify(results)

get_index = (req, res) ->
  res.render 'index', {}

app.get '/', get_index
app.get '/index.html', get_index

#app.get '/'


toSeconds = (time) ->
  if not time?
    return null
  if typeof time == 'number'
    return time
  if typeof time == 'string'
    timeParts = [parseInt(x) for x in time.split(':')]
    if timeParts.length == 0
      return null
    if timeParts.length == 1
      return timeParts[0]
    if timeParts.length == 2
      return timeParts[0]*60 + timeParts[1]
    if timeParts.legnth == 3
      return timeParts[0]*3600 + timeParts[1]*60 + timeParts[2]
  return null

spawn = require('child_process').spawn
fs = require 'fs'

callCommand = (command, options, callback) ->
  ffmpeg = spawn command, options
  ffmpeg.stdout.on 'data', (data) ->
    console.log 'stdout:' + data
  ffmpeg.stderr.on 'data', (data) ->
    console.log 'stderr:' + data
  ffmpeg.on 'exit', (code) ->
    console.log 'exited with code:' + code
    callback() if callback?

makeSegment = (video, start, end, output, callback) ->
  extra_options = []
  if output.indexOf('.webm') != -1
    extra_options = <[ -c:v libvpx -b:v 1M -c:a libvorbis -cpu-used -5 -deadline realtime ]>
  if output.indexOf('.mp4') != -1
    extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -threads 0 -strict -2 -codec:a aac ]>
  #  #extra_options = <[ -strict experimental ]>
  #  #extra_options = <[ -codec:v libx264 -profile:v high -preset ultrafast -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=-1:480 -threads 0 -codec:a aac ]>
  command = './ffmpeg'
  #command = 'avconv'
  options = ['-ss', start, '-t', (end - start), '-i', video].concat extra_options.concat ['-y', output]
  callCommand command, options, callback
  #callCommand command, options, ->
  #  callCommand 'qtfaststart', [output], callback

serverRootStatic = 'http://10.172.99.36:80/'

segmentVideo = (req, res) ->
  console.log 'segmentvideo'
  video = req.query.video
  start = req.query.start
  end = req.query.end
  video_base = video.split('.')[0]
  video_path = video
  output_file = video_base + '_' + start + '_' + end + '.mp4'
  output_path = 'static/' + output_file
  if fs.existsSync(output_path)
    console.log serverRootStatic + output_path
    res.redirect serverRootStatic + output_path #+ '?' + Math.floor(Math.random() * 2**32)
    #res.sendfile output_path
  else
    makeSegment video_path, start, end, output_path, ->
      #res.sendfile output_path
      res.redirect serverRootStatic + output_path #+ '?' + Math.floor(Math.random() * 2**32)

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
    res.sendfile thumbnail_path
  else
    makeSnapshot video, time, thumbnail_path, width, height, ->
      res.sendfile thumbnail_path

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

