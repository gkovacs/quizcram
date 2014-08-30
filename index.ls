root = exports ? this

J = $.jade

{sum} = require \prelude-ls

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
  '1-1-2': [ '1-1-1' ]
  '1-2-1': [ '1-1-2' ]
  '1-2-2': [ '1-2-1' ]
  '1-2-3': [ '1-2-2' ]
  '1-2-4': [ '1-2-3' ]
  '1-2-5': [ '1-2-4' ]
  '1-2-6': [ '1-2-5' ]
  '1-3-1': [ '1-2-6' ]
  '1-3-2': [ '1-3-1' ]
  '1-3-3': [ '1-3-2' ]
  '1-3-4': [ '1-3-3' ]
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


do ->
  for question,idx in root.questions
    question.idx = idx

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

root.username = 'defaultuser'

randomFromList = (list) ->
  return list[Math.floor(Math.random() * list.length)]

randomString = (length) ->
  alphabet = [\a to \z] ++ [\A to \Z] ++ [\0 to \9]
  return [randomFromList(alphabet) for x in [0 til length]].join('')

do ->
  if $.cookie('username')?
    root.username = $.cookie('username')
  else
    root.username = randomString(14)
    $.cookie('username', root.username)

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
root.logging-disabled = false

ensureLoggedToServer = (list, name) ->
  if not name?
    name = randomString(14)
  if not root.server-received-logidx?
    root.server-received-logidx = {}
  if root.server-received-logidx[name]?
    console.log 'already ensuring logged to server: ' + name
    return
  root.server-received-logidx[name] = -1
  setInterval ->
    nextidx = root.server-received-logidx[name] + 1
    if nextidx < list.length
      # have new data to send
      console.log 'sending item ' + nextidx
      postJSON '/addlog', list[nextidx], (updated-idx) ->
        console.log 'updated-idx: ' + updated-idx
        updated-idx = parseInt(updated-idx)
        if isFinite(updated-idx)
          root.server-received-logidx[name] = updated-idx
  , 350

addlogReal = root.addlogReal = (data) ->
  if not data.logidx?
    data.logidx = root.logged-data.length
  root.logged-data.push data
  #postJSON '/addlog', data

addlog = root.addlog = (logdata) ->
  if root.logging-disabled
    return
  data = $.extend {}, logdata
  if not data.username?
    data.username = root.username
  if not data.time?
    data.time = Date.now()
  if not data.timeloc?
    data.timeloc = new Date().toString()
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

root.video-parts-seen = []
console.log 'vidinfo!!!---------------------==================='
do ->
  for vidname,vidinfo of root.video_info
    seen = [0] * (Math.round(getVideoEnd(vidinfo)) + 1)
    root.video-parts-seen[vidname] = seen

getVideoProgress = root.getVideoProgress = (vidname, vidpart) ->
  [start,end] = getVideoStartEnd vidname, vidpart
  start = 0
  viewing-history = root.video-parts-seen[vidname]
  relevant-section = viewing-history[Math.round(start) to Math.round(end)]
  return sum(relevant-section) / relevant-section.length

isCurrentPortionPreviouslySeen = root.isCurrentPortionPreviouslySeen = (qnum) ->
  curtime = Math.round $('#video_' + qnum)[0].currentTime
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
  curtime = Math.round $('#video_' + qnum)[0].currentTime
  vidname = getVidname qnum
  vidpart = getVidpart qnum
  seen-intervals = getVideoSeenIntervalsRaw vidname, vidpart
  for [start,end] in seen-intervals
    if start <= curtime < end - 1
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
  $('.videoprogress_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).text(toPercent(percent-viewed) + '% seen')
  $('.watch_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).html('<span class="glyphicon glyphicon-play"></span> watch video (' + toPercent(percent-viewed) + '% seen)')
  $('.review_' + toVidnamePart(vidname, vidpart)).data('progress', percent-viewed).html('<span class="glyphicon glyphicon-play"></span> review video before answering again (' + toPercent(percent-viewed) + '% seen)')

updateWatchButtonProgress = root.updateWatchButtonProgress = (vidname, vidpart) ->
  console.log "setWatchButtonProgress(#vidname, #vidpart)"
  percent-viewed = getVideoProgress vidname, vidpart
  console.log 'percent-viewed: ' + percent-viewed
  setWatchButtonProgress vidname, vidpart, percent-viewed

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
  setSeenIntervals vidname, vidpart, seen-intervals

timeUpdatedReal = (qnum) ->
  video = $("\#video_#qnum")
  #body = getBody qnum
  vidname = getVidname qnum
  vidpart = getVidpart qnum
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
  updateTickLocation qnum
  if isCurrentPortionPreviouslySeen qnum
    (getVideo vidname, vidpart).find(\.skipseen).show()
  else
    (getVideo vidname, vidpart).find(\.skipseen).hide()
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
  video[0].currentTime = percent * video[0].duration

seekVideoTo = (time) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  video[0].currentTime = time

seekVideoByOffset = (offset) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return
  video[0].currentTime += offset

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

getVideoPanel = (elem) ->
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
      z-index: \4
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
      z-index: \4
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
        z-index: \5
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
        z-index: \6
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

getbot = root.getbot = (elem) ->
  if typeof elem == typeof ''
    elem = $(elem)
  return elem.offset().top + elem.height()

insertVideo = (vidname, vidpart, reasonForInsertion) ->
  [start,end] = getVideoStartEnd vidname, vidpart
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
      margin-bottom: \0px
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
  fileurl = '/segmentvideo?video=' + basefilename + '&' + $.param {start: 0, end: end, randpart: randomString(10)}
  title = root.video_info[vidname].title
  # {filename, title} = root.video_info[vidinfo.name]
  fulltitle = title
  if vidpart?
    if vidpart == 0
      fulltitle = fulltitle + ' part 1'
    else
      fulltitle = fulltitle + ' parts 1-' + (vidpart+1)
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
    .on 'ended', (evt) ->
      this.pause()
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
      padding-left: \10px
      padding-top: \2px
      padding-bottom: \2px
      margin-top: \0px
      margin-bottom: \0px
    }
  #video-header.append J('h3').css(\color, \white).css(\float, \left).css(\margin-left, \10px).css(\margin-top, \10px).text fulltitle
  video-header.append J('span').css(\color, \white).css(\font-size, \24px).css(\pointer-events, \none).text fulltitle
  video-header.append J('span#progress_' + qnum).addClass('videoprogress_' + vidnamepart).css(\pointer-events, \none).css(\color, \white).css(\margin-left, \30px).css(\font-size, \24px).text '0% seen'
  if reasonForInsertion?
    video-header.append $(reasonForInsertion).addClass('insertionreason').css(\display, \none).css(\font-size, \24px).css(\color, \white).css(\margin-left, \30px) #.css(\float, \left).css(\margin-top, \10px)
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
      console.log 'hover on progress bar:'
      console.log evt
      if not evt.pageX
        return
      offsetX = evt.pageX - progress-bar.offset().left
      progress-bar-width = progress-bar.width()
      if progress-bar-width == 0
        return
      percent = offsetX / progress-bar.width()
      if not 0 < percent <= 1
        return
      #console.log percent
      setHoverTickPercentage vidname, vidpart, percent
    .click (evt) ->
      console.log 'click on progress bar:'
      console.log evt
      makeVideoActive qnum
      if not evt.pageX
        return
      offsetX = evt.pageX - progress-bar.offset().left
      percent = offsetX / progress-bar.width()
      console.log 'percent:'
      console.log percent
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
  progress-bar.append unwatched-portion
  video-footer.append [play-button, slower-button, current-speed, faster-button, progress-bar]
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
      bottom: \70px
      left: \30px
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
    .text 'here is the current subtitle text'
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
  body.append [video-header, video-skip, subtitle-display-container, playbutton-overlay, video, video-footer]
  if /*(vidpart? and vidpart > 0) or*/ (root.video_dependencies[vidname]? and root.video_dependencies[vidname].length > 0)
    #body.append J('button.btn.btn-primary.btn-lg').text("show related videos from earlier").click (evt) ->
    view-previous-video-button = J(\span.linklike)/*.css(\float, \left).css(\margin-left, \10px).css(\margin-top, \10px)*/.css({margin-left: \30px, font-size: \24px}).html('<span class="glyphicon glyphicon-step-backward"></span> view previous video').click (evt) ->
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
      gotoNum target-qnum
      (getButton target-qnum, \watch).show()
  video-header.append close-button
  if vidpart?
    for part-idx in [0 to vidpart]
      start-time-for-part = toSeconds root.video_info[vidname].parts[part-idx].start
      addStartMarker vidname, vidpart, start-time-for-part / end, "part #{part-idx + 1}", (part-idx == vidpart)
  else
    for part-idx in [0 til root.video_info[vidname].parts.length]
      start-time-for-part = toSeconds root.video_info[vidname].parts[part-idx].start
      addStartMarker vidname, vidpart, start-time-for-part / end, "part #{part-idx + 1}", false
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

getQidx = (qnum) ->
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
      insertBefore qnum, (insertVideo vidinfo.name, vidinfo.part, "<span>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{question.title}</span>)</span>")
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
  console.log 'scrollToElement'
  console.log elem
  printStack()
  if isParentAnimated(elem)
    console.log 'animated!'
    setTimeout ->
      if cur-elem-idx != root.scroll-elem-idx
        return
      newoffset = elem.offset().top
      if Math.abs(newoffset - offset) > 30
        console.log 'have new offset!'
        console.log 'going to element:'
        console.log elem
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

getNextQuestion = ->
  now = Date.now()
  scores = [scoreQuestion(now, question) for question,idx in root.question_progress]
  qidx = maxidx scores
  #qidx = Math.random() * root.questions.length |> Math.floor
  return root.questions[qidx]

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

createRadio = (qnum, idx, option, body) ->
  inputbox = J("input.radiogroup_#{qnum}(type='radio' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "radiogroup_#{qnum}").attr('id', "radio_#{qnum}_#{idx}").attr('value', idx).change (evt) ->
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
  #console.log option
  inputbox = J("input.checkboxgroup_#{qnum}(type='checkbox' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "checkboxgroup_#{qnum}").attr('id', "checkbox_#{qnum}_#{idx}").attr('value', idx).change (evt) ->
    value = $('#checkbox_' + qnum + '_' + idx).is(':checked')
    console.log 'value:' + value
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
  console.log question_progress
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
  console.log 'increaseButtionFill ' + button-fill
  console.log 'autotrigger offset: ' + autotrigger.offset().top
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
  console.log 'top is: ' + top
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

showIsCorrect = (qnum, isCorrect) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  console.log 'showIsCorrect!'
  feedback = J('span')
  if isCorrect
    feedback.append J('b').css('color', 'green').text 'Correct'
    if not question.explanation? or question.explanation == '(see correct answers above)'
      $("\#explanation_#qnum").text 'Move on to the next question!'
    else
      $("\#explanation_#qnum").text question.explanation
  else
    feedback.append J('b').css('color', 'red').text 'Incorrect'
    $("\#explanation_#qnum").text 'We suggest you watch the video and try answering again, or see solution'
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
  explanation-display = $("\#explanation_#qnum")
  explanation-display.text ''
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
  explanation-display = $("\#explanation_#qnum")
  explanation-display.text question.explanation
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
  if video.length > 0
    if video[0].paused
      video[0].play()

root.playback-speed = '1.00'

setPlaybackSpeed = (new-speed) ->
  if not new-speed?
    return
  root.playback-speed = new-speed
  $('.currentspeed').text(new-speed + 'x')
  $('video').prop('playbackRate', parseFloat(new-speed))
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
  console.log 'disableButtonAutotrigger'
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
    setInsertionReasonAsVideo dvidname, dvidpart, vidname, vidpart
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

setInsertionReasonAs = (vidname, vidpart, reason) ->
  curvid = getVideo(vidname, vidpart)
  curvid.find('.insertionreason').html(reason)

setInsertionReasonAsQuestion = (vidname, vidpart, qnum) ->
  qidx = getQidx qnum
  question = root.questions[qidx]
  lqnum = getCurrentQuestionQnum()
  setInsertionReasonAs vidname, vidpart, "<span class='linklike' onclick='gotoNum(#{lqnum})'><span class='glyphicon glyphicon-share-alt'></span> go to current question</span>"
  #setInsertionReasonAs vidname, vidpart, "(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{question.title}</span>)"

setInsertionReasonAsVideo = (vidname, vidpart, pvidname, pvidpart) ->
  pqnum = getVideo(pvidname, pvidpart).data(\qnum)
  lqnum = getCurrentQuestionQnum()
  setInsertionReasonAs vidname, vidpart,  "<span class='linklike' onclick='gotoNum(#{lqnum})'><span class='glyphicon glyphicon-share-alt'></span> go to current question</span>"
  /*
  if pvidpart?
    setInsertionReasonAs vidname, vidpart, "(to help you understand <span class='linklike' onclick='gotoNum(#pqnum)'>#{pvidname} part #{pvidpart + 1}</span>)"
  else
    setInsertionReasonAs vidname, vidpart, "(to help you understand <span class='linklike' onclick='gotoNum(#pqnum)'>#{pvidname}</span>)"
  */

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
  setInsertionReasonAsVideo dvidname, dvidpart, vidname, vidpart
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
    newvideo = insertVideo vidname, vidpart, "<span>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>Question Title</span>)</span>"
    #$('#prebody_' + qnum).append newvideo
    appendWithSlideDown newvideo, $('#prebody_' + qnum)
    getVideo(vidname, vidpart).data(\prebody, qnum)

insertQuestion = root.insertQuestion = (question, options) ->
  options = {} if not options?
  if options.qnum?
    qnum = options.qnum
    counterSet 'qnum', qnum
  else
    qnum = counterNext 'qnum'
  root.currentQuestionQnum = qnum
  turnOffAllDefaultbuttons()
  #removeAllVideos()
  body = J('.panel-body-new')
    .attr('id', "body_#qnum")
    .data(\qnum, qnum)
    .data('qidx', question.idx)
    .data(\type, \question)
    .css {
      padding-top: \0px
      padding-left: \10px
      padding-right: \10px
      padding-bottom: \10px
    }
  vidname = getVidnameForQuestion(question)
  vidpart = getVidpartForQuestion(question)
  vidnamepart = getVidnamePartForQuestion(question)
  question-title = vidname.split('-').join('.') + ' ' + root.video_info[vidname].title + ' – Question ' + (vidpart + 1)
  body.append J('div').css({font-size: \24px, padding-top: \10px}).text question-title
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
  insertCheckAnswerButton = ->
    body.append J('button.btn.btn-primary.btn-lg#check_' + qnum).css('margin-right', '15px').css(\width, \100%)/*.attr('disabled', true)*/.html('<span class="glyphicon glyphicon-check"></span> check answer').click (evt) ->
      gotoNum qnum
      answers = getAnswerValue question.type, qnum
      console.log answers
      if isAnswerCorrect question, answers
        addlog {
          event: 'check'
          type: 'button'
          correct: true
          qidx: question.idx
          answers: answers
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
        (getBody qnum).data(\answered, true)
        (getBody qnum).data(\correct, true)
      else
        addlog {
          event: 'check'
          type: 'button'
          correct: false
          qidx: question.idx
          answers: answers
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
    setInsertionReasonAsQuestion(vidname, vidpart, qnum)
    showVideo(vidname, vidpart)
    setVideoFocused(true)
  insertWatchVideoButton = (autotrigger) ->
    watch-video-button = J('button.btn.btn-primary.btn-lg#watch_' + qnum).css(\display, \none).data('vidname', vidname).data('vidpart', vidpart).addClass('watch_' + vidnamepart).css('margin-right', '15px').css(\width, \100%)/*.text("watch video (0% seen)")*/.click (evt) ->
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
    review-video-button = J('button.btn.btn-primary.btn-lg#review_' + qnum).addClass('review_' + vidnamepart).css(\display, \none).css('margin-right', '15px').css(\width, \100%).text('review video before answering again (0% seen)').click (evt) ->
      (getButton qnum, \watch).click()
    body.append review-video-button
  insertNextQuestionButton = ->
    body.append J('button.btn.btn-primary.btn-lg#next_' + qnum).css(\display, \none).css('margin-right', '15px').css(\width, \100%)/*.attr('disabled', true)*/.html('<span class="glyphicon glyphicon-forward"></span> next question').click (evt) ->
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
  insertWatchVideoButton(true)
  insertCheckAnswerButton()
  insertReviewVideoButton()
  /*
  if root.question_progress[question.idx].correct.length > 0
    insertCheckAnswerButton()
    if not options.skip-video?
      insertWatchVideoButton()
  else
    if not options.skip-video?
      insertWatchVideoButton(true)
    insertCheckAnswerButton()
  */
  #if root.question_progress[question.idx].correct.length > 0
  #  insertSkipButton()
  insertShowAnswerButton()
  insertNextQuestionButton()
  #body.append J('.endquestion#endquestion_' + qnum).data(\qnum, qnum)
  containerdiv = J(\.container_ + qnum).css({width: \100%, margin-bottom: \10px}).append [
    J(\.leftbar.leftbar_ + qnum).css({width: \30%, float: \left}).append(body),
    J(\.rightbar.rightbar_ + qnum).css({width: \70%, float: \right}).append(J('#prebody_' + qnum)),
    J(\div).css({clear: \both})
  ]
  containerdiv.prependTo $(\#quizstream)
  #$('#quizstream').prepend J('#prebody_' + qnum)
  #body.prependTo($('#quizstream'))
  autoShowVideo = ->
    console.log 'autoshowvideo for question ' + qnum
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

replayLogs = (logs) ->
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
  console.log 'window-top:' + window-top
  window-bottom = window-top + window-height
  video-top = video.offset().top
  video-bottom = video-top + video-height
  video-hidden-top = Math.max(0, window-top - video-top)
  console.log 'video-hidden-top:' + video-hidden-top
  video-hidden-bottom = Math.max(0, video-bottom - window-bottom)
  console.log 'video-hidden-bottom:' + video-hidden-bottom
  video-hidden = video-hidden-top + video-hidden-bottom
  video-shown = video-height - video-hidden
  #fraction-hidden = video-hidden / Math.min(window-height, video-height)
  #console.log 'video-hidden:' + video-hidden
  #console.log 'fraction hiddden:' +  (1 - fraction-hidden)
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

root.skip-load-logs = true

$(document).ready ->
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
      | 221 => increasePlaybackSpeed() # ] key      
      | 219 => decreasePlaybackSpeed() # [ key
      | 189 => decreasePlaybackSpeed() # - key
      | 13 => # enter
        skipToEndOfSeenPortion $(\.activevideo).data(\qnum)
        playVideo()
      | 32 => playPauseVideo() # space
      | _ => console.log key; return true
      evt.preventDefault()
      return false
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
  if not root.skip-load-logs
    getlog (logs) ->
      if logs.length > 0
        root.logging-disabled = true
        console.log 'replaying logs!'
        root.logged-data = logs
        replayLogs(logs)
        root.logging-disabled = false
      else
        insertQuestion getNextQuestion(), {immediate: true}
  else
    #insertQuestion getNextQuestion(), {immediate: true}
    insertQuestion getNextQuestion()
    ensureLoggedToServer(root.logged-data, 'logged-data')
  #insertQuestion questions[0]
  #for question in root.questions.slice 0,1
  #  insertQuestion question
    
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some text')
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some more text')
