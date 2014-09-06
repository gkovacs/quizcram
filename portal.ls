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
    user: root.user
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
  url = 'https://docs.google.com/forms/d/1kvJiqjf4J2bm9b4_ZFjUViMP74tAXL8OpIJTy24Uv64/viewform?entry.142775808=' + root.user
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

$(document).ready ->
  hideQuizzes()
  console.log 'ready!'
  params = getUrlParameters()
  root.user = params.user
  setPreStudyUrl()
  if not isFirefox()
    $('body').text 'need to be using Firefox'
    return
  if not root.user?
    $('body').text 'need user param'
    return
  root.condition = parseInt params.condition
  if [0, 1].indexOf(root.condition) == -1
    $('body').text 'need condition param, either 0 or 1'
    return
  for unitnum in [0, 1]
    url = makeUrl unitnum
    platform = getPlatformForUnitNum unitnum
    setPostStudyUrl unitnum
    $('#url' + unitnum).text(url).attr(\href, url)
    $('#cond' + unitnum).text platform
