root = exports ? this

J = $.jade

{sum, reverse} = require \prelude-ls

# Date.now = Date.now || -> +new Date

stringEach = (l) ->
  output = []
  for x in l
    if x.split?
      output.push [$('<span>').text(y).html() for y in x.split("\n")].join('<br>')
    else
      output.push x.toString()
  return output

root.video_dependencies = {
  '1-1-1': []
  '1-2-1': [ '1-1-1' ]
  '1-2-2': [ '1-2-1' ]
  '1-3-1': [ '1-2-2' ]
  '1-3-2': [ '1-3-1' ]
  '1-3-3': [ '1-3-2' ]
  '1-3-4': [ '1-3-3' ]
  '1-3-5': [ '1-3-4' ]
  '1-3-6': [ '1-3-5' ]
  '1-4-1': [ '1-3-6' ]
  '1-4-2': [ '1-4-1' ]
  '1-4-3': [ '1-4-2' ]
  '1-4-4': [ '1-4-3' ]
  '2-1-1': []
  '2-1-2': [ '2-1-1' ]
  '2-1-3': [ '2-1-2' ]
  '2-2-1': [ '2-1-3' ]
  '2-2-2': [ '2-2-1' ]
  '2-2-3': [ '2-2-2' ]
  '2-2-4': [ '2-2-3' ]
  '2-2-5': [ '2-2-4' ]
  '2-2-6': [ '2-2-5' ]
}

listVideos = root.listVideos = ->
  video-names = [vidname for vidname,vidinfo of root.video_info]
  video-names.sort()
  return video-names

getAllDependencies = root.getAllDependencies = (videoname) ->
  if not root.video_dependencies[videoname]?
    return []
  else
    output = root.video_dependencies[videoname]
    for x in root.video_dependencies[videoname]
      output = output ++ getAllDependencies(x)
    return output

getQuestionsForVideoPart = root.getQuestionsForVideoPart = (vidname, vidpart) ->
  output = []
  for question in root.questions
    for video in question.videos
      if video.name == vidname and video.part == vidpart
        output.push question
  return output

createQuestionsForVideosWithoutQuizzes = ->
  new-questions = []
  for vidname,vidinfo of root.video_info
    for partinfo,vidpart in vidinfo.parts
      video-questions = getQuestionsForVideoPart vidname, vidpart
      for question in video-questions
        new-questions.push question
      if video-questions.length == 0
        new-questions.push {
          text: 'How well do you understand this video?'
          title: 'some question'
          type: 'radio'
          course: vidinfo.course
          autoshowvideo: true
          nocheckanswer: true
          needanswer: true
          selfrate: true
          options: [
            'Understand the video'
            'Somewhat unclear, would like to rewatch it later'
            'Do not understand the video at all, would like to rewatch it soon'
          ]
          correct: 0
          explanation: 'some explanation'
          videos: [
            {
              name: vidname
              degree: 1.0
              part: vidpart
            }
          ]
        }
  root.questions = new-questions

#root.questions = root.questions[0 to 3] # TEMPORARY # TODO remove this

/*
root.video_info = {
  '3-3': {
    filename: '3-3.mp4'
    title: ''
  }
  '3-1': {
    filename: '3-1.mp4'
  }
}

root.video_dependencies = {
  '3-3': [
    {
      name: '3-1'
      degree: 1.0
    }
  ]
  '3-1': [
    {
      name: '3-1'
      degree: 1.0
    }
  ]
}

root.questions = [
  {
    text: 'How many distinct strings are in the language of the regular expression: (0+1+ϵ)(0+1+ϵ)(0+1+ϵ)(0+1+ϵ) ?'
    title: 'Question 1'
    type: 'radio'
    options: stringEach [
      81, 12, 31, 32, 16, 64
    ]
    correct: 2
    explanation: 'We have 16 distinct strings of length 4, 8 distinct strings of length 3, 4 distinct strings of length 2, 2 distinct strings of length 1, and one empty string. In total, we have 16+8+4+2+1=31 distinct strings.'
    videos: [
      {
        name: '3-3'
        degree: 1.0
      }
    ]
  }
  {
    text: 'Consider the string abbbaacc. Which of the following lexical specifications produces the tokenization ab/bb/a/acc ?'
    title: 'Question 2'
    type: 'checkboxes'
    options: stringEach [
      'b+\nab*\nac*', 'c*\nb+\nab\nac*', 'ab\nb+\nac*', 'a(b + c*)\nb+'
    ]
    explanation: 'some long explanation'
  }
]
*/

root.username = null

randomFromList = (list) ->
  return list[Math.floor(Math.random() * list.length)]

randomString = (length) ->
  alphabet = [\a to \z] ++ [\A to \Z] ++ [\0 to \9]
  return [randomFromList(alphabet) for x in [0 til length]].join('')

getlog = root.getlog = (callback) ->
  $.getJSON '/viewlog?' + $.param({username: root.username}), (logs) ->
    for line in logs
      console.log JSON.stringify(line)
    callback logs

postJSON = root.postJSON = (url, jsondata, callback) ->
  $.ajax {
    type: 'POST'
    url: url
    data: JSON.stringify(jsondata)
    success: (data) ->
      if callback?
        callback data
      else
        console.log data
    contentType: 'application/json'
    #dataType: 'json'
  }

clearlog = root.clearlog = ->
  postJSON '/clearlog', {
    username: root.username
  }

root.logged-data = []
root.logging-disabled-globally = false
root.logging-disabled = false

root.server-received-logidx = {}

ensureLoggedToServer = (list, name) ->
  if not name?
    name = randomString(14)
  if root.server-received-logidx[name]?
    console.log 'already ensuring logged to server: ' + name
    return
  root.server-received-logidx[name] = -1
  setInterval ->
    nextidx = root.server-received-logidx[name] + 1
    if nextidx < list.length
      # have new data to send
      #console.log 'postJSON called'
      #console.log 'listLength: ' + list.length
      postJSON '/addlog', list[nextidx], (updated-idx) ->
        #console.log 'postJSON results'
        #console.log updated-idx
        updated-idx = parseInt(updated-idx)
        if isFinite(updated-idx)
          root.server-received-logidx[name] = updated-idx
  , 350

addlogvideo = root.addlogvideo = (logdata) ->
  if root.logging-disabled or root.logging-disabled-globally
    return
  videotag = $('.activevideo')
  if not videotag? or videotag.length == 0
    return
  video = getVideoPanel videotag
  if not video? or video.length == 0
    return
  qnum = video.data \qnum
  vidname = video.data \vidname
  vidpart = video.data \vidpart
  data = $.extend {}, logdata
  data.vidname = vidname
  data.vidpart = vidpart
  data.qnum = qnum
  data.type = \video
  data.curtime = videotag[0].currentTime
  data.paused = videotag[0].paused
  data.speed = videotag[0].playbackRate
  data.partsseen = getVideoPartSeenCompressed(vidname)
  addlog data

addlogReal = root.addlogReal = (data) ->
  if not data.logidx?
    data.logidx = root.logged-data.length
  root.logged-data.push data
  postJSON '/addlog', data

addlog = root.addlog = (logdata) ->
  if root.logging-disabled or root.logging-disabled-globally
    return
  data = $.extend {}, logdata
  if not data.username?
    data.username = root.username
  if not data.course?
    data.course = root.coursename
  if not data.platform?
    data.platform = root.platform
  if not data.time?
    data.time = Date.now()
  if not data.timeloc?
    data.timeloc = new Date().toString()
  if not data.started?
    data.started = root.time-started
  if not data.qnumcurq?
    data.qnumcurq = getCurrentQuestionQnum()
  if not data.automatic? and root.automatic-trigger
    data.automatic = true
    root.automatic-trigger = false
  addlogReal data

root.counter_values = {}

counterNext = root.counterNext = (name) ->
  if not root.counter_values[name]?
    root.counter_values[name] = 0
  else
    root.counter_values[name] += 1
  return root.counter_values[name]

counterSet = root.counterSet = (name, val) ->
  root.counter_values[name] = val

counterCurrent = root.counterCurrent = (name) ->
  if not root.counter_values[name]
    return 0
  return root.counter_values[name]

toPercent = (num) ->
  #return (num * 100).toFixed(2)
  return (num * 100).toFixed(0)

toPercentCss = (num) ->
  return (Math.min(1, num) * 100).toString() + '%'

toSeconds = root.toSeconds

getVideoEnd = (vidinfo) ->
  return toSeconds(vidinfo.parts[*-1].end)

getVideoStartEnd = (vidname, vidpart) ->
  vidinfo = root.video_info[vidname]
  if vidpart?
    {start,end} = vidinfo.parts[vidpart]
    return [toSeconds(start), toSeconds(end)]
  else
    start = 0
    end = getVideoEnd vidinfo
    return [toSeconds(start), toSeconds(end)]

root.video-parts-seen = {}
root.video-parts-seen-server = {}
console.log 'vidinfo!!!---------------------==================='
do ->
  for vidname,vidinfo of root.video_info
    seen = [0] * (Math.round(getVideoEnd(vidinfo)) + 1)
    root.video-parts-seen[vidname] = seen

getVideoPartSeenCompressed = (vidname) ->
  seenpart = root.video-parts-seen[vidname]
  if not seenpart?
    return ''
  return LZString.compressToBase64(seenpart.join(''))

getVideoPartsSeenThatNeedToBeSent = root.getVideoPartsSeenThatNeedToBeSent = ->
  output = {}
  for vidname,seenpart of root.video-parts-seen
    if not root.video-parts-seen-server[vidname]? or seenpart !== root.video-parts-seen-server[vidname]
      output[vidname] = seenpart[to]
  return output

getVideoPartsSeenThatNeedToBeSentCompressed = root.getVideoPartsSeenThatNeedToBeSentCompressed = ->
  return {[vidname, LZString.compressToBase64(seenpart.join(''))] for vidname,seenpart of getVideoPartsSeenThatNeedToBeSent()}

decompressBinaryArray = (compressedData) ->
  uncompressed = LZString.decompressFromBase64 compressedData
  return [parseInt(x) for x in uncompressed]

sendVideoPartsSeen = root.sendVideoPartsSeen = ->
  console.log 'sendVideoPartsSeen called!'
  to-be-sent = getVideoPartsSeenThatNeedToBeSentCompressed()
  console.log 'parts sent: ' + JSON.stringify(Object.keys(to-be-sent))
  if Object.keys(to-be-sent).length == 0
    return
  #console.log to-be-sent
  qnum = getCurrentQuestionQnum()
  qidx = getQidx qnum
  addlog {
    event: \videopartsseen
    type: \video
    partsseen: to-be-sent
    qnum
    qidx
  }
  for vidname,compressedData of to-be-sent
    root.video-parts-seen-server[vidname] = decompressBinaryArray compressedData
    # root.video-parts-seen-server[vidname] = root.video-parts-seen[vidname][to]
  

getVideoProgress = root.getVideoProgress = (vidname, vidpart) ->
  [start,end] = getVideoStartEnd vidname, vidpart
  #start = 0
  viewing-history = root.video-parts-seen[vidname]
  relevant-section = viewing-history[Math.round(start) to Math.round(end)]
  return sum(relevant-section) / relevant-section.length

isCurrentPortionPreviouslySeen = root.isCurrentPortionPreviouslySeen = (qnum) ->
  video = $('#video_' + qnum)
  if video.length < 1
    return false
  curtime = Math.round video[0].currentTime
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  length = end - start
  viewing-history = root.video-parts-seen[vidname]
  relevant-section = viewing-history[Math.round(start) to Math.round(end)]
  if sum(relevant-section[curtime to curtime + 3]) >= 4
    return true
  return false

skipToEndOfSeenPortion = root.skipToEndOfSeenPortion = (qnum) ->
  #if not isCurrentPortionPreviouslySeen qnum
  #  return
  if root.platform == 'invideo'
    return
  curtime = Math.round $('#video_' + qnum)[0].currentTime
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  seen-intervals = getVideoSeenIntervalsRaw vidname, vidpart
  for [start,end] in seen-intervals
    if start <= curtime < end - 1
      addlogvideo {
        event: \skipToEndOfSeenPortion
        newtime: end - 1
      }
      seekVideoTo end - 1
      (getVideo vidname, vidpart).find(\.skipseen).hide()
      return

getVideoSeenIntervalsRaw = root.getVideoSeenIntervalsRaw = (vidname, vidpart) ->
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  length = end - start
  viewing-history = root.video-parts-seen[vidname]
  relevant-section = viewing-history[Math.round(start) to Math.round(end)]
  seen-intervals = []
  interval-start = null
  for val,i in relevant-section
    if val == 0
      if interval-start?
        seen-intervals.push [interval-start, i]
        interval-start = null
    else
      if not interval-start?
        interval-start = i
  if interval-start?
    seen-intervals.push [interval-start, relevant-section.length - 1]
  return seen-intervals

getVideoSeenIntervals = root.getVideoSeenIntervals = (vidname, vidpart) ->
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  length = end - start
  seen-intervals = getVideoSeenIntervalsRaw vidname, vidpart
  return [[start / length, end / length] for [start,end] in seen-intervals]

markVideoSecondWatched = root.markVideoSecondWatched = (vidname, vidpart, second) ->
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  viewing-history = root.video-parts-seen[vidname]
  viewing-history[Math.round(second + start)] = 1

setWatchButtonProgress = root.setWatchButtonProgress = (vidname, vidpart, percent-viewed) ->
  seenmsg = '% seen'
  #if root.video_info[vidname].parts.length > 1
  #  seenmsg = '% of part ' + (vidpart + 1) + ' seen'
  $('.videoprogress_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).text(toPercent(percent-viewed) + seenmsg)
  $('.watch_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).html('<span class="glyphicon glyphicon-play"></span> watch video (' + toPercent(percent-viewed) + '% seen)')
  #$('.review_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).html('<span class="glyphicon glyphicon-play"></span> review video before answering again (' + toPercent(percent-viewed) + '% seen)')

updateWatchButtonProgress = root.updateWatchButtonProgress = (vidname, vidpart) ->
  percent-viewed = getVideoProgress vidname, vidpart
  setWatchButtonProgress vidname, vidpart, percent-viewed

updateCurrentTimeText = root.updateCurrentTimeText = (vidname, vidpart) ->
  video = getVideo vidname, vidpart
  time-indicator = video.find \.timeindicator
  videoTag = video.find(\video)[0]
  duration = videoTag.duration
  durationDisplay = secondsToDisplayableMinutes duration
  currentTime = videoTag.currentTime
  currentTimeDisplay = secondsToDisplayableMinutes currentTime
  time-indicator.text "#currentTimeDisplay / #durationDisplay"

updateTickLocation = root.updateTickLocation = (qnum) ->
  video = $("\#video_#qnum")
  if video.length == 0
    return
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  length = end - start
  curtime = video[0].currentTime
  curpercent = curtime / length
  setTickPercentage vidname, vidpart, curpercent

updateSeenIntervals = (vidname, vidpart) ->
  percent-viewed = getVideoProgress vidname, vidpart
  vidnamepart = getVidnamePart vidname, vidpart
  #$('.videoprogress_' + vidnamepart).text(toPercent(percent-viewed) + '% seen')
  setWatchButtonProgress vidname, vidpart, percent-viewed
  seen-intervals = getVideoSeenIntervals vidname, vidpart
  if root.platform == 'invideo'
    return
  setSeenIntervals vidname, vidpart, seen-intervals

setSubtitleText = root.setSubtitleText = (vidname, vidpart, text) ->
  video = getVideo vidname, vidpart
  subtitle-display = video.find \.subtitles
  if text == ''
    subtitle-display.hide()
  else
    subtitle-display.text text
    subtitle-display.show()

updateSubtitle = root.updateSubtitle = (vidname, vidpart, curtime) ->
  vidinfo = root.video_info[vidname]
  if vidinfo.subtitle?
    for line in vidinfo.subtitle
      start = toSeconds line.startTime
      end = toSeconds line.endTime
      if start <= curtime <= end
        setSubtitleText vidname, vidpart, line.text
        return
  setSubtitleText vidname, vidpart, ''

root.most-recent-time-quiz-skipped = {}

timeUpdatedReal = (qnum) ->
  video = $("\#video_#qnum")
  #body = getBody qnum
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  qnum-current = getCurrentQuestionQnum()
  tryClearWaitBeforeAnswering(qnum-current)
  #curqidx = getQidx qnum-current
  #fixVideoHeight video
  /*
  if not video.data('duration')?
    video.data 'duration', video[0].duration
  if not video.data('viewed')?
    video.data('viewed', [0]*(Math.round(video.data 'duration')+1))
  viewed = video.data('viewed')
  if video.length > 0
    curtime = video[0].currentTime
    viewed[Math.round(curtime)] = 1
  percent-viewed = sum(viewed) / viewed.length
  */
  if video.length > 0
    curtime = video[0].currentTime
    markVideoSecondWatched vidname, vidpart, curtime
    updateSubtitle vidname, vidpart, curtime
    updateCurrentTimeText vidname, vidpart
    if root.platform == 'invideo'
      for partinfo,partidx in root.video_info[vidname].parts[0 til -1] # skip the last
        partend = toSeconds partinfo.end
        if partend < curtime < partend + 0.7
          skippedtime = root.most-recent-time-quiz-skipped[vidname + '_' + partidx]
          if skippedtime? and Date.now() < skippedtime + 1300 # just finished the in-video quiz
            continue
          pauseVideo()
          showInVideoQuiz(vidname, partidx)
  updateTickLocation qnum
  if isCurrentPortionPreviouslySeen qnum
    (getVideo vidname, vidpart).find(\.skipseen).show()
  else
    (getVideo vidname, vidpart).find(\.skipseen).hide()
  if root.video_info[vidname]? and root.video_info[vidname].parts?
    for curvidpart in [0 til root.video_info[vidname].parts.length]
      if getVideo(vidname, curvidpart).length > 0
        updateSeenIntervals vidname, curvidpart

timeUpdated = root.timeUpdated = _.throttle timeUpdatedReal, 300

setStartTime = root.setStartTime = (time, qnum) ->
  video = $("\#video_#qnum")
  video[0].currentTime = time

insertAfter = (qnum, contents) ->
  console.log "insertAfter #qnum #contents"
  contents.insertAfter $("\#body_#qnum")

seekVideoToPercent = (percent) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  newtime = percent * video[0].duration
  addlogvideo {
    event: \seek
    subevent: \seekVideoToPercent
    percent
    newtime
  }
  hideInVideoQuiz()
  video[0].currentTime = newtime

seekVideoTo = (time) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  addlogvideo {
    event: \seek
    subevent: \seekVideoTo
    newtime: time
  }
  hideInVideoQuiz()
  video[0].currentTime = time

seekVideoByOffset = (offset) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  newtime = video[0].currentTime + offset
  addlogvideo {
    event: \seek
    subevent: \seekVideoByOffset
    offset
    newtime
  }
  hideInVideoQuiz()
  video[0].currentTime = newtime

playPauseVideo = ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  if video[0].paused
    playVideo()
  else
    pauseVideo()

isVideoFocused = root.isVideoFocused = ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return false
  return video.data('focused')

timeSinceVideoFocus = root.timeSinceVideoFocus = ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return 0
  if not video.data('focused')
    return 0
  if not video.data('timeVideoFocused')
    return 0
  return (Date.now() - video.data('timeVideoFocused')) / 1000

getVideoPanel = root.getVideoPanel = (elem) ->
  while elem? and elem.length? and elem.length > 0 and elem.parent?
    if elem.hasClass(\videopanel)
      return elem
    elem = elem.parent()

getOuterBody = (elem) ->
  while elem? and elem.length? and elem.length > 0 and elem.parent?
    if elem.hasClass(\outerbody)
      return elem
    elem = elem.parent()

getRightbar = (elem) ->
  while elem? and elem.length? and elem.length > 0 and elem.parent?
    if elem.hasClass(\rightbar)
      return elem
    elem = elem.parent()

setVideoFocused = root.setVideoFocused = (isFocused) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return false
  if isFocused
    video.data('timeVideoFocused', Date.now())
    #video-top = video.offset().top
    #$(window).scrollTop(video-top)
    #scrollWindow video-top
    #scrollToElement getVideoPanel(video)
    scrollToElement video #getVideoPanel(video)
    fixVideoHeight video
    setTimeout ->
      fixVideoHeight video
    , 250
  else
    pauseVideo()
  video.data('focused', isFocused)

getQnumOfPanelAbove = root.getQnumOfPanelAbove = (qnum) ->
  panels = $(\.panel-body-new).filter (idx, elem) -> $(elem).data(\qnum)?
  panels.sort (a,b) ->
    $(a).offset().top - $(b).offset().top
  panel-qnums = $.map panels, (elem) -> $(elem).data(\qnum)
  target-idx = panel-qnums.indexOf(qnum)
  if target-idx <= 0
    return panel-qnums[0]
  return panel-qnums[target-idx - 1]

removeAllVideos = root.removeAllVideos = ->
  $('.videopanel').remove()

fixVideoHeight = root.fixVideoHeight = (video) ->
  if video.length < 1
    return
  height = video[0].videoHeight
  width = video[0].videoWidth
  max-height = $(window).height() #* 0.5
  max-width = $(window).width() * 0.7
  max-width = Math.min max-width, max-height * width / height
  max-height = Math.min max-height, max-width * height / width
  if video.height != max-height
    video.height max-height
  if video.width != max-width
    video.width max-width
  panel = getVideoPanel video
  if panel.height() != max-height
    panel.height max-height
  if panel.width() != max-width
    panel.width max-width
  outerbody = getOuterBody video
  real-height = max-height
  #real-width = max-width
  if not video.hasClass(\activevideo)
    real-height = max-height / 2
    applyTransform outerbody, 'scale(0.5) translateY(-50%) translateX(-50%)'
  #  real-width = max-width / 2
  if outerbody.height() != real-height
    outerbody.height real-height
  #if outerbody.width() != real-width
  #  outerbody.width real-width

fixVideoHeightFull = root.fixVideoHeightFull = (video) ->
  if video.length < 1
    return
  height = video[0].videoHeight
  width = video[0].videoWidth
  max-height = $(window).height()
  max-width = $(window).width()
  max-width = Math.min max-width, max-height * width / height
  max-height = Math.min max-height, max-width * height / width
  if video.height != max-height
    video.height max-height

getLastVideoForQuestion = root.getLastVideoForQuestion = (qnum) ->
  child-videos = $('#prebody_' + qnum).find(\.videopanel)
  child-videos.sort (a,b) ->
    $(a).offset().top - $(b).offset().top
  return child-videos[*-1]

addStartMarker = root.addStartMarker = (vidname, vidpart, percentage, label-text, active) ->
  if not active?
    active = false
  video = getVideo vidname, vidpart
  qnum = video.data \qnum
  progress-bar = video.find \.videoprogressbar
  color = 'rgba(196, 8, 8, 0.8)'
  if active
    color = 'rgba(196, 8, 8, 0.8)'
  if active
    label-text = label-text + ' (current)'
  tick = J(\.videostarttick.tick)
    .css {
      position: \absolute
      z-index: 6
      height: 'calc(100% + 1px)'
      width: \5px
      bottom: \0%
      border-radius: \5px
      border: "2px #{color}"
      background-color: color
      pointer-events: \none
    }
  tick-label = J(\.videostartlabel.tick)
    .css {
      position: \absolute
      display: \table
      overflow: \hidden
      z-index: 6
      height: \20px
      margin-left: \-15px
      padding-left: \3px
      padding-right: \3px
      padding-bottom: \3px
      padding-top: \3px
      bottom: '100%'
      background-color: color
      color: \white
      border: "5px #{color}"
      border-radius: \5px
      font-size: \16px
      cursor: \pointer
    }
    .mousemove (evt) ->
      $(\.videohovertick).hide()
      evt.preventDefault()
      return false
    .click (evt) ->
      makeVideoActive qnum
      seekVideoToPercent percentage
      playVideo()
      evt.preventDefault()
      return false
  tick-label-text = J(\div).css({display: \table-cell, vertical-align: \middle, cursor: \pointer}).text(label-text)
  if active
    tick-label-text.css(\font-weight, \bold)
  tick-label.append tick-label-text
  progress-bar.append [tick, tick-label]
  tick.css \left, toPercentCss(percentage)
  tick-label.css \left, toPercentCss(percentage)

setTickPercentage = root.setTickPercentage = (vidname, vidpart, percentage) ->
  video = getVideo vidname, vidpart
  progress-bar = video.find \.videoprogressbar
  tick = progress-bar.find \.videotick
  if not tick? or tick.length == 0
    tick = J(\.videotick.tick)
      .css {
        position: \absolute
        z-index: 7
        height: \90%
        width: \5px
        top: \5%
        border-radius: \5px
        border: '2px white'
        background-color: \white
        pointer-events: \none
      }
    progress-bar.append tick
  tick.css \left, toPercentCss(percentage)

setHoverTickPercentage = root.setHoverTickPercentage = (vidname, vidpart, percentage) ->
  video = getVideo vidname, vidpart
  progress-bar = video.find \.videoprogressbar
  tick = progress-bar.find \.videohovertick
  if not tick? or tick.length == 0
    tick = J(\.videohovertick.tick)
      .css {
        position: \absolute
        z-index: 8
        height: \90%
        width: \5px
        top: \5%
        border-radius: \5px
        border: '2px yellow'
        background-color: \yellow
        pointer-events: \none
      }
    progress-bar.append tick
  tick.css \left, toPercentCss(percentage)
  tick.show()

setSeenIntervals = root.setSeenIntervals = (vidname, vidpart, intervals) ->
  video = getVideo vidname, vidpart
  videostart = video.data(\start)
  videostartfraction = videostart / video.data(\end)
  progress-bar = video.find \.videoprogressbar
  bar-width = progress-bar.width()
  progress-bar.children().not('.unwatched').not('.tick').remove()
  new-intervals = []
  for [start,end] in intervals
    if start < videostartfraction < end
      new-intervals.push [start, videostartfraction]
      new-intervals.push [videostartfraction, end]
    else
      new-intervals.push [start, end]
  for [start,end] in new-intervals
    watched-portion = J(\div)
      .css {
        position: \absolute
        left: (start * bar-width) + 'px' #toPercentCss(start)
        width: ((end - start) * bar-width) + 'px' #toPercentCss(end - start)
        height: \50%
        top: \25%
        background-color: 'rgba(50, 255, 50, 0.7)'
        float: \left
        border-radius: \5px
        border: '2px rgba(50, 255, 50, 0.7)'
        pointer-events: \none
      }
    if start < videostartfraction
      watched-portion.css {background-color: 'rgba(50, 255, 255, 0.7)', border: '2px rgba(50, 255, 255, 0.7)'}
    progress-bar.append watched-portion

getPercentageOnProgressBar = (evt, progress-bar) ->
  if not evt.pageX
    return
  offsetX = evt.pageX - progress-bar.offset().left
  progress-bar-width = progress-bar.width()
  if progress-bar-width == 0
    return
  if haveTransform(getOuterBody(progress-bar))
    progress-bar-width /= 2
  percent = offsetX / progress-bar-width
  return percent

getbot = root.getbot = (elem) ->
  if typeof elem == typeof ''
    elem = $(elem)
  return elem.offset().top + elem.height()

insertVideo = (vidname, vidpart, options) ->
  if not options?
    options = {}
  [start,end] = getVideoStartEnd vidname, vidpart
  if options.nopart
    start = 0
  qnum = counterNext 'qnum'
  vidnamepart = toVidnamePart(vidname, vidpart)
  outer-body = J('.outerbody')
    .attr('id', "outerbody_#qnum")
    .css {
      padding-top: \0px
      padding-left: \0px
      padding-right: \0px
      padding-bottom: \0px
      margin-top: \0px
      margin-bottom: \10px
      margin-left: \0px
      margin-right: \0px
      position: \relative
    }
  body = J('.panel-body-new')
    .attr('id', "body_#qnum")
    .addClass(\videopanel)
    .addClass("video_#vidnamepart")
    .css {
      padding-top: \0px
      padding-left: \0px
      padding-right: \0px
      padding-bottom: \0px
      margin-top: \0px
      margin-bottom: \0px
      margin-left: \0px
      margin-right: \0px
      position: \relative
    }
    .data(\qnum, qnum)
    .data(\type, \video)
    .data(\vidname, vidname)
    .data(\vidpart, vidpart)
    .data(\start, start)
    .data(\end, end)
  setVideoBody vidname, vidpart, body
  console.log vidname
  basefilename = root.video_info[vidname].filename
  fileurl = '/segmentvideo?video=' + basefilename + '&' + $.param {start: 0, end: end + 1, randpart: randomString(10)}
  title = root.video_info[vidname].title
  # {filename, title} = root.video_info[vidinfo.name]
  fulltitle = title
  if vidpart? and not options.nopart
    numparts = root.video_info[vidname].parts.length
    if vidpart == 0
      if numparts > 1
        fulltitle = fulltitle + ' part 1/' + numparts
    else
      fulltitle = fulltitle + ' part ' + (vidpart+1) + '/' + numparts
      #fulltitle = fulltitle + ' parts 1-' + (vidpart+1)
  #$('.activevideo').removeClass 'activevideo'
  removeActiveVideoAndShrink()
  videodiv = J(\div)
    .css {
      position: \relative
      width: \100%
      padding-bottom: \0px
      margin-bottom: \0px
      border-bottom: \0px
    }
  video = J('video')
    .attr('id', "video_#qnum")
    #.attr('controls', 'controls')
    .attr('ontimeupdate', 'timeUpdated(' + qnum + ')')
    .prop('playbackRate', parseFloat(root.playback-speed))
    .prop('defaultPlaybackRate', parseFloat(root.playback-speed))
    .css {
      width: \100%
      padding-bottom: \0px
      margin-bottom: \0px
      border-bottom: \0px
    }
    .addClass('activevideo')
    .data(\qnum, qnum)
    #.data('focused', true)
    .click (evt) ->
      fixVideoHeight $(this)
      console.log 'mousedown video ' + qnum
      makeVideoActive qnum
      if not isVideoPlaying()
        playVideo()
        evt.preventDefault()
        return false
    #.on 'canplay', (evt) ->
    #  console.log 'loaded meatadata!'
    #  setTimeout ->
    #    fixVideoHeight $(this)
    #  , 300
    .on 'loadedmetadata', (evt) ->
      this.currentTime = start
      addlogvideo {
        event: \loadedmetadata
        newstart: start
      }
    .on 'ended', (evt) ->
      this.pause()
      addlogvideo {
        event: \ended
        newstart: start
      }
      hideInVideoQuiz()
      #this.currentTime = 0
      this.currentTime = start
      #gotoNum getCurrentQuestionQnum()
    .append(J('source').attr('src', fileurl))
    .on \play, (evt) ->
      (getVideo vidname, vidpart).find(\.playbuttonoverlay).hide()
      (getVideo vidname, vidpart).find(\.playbutton).removeClass(\glyphicon-play).addClass(\glyphicon-pause)
    .on \pause, (evt) ->
      (getVideo vidname, vidpart).find(\.playbuttonoverlay).show()
      (getVideo vidname, vidpart).find(\.playbutton).removeClass(\glyphicon-pause).addClass(\glyphicon-play)
    .on \timeupdate, (evt) ->
      updateTickLocation qnum
    .on \seeked, (evt) ->
      updateTickLocation qnum
  #setInterval ->
  #  console.log $("\#video_#qnum")[0].currentTime
  #, 1000
  console.log video
  video-header = J(\div)
    .css {
      width: \100%
      background-color: 'rgba(0, 0, 0, 0.5)'
      position: \absolute
      z-index: \2
      top: \0px
      height: \38px
      padding-left: \10px
      padding-top: \2px
      padding-bottom: \2px
      margin-top: \0px
      margin-bottom: \0px
    }
  #video-header.append J('h3').css(\color, \white).css(\float, \left).css(\margin-left, \10px).css(\margin-top, \10px).text fulltitle
  video-header.append J('span').css(\color, \white).css(\font-size, \24px).css(\pointer-events, \none).text fulltitle
  if not options.noprogressdisplay
    video-header.append J('span#progress_' + qnum).addClass('videoprogress_' + vidnamepart).css({pointer-events: \none, color: \white, margin-left: \30px, font-size: \24px}).text '0% seen'
  video-footer = J(\.videofooter)
    .css {
      width: \100%
      background-color: 'rgba(0, 0, 0, 0.5)'
      position: \absolute
      display: \table
      bottom: \0px
      padding-top: \0px
      padding-left: \0px
      padding-right: \0px
      padding-bottom: \0px
      margin-left: \0px
      margin-right: \0px
      margin-top: \0px
      margin-bottom: \0px
      height: \38px
    }
  play-button = J('span.playbutton.glyphicon.glyphicon-play')
    .css {
      display: \table-cell
      width: \30px
      color: \white
      font-size: \24px
      padding-left: \5px
      padding-right: \10px
      vertical-align: \middle
      cursor: \pointer
    }
    .attr 'title', 'play / pause video [shortcut: space key]'
    .click (evt) ->
      console.log 'play button clicked'
      makeVideoActive qnum
      playPauseVideo()
      #evt.preventDefault()
      #return false
  slower-button = J('span.slowerbutton.glyphicon.glyphicon-minus-sign')
    .css {
      display: \table-cell
      width: \30px
      color: \white
      font-size: \24px
      padding-left: \5px
      padding-right: \5px
      vertical-align: \middle
      cursor: \pointer
    }
    .attr 'title', 'slow down playback speed [shortcut: -/_ key]'
    .click (evt) ->
      makeVideoActive qnum
      console.log 'slower button clicked'
      decreasePlaybackSpeed video
  faster-button = J('span.fasterbutton.glyphicon.glyphicon-plus-sign')
    .css {
      display: \table-cell
      width: \30px
      color: \white
      font-size: \24px
      padding-left: \5px
      padding-right: \10px
      vertical-align: \middle
      cursor: \pointer
    }
    .attr 'title', 'speed up playback speed [shortcut: =/+ key]'
    .click (evt) ->
      makeVideoActive qnum
      console.log 'faster button clicked'
      increasePlaybackSpeed video
  current-speed = J('span.currentspeed')
    .css {
      display: \table-cell
      width: \30px
      color: \white
      font-size: \18px
      padding-left: \0px
      padding-right: \0px
      vertical-align: \middle
      pointer-events: \none
    }
    .text(root.playback-speed + 'x')
  progress-bar = J(\.videoprogressbar)
    .css {
      #position: \relative
      #width: 'calc(100% - 55px)'
      height: \100%
      display: \table-cell
      width: \auto
      #left: \45px
      color: \black
      position: \relative
      #position: \absolute
      #top: \0px
      background-color: 'rgba(0, 0, 0, 0.0)'
    }
    .mouseleave (evt) ->
      $('.videohovertick').hide()
    .mousemove (evt) ->
      percent = getPercentageOnProgressBar(evt, progress-bar)
      if not percent? or not isFinite(percent) or not 0 < percent <= 1
        return
      #console.log percent
      setHoverTickPercentage vidname, vidpart, percent
    .click (evt) ->
      percent = getPercentageOnProgressBar(evt, progress-bar)
      if not percent? or not isFinite(percent) or not 0 < percent <= 1
        return
      makeVideoActive qnum
      setTickPercentage vidname, vidpart, percent
      seekVideoToPercent percent
  unwatched-portion = J(\.unwatched)
    .css {
      position: \absolute
      width: \100%
      height: \10%
      left: \0%
      top: \45%
      background-color: \white
    }
  time-indicator = J(\.timeindicator)
    .css {
      height: \100%
      display: \table-cell
      width: \50px
      position: \relative
      color: \white
      vertical-align: \middle
      padding-left: \10px
      font-size: \12px
    }
  progress-bar.append unwatched-portion
  video-footer.append [play-button, slower-button, current-speed, faster-button, progress-bar, time-indicator]
  video-skip = J(\.skipseen)
    .css {
      position: \absolute
      background-color: 'rgba(0, 0, 0, 0.5)'
      padding-left: \10px
      padding-right: \10px
      padding-top: \10px
      padding-bottom: \10px
      border: \15px
      border-radius: \15px
      color: \white
      font-size: \20px
      top: \50px
      left: \10px
      text-align: \center
      display: \none
      cursor: \pointer
    }
    .html 'skip to unseen portion<br><span style="font-size: 14px; text-align: center">shortcut: Enter/Return key</span>'
    .click (evt) ->
      makeVideoActive qnum
      playVideo()
      skipToEndOfSeenPortion(qnum)
  subtitle-display-container = J(\.subtitlecontainer)
    .css {
      position: \absolute
      left: 0
      right: 0
      bottom: \70px
      margin: '0 auto'
      width: '100%'
      text-align: \center
      pointer-events: \none
    }
  subtitle-display = J(\.subtitles)
    .attr \align, \center
    .css {
      background-color: 'rgba(0, 0, 0, 0.5)'
      padding-left: \10px
      padding-right: \10px
      padding-top: \10px
      padding-bottom: \10px
      border: \15px
      border-radius: \15px
      color: \white
      font-size: \20px
      #float: \left
      display: \inline-block
      text-align: \center
      pointer-events: \none
    }
    .text 'loading video and subtitles'
  subtitle-display-container.append subtitle-display
  #video.append subtitle-display
  #videodiv.append [video-header, video-skip, subtitle-display-container, video, video-footer]
  #body.append [videodiv, J(\br)]
  #body.append videodiv
  playbutton-overlay = J(\img.playbuttonoverlay)
    .attr 'src', 'play.svg'
    .css {
      position: \absolute
      left: 0
      right: 0
      top: \25%
      #bottom: \300px
      opacity: 0.5
      margin: '0 auto'
      width: \50%
      height: \50%
      text-align: \center
      vertical-align: \center
      cursor: \pointer
      color: \white
    }
    .attr 'title', 'play video [shortcut: space key]'
    .click (evt) ->
      makeVideoActive qnum
      playVideo()
    #.text 'play button is here'
  body.append [video-header, subtitle-display-container, playbutton-overlay, video, video-footer]
  if not options.novideoskip
    body.append video-skip
  if options.quizzes
    console.log 'insertVideo options.quizzes is true!'
    console.log 'vidpart is:'
    console.log vidpart
    console.log 'vidname is:'
    console.log vidname
    for let vidpartidx in [0 to vidpart]
      question-for-quiz-overlay = getQuestionsForVideoPart(vidname, vidpartidx)
      if not question-for-quiz-overlay? or question-for-quiz-overlay.length < 1
        return
      quiz-overlay = J(\#quizoverlay_ + vidname + '_' + vidpartidx)
        .addClass(\quizoverlay)
        .data('quizvidname', vidname)
        .data('quizvidpart', vidpartidx)
        .css {
          position: \absolute
          left: \0px
          right: \0px
          top: \40px
          bottom: \40px
          border: '3px solid black'
          display: \none
          #width: \100%
          #height: \100%
          z-index: 5
          background-color: \white
        }
      body.append quiz-overlay
      insertInVideoQuiz question-for-quiz-overlay[0], body, vidpartidx
  if /*(vidpart? and vidpart > 0) or*/ (root.video_dependencies[vidname]? and root.video_dependencies[vidname].length > 0) and not options.noprevvideo
    #body.append J('button.btn.btn-primary.btn-lg').text("show related videos from earlier").click (evt) ->
    view-previous-video-button = J(\span.linklike)/*.css(\float, \left).css(\margin-left, \10px).css(\margin-top, \10px)*/.css({margin-left: \30px, font-size: \24px}).html('<span class="glyphicon glyphicon-step-backward"></span> previous video').click (evt) ->
      console.log 'do not understand video'
      console.log vidname
      viewPreviousClip vidname, vidpart
      #showChildVideo qnum
      #dependencies = []
      #for prevpart in [0 til partnum]
      #  dependencies.push [vidname, prevpart]
      #dependencies = dependencies ++ [[x,null] for x in root.video_dependencies[vidname]]
      /*
      dependencies = getVideoDependencies vidname, partnum
      for [dependency,vidnum] in dependencies
        console.log dependency
        console.log root.video_info[dependency]
        insertAfter qnum, (insertVideo dependency, vidnum, "<h3>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#title</span>)</h3>")
        addVideoDependsOnQuestion qnum, counterCurrent(\qnum)
        gotoNum counterCurrent(\qnum)
        break
      */
    video-header.append view-previous-video-button
  close-button = J(\span.glyphicon.glyphicon-remove-circle)
    .css {
      font-size: \24px
      position: \absolute
      top: \5px
      right: \5px
      color: \white
      display: \block
      cursor: \pointer
    }
    #.hover ->
    #  $(this).css \cursor, \pointer
    .click ->
      amount-to-scroll-up = $('#body_' + qnum).height()
      #target-qnum = getQnumOfPanelAbove qnum
      target-qnum = (getVideo vidname, vidpart).data \prebody
      $('#body_' + qnum).remove()
      $('#outerbody_' + qnum).remove()
      resetVideoBody vidname, vidpart
      #scrollWindowBy -amount-to-scroll-up
      #gotoNum target-qnum
      (getButton target-qnum, \watch).show()
  video-header.append close-button
  if root.video_info[vidname].parts.length > 1
    if vidpart?
      for part-idx in [0 to vidpart]
        start-time-for-part = toSeconds root.video_info[vidname].parts[part-idx].start
        isCurrentPart = part-idx == vidpart
        if options.nopart
          isCurrentPart = false
        if options.quizzes
          if part-idx == 0
            continue
          addStartMarker vidname, vidpart, start-time-for-part / end, "quiz #{part-idx}", false
        else
          addStartMarker vidname, vidpart, start-time-for-part / end, "part #{part-idx + 1}", isCurrentPart
  outer-body.append body
  return outer-body #body

root.question-to-video-dependencies = {}

addVideoDependsOnQuestion = root.addVideoDependsOnQuestion = (qnum-question, qnum-video) ->
  if not root.question-to-video-dependencies[qnum-question]?
    root.question-to-video-dependencies[qnum-question] = []
  root.question-to-video-dependencies[qnum-question].push qnum-video

getVideosDependingOnQuestion = root.getVideosDependingOnQuestion = (qnum-question) ->
  return question-to-video-dependencies[qnum-question]

/*
insertReview = (question) ->
  console.log 'reviewing!'
  numvideos = 0
  numvideos = question.videos.length if question.videos?
  qnum-question = counterCurrent(\qnum) + numvideos + 1
  console.log 'qnum-question ' + qnum-question
  #$('#quizstream').append J('h3').text('We suggest you review the following videos:')
  if question.videos?
    for vidinfo in question.videos
      $('#quizstream').append insertVideo vidinfo.name, vidinfo.part, "<h3>(to help you understand <a href='\#body_#{qnum-question}' onclick='setVideoFocused(false)'>#{question.title}</a>)</h3>"
      addVideoDependsOnQuestion qnum-question, counterCurrent(\qnum)
  #$('#quizstream').append J('.panel.panel-default').append body
  insertQuestion question, {skip-video: true}
  console.log 'qnum-question and actual: ' + qnum-question + ' vs ' + counterCurrent(\qnum)
*/

getType = (qnum) ->
  return $("\#body_#qnum").data \type

bodyExists = (qnum) ->
  return $("\#body_#qnum").length > 0

getBody = root.getBody = (qnum) ->
  return $("\#body_#qnum")

getQidx = root.getQidx = (qnum) ->
  return $("\#body_#qnum").data \qidx

getVidnameForQidx = (qidx) ->
  question = root.questions[qidx]
  return getVidnameForQuestion question

getVidpartForQidx = (qidx) ->
  question = root.questions[qidx]
  return getVidpartForQuestion question

getVidnameForQuestion = (question) ->
  vidinfo = question.videos[0]
  vidname = vidinfo.name
  return vidname

getVidpartForQuestion = (question) ->
  vidinfo = question.videos[0]
  vidpart = vidinfo.part
  return vidpart

getVidnamePartForQuestion = (question) ->
  vidinfo = question.videos[0]
  vidname = vidinfo.name
  vidpart = vidinfo.part
  if vidpart?
    return vidname + '_' + vidpart
  else
    return vidname

toVidnamePart = (vidname, vidpart) ->
  if vidpart?
    return vidname + '_' + vidpart
  else
    return vidname

getVidnamePart = (qnum) ->
  body = $("\#body_#qnum")
  vidname = body.data \vidname
  vidpart = body.data \vidpart
  if vidpart?
    return vidname + '_' + vidpart
  else
    return vidname

getVidname = (qnum) ->
  return $("\#body_#qnum").data \vidname

getVidpart = (qnum) ->
  return $("\#body_#qnum").data \vidpart

insertBefore = (qnum, content) ->
  content.insertBefore $("\#body_#qnum")

insertReviewForQuestion = (qnum) ->
  body = getBody qnum
  qidx = getQidx qnum
  console.log 'qidx is: ' + qidx
  question = root.questions[qidx]
  if question.videos?
    for vidinfo in question.videos
      #$('#quizstream').append insertVideo vidinfo.name, vidinfo.part, "<h3>(to help you understand <a href='\#body_#{qnum}' onclick='setVideoFocused(false)'>#{question.title}</a>)</h3>"
      insertBefore qnum, (insertVideo vidinfo.name, vidinfo.part)
      addVideoDependsOnQuestion qnum, counterCurrent(\qnum)
      body.data \video, counterCurrent(\qnum)

childVideoAlreadyInserted = (qnum) ->
  body = $("\#body_#qnum")
  if not body? or body.length < 1
    return false
  video-qnum = body.data(\video)
  if video-qnum? and $('#body_' + video-qnum).length > 0
    return true
  return false

getChildVideoQnum = (qnum) ->
  return $("\#body_#qnum").data \video

isParentAnimated = (elem) ->
  while not (elem.hasClass(\.panel-body-new) or elem.attr(\id) == \#quizstream)
    if elem.is(\:animated)
      return true
    elem = elem.parent()
  return false

printStack = ->
  e = new Error('dummy')
  stack = e.stack.replace(/^[^\(]+?[\n$]/gm, '')
    .replace(/^\s+at\s+/gm, '')
    .replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@')
    .split('\n')
  console.log stack

root.scroll-elem-idx = 0

scrollToElement = (elem) ->
  root.scroll-elem-idx += 1
  cur-elem-idx = root.scroll-elem-idx
  offset = elem.offset().top
  scrollWindow offset
  if isParentAnimated(elem)
    setTimeout ->
      if cur-elem-idx != root.scroll-elem-idx
        return
      newoffset = elem.offset().top
      if Math.abs(newoffset - offset) > 30
        scrollWindow newoffset
    , 350


#scrollWindowBy = (offset) ->
#  scrollWindow $(window).scrollTop() + offset

scrollWindow = (offset-top) ->
  #$(window).scrollTop offset-top
  $('html, body').animate {
    scrollTop: offset-top
  }, '1000', 'swing'

applyTransform = (elem, transform) ->
  if elem.data('transform') == transform
    return
  elem.data 'transform', transform
  elem.css {
    webkit-transform: transform
    moz-transform: transform
    ms-transform: transform
    transform: transform
  }

haveTransform = (elem) ->
  if not elem? or not elem.data?
    return false
  transform = elem.data('transform')
  if transform? and transform != ''
    return true
  return false

removeActiveVideoAndShrink = root.removeActiveVideoAndShrink = ->
  video = $(\.activevideo)
  #outerbody = getOuterBody video
  #if outerbody?
  #  applyTransform outerbody, 'scale(0.5) translateY(-50%) translateX(-50%)'
  video.removeClass \activevideo

gotoQuestionNum = (qnum) ->
  pauseVideo()
  panel = getVideoPanel($(\.activevideo))
  if panel? and qnum != panel.data(\prebody)
    #$(\.activevideo).removeClass \activevideo
    removeActiveVideoAndShrink()
    #qidx = getQidx qnum
    #vidname = getVidnameForQidx qidx
    #vidpart = getVidpartForQidx qidx
    #makeVideoActiveByVideoPanel getVideo(vidname, vidpart) 
  body = getBody qnum
  scrollToElement body
  #scrollWindow body.offset().top
  #$(window).scrollTop body.offset().top
  #throw 'gotoQuestionNum unimplemented'

makeVideoActiveByVideoPanel = (videopanel) ->
  video = videopanel.find \video
  makeVideoActiveByVideoTag video

makeVideoActiveByVideoTag = (video) ->
  if not video.hasClass \activevideo
    pauseVideo()
    #$(\.activevideo).removeClass \activevideo
    removeActiveVideoAndShrink()
    outerbody = getOuterBody video
    if outerbody?
      applyTransform outerbody, ''
    video.addClass \activevideo
    addlogvideo {
      event: \makeactive
    }

makeVideoActive = root.makeVideoActive = (qnum) ->
  body = $("\#body_#qnum")
  video = body.find \video
  makeVideoActiveByVideoTag video

gotoVideoNum = (qnum) ->
  makeVideoActive qnum
  setVideoFocused(true)

gotoNum = root.gotoNum = (qnum) ->
  body = $("\#body_#qnum")
  switch body.data(\type)
  | \video => gotoVideoNum qnum
  | \question => gotoQuestionNum qnum
  | _ => throw 'unexpected body type: ' + body.data(\type) + ' for qnum: ' + qnum

disableAnswerOptions = (qnum) ->
  $("input[type=radio][name=radiogroup_#qnum]").attr('disabled', true)
  $("input[type=checkbox][name=checkboxgroup_#qnum]").attr('disabled', true)

enableAnswerOptions = (qnum) ->
  $("input[type=radio][name=radiogroup_#qnum]").attr('disabled', false)
  $("input[type=checkbox][name=checkboxgroup_#qnum]").attr('disabled', false)


disableQuestion = root.disableQuestion = (qnum) ->
  type = getType qnum
  body = getBody qnum
  switch type
  | \video =>
    body.remove()
  | \question =>
    disableAnswerOptions qnum
    /*
    $('#check_' + qnum).attr('disabled', true)
    $('#watch_' + qnum).attr('disabled', true)
    #$('#skip_' + qnum).attr('disabled', true)
    $('#show_' + qnum).attr('disabled', true)
    $('#next_' + qnum).attr('disabled', true)
    */
    hideButton qnum, \check
    hideButton qnum, \watch
    hideButton qnum, \show
    hideButton qnum, \next
  | _ => throw 'unknown body type ' + type
  body.css 'background-color' 'rgb(232,232,232)'
  if getVideosDependingOnQuestion(qnum)?
    for qnum-video in getVideosDependingOnQuestion(qnum)
      disableQuestion qnum-video

hideQuestion = (qnum) ->
  $("\#body_#qnum").hide()

initializeQuestion = ->
  return {
    correct: []
    incorrect: []
    skip: []
  }

root.question_progress = [initializeQuestion() for x in root.questions]

havePassedQuestion = (question) ->
  return question.correct.length > 0 or question.skip.length > 0

mostRecentCorrect = (question) ->
  if question.correct.length > 0
    return question.correct[*-1]
  return 0

mostRecentSkip = (question) ->
  if question.skip.length > 0
    return question.skip[*-1]
  return 0

mostRecentCorrectOrSkip = (question) ->
  return Math.max(mostRecentCorrect(question), mostRecentSkip(question))

scoreQuestion = (now, question) ->
  # higher score = more need to review
  return now - mostRecentCorrectOrSkip(question)

maxidx = (list) ->
  maxidx = 0
  maxval = Number.MIN_VALUE
  for item,idx in list
    if item > maxval
      maxval = item
      maxidx = idx
  return maxidx

getNextQuestionOld = ->
  now = Date.now()
  scores = [scoreQuestion(now, question) for question,idx in root.question_progress]
  qidx = maxidx scores
  #qidx = Math.random() * root.questions.length |> Math.floor
  return root.questions[qidx]

getNextQuestion = ->
  curqnum = getCurrentQuestionQnum()
  curbody = getBody curqnum
  curqidx = -1
  if curbody? and curbody.data(\qidx)? and isFinite(curbody.data(\qidx))
    curqidx = curbody.data(\qidx)
  scores = [{score: getMasteryScoreForQuestion(qidx), qidx: qidx} for qidx in [0 til root.questions.length] when qidx != curqidx]
  scores = [{score: score, qidx: qidx} for {score, qidx} in scores when score != null]
  scores.sort (a,b) ->
    return a.score - b.score
  new-qidx = scores[0].qidx
  console.log 'new-qidx is: ' + new-qidx
  console.log 'question is: ' + root.questions[new-qidx]
  return root.questions[new-qidx]

interleavedConcat = (list1, list2) ->
  output = []
  l1 = 0
  l2 = 0
  while l1 < list1.length or l2 < list2.length
    if l1 == list1.length and l2 == list2.length
      break
    else if l1 == list1.length
      output.push list2[l2++]
    else if l2 == list2.length
      output.push list1[l1++]
    else if (l1 + l2) % 0 == 0
      output.push list1[l1++]
    else
      output.push list2[l2++]
  return output

toBrainData = (list, outval) ->
  return {input: list, output: [outval]}

getInitialTrainData = ->
  # features:
  # % of immediate dependent video watched
  # has been correctly answered previously [1 or 0]
  # ratio of correct vs incorrect responses 
  positive-instances-raw = [
    [1.0, 0.0, 0.0]
    [1.0, 1.0, 0.5]

  ]
  positive-instances = [toBrainData(x, 1.0) for x in positive-instances-raw]
  negative-instances-raw = [
    [0.0, 0.0, 0.0]
  ]
  negative-instances = [toBrainData(x, 0.0) for x in negative-instances-raw]
  return interleavedConcat positive-instances, negative-instances

getClassifier = root.getClassifier = ->
  net = new brain.NeuralNetwork()
  net.train getInitialTrainData()
  return net

/*
tovol = root.tovol = (l) -> return new convnetjs.Vol(l)

getInitialTrainData = ->
  # features: % of immediate dependent video watched, has been correctly answered previously, was answered correctly last time, % correctly answered thus far, 
  answered_correctly_data = [tovol([1.0])]
  answered_incorrectly_data = [tovol([0.0])]
  return [interleavedConcat(answered_correctly_data, answered_incorrectly_data), interleavedConcat([1]*answered_correctly_data.length, [0]*answered_incorrectly_data.length)] # data, labels

getMagicNet = root.getMagicNet = ->
  [train_data,train_labels] = getInitialTrainData()
  magic-net = new convnetjs.MagicNet(train_data, train_labels)
  console.log train_data
  console.log train_labels
  magic-net.onFinishBatch ->
    console.log 'batch finished!'
    testData = tovol([1.0])
    results = magic-net.predict_soft(testData)
    #console.log results.w[0]
    console.log results
  setInterval ->
    #console.log 'magic-net step!'
    magic-net.step()
  , 0
*/

setExplanationHtml = root.setExplanationHtml = (qnum, html) ->
  $("\#explanation_#qnum").html(html)

setExplanation = root.setExplanation = (qnum, text) ->
  $("\#explanation_#qnum").text(text)

getExplanation = root.getExplanation = (qnum) ->
  return $("\#explanation_#qnum").text()

needAnswerForQuestion = (qnum) ->
  setExplanationHtml qnum, '<b>Please answer the question</b> before moving to the next video'

clearNeedAnswerForQuestion = (qnum) ->
  if getExplanation(qnum) == 'Please answer the question before moving to the next video'
    setExplanation qnum, ''

tryClearWaitBeforeAnswering = root.tryClearWaitBeforeAnswering = (qnum) ->
  explanation = getExplanation(qnum)
  if explanation.indexOf('Please watch at least ') == 0
    qbody = getBody qnum
    vidname = qbody.data \vidname
    vidpart = qbody.data \vidpart
    progress = getVideoProgress vidname, vidpart
    target-amount = parseInt explanation.split('%')[0].split(' ')[*-1]
    if 100 * progress >= target-amount
      enableAnswerOptions qnum
      setExplanation qnum, ''
      showButton qnum, \check

clearWaitBeforeAnswering = root.clearWaitBeforeAnswering = (qnum) ->
  if getExplanation(qnum).indexOf('Please watch at least ') == 0
    enableAnswerOptions qnum
    setExplanation qnum, ''
    showButton qnum, \check

waitBeforeAnswering = root.waitBeforeAnswering = (qnum, target) ->
  disableAnswerOptions qnum
  setExplanationHtml qnum, "<span style='font-size: 20px'><b>Please watch at least #{toPercent(target)}% of this video part</b> before trying to answer again.</span>"

createRadio = (qnum, idx, option, body) ->
  inputbox = J("input.radiogroup_#{qnum}(type='radio' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "radiogroup_#{qnum}").attr('id', "radio_#{qnum}_#{idx}").attr('value', idx).change (evt) ->
    clearNeedAnswerForQuestion qnum
    addlog {
      event: \radiobox
      type: \selection
      qnum: qnum
      optionidx: idx
    }
    #setDefaultButton qnum, \check
    /*
    question = root.questions[getQidx(qnum)]
    answers = getAnswerValue \radio, qnum
    if isAnswerCorrect question, answers
      #showAnswer qnum, true
      (getButton qnum, \check).click()
    */
    #$('#check_' + qnum).attr('disabled', false)
  body.append J('.radio').append J('label').append(inputbox).append(option)
  #body.append inputbox
  #body.append J("label(style='display: inline-block; font-weight: normal' for='radio_#{qnum}_#{idx}')").html option
  #body.append J('br')

shouldBeChecked = (qnum, idx) ->
  question = root.questions[getQidx(qnum)]
  if question.correct.indexOf(idx) != -1
    return true
  return false

createCheckbox = (qnum, idx, option, body) ->
  inputbox = J("input.checkboxgroup_#{qnum}(type='checkbox' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "checkboxgroup_#{qnum}").attr('id', "checkbox_#{qnum}_#{idx}").attr('value', idx).change (evt) ->
    clearNeedAnswerForQuestion qnum
    value = $('#checkbox_' + qnum + '_' + idx).is(':checked')
    shouldbechecked = shouldBeChecked(qnum, idx)
    addlog {
      event: \checkbox
      type: \selection
      value
      shouldbechecked
      qnum
      optionidx: idx
    }
    #setDefaultButton qnum, \check
    /*
    question = root.questions[getQidx(qnum)]
    answers = getAnswerValue \checkbox, qnum
    if isAnswerCorrect question, answers
      #showAnswer qnum, true
      (getButton qnum, \check).click()
    */
    #$('#check_' + qnum).attr('disabled', false)
  body.append J('.checkbox').append J('label').append(inputbox).append(option)
  #body.append inputbox
  #body.append J("label(style='display: inline-block; font-weight: normal' for='checkbox_#{qnum}_#{idx}')").html option
  #body.append J('br')

setCheckboxOption = root.setCheckboxOption = (qnum, idx, value) ->
  $('#checkbox_' + qnum + '_' + idx).prop('checked', value)
  #$('#checkbox_' + qnum + '_' + idx).change()

setOption = (type, qnum, idx, value) ->
  switch type
  | \radio => throw 'selectOption not implemented for radio'
  | \checkbox => setCheckboxOption(qnum, idx, value)
  | _ => 'selectOption not implemented for ' + type

createWidget = (type, qnum, idx, option, body) ->
  switch type
  | \radio => createRadio(qnum, idx, option, body)
  | \checkbox => createCheckbox(qnum, idx, option, body)
  | _ => throw 'nonexistant question type ' + type

getRadioValue = root.getRadioValue = (qnum) ->
  #throw 'getRadioValue not implemented'
  radioname = 'radiogroup_' + qnum
  return parseInt $("input[type=radio][name=#radioname]:checked").val()

getCheckboxes = root.getCheckboxes = (qnum) ->
  numoptions = $('.checkboxgroup_' + qnum).length
  return [$('#checkbox_' + qnum + '_' + i)[0] for i in [0 til numoptions]]

getCheckboxValue = root.getCheckboxValue = (qnum) ->
  output = []
  for checkbox,i in getCheckboxes(qnum)
    if checkbox.checked
      output.push i
  return output
  #return [parseInt(x) for x in $("input[type=checkbox][name=#checkboxname]:checked").map(-> $(this).val()).get()]

arraysEqualUnsorted = root.arraysEqualUnsorted = (a,b) ->
  a = a[to]
  a.sort()
  b = b[to]
  b.sort()
  return arraysEqual a, b

arraysEqual = root.arraysEqual = (a,b) ->
  return a === b
  #if a.length != b.length
  #  return false
  #for i in [0 til a.length]
  #  if a[i] != b[i]
  #    return false
  #return true

getAnswerValue = (type, qnum) ->
  switch type
  | \radio => getRadioValue qnum # "radiogroup_#qnum"
  | \checkbox => getCheckboxValue qnum # "checkboxgroup_#qnum"
  | _ => throw 'nonexistant question type ' + type 

isAnswerCorrect = (question, answers) ->
  switch question.type
  | \radio => answers == question.correct
  | \checkbox => arraysEqualUnsorted answers, question.correct
  | _ => throw 'nonexistant question type ' + type

markQuestion = (question_idx, mark) ->
  if question_idx.idx?
    return markQuestion question_idx.idx, mark
  question_progress = root.question_progress[question_idx]
  question_progress[mark].push Date.now()

questionSkip = (question) -> markQuestion question, 'skip'

questionCorrect = (question) -> markQuestion question, 'correct'

questionIncorrect = (question) -> markQuestion question, 'incorrect'

root.overlap-button = null
root.automatic-trigger = false

resetButtonFill = ->
  if root.overlap-button?
    root.overlap-button.hide()
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  button-fill = 0
  autotrigger.data('button-fill', button-fill)
  #partialFillButton button-fill

increaseButtonFill = ->
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  button-fill = 0
  if autotrigger.data('button-fill')?
    button-fill = autotrigger.data('button-fill')
  button-fill += 0.1
  if button-fill >= 1.0
    resetButtonFill()
    #disableButtonAutotrigger()
    root.automatic-trigger = true
    autotrigger.click()
    root.automatic-trigger = false
    return
  autotrigger.data('button-fill', button-fill)
  partialFillButton button-fill

partialFillButton = root.partialFillButton = (fraction) ->
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  if not root.overlap-button?
    root.overlap-button = J('button.btn.btn-success.btn-lg').css('position', 'absolute').css('pointer-events', 'none')
    $('#quizstream').append /*J('#overlapButtonContainer').append*/ root.overlap-button
  root.overlap-button.text autotrigger.text()
  root.overlap-button.width autotrigger.width()
  root.overlap-button.height autotrigger.height()
  {top, left} = autotrigger.offset()
  root.overlap-button.css \top, top
  root.overlap-button.css \left, left
  root.overlap-button.css 'clip', 'rect(0px ' + (autotrigger.outerWidth() * fraction) + 'px auto 0px)' # top right bottom left
  root.overlap-button.show()

root.inserted-reviews = {}

haveInsertedReview = (qnum) ->
  if root.inserted-reviews[qnum]?
    return true
  return false

reviewInserted = (qnum) ->
  root.inserted-reviews[qnum] = true

showIsCorrect = (qnum, isCorrect, options) ->
  if not options?
    options = {}
  qidx = getQidx qnum
  question = root.questions[qidx]
  feedback = J('span')
  if isCorrect
    feedback.append J('b').css('color', 'green').text 'Correct'
    if not question.explanation? or question.explanation == '(see correct answers above)'
      correcttext = 'Move on to the next question!'
      if options.correcttext?
        correcttext = options.correcttext
      $("\#explanation_#qnum").text correcttext
    else
      $("\#explanation_#qnum").text question.explanation
  else
    feedback.append J('b').css('color', 'red').text 'Incorrect'
    incorrecttext = 'We suggest you watch the video and try answering again, or see solution'
    if options.incorrecttext?
      incorrecttext = options.incorrecttext
    $("\#explanation_#qnum").text incorrecttext
  #feedback.append question.explanation
  feedback-display = $("\#iscorrect_#qnum")
  feedback-display.html ''
  feedback-display.append feedback

scrambleAnswerOptionsCheckbox = (qnum) ->
  #options = $(".checkboxgroup_#{qnum}")
  optionsdiv = $("\#options_#{qnum}")
  options = optionsdiv.find('.checkbox')
  for i in [0 til options.length]
    randidx = Math.floor(Math.random() * options.length)
    curopt = $(options[randidx]).detach()
    optionsdiv.append curopt

scrambleAnswerOptions = root.scrambleAnswerOptions = (qnum) ->
  scrambleAnswerOptionsCheckbox(qnum)

hideAnswer = root.hideAnswer = (qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  body = getBody qnum
  if question.type == \checkbox
    $(".checkboxgroup_#{qnum}").prop \checked, false
  else if question.type == \radio
    $(".radiogroup_#{qnum}").prop \checked, false
  feedback-display = $("\#iscorrect_#qnum")
  feedback-display.html ''
  setExplanation qnum, ''
  hideButton qnum, \show
  hideButton qnum, \next
  showButton qnum, \check
  #showButton qnum, \watch
  hideButton qnum, \review
  enableAnswerOptions qnum
  scrambleAnswerOptions qnum

showAnswer = root.showAnswer = (qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  body = getBody qnum
  if question.type == \checkbox
    $(".checkboxgroup_#{qnum}").prop \checked, false
    for answeridx in question.correct
      $("\#checkbox_#{qnum}_#{answeridx}").prop \checked, true
  else if question.type == \radio
    $(".radiogroup_#{qnum}").prop \checked, false
    $("\#radio_#{qnum}_#{question.correct}").prop \checked, true
  feedback-display = $("\#iscorrect_#qnum")
  feedback-display.html '<b style="color: red">Incorrect - see correct answer above</b>'
  setExplanation qnum, question.explanation
  hideButton qnum, \show
  hideButton qnum, \check
  vidname = question.videos[0].name
  vidpart = question.videos[0].part
  showButton qnum, \review
  hideButton qnum, \watch
  updateWatchButtonProgress(vidname, vidpart)
  disableAnswerOptions qnum

videoAtFront = ->
  video = $('.activevideo')
  if video[0].currentTime < 1.0
    return true
  return false

videoAtEnd = ->
  video = $('.activevideo')
  if Math.abs(video[0].currentTime - video[0].duration) < 1.0
    return true
  return false

scrollVideoForward = ->
  video = $('.activevideo')
  video[0].currentTime += 5.0

scrollVideoBackward = ->
  video = $('.activevideo')
  video[0].currentTime -= 5.0

isVideoPlaying = root.isVideoPlaying = ->
  video = $('.activevideo')
  if video.length == 0
    return false
  return not video[0].paused

playVideoFromStart = ->
  video = $('.activevideo')
  if video.length < 1
    return
  video[0].currentTime = 0
  if video[0].paused
    video[0].play()

root.currentQuestionQnum = 0

getCurrentQuestionQnum = root.getCurrentQuestionQnum = ->
  root.currentQuestionQnum

playVideo = ->
  resetIfNeeded getCurrentQuestionQnum()
  video = $('.activevideo')
  if video.length < 1
    return
  if not video[0].paused
    return
  addlogvideo {
    event: \play
  }
  video[0].play()

root.playback-speed = '1.00'

setPlaybackSpeed = (new-speed) ->
  if not new-speed?
    return
  root.playback-speed = new-speed
  $('.currentspeed').text(new-speed + 'x')
  new-speed = parseFloat new-speed
  addlogvideo {
    event: \setPlaybackSpeed
    newspeed: new-speed
  }
  $('video').prop('playbackRate', new-speed)
  #for x in $('video')
  #  x.playbackRate = parseFloat new-speed

increasePlaybackSpeed = root.increasePlaybackSpeed = ->
  speed-map = {
    '0.75': \1.00
    '1.00': \1.25
    '1.25': \1.50
    '1.50': \1.75
    '1.75': \2.00
    '2.00': \2.00
  }
  new-speed = speed-map[root.playback-speed]
  setPlaybackSpeed new-speed

decreasePlaybackSpeed = root.decreasePlaybackSpeed = ->
  speed-map = {
    '0.75': \0.75
    '1.00': \0.75
    '1.25': \1.00
    '1.50': \1.25
    '1.75': \1.50
    '2.00': \1.75
  }
  new-speed = speed-map[root.playback-speed]
  setPlaybackSpeed new-speed

pauseVideo = ->
  video = $('.activevideo')
  for vid in video
    if not vid.paused
      vid.pause()
  #if not video[0].paused
  #  video[0].pause()

disableButtonAutotrigger = ->
  resetButtonFill()
  button = $(\.autotrigger)
  button.removeClass \autotrigger
  if button.hasClass \btn-primary
    button.removeClass \btn-primary
    button.addClass \btn-default

getButton = root.getButton = (qnum, buttontype) ->
  switch buttontype
  | \show => $("\#show_#qnum")
  | \check => $("\#check_#qnum")
  | \watch => $("\#watch_#qnum")
  | \next => $("\#next_#qnum")
  | \review => $("\#review_#qnum")
  | \skip => $("\#skip_#qnum")
  | \continue => $("\#continue_#qnum")
  | \submit => $("\#submit_#qnum")
  | _ => throw 'unknown button type ' + buttontype

showButton = (qnum, buttontype) ->
  (getButton qnum, buttontype).show()

hideButton = (qnum, buttontype) ->
  (getButton qnum, buttontype).hide()

turnOffAllDefaultbuttons = ->
  buttons = $(\.btn-primary)
  buttons.removeClass \btn-primary
  buttons.addClass \btn-default

turnOffDefaultButton = (button, buttontype) ->
  if typeof button == typeof 0 # first argument is actually qnum
    button = getButton button, buttontype
  if button.hasClass \btn-primary
    button.removeClass \btn-primary
    button.addClass \btn-default

setDefaultButton = (button, buttontype) -> # or alternativey: button
  return # should no longer do anything
  if typeof button == typeof 0 # first argument is actually qnum
    button = getButton button, buttontype
  if not button.hasClass \autotrigger
    #$(\.autotrigger).removeClass \autotrigger
    disableButtonAutotrigger()
    button.addClass \autotrigger
  if not button.hasClass \btn-primary
    button.removeClass \btn-default
    button.addClass \btn-primary

showChildVideoForQuestion = (qnum) ->
  if childVideoAlreadyInserted qnum
    gotoNum getChildVideoQnum(qnum)
  else
    insertReviewForQuestion qnum
    gotoNum getChildVideoQnum(qnum)
  setVideoFocused(true)

getVideoDependencies = (vidname, vidpart) ->
  dependencies = []
  #if vidpart?
  #  for prevpart in [0 til vidpart]
  #    dependencies.push [vidname, prevpart]
  if root.video_dependencies[vidname]?
    dependencies = dependencies ++ [[x,root.video_info[x].parts.length - 1] for x in root.video_dependencies[vidname]]
  return dependencies

showChildVideoForVideo = (qnum) ->
  setVideoFocused(false)
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  prebody-qnum = getVideo(vidname, vidpart).data(\prebody)
  if childVideoAlreadyInserted qnum
    gotoNum getChildVideoQnum(qnum)
  else
    dependency = getVideoDependencies(vidname, vidpart)[*-1]
    [dvidname,dvidpart] = dependency
    /*
    if vidpart?
      insertBefore qnum, (insertVideo dvidname, dvidpart, "<h3>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{vidname} part #{vidpart+1}</span>)</h3>")
    else
      insertBefore qnum, (insertVideo dvidname, dvidpart, "<h3>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{vidname}</span>)</h3>")
    */
    placeVideoBefore dvidname, dvidpart, prebody-qnum
    addVideoDependsOnQuestion qnum, counterCurrent(\qnum)
    body = getBody qnum
    body.data \video, counterCurrent(\qnum)
    gotoNum getChildVideoQnum(qnum)
  setVideoFocused(true)
  playVideo()

showChildVideo = root.showChildVideo = (qnum) ->
  type = getType qnum
  switch type
  | \question => showChildVideoForQuestion(qnum)
  | \video => showChildVideoForVideo(qnum)
  | _ => throw 'unknown item type ' + type

resetIfNeeded = root.resetIfNeeded = (qnum) ->
  if (getBody qnum).data(\answered)
    if not (getBody qnum).data(\correct)
      # hide answer and require user to try again
      (getBody qnum).data(\answered, false)
      (getBody qnum).data(\correct, false)
      hideAnswer qnum

root.vidnamepart-to-videos = {}

resetVideoBody = (vidname, vidpart) ->
  vidnamepart = toVidnamePart vidname, vidpart
  delete root.vidnamepart-to-videos[vidnamepart]

setVideoBody = (vidname, vidpart, body) ->
  vidnamepart = toVidnamePart vidname, vidpart
  root.vidnamepart-to-videos[vidnamepart] = body

getVideo = root.getVideo = (vidname, vidpart) ->
  vidnamepart = toVidnamePart vidname, vidpart
  if root.vidnamepart-to-videos[vidnamepart]?
    return root.vidnamepart-to-videos[vidnamepart]
  return $('.video_' + vidnamepart)

showVideo = (vidname, vidpart) ->
  curvid = getVideo(vidname, vidpart)
  gotoNum curvid.data(\qnum)

viewPreviousClip = (vidname, vidpart) ->
  pauseVideo()
  curvid = getVideo(vidname, vidpart)
  qnum = curvid.data(\qnum)
  prebody-qnum = curvid.data(\prebody)
  dependency = getVideoDependencies(vidname, vidpart)[*-1]
  [dvidname,dvidpart] = dependency
  placeVideoBefore dvidname, dvidpart, prebody-qnum
  showVideo dvidname, dvidpart
  playVideo()

appendWithSlideDown = (elem, parent, time) ->
  if not time?
    time = 300
  elem.appendTo(parent).hide().slideDown(time)

placeVideoBefore = root.placeVideoBefore = (vidname, vidpart, qnum) ->
  vidnamepart = toVidnamePart vidname, vidpart
  curvid = getVideo(vidname, vidpart)
  if curvid.length > 0
    if curvid.data(\prebody) == qnum
      return # already inserted in the correct location
    else
      target-body = $('#prebody_' + qnum)
      (getButton curvid.data(\prebody), \watch).show()
      #curvid-data = curvid.data()
      outerbody = getOuterBody curvid
      outerbody.detach()
      #target-body.append curvid
      appendWithSlideDown outerbody, target-body
      #curvid.data(curvid-data)
      curvid.data(\prebody, qnum)
  else
    newvideo = insertVideo vidname, vidpart
    #$('#prebody_' + qnum).append newvideo
    appendWithSlideDown newvideo, $('#prebody_' + qnum)
    getVideo(vidname, vidpart).data(\prebody, qnum)

getPartialScoreCheckbox = root.getPartialScoreCheckbox = (qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  numoptions = $('.checkboxgroup_' + qnum).length
  scores = []
  for optidx in [0 til numoptions]
    checkbox = $('#checkbox_' + qnum + '_' + optidx)
    myanswer = checkbox.is(':checked')
    realanswer = question.correct.indexOf(optidx) != -1
    score = 0
    if myanswer == realanswer
      score = 1
    # TODO track whether has been put into incorrect / correct state and award partial credit accordingly
    # 0.8 for correct final state, 0.1 for entering correct state, 0.1 for not entering incorrect state
    scores.push score
  return sum(scores) / scores.length

getPartialScoreSelfRate = root.getPartialScoreSelfRate = (qnum) ->
  radioidx = getRadioValue(qnum)
  switch radioidx
  | 0 => 1.0 # perfectly understand
  | 1 => 0.75 # somewhat understand
  | 2 => 0.5 # do not understand
  | _ => 0.75

getPartialScore = root.getPartialScore = (qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  if question.type == 'checkbox'
    return getPartialScoreCheckbox qnum
  if question.type == 'radio'
    if question.selfrate
      return getPartialScoreSelfRate qnum
  throw 'getScoreForAnswers does not support question type: ' + question.type

root.question_scores = []

computeScoreFromHistory = (qnumhistory, scorehistory) ->
  total = 0
  divisor = 0
  power = 1
  for qnum in qnumhistory
    for score in scorehistory[qnum]
      total += power * score
      divisor += power
    power = power * 0.25
  return total / divisor

haveSeenQuestion = root.haveSeenQuestion = (qidx) ->
  if root.question_scores[qidx]?
    return true
  return false

getScoreForQuestion = root.getScoreForQuestion = (qidx) ->
  if not root.question_scores[qidx]?
    return 0
  return root.question_scores[qidx].current

updateQuestionScore = root.updateQuestionScore = (qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  score = getPartialScore qnum
  overallscore = score
  if not root.question_scores[qidx]?
    root.question_scores[qidx] = {
      current: score
      qnumhistory: [] # most recent to oldest
      scorehistory: {}
    }
  scoreinfo = root.question_scores[qidx]
  if not scoreinfo.scorehistory[qnum]?
    scoreinfo.scorehistory[qnum] = []
    scoreinfo.qnumhistory.unshift qnum # prepends
  scoreinfo.scorehistory[qnum].unshift score # prepends
  scoreinfo.current = computeScoreFromHistory(scoreinfo.qnumhistory, scoreinfo.scorehistory)
  overallscore = scoreinfo.current
  addlog {
    event: \questionscore
    newscore: score
    overallscore: overallscore
    qnum: qnum
    qidx: qidx
    scoreinfo: root.question_scores[qidx]
  }
  $('#questionscore_' + qnum).text(overallscore)
  #score = getScoreForAnswers question, answers

root.question_recency_info = []

getRecencyScoreForQuestion = root.getRecencyScoreForQuestion = (qidx) ->
  # 0 = was inserted just now
  # 1 = has been questions.length or more since it has been seen
  if not root.question_recency_info[qidx]?
    return 0
  qcycle = root.question_recency_info[qidx].qcycle
  cur-qcycle = counterCurrent \qcycle
  cycles-since-seen = Math.min(root.questions.length, cur-qcycle - qcycle)
  oldness-score = cycles-since-seen / root.questions.length
  oldness-score = Math.max(0, Math.min(1, oldness-score))
  return 1 - oldness-score

getVideoScoreForQuestion = root.getVideoScoreForQuestion = (qidx) ->
  vidinfo = root.questions[qidx].videos[0]
  vidname = vidinfo.name
  vidpart = vidinfo.part
  return getVideoProgress vidname, vidpart

getMasteryScoreForQuestion = root.getMasteryScoreForQuestion = (qidx) ->
  # 1 = mastered (no need to review), 0 = haven't tried yet, null = should not attempt it at all
  questionscore = getScoreForQuestion qidx * 1.5 # 0 = answered the worst, 1 = answered the best
  recencyscore = (getRecencyScoreForQuestion qidx) # 0 = oldest, 1 = most recent
  videoscore = (getVideoScoreForQuestion qidx) * 0.5 # 0 = haven't watched any, 1 = watched 100%
  if qidx == 0 or haveSeenQuestion(qidx) or haveSeenQuestion(qidx - 1)
    return Math.max(0, Math.min(1, (questionscore + recencyscore + videoscore) / 3))
  return null

updateRecencyInfo = root.updateRecencyInfo = (qnum) ->
  qidx = getQidx qnum
  qcycle = getBody(qnum).data \qcycle
  if not root.question_recency_info[qidx]?
    root.question_recency_info[qidx] = {}
  root.question_recency_info[qidx].qcycle = qcycle
  root.question_recency_info[qidx].time = Date.now()
  addlog {
    event: \recencyinfo
    qnum: qnum
    qidx: qidx
    recencyinfo: root.question_recency_info[qidx]
  }

root.numIncorrectAnswers = 0

showInVideoQuiz = root.showInVideoQuiz = (vidname, vidpart) ->
  if root.platform == 'invideo'
    quiz-overlay = $('#quizoverlay_' + vidname + '_' + vidpart)
    if quiz-overlay.filter(':visible').length > 0
      return
    quiz-overlay.show()
    addlogvideo {
      event: \quizshow
      quizvidname: vidname
      quizvidpart: vidpart
    }

hideInVideoQuiz = root.hideInVideoQuiz = ->
  if root.platform == 'invideo'
    quiz-overlay = $('.quizoverlay')
    if quiz-overlay.filter(':visible').length == 0
      return
    quiz-overlay.hide()
    addlogvideo {
      event: \quizhide
      quizvidname: quiz-overlay.data(\quizvidname)
      quizvidpart: quiz-overlay.data(\quizvidpart)
    }

insertInVideoQuiz = root.insertInVideoQuiz = (question, video, vidpart) ->
  vidname = video.data(\vidname)
  target = video.find '#quizoverlay_' + vidname + '_' + vidpart
  #target = $('#quizoverlay_' + vidname + '_' + vidpart)
  insertQuestion question, { immediate: true, novideo: true, append: true, target: target, nobuttons: true, nocontainer: true, invideo: true, video: video }

insertQuestion = root.insertQuestion = (question, options) ->
  options = {} if not options?
  if options.qnum?
    qnum = options.qnum
    counterSet 'qnum', qnum
  else
    qnum = counterNext 'qnum'
  if options.qcycle?
    qcycle = options.qcycle
    counterSet 'qcycle', qcycle
  else
    qcycle = counterNext 'qcycle'
  root.currentQuestionQnum = qnum
  root.numIncorrectAnswers = 0
  turnOffAllDefaultbuttons()
  #removeAllVideos()
  vidname = getVidnameForQuestion(question)
  vidpart = getVidpartForQuestion(question)
  body = J('.panel-body-new')
    .attr('id', "body_#qnum")
    .data(\qnum, qnum)
    .data(\qcycle, qcycle)
    .data('qidx', question.idx)
    .data(\type, \question)
    .data(\vidname, vidname)
    .data(\vidpart, vidpart)
    .css {
      padding-top: \0px
      padding-left: \10px
      padding-right: \10px
      padding-bottom: \10px
    }
  vidnamepart = getVidnamePartForQuestion(question)
  if question.exam
    question-title = question.title
  else
    question-title = root.video_info[vidname].title + ', part ' + (vidpart + 1) + '/' + root.video_info[vidname].parts.length
  question-subtitle = 'Question ' + (question.idx + 1) + ' of ' + root.questions.length
  question-subtitle-div = J('span').text question-subtitle
  question-score-div = J('span.questionscore_' + question.idx).css({
    float: \right
    #text-align: \right
    #clear: \both
    #display: \none
  })#.text('Question Score:')
  body.append J('div').css({font-size: \14px, padding-top: \10px, clear: \both}).append [ question-subtitle-div, question-score-div ]
  body.append J('div').css({font-size: \24px, padding-top: \0px}).text question-title
  body.append J('div').text question.text
  optionsdiv = J("\#options_#qnum")
  for option,idx in question.options
    createWidget(question.type, qnum, idx, option, optionsdiv)
  body.append optionsdiv
  addlog {
    event: 'insertquestion'
    type: 'question'
    qidx: question.idx
    qnum: qnum
    qcycle: qcycle
  }
  insertShowAnswerButton = ->
    body.append J('button.btn.btn-default.btn-lg#show_' + qnum).css(\display, \none).css('margin-right', '15px')/*.attr('disabled', true)*/.text('see solution').click (evt) ->
      questionSkip question
      showAnswer qnum
      showButton qnum, \next
      setDefaultButton qnum, \next
      addlog {
        event: 'show'
        type: 'button'
        qidx: question.idx
        qnum: qnum
      }
  quizvidname = question.videos[0].name
  quizvidpart = question.videos[0].part
  insertInVideoSubmitButton = ->
    body.append J('button.btn.btn-primary.btn-lg#submit_' + qnum).css('margin-right', '15px').html('<span class="glyphicon glyphicon-check"></span> submit answer').click (evt) ->
      console.log 'in video submit button clicked'
      answers = getAnswerValue question.type, qnum
      isCorrect = isAnswerCorrect question, answers
      partialscore = getPartialScore qnum
      if isCorrect
        showIsCorrect qnum, true, {correcttext: ''}
        hideButton qnum, \submit
        hideButton qnum, \skip
        showButton qnum, \continue
        addlogvideo {
          event: \check
          qidx: question.idx
          questionqnum: qnum
          correct: true
          partialscore: partialscore
          answers: answers
          numIncorrectAnswers: root.numIncorrectAnswers
          quizvidname
          quizvidpart
        }
      else
        root.numIncorrectAnswers += 1
        if root.numIncorrectAnswers >= 3
          showIsCorrect qnum, false, {incorrecttext: 'See correct answer above'}
          hideButton qnum, \skip
          hideButton qnum, \submit
          showButton qnum, \continue
          addlogvideo {
            event: \check
            qidx: question.idx
            questionqnum: qnum
            correct: false
            partialscore: partialscore
            answers: answers
            numIncorrectAnswers: root.numIncorrectAnswers
            quizvidname
            quizvidpart
          }
          showAnswer qnum
        else
          showIsCorrect qnum, false, {incorrecttext: 'Try again'}
          addlogvideo {
            event: \check
            qidx: question.idx
            questionqnum: qnum
            correct: false
            partialscore: partialscore
            answers: answers
            numIncorrectAnswers: root.numIncorrectAnswers
            quizvidname
            quizvidpart
          }
  insertInVideoContinueButton = ->
    body.append J('button.btn.btn-primary.btn-lg#continue_' + qnum).css('margin-right', '15px').css('display', 'none').html('<span class="glyphicon glyphicon-forward"></span> continue').click (evt) ->
      console.log 'in video continue button clicked'
      addlogvideo {
        event: \continue
        qidx: question.idx
        questionqnum: qnum
        quizvidname
        quizvidpart
      }
      root.most-recent-time-quiz-skipped[quizvidname + '_' + quizvidpart] = Date.now()
      hideInVideoQuiz()
      playVideo()
  insertInVideoSkipButton = ->
    body.append J('button.btn.btn-primary.btn-lg#skip_' + qnum).css('margin-right', '15px').html('<span class="glyphicon glyphicon-forward"></span> skip question').click (evt) ->
      console.log 'in video skip button clicked'
      addlogvideo {
        event: \skip
        qidx: question.idx
        questionqnum: qnum
        quizvidname
        quizvidpart
      }
      root.most-recent-time-quiz-skipped[quizvidname + '_' + quizvidpart] = Date.now()
      hideInVideoQuiz()
      playVideo()
  insertCheckAnswerButton = ->
    body.append J('button.btn.btn-primary.btn-lg#check_' + qnum).css('margin-right', '15px').css(\width, \100%)/*.attr('disabled', true)*/.html('<span class="glyphicon glyphicon-check"></span> check answer').click (evt) ->
      gotoNum qnum
      answers = getAnswerValue question.type, qnum
      updateQuestionScore(qnum)
      partialscore = getPartialScore(qnum)
      if isAnswerCorrect question, answers
        addlog {
          event: 'check'
          type: 'button'
          correct: true
          partialscore: partialscore
          qidx: question.idx
          answers: answers
          numIncorrectAnswers: root.numIncorrectAnswers
          qnum: qnum
        }
        showIsCorrect qnum, true
        questionCorrect question
        #insertQuestion getNextQuestion()
        #disableQuestion qnum
        #showButton qnum, \watch
        hideButton qnum, \review
        hideButton qnum, \check
        hideButton qnum, \show
        showButton qnum, \next
        #setDefaultButton qnum, \next
        disableAnswerOptions qnum
        #insertQuestion getNextQuestion()
        #(getButton qnum, \next).hide()
        updateRecencyInfo qnum
        (getBody qnum).data(\answered, true)
        (getBody qnum).data(\correct, true)
      else
        root.numIncorrectAnswers += 1
        addlog {
          event: 'check'
          type: 'button'
          correct: false
          partialscore: partialscore
          qidx: question.idx
          answers: answers
          numIncorrectAnswers: root.numIncorrectAnswers
          qnum: qnum
        }
        showIsCorrect qnum, false
        questionIncorrect question
        #setDefaultButton qnum, \watch
        showAnswer qnum
        (getBody qnum).data(\answered, true)
        (getBody qnum).data(\correct, false)
        #if (getButton qnum, \watch).data('progress') > 0.1
        #  showButton qnum, \next
        
        #showButton qnum, \show
        #(getButton qnum, \show).click()
        #insertQuestion getNextQuestion()
        #(getButton qnum, \next).hide()
        
        #if not haveInsertedReview qnum
        #  disableQuestion qnum
        #  insertReview question
        #  reviewInserted (counterCurrent \qnum)
  insertVideoHere = ->
    placeVideoBefore(vidname, vidpart, qnum)
    showVideo(vidname, vidpart)
    setVideoFocused(true)
  insertWatchVideoButton = (autotrigger) ->
    watch-video-button = J('button.btn.btn-primary.btn-lg#watch_' + qnum).css(\display, \none).data('vidname', vidname).data('vidpart', vidpart).addClass('watch_' + vidnamepart).css('margin-right', '15px').css(\width, \100%)/*.text("watch video (0% seen)")*/.click (evt) ->
      pauseVideo()
      addlog {
        event: 'watch'
        type: 'button'
        qidx: question.idx
        qnum: qnum
      }
      resetIfNeeded getCurrentQuestionQnum()
      if not root.replaying-logs
        insertVideoHere()
        playVideo()
      (getButton qnum, \watch).hide()
    if autotrigger
      setDefaultButton watch-video-button
    body.append watch-video-button
  insertReviewVideoButton = ->
    review-video-button = J('button.btn.btn-primary.btn-lg#review_' + qnum).addClass('review_' + vidnamepart).css(\display, \none).css('margin-right', '15px').css(\width, \100%).html('<span class="glyphicon glyphicon-play"></span> review video before answering again').click (evt) ->
      (getButton qnum, \watch).click()
      percent-seen = getVideoProgress vidname, vidpart
      if percent-seen < 0.75
        waitBeforeAnswering qnum, Math.min(0.75, percent-seen + 0.10)
        hideButton qnum, \check
    body.append review-video-button
  insertNextQuestionButton = ->
    body.append J('button.btn.btn-primary.btn-lg#next_' + qnum).css(\display, \none).css('margin-right', '15px').css(\width, \100%)/*.attr('disabled', true)*/.html('<span class="glyphicon glyphicon-forward"></span> next video').click (evt) ->
      if question.needanswer? and question.needanswer
        answer = getAnswerValue \radio, qnum
        if not answer? or not isFinite(answer)
          needAnswerForQuestion qnum
          return
      if not root.replaying-logs
        sendVideoPartsSeen()
      addlog {
        event: 'next'
        type: 'button'
        qidx: question.idx
        qnum: qnum
      }
      body.css \padding-top, \0px
      pauseVideo()
      questionCorrect question
      hideButton qnum, \next
      clearNeedAnswerForQuestion qnum
      disableAnswerOptions qnum
      if question.selfrate
        updateQuestionScore(qnum)
        updateRecencyInfo qnum
      #disableQuestion qnum
      #showButton qnum, \watch
      insertQuestion getNextQuestion()
  /*
  insertSkipButton = ->
    body.append J('button.btn.btn-default.btn-lg#skip_' + qnum).css('margin-right', '15px').text('already know answer').click (evt) ->
      console.log 'skipping question'
      disableQuestion qnum
      questionSkip question
      insertQuestion getNextQuestion()
  */
  body.append J(\hr.vspace).css(\height, \3px)
  body.append J("span\#iscorrect_#qnum").html('')
  body.append J("span\#explanation_#qnum").css(\margin-left, \5px).html('')
  body.append J(\br)
  if options.invideo
    insertInVideoSubmitButton()
    insertInVideoSkipButton()
    insertInVideoContinueButton()
  if not options.nobuttons
    insertWatchVideoButton(true)
    insertCheckAnswerButton()
    insertReviewVideoButton()
    insertShowAnswerButton()
    insertNextQuestionButton()
  #body.append J('.endquestion#endquestion_' + qnum).data(\qnum, qnum)
  if options.nocontainer
    containerdiv = J(\.container_ + qnum).css({width: \100%}).append [
      J(\.leftbar.leftbar_ + qnum).css({width: \100%, float: \left}).append(body),
      J(\.rightbar.rightbar_ + qnum).css({width: \0%, float: \right}).append(J('#prebody_' + qnum)),
      J(\div).css({clear: \both})
    ]
  else
    containerdiv = J(\.container_ + qnum).css({width: \100%}).append [
      J(\.leftbar.leftbar_ + qnum).css({width: \30%, float: \left}).append(body),
      J(\.rightbar.rightbar_ + qnum).css({width: \70%, float: \right}).append(J('#prebody_' + qnum)),
      J(\div).css({clear: \both})
    ]
  targetToAddQuestionTo = $(\#quizstream)
  if options.target
    targetToAddQuestionTo = options.target
  if options.append
    containerdiv.appendTo targetToAddQuestionTo
  else
    containerdiv.prependTo targetToAddQuestionTo
  #$('#quizstream').prepend J('#prebody_' + qnum)
  #body.prependTo($('#quizstream'))
  autoShowVideo = ->
    (getButton qnum, \watch).click()
  if not options.immediate? #and not question.autoshowvideo
    body.hide()
    setTimeout ->
      #removeAllVideos()
      if question.autoshowvideo
        body.slideDown(300)
        setTimeout ->
          playVideo()
        , 500
      else
        body.slideDown(300)
        scrollToElement body
    , 0
  scrambleAnswerOptions qnum
  updateWatchButtonProgress(vidname, vidpart)
  setTimeout ->
    if options.novideo
      return
    insertVideoHere()
    if options.immediate and question.autoshowvideo
      #autoShowVideo()
      playVideo()
  , 0
  if question.nocheckanswer
    (getButton qnum, \check).hide()
    (getButton qnum, \next).show()
  #heightinserted = $(window).height() - origheight
  /*
  if not root.replaying-logs
    heightinserted = $('#prebody_' + qnum).offset().top
    console.log 'heightinserted is: ' + heightinserted
    $(window).scrollTop(heightinserted)
    scrollWindow 0
  */
  #if root.question_progress[question.idx].correct.length > 0
  #  showButton qnum, \show
  #  setDefaultButton qnum, \show

isMouseInVideo = (evt) ->
  video = $ \.activevideo
  if video.length < 1
    return false
  #if timeSinceVideoFocus() < 1.0
  #  return true
  video-top = video.offset().top
  video-bottom = video-top + video.height()
  return video-top <= parseFloat(evt.pageY) <= video-bottom

isScrollAtBottom = ->
  return $(window).scrollTop() + $(window).height() == $(document).height()

root.replaying-logs = false

replayLogs = root.replayLogs = (logs) ->
  if root.platform != 'quizcram'
    return
  root.replaying-logs = true
  for log in logs
    if log.course != root.coursename
      continue
    if log.platform != root.platform
      continue
    console.log 'replaying: ' + JSON.stringify(log)
    switch log.event
    | \insertquestion =>
      counterSet \qnum, log.qnum
      counterSet \qcycle, log.qcycle
    | \questionscore =>
      root.question_scores[log.qidx] = log.scoreinfo
    | \recencyinfo =>
      root.question_recency_info[log.qidx] = log.recencyinfo
    | \videopartsseen =>
      for vidname,compressedData of log.partsseen
        decompressed = decompressBinaryArray compressedData
        root.video-parts-seen-server[vidname] = decompressed
        root.video-parts-seen[vidname] = decompressed[to]
    | _ => console.log log
  root.replaying-logs = false

replayLogsOrig = (logs) ->
  root.replaying-logs = true
  for log in logs
    console.log 'replaying: ' + JSON.stringify(log)
    switch log.event
    | \insertquestion =>
      if log.qnum != 0 #if bodyExists(log.qnum)
        continue
      insertQuestion root.questions[log.qidx], {qnum: log.qnum}
    | \watch => (getButton log.qnum, \watch).click()
    | \check => (getButton log.qnum, \check).click()
    | \show => (getButton log.qnum, \show).click()
    | \next => (getButton log.qnum, \next).click()
    | \checkbox => setOption \checkbox, log.qnum, log.optionidx, log.value
    | \radio => setOption \radio, log.qnum, log.optionidx, log.value
    | _ => console.log(log)
  root.replaying-logs = false

videoHeightFractionVisible = ->
  video = $('.activevideo')
  if video.length == 0
    return 0
  video-height = video.height()
  if video-height <= 0 or not isFinite video-height
    return 0
  window-height = $(window).height()
  window-top = $(window).scrollTop()
  window-bottom = window-top + window-height
  video-top = video.offset().top
  video-bottom = video-top + video-height
  video-hidden-top = Math.max(0, window-top - video-top)
  video-hidden-bottom = Math.max(0, video-bottom - window-bottom)
  video-hidden = video-hidden-top + video-hidden-bottom
  video-shown = video-height - video-hidden
  #fraction-hidden = video-hidden / Math.min(window-height, video-height)
  #return 1 - fraction-hidden
  fraction-shown = video-shown / Math.min(window-height, video-height)
  return fraction-shown

fixVideoHeightProcess = ->
  setInterval ->
    for x in $('video')
      fixVideoHeight $(x)
  , 250

questionAlwaysShownProcess = ->
  root.prev-scroll-top = 0
  setInterval ->
    scroll-top = $(window).scrollTop()
    if scroll-top == root.prev-scroll-top
      return
    root.prev-scroll-top = scroll-top
    qnum = getCurrentQuestionQnum()
    body = getBody qnum
    body-bottom = body.parent().parent().height()
    #last-video = getLastVideoForQuestion qnum
    #if not last-video?
    #  return
    #last-video-top = $(last-video).offset().top
    body-height = body.height()
    scroll-top = Math.min scroll-top, body-bottom - body-height - 10
    body.animate {
      padding-top: scroll-top
    }, 200
  , 500

getUrlParameters = root.getUrlParameters = ->
  url = window.location.href
  hash = url.lastIndexOf('#')
  if hash != -1
    url = url.slice(0, hash)
  map = {}
  parts = url.replace /[?&]+([^=&]+)=([^&]*)/gi, (m,key,value) ->
    map[key] = decodeURI(value)
  return map

prepadTo2 = (num) ->
  num = num.toString()
  if num.length == 1
    num = '0' + num
  return num

secondsToDisplayableMinutes = (seconds) ->
  seconds = Math.round seconds
  minutes = Math.floor(seconds / 60)
  seconds -= minutes * 60
  minutes = prepadTo2 minutes
  seconds = prepadTo2 seconds
  return "#minutes:#seconds"

millisecToDisplayable = (millisec) ->
  seconds = Math.round(millisec / 1000)
  hours = Math.floor(seconds / 3600)
  seconds -= hours * 3600
  minutes = Math.floor(seconds / 60)
  seconds -= minutes * 60
  hours = prepadTo2 hours
  minutes = prepadTo2 minutes
  seconds = prepadTo2 seconds
  return "#hours:#minutes:#seconds"

root.baseparams = null

root.have-shown-done = false

updateUrlBar = ->
  if not root.baseparams?
    pdict = {
      user: root.username
      course: root.coursename
      platform: root.platform
      started: root.time-started
    }
    if root.logging-disabled-globally
      pdict.nolog = true
    if root.limit-numquestions
      pdict.numquestions = root.limit-numquestions
    root.baseparams = '?' + $.param pdict
  millisecsElapsed = Date.now() - root.time-started
  elapsed = millisecToDisplayable(millisecsElapsed)
  if not root.have-shown-done and millisecsElapsed > 90 * 60 * 1000
    root.have-shown-done = true
    window.alert '90 minutes study time is over! Move on to the quiz!'
    #$('body').text '90 minutes study time is over! Move on to the quiz!'
  history.replaceState {}, '', root.baseparams + '#elapsed=' + elapsed

updateUrlHash = root.updateUrlHash = ->
  elapsed = millisecToDisplayable(Date.now() - root.time-started)
  window.location.hash = 'elapsed=' + elapsed

updateUsername = ->
  root.username = getUrlParameters().user ? getUrlParameters().username
  past-usernames = []
  if $.cookie('usernames')
    past-usernames = JSON.parse $.cookie('usernames')
  if past-usernames.length > 0
    most-recent-username = past-usernames[*-1].name
    if not root.username?
      root.username = most-recent-username
    if most-recent-username != root.username
      past-usernames.push {name: root.username, time: Date.now()}
      $.cookie 'usernames', JSON.stringify(past-usernames)
  else if root.username?
    past-usernames.push {name: root.username, time: Date.now()}
    $.cookie 'usernames', JSON.stringify(past-usernames)
  else if not root.username?
    root.username = randomString(14)
    past-usernames.push {name: root.username, time: Date.now()}
    $.cookie 'usernames', JSON.stringify(past-usernames)

root.time-started = null

updateTimeStarted = ->
  root.time-started = parseInt getUrlParameters().started
  if not root.time-started? or not isFinite(root.time-started)
    root.time-started = Date.now()

root.coursename = null
root.platform = 'quizcram'

updateCourseName = root.updateCourseName = ->
  root.coursename = getUrlParameters().coursename ? getUrlParameters().course
  if not root.coursename?
    root.coursename = 'neuro_1'
  if root.coursename == '1'
    root.coursename = 'neuro_1'
  if root.coursename == '2'
    root.coursename = 'neuro_2'

filterQuestions = root.filterQuestions = ->
  root.questions = switch root.coursename
  | 'neuro_1' =>
    [x for x in root.questions when x.course == 1 or x.course == 'neuro_1']
  | 'neuro_2' =>
    [x for x in root.questions when x.course == 2 or x.course == 'neuro_2']
  | _ =>
    throw 'unknown course: ' + root.coursename
  root.exam_questions = switch root.coursename
  | 'neuro_1' =>
    [x for x in root.exam_questions when x.course == 1 or x.course == 'neuro_1']
  | 'neuro_2' =>
    [x for x in root.exam_questions when x.course == 2 or x.course == 'neuro_2']
  | _ =>
    throw 'unknown course: ' + root.coursename

filterVideos = root.filterVideos = ->
  root.video_info = {[vidname, vidinfo] for vidname,vidinfo of root.video_info when vidinfo.course == root.coursename}

updateVideos = root.updateVideos = ->
  for vidname,vidinfo of root.video_info
    if not vidinfo.course?
      if vidname.indexOf('1-') == 0
        vidinfo.course = 'neuro_1'
      else if vidname.indexOf('2-') == 0
        vidinfo.course = 'neuro_2'
    if not vidinfo.srtfile?
      vidinfo.srtfile = vidname + '.srt'

downloadAndParseSubtitle = root.downloadAndParseSubtitle = (srtfile, callback) ->
  $.get srtfile, (data) ->
    subs = parser.fromSrt(data)
    callback(subs)

downloadAndParseAllSubtitles = root.downloadAndParseAllSubtitles = ->
  tasks = []
  for let vidname,vidinfo of root.video_info
    tasks.push (callback) ->
      downloadAndParseSubtitle vidinfo.srtfile, (subs) ->
        vidinfo.subtitle = subs
        callback(null)
  async.series tasks, ->
    console.log 'downloadAndParseAllSubtitles done!'

updateQuestions = root.updateQuestions = ->
  for question,idx in root.questions
    question.idx = idx
    if question.course == '1' or question.course == 1
      question.course = 'neuro_1'
    if question.course == '2' or question.course == 2
      question.course = 'neuro_2'
    if question.course != 'neuro_1' and question.course != 'neuro_2'
      throw 'unknown course: ' + question.course
    /*
    if not question.course?
      vidname = question.videos[0].name
      vidinfo = root.video_info[vidname]
      if not vidinfo?
        console.log 'no vidinfo!'
        console.log vidname
        console.log idx
        console.log question
      question.course = vidinfo.course
    */

updateExamQuestions = root.updateExamQuestions = ->
  for question,idx in root.exam_questions
    question.idx = idx
    question.exam = true
    if question.course == '1' or question.course == 1
      question.course = 'neuro_1'
    if question.course == '2' or question.course == 2
      question.course = 'neuro_2'
    if question.course != 'neuro_1' and question.course != 'neuro_2'
      throw 'unknown course: ' + question.course

root.limit-numquestions = null

updateOptions = ->
  params = getUrlParameters()
  if params.nolog? and params.nolog != 'false'
    root.logging-disabled-globally = true
  if params.numquestions? and isFinite(parseInt(params.numquestions))
    root.limit-numquestions = parseInt(params.numquestions)
  if params.platform?
    root.platform = params.platform

updateMasteryScoreDisplay = root.updateMasteryScoreDisplay = (qidx) ->
  scoredisplay = $('.questionscore_' + qidx)
  if scoredisplay.length < 1
    return
  questionscore = getScoreForQuestion qidx
  if questionscore > 0
    scoredisplay.text 'Question Mastery: ' + toPercent(questionscore) + '%'

updateMasteryScoreDisplayProcess = ->
  setInterval ->
    for curqidx in [0 til root.questions.length]
      updateMasteryScoreDisplay curqidx
  , 1000

updateUrlBarProcess = ->
  setInterval ->
    #updateUrlHash()
    updateUrlBar()
  , 10000

setKeyBindings = ->
  $(document).keydown (evt) ->
    key = evt.which
    if $('.activevideo').length > 0 # in video
      switch key
      | 27 => pauseVideo() # esc
      | 37 => seekVideoByOffset(-5) # left
      | 39 => seekVideoByOffset(5) # right
      | 8 => pauseVideo() # backspace
      | 46 => pauseVideo() # delete
      | 187 => increasePlaybackSpeed() # + key
      | 61 => increasePlaybackSpeed() # + key
      | 221 => increasePlaybackSpeed() # ] key      
      | 219 => decreasePlaybackSpeed() # [ key
      | 189 => decreasePlaybackSpeed() # - key
      | 173 => decreasePlaybackSpeed() # - key
      | 13 => # enter
        skipToEndOfSeenPortion $(\.activevideo).data(\qnum)
        playVideo()
      | 32 => playPauseVideo() # space
      | _ => console.log key; return true
      evt.preventDefault()
      return false

quizCramInitialize = ->
  updateMasteryScoreDisplayProcess()
  console.log 'ready'
  fixVideoHeightProcess()
  #questionAlwaysShownProcess()
  /*
  $(document).mousedown (evt) ->
    console.log 'document mousedown'
    resetButtonFill()
    if isVideoFocused()
      console.log 'docuemtn mousedown video is focused'
      if not isMouseInVideo(evt)
        console.log 'document mousedown setvideofocused false'
        setVideoFocused(false)
  */
  /*
  $(document).mousewheel (evt) ->
    try
      #console.log evt
      scrolling-towards-video = false
      if $('.activevideo').length > 0
        window-top = $(window).scrollTop()
        video-top = $('.activevideo').offset().top
        window-bottom = window-top + $(window).height()
        video-bottom = video-top + $('.activevideo').height()
        #if Math.abs(window-bottom - video-bottom) < 50
        window-center = (window-top + window-bottom) / 2
        video-center = (video-top + video-bottom) / 2
      console.log evt.deltaY
      if evt.deltaY < 0 and window-center < video-center # scrolling downwards, towards video
        scrolling-towards-video = true
      if evt.deltaY > 0 and window-center > video-center # scrolling upwards, towards video
        scrolling-towards-video = true
      if isVideoPlaying() and videoHeightFractionVisible() < 0.85 and not scrolling-towards-video
        pauseVideo()
      else if not isVideoPlaying() and videoHeightFractionVisible() > 0.85 and scrolling-towards-video
        playVideo()
      if $('.activevideo').length > 0 and false #and isVideoPlaying()
        invideo = false
        if isVideoFocused()
          if evt.deltaY < 0 and videoAtEnd()
            setVideoFocused false
          else if evt.deltaY > 0 and videoAtFront()
            setVideoFocused false
          else
            invideo = true
        if timeSinceVideoFocus() > 1.0 and not (video-top <= parseFloat(evt.pageY) <= video-bottom)
          invideo = false
          console.log 'evt.pageY is:' + parseFloat(evt.pageY)
          console.log 'video-bottom is:' + video-bottom
          console.log 'video-top is:' + video-top
          setVideoFocused(false)
        if invideo
          $(window).scrollTop(video-top)
          if not isVideoPlaying() and not videoAtEnd()
            playVideo()
          else
            if evt.deltaY < 0
              #if videoAtEnd()
              #  return
              scrollVideoForward()
            else
              #if videoAtFront()
              #  return
              scrollVideoBackward()
          evt.preventDefault()
          return false
        else
          pauseVideo()
        return
      if evt.deltaY < 0
        $(window).scrollTop $(window).scrollTop() + 30
      else if evt.deltaY > 0
        $(window).scrollTop $(window).scrollTop() - 30
    catch e
      console.log e
    finally
      evt.preventDefault()
      return false
  */
  if root.logging-disabled-globally
    insertQuestion getNextQuestion(), {immediate: true}
  else
    getlog (logs) ->
      if logs? and logs.length > 0
        root.logging-disabled = true
        console.log 'replaying logs!'
        root.logged-data = logs
        replayLogs(logs)
        root.logging-disabled = false
      insertQuestion getNextQuestion(), {immediate: true, qnum: counterCurrent('qnum'), qcycle: counterCurrent('qcycle')}
      ensureLoggedToServer(root.logged-data, 'logged-data')

root.current-video-qnum = -1
root.current-video-vidname = null
root.current-video-vidpart = null

courseraInitialize = ->
  console.log 'coursera initialize'
  $('#quizstream').append [
    J(\.leftbar).css({width: \30%, height: \100%, float: \left}),
    J(\.rightbar).css({width: \70%, height: \100%, float: \right}),
    J(\div).css({clear: \both})
  ]
  idx = -1
  for let vidname,vidinfo of root.video_info
    console.log vidname
    vidpart = vidinfo.parts.length - 1
    idx += 1
    video-selector = J('#videoselector_' + idx)
      .data(\idx, idx)
      .css {
        cursor: \pointer
        font-size: \16px
        margin-bottom: \10px
        #text-decoration: \underline
      }
      .mouseenter (evt) ->
        $(this).css \text-decoration, \underline
      .mouseleave (evt) ->
        $(this).css \text-decoration, ''
      .text(vidname.split('-').join('.') + ': ' + vidinfo.title)
      .click (evt) ->
        oldvidname = root.current-video-vidname
        oldvidpart = root.current-video-vidpart
        oldqnum = root.current-video-qnum
        $(\.activevideoselect).removeClass \activevideoselect
        $('#body_' + root.current-video-qnum).remove()
        $('#outerbody_' + root.current-video-qnum).remove()
        if root.current-video-vidname?
          resetVideoBody root.current-video-vidname, root.current-video-vidpart
        video-selector.addClass \activevideoselect
        root.current-video-vidname = vidname
        root.current-video-vidpart = vidpart
        console.log vidname
        newvideo = insertVideo vidname, vidpart, { nopart: true, quizzes: true, noprevvideo: true, noprogressdisplay: true, novideoskip: true }
        $('.rightbar').append newvideo
        root.current-video-qnum = getVideo(vidname, vidpart).data \qnum
        addlog {
          event: \switchvideo
          vidname: vidname
          vidpart: vidpart
          oldvidname: oldvidname
          oldvidpart: oldvidpart
          qnum: root.current-video-qnum
          oldqnum: oldqnum
        }
        playVideo()
        #insertInVideoQuiz root.questions[0], vidname, vidpart
    $('.leftbar').append video-selector
  $('#videoselector_0').click()
  getlog (logs) ->
    if logs? and logs.length > 0
      root.logged-data = logs
    ensureLoggedToServer(root.logged-data, 'logged-data')


testExamInitialize = ->
  for question in root.questions
    if question.selfrate
      continue
    console.log JSON.stringify(question)
    insertQuestion question, {immediate: true, novideo: true, append: true, nobuttons: true, nocontainer: true}
  #randomizeChildrenOrder $('#quizstream')
  submit-button = J('button.btn.btn-primary.btn-lg#submitquiz').html('<span class="glyphicon glyphicon-check"></span> Submit Quiz').click (evt) ->
    console.log 'submit quiz clicked'
    numcorrect = 0
    numincorrect = 0
    idxcorrect = []
    idxincorrect = []
    partialscores = []
    for panel in $('.panel-body-new')
      qnum = $(panel).data \qnum
      qidx = getQidx qnum
      question = root.questions[qidx]
      answers = getAnswerValue question.type, qnum
      isCorrect = isAnswerCorrect question, answers
      if isCorrect
        numcorrect += 1
        idxcorrect.push qidx
      else
        numincorrect += 1
        idxincorrect.push qidx
      showIsCorrect qnum, isCorrect
      partialscore = getPartialScore qnum
      partialscores.push partialscore
      addlog {
        event: \testexamcheck
        correct: isCorrect
        partialscore: partialscore
        qidx: question.idx
        answers: answers
        qnum: qnum
      }
    addlog {
      event: \submittestexam
      numcorrect: numcorrect
      numincorrect: numincorrect
      idxcorrect: idxcorrect
      idxincorrect: idxincorrect
      partialscores: partialscores
    }
  $('#quizstream').append submit-button
  getlog (logs) ->
    if logs? and logs.length > 0
      root.logged-data = logs
    ensureLoggedToServer(root.logged-data, 'logged-data')

#randomizeChildrenOrder = (container) ->
#  throw 'not implemented yet: randomizeChildrenOrder'

testQuizInitialize = ->
  for question in root.questions
    if question.selfrate
      continue
    console.log JSON.stringify(question)
    insertQuestion question, {immediate: true, novideo: true, append: true, nobuttons: true, nocontainer: true}
  #randomizeChildrenOrder $('#quizstream')
  submit-button = J('button.btn.btn-primary.btn-lg#submitquiz').html('<span class="glyphicon glyphicon-check"></span> Submit Quiz').click (evt) ->
    console.log 'submit quiz clicked'
    numcorrect = 0
    numincorrect = 0
    idxcorrect = []
    idxincorrect = []
    partialscores = []
    for panel in $('.panel-body-new')
      qnum = $(panel).data \qnum
      qidx = getQidx qnum
      question = root.questions[qidx]
      answers = getAnswerValue question.type, qnum
      isCorrect = isAnswerCorrect question, answers
      if isCorrect
        numcorrect += 1
        idxcorrect.push qidx
      else
        numincorrect += 1
        idxincorrect.push qidx
      showIsCorrect qnum, isCorrect
      partialscore = getPartialScore qnum
      partialscores.push partialscore
      addlog {
        event: \testquizcheck
        correct: isCorrect
        partialscore: partialscore
        qidx: question.idx
        answers: answers
        qnum: qnum
      }
    addlog {
      event: \submittestquiz
      numcorrect: numcorrect
      numincorrect: numincorrect
      idxcorrect: idxcorrect
      idxincorrect: idxincorrect
      partialscores: partialscores
    }
  $('#quizstream').append submit-button
  getlog (logs) ->
    if logs? and logs.length > 0
      root.logged-data = logs
    ensureLoggedToServer(root.logged-data, 'logged-data')

$(document).ready ->
  root.questions = root.questions_extra
  root.video_info = root.video_info_extra
  updateOptions()
  updateUsername()
  updateTimeStarted()
  updateCourseName()
  #updateUrlBar()
  updateVideos()
  filterVideos()
  downloadAndParseAllSubtitles()
  if root.platform == 'quizcram'
    createQuestionsForVideosWithoutQuizzes()
  filterQuestions()
  if root.platform == 'exam'
    updateExamQuestions()
    root.questions = root.exam_questions
  else
    updateQuestions()
  if root.limit-numquestions != null
    root.questions = root.questions[0 til root.limit-numquestions]
    # this is incorrect - video_info is a dictionary not a list!
  updateUrlBarProcess()
  setKeyBindings()
  switch root.platform
  | 'quizcram' => quizCramInitialize()
  | 'invideo' => courseraInitialize()
  | 'exam' => testExamInitialize()
  | 'quiz' => testQuizInitialize()
  | _ => throw 'unknown platform name: ' + root.platform

