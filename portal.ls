root = exports ? this

getUrlParameters = root.getUrlParameters = ->
  url = window.location.href
  hash = url.lastIndexOf('#')
  if hash != -1
    url = url.slice(0, hash)
  map = {}
  parts = url.replace /[?&]+([^=&]+)=([^&]*)/gi, (m,key,value) ->
    map[key] = decodeURI(value)
  return map

getPlatformForUnitNum = (unitnum) ->
  switch root.condition
  | 0 =>
    if unitnum == 0
      return \invideo
    else
      return \quizcram
  | 1 =>
    if unitnum == 0
      return \quizcram
    else
      return \invideo

makeUrl = (unitnum) ->
  params = {
    user: root.username
    #course: 'neuro_' + (unitnum + 1)
    half: (unitnum + 1)
    platform: getPlatformForUnitNum(unitnum)
  }
  return '/?' + $.param(params)

root.study-time-for-unit = 90 * 60 * 1000

setPostStudyUrl = (unitnum) ->
  platform = getPlatformForUnitNum unitnum
  url = switch unitnum
  | 0 => 'https://docs.google.com/forms/d/1f3fHYPzUofCFrkEdIt0L4PuV7O4JtvkA26Q1nPUH4TU/viewform?entry.1047354409=' + root.username + '&entry.1656808541=' + platform
  | 1 => 'https://docs.google.com/forms/d/1yKeFXh-Bqv7-nMA0Cdpfo6GUv9YLmjJ7EIWbalsCmsY/viewform?entry.1047354409=' + root.username + '&entry.1656808541=' + platform
  $('#poststudy' + unitnum).text 'Post-Viewing Survey for part ' + (unitnum + 1)
  $('#poststudy' + unitnum).attr 'href', url

setPreStudyUrl = ->
  #url = 'https://docs.google.com/forms/d/1kvJiqjf4J2bm9b4_ZFjUViMP74tAXL8OpIJTy24Uv64/viewform?entry.142775808=' + root.username
  url = 'https://docs.google.com/forms/d/1UIvXiC1kgci59J9lsWrTjDRthqysA6KoYLVklx2JZTs/viewform?entry.142775808=' + root.username
  $('#prestudy').text 'Pre-Study Questionnaire'
  $('#prestudy').attr 'href', url

getlog = root.getlog = (callback) ->
  $.getJSON '/viewlog?' + $.param({username: root.username}), (logs) ->
    callback logs

isFirefox = ->
  return navigator.userAgent.search('Firefox') != -1

hideQuizzes = root.hideQuizzes = ->
  $('#quiz0').hide()
  $('#quiz1').hide()

show1AfterTimeout = root.show1AfterTimeout = ->
  setTimeout show1, root.study-time-for-unit

show2AfterTimeout = root.show2AfterTimeout = ->
  setTimeout show2, root.study-time-for-unit

show1 = root.show1 = ->
  $('#quiz0').show()

show2 = root.show2 = ->
  $('#quiz1').show()

updateUrlBar = ->
  params = {
    user: root.username
    condition: root.condition
  }
  history.replaceState {}, '', '?' + $.param(params)

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
    root.username = null #randomString(14)
    #past-usernames.push {name: root.username, time: Date.now()}
    #$.cookie 'usernames', JSON.stringify(past-usernames)

updateCondition = ->
  root.condition = parseInt(getUrlParameters().condition)
  if not root.condition? or not isFinite(root.condition)
    root.condition = require('prelude-ls').sum([x.charCodeAt(0) for x in root.username]) % 2
  #if root.condition? and isFinite(root.condition) and [0, 1].indexOf(root.condition) != -1
  #  $.cookie 'condition', root.condition
  #else if $.cookie('condition')?
  #  root.condition = parseInt($.cookie('condition'))

gotoTarget = ->
  url = switch getUrlParameters().target
  | \poststudy1 =>
    platform = getPlatformForUnitNum 0
    whichhalf = 'First+half'
    'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform
  | \poststudy2 =>
    platform = getPlatformForUnitNum 1
    whichhalf = 'Second+half'
    'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform
  | \quiz1 =>
    "https://docs.google.com/forms/d/1gOLtZuVO5HIuIgKAaYJMg91DyRKkZFbXgF8XFgtzibk/viewform"
  | \exam1 =>
    "https://docs.google.com/forms/d/1wToigTH9pglQApRf0g-t02134rRv9gvBJEaJfG31gsg/viewform"
  | \quiz2 =>
    "https://docs.google.com/forms/d/1h-CcxVTnXGNcZ5mYKLdcygYi92lNbJJEu9Uua6SsH2I/viewform"
  | \exam2 =>
    "https://docs.google.com/forms/d/1N78vFuHeoyBlwFdJfgk2PY9ATwnqRpe02_PZNusc32Y/viewform"
  window.location.href = url

toUserName = (fullname) ->
  output = []
  allowedletters = [\a to \z] ++ [\0 to \9]
  for c in fullname
    c = c.toLowerCase()
    if allowedletters.indexOf(c) != -1
      output.push c
  return output.join('')

submitname = root.submitname = ->
  fullname = $('#nameinput').val()
  username = toUserName fullname
  params = getUrlParameters()
  params.user = username
  window.location = window.location.pathname + '?' + $.param(params)

showquiz = root.showquiz = ->
  $('#quizlater').hide()
  $('#quizsection').show()
  $('#q00').attr 'href', 'https://docs.google.com/forms/d/13jOTdfcGtcxdaCXp4SQSe3yW3MwFISQhowX8a3uKgHI/viewform?entry.1982045070=' + root.username
  $('#q01').attr 'href', 'https://docs.google.com/forms/d/1zpkzXj9TF0hmGVNaQgc3gqUnRQJhjyJhm0D2FsFaeW0/viewform?entry.56085394=' + root.username
  $('#q10').attr 'href', 'https://docs.google.com/forms/d/1mNZWkc-VGk0XjPKvH5be74NC1XyQlM2VxjKFYq1G7ic/viewform?entry.565234045=' + root.username
  $('#q11').attr 'href', 'https://docs.google.com/forms/d/1F5DeOZYtN2w0O-mGi1nyU_s47ccgk5RcZWDd3nupQko/viewform?entry.565234045=' + root.username
  $('#q20').attr 'href', 'https://docs.google.com/forms/d/1YxjqtoBldX1tH6fZlMNrtQwYzVb0sgRlb88GJM1TV0I/viewform?entry.894447393=' + root.username
  $('#q21').attr 'href', 'https://docs.google.com/forms/d/1y4swiqx33sPFxjJ6Awnted-dJoAH2_oAqb-MtNme0NA/viewform?entry.894447393=' + root.username
  $('#q30').attr 'href', 'https://docs.google.com/forms/d/1UANjvn-9pmDNPYYlvJcy1Id_ZbHUINrBq_AHktOC4Vc/viewform?entry.1893730634=' + root.username
  $('#q31').attr 'href', 'https://docs.google.com/forms/d/1c8g43cDWAMlcfpM4eIlGrL1bHgIjj1cfu-9LYh1LaV8/viewform?entry.1827769055=' + root.username

$(document).ready ->
  $('#nameinput').keydown (evt) ->
    if evt.keyCode == 13 # return / enter
      submitname()
  console.log 'ready!'
  params = getUrlParameters()
  if not isFirefox()
    $('#studycontents').html '<b>Please open this page using <a href="http://www.mozilla.org/en-US/firefox">Firefox</a> to do the study, it does not work on other browsers at the moment.</b>'
    return
  updateUsername()
  if not root.username?
    $('#entername').show()
    $('#studycontents').hide()
    return
  updateCondition()
  setPreStudyUrl()
  if not root.username?
    $('body').text 'need user param'
    return
  if [0, 1].indexOf(root.condition) == -1
    $('body').text 'need condition param, either 0 or 1'
    return
  if params.target?
    gotoTarget()
    return
  updateUrlBar()
  for unitnum in [0, 1]
    url = makeUrl unitnum
    platform = getPlatformForUnitNum unitnum
    setPostStudyUrl unitnum
    $('#url' + unitnum).attr(\href, url)
    $('#cond' + unitnum).text platform
  getlog (logs) ->
    #console.log 'get logs: ' + JSON.stringify(logs)
    if not logs? or logs.length < 1
      return
    starttime = logs[0].time
    day2time = starttime + 1000 * 60 * 60 * 24 # + 24 hours
    currenttime = Date.now()
    #$('#quiztimedetails').text 'You started watching videos at ' + (new Date(starttime).toString()) + ' so you can take the quizzes at ' + (new Date(day2time).toString()) + ' it is currently ' + (new Date(currenttime).toString())
    if day2time > currenttime
      hoursleft = (day2time - currenttime) / (1000 * 60 * 60)
      $('#quiztimedetails').text 'Please wait ' + hoursleft.toFixed(2) + ' hours, then revisit this page to do the quizzes'
    else
      showquiz()

