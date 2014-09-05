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

isFirefox = ->
  return navigator.userAgent.search('Firefox') != -1

$(document).ready ->
  console.log 'ready!'
  params = getUrlParameters()
  root.user = params.user
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
    $('#url' + unitnum).text(url).attr(\href, url)
    $('#cond' + unitnum).text platform
