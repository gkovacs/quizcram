root = exports ? this

toSeconds = root.toSeconds = (time) ->
  if not time?
    return null
  if typeof time == 'number'
    return time
  if typeof time == 'string'
    if time.lastIndexOf(',') != -1
      time = time.split(',').join('.')
    timeParts = [parseFloat(x) for x in time.split(':')]
    if timeParts.length == 0
      return null
    if timeParts.length == 1
      return timeParts[0] 
    if timeParts.length == 2
      return timeParts[0]*60 + timeParts[1]
    if timeParts.length == 3
      return timeParts[0]*3600 + timeParts[1]*60 + timeParts[2]
  return null
