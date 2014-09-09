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
    course: 'neuro_' + (unitnum + 1)
    platform: getPlatformForUnitNum(unitnum)
  }
  return 'http://10.172.99.36:8080/?' + $.param(params)

root.study-time-for-unit = 90 * 60 * 1000

setPostStudyUrl = (unitnum) ->
  platform = getPlatformForUnitNum unitnum
  whichhalf = switch unitnum
  | 0 => 'First+half'
  | 1 => 'Second+half'
  url = 'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform
  $('#poststudy' + unitnum).text 'Post-Study Survey ' + (unitnum + 1)
  $('#poststudy' + unitnum).attr 'href', url

setPreStudyUrl = ->
  url = 'https://docs.google.com/forms/d/1kvJiqjf4J2bm9b4_ZFjUViMP74tAXL8OpIJTy24Uv64/viewform?entry.142775808=' + root.username
  $('#prestudy').text 'Pre-Study Questionnaire'
  $('#prestudy').attr 'href', url

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

#updateCondition = ->
#  root.condition = getUrlParameters().condition ? 

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
  if root.condition? and isFinite(root.condition) and [0, 1].indexOf(root.condition) != -1
    $.cookie 'condition', root.condition
  else if $.cookie('condition')?
    root.condition = parseInt($.cookie('condition'))

$(document).ready ->
  hideQuizzes()
  console.log 'ready!'
  params = getUrlParameters()
  updateUsername()
  updateCondition()
  setPreStudyUrl()
  if not isFirefox()
    $('body').text 'need to be using Firefox'
    return
  if not root.username?
    $('body').text 'need user param'
    return
  if [0, 1].indexOf(root.condition) == -1
    $('body').text 'need condition param, either 0 or 1'
    return
  updateUrlBar()
  for unitnum in [0, 1]
    url = makeUrl unitnum
    platform = getPlatformForUnitNum unitnum
    setPostStudyUrl unitnum
    $('#url' + unitnum).text(url).attr(\href, url)
    $('#cond' + unitnum).text platform
