root = exports ? this

J = $.jade

{sum} = require \prelude-ls

stringEach = (l) ->
  output = []
  for x in l
    if x.split?
      output.push [$('<span>').text(y).html() for y in x.split("\n")].join('<br>')
    else
      output.push x.toString()
  return output

root.video_info = {
  '1-1-1': {
    filename: '1-1-1.webm'
    title: 'The Four Functions'
    parts: [
      {
        start: '0:00'
        end: '2:40'
      }
      {
        start: '2:40'
        end: '3:53'
      }
      {
        start: '3:53'
        end: '5:22'
      }
      {
        start: '5:22' # noquiz
        end: '6:15'
      }
    ]
  }
  '1-1-2': {
    filename: '1-1-2.webm'
    title: 'Central Anatomy'
    parts: [
      {
        start: '0:00'
        end: '4:54'
      }
      {
        start: '4:54'
        end: '5:48'
      }
      {
        start: '5:48' # noquiz
        end: '6:56'
      }
    ]
  }
  '1-2-1': {
    filename: '1-2-1.webm'
    title: 'Meet the Stars: Neurons'
    parts: [
      {
        start: '0:00'
        end: '2:01'
      }
      {
        start: '2:01' # noquiz
        end: '2:20'
      }
    ]
  }
  '1-2-2': {
    filename: '1-2-2.webm'
    title: 'Parts of the Neuron'
    parts: [
      {
        start: '0:00'
        end: '2:57'
      }
      {
        start: '2:57'
        end: '3:30'
      }
      {
        start: '3:30' # noquiz
        end: '3:58'
      }
    ]
  }
  '1-2-3': {
    filename: '1-2-3.webm'
    title: 'Neuronal Uniqueness: Stars of the Sky'
    parts: [
      {
        start: '0:00'
        end: '8:39'
      }
      {
        start: '8:39' # noquiz
        end: '8:58'
      }
    ]
  }
  '1-2-4': {
    filename: '1-2-4.webm'
    title: 'Meet the Support Staff: Glial Cells'
    parts: [
      {
        start: '0:00'
        end: '3:14'
      }
      {
        start: '3:14' # noquiz
        end: '3:47'
      }
    ]
  }
  '1-2-5': {
    filename: '1-2-5.webm'
    title: 'Myelin'
    parts: [
      {
        start: '0:00'
        end: '2:10'
      }
      {
        start: '2:10'
        end: '5:03'
      }
      {
        start: '5:03' # noquiz
        end: '5:20'
      }
    ]
  }
  '1-2-6': {
    filename: '1-2-6.webm'
    title: 'Demyelinating Diseases'
    parts: [
      {
        start: '0:00'
        end: '2:51'
      }
      {
        start: '2:51' # noquiz
        end: '3:06'
      }
    ]
  }
  '1-3-1': {
    filename: '1-3-1.webm'
    title: 'Meninges'
    parts: [
      {
        start: '0:00'
        end: '1:58'
      }
      {
        start: '1:58'
        end: '4:02'
      }
      {
        start: '4:02' # noquiz
        end: '5:49'
      }
    ]
  }
  '1-3-2': {
    filename: '1-3-2.webm'
    title: 'Peripheral Diseases'
    parts: [
      {
        start: '0:00'
        end: '4:51'
      }
      {
        start: '4:51' # noquiz
        end: '6:09'
      }
    ]
  }
  '1-3-3': {
    filename: '1-3-3.webm'
    title: 'Brain Tumors'
    parts: [
      {
        start: '0:00'
        end: '5:06'
      }
      {
        start: '5:06' # noquiz
        end: '5:46'
      }
    ]
  }
  '1-3-4': {
    filename: '1-3-4.webm'
    title: 'Looking Ahead: Course Preview'
    parts: [
      {
        start: '0:00' # noquiz
        end: '3:41'
      }
    ]
  }
}

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

getAllDependencies = root.getAllDependencies = (videoname) ->
  if not root.video_dependencies[videoname]?
    return []
  else
    output = root.video_dependencies[videoname]
    for x in root.video_dependencies[videoname]
      output = output ++ getAllDependencies(x)
    return output

root.questions = [
  {
    text: 'Which of the following are voluntary movements?'
    title: '1-1-1 Question 1'
    type: 'checkbox'
    options: [
      'Laughing at a joke' #
      'Moving food through the intestinal tract'
      'Crying when you hear bad news' #
      'Breathing' #
      'Pumping blood through the circulatory system'
    ]
    correct: [
      0, 2, 3
    ]
    explanation: 'Voluntary movements are self-generated actions driven by the brain. These can be deliberate movements or emotional reactions.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following stimuli are sensed but not perceived?'
    title: '1-1-1 Question 2'
    type: 'checkbox'
    options: [
      'Vibration'
      'Skin warming'
      'Skin incision'
      'An increase in blood oxygen concentration' #
      'Lung pressure' #
    ]
    correct: [
      3, 4
    ]
    explanation: 'Our bodies are able to detect things (like carbon dioxide concentration in the blood) that we are not able to perceive. Perceivable stimuli are those we are capable of being aware of.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are not influenced by homeostatic brain functions?'
    title: '1-1-1 Question 3'
    type: 'checkbox'
    options: [
      'Digestion'
      'Breathing'
      'Sleeping'
      'Eating'
      'Blood pressure'
    ]
    correct: [
      # none checked
    ]
    explanation: 'Homeostasis is the process of maintaining healthy internal conditions, such as body temperature, pH, and blood oxygen levels. All of the functions listed as answer options are influenced by homeostatic brain functions.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 2
      }
    ]
  }
  {
    text: 'Which of the following are true of the brainstem?'
    title: '1-1-2 Question 1'
    type: 'checkbox'
    options: [
      'Contained in the skull' #
      'Is involved in homeostasis' #
      'Contains motoneurons that control voluntary muscles of the arms and legs'
      'Contains two parts: the midbrain and the hindbrain' #
      'Is viewed more completely in a mid-sagittal cut than from the side' #
    ]
    correct: [
      0, 1, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-1-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of the forebrain?'
    title: '1-1-2 Question 2'
    type: 'checkbox'
    options: [
      'Contained in the skull' #
      'Smaller than the brainstem'
      'Contains motoneurons that control voluntary muscles'
      'Location of abstract cognitive functions' #
      'Required for sensory perception' #
    ]
    correct: [
      0, 3, 4
    ]
    explanation: 'The forebrain includes the cerebral cortex and is the "seat of consciousness." All perception and abstract cognitive functions like memory are contained in the forebrain.'
    videos: [
      {
        name: '1-1-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true about neurons?'
    title: '1-2-1 Question 1'
    type: 'checkbox'
    options: [
      'There are far more different types of neurons than there are types of bone or pancreatic cells' #
      'Neurons can be longer than any other type of cell in the body' #
      'Neurons are the most important cell type in the nervous system' #
      'There are only about 10 different types of neurons'
    ]
    correct: [
      0, 1, 2
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true about neurons?'
    title: '1-2-2 Question 1'
    type: 'checkbox'
    options: [
      'Dendrites receive information' #
      'The cell body is a cellular part unique to neurons'
      'The synapse is a place of communication between neurons' #
      'Axons carry information from synaptic terminals to the dendrites'
      'There is an empty space between neurons at the synapse' #
    ]
    correct: [
      0, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following could be on the receiving end of a synapse?'
    title: '1-2-2 Question 2'
    type: 'checkbox'
    options: [
      'Neuronal dendrites' #
      'Skeletal muscle' #
      'Salivary gland' #
      'Smooth muscle in the intestines' #
      'Cardiac muscle of the heart' #
    ]
    correct: [
      0, 1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Neurons can differ in which of the following features?'
    title: '1-2-3 Question 1'
    type: 'checkbox'
    options: [
      'Connectivity' #
      'Excitability' #
      'Neurotransmitters' #
      'Appearance' #
      'Location' #
    ]
    correct: [
      0, 1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of glial cells?'
    title: '1-2-4 Question 1'
    type: 'checkbox'
    options: [
      'There are more types of glial cells than there are types of neurons'
      'Glial cells outnumber neurons' #
      'Astrocytes are the most common type of glial cell' #
      'One type of glial cell makes myelin wherever it is found'
      'Glial cells are critical to brain development' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-4'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of myelin?'
    title: '1-2-5 Question 1'
    type: 'checkbox'
    options: [
      'Myelin reduces the time needed for the brain to send messages.' #
      'Information travels faster on the unmyelinated axons than on the myelinated axons.'
      'Myelin helps humans react more quickly to perceived information.' #
      'About 1/100th of a second is needed for an action potential to travel from the toe to the brain along a myelinated axon.' #
    ]
    correct: [
      0, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-5'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true?'
    title: '1-2-5 Question 2'
    type: 'checkbox'
    options: [
      'The neural code consists of a temporal pattern of action potentials.' #
      'Demyelination disrupts the patterning of action potentials.' #
      'Demyelination can result in some action potentials failing to make it to the end of an axon.' #
      'Sometimes demyelination speeds up action potential conduction (another name for travel).'
      'In myelinated axons, spikes jump from one inter-myelin space (called a node) to the next one.' #
    ]
    correct: [
      0, 1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-5'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true?'
    title: '1-2-6 Question 1'
    type: 'checkbox'
    options: [
      'Mutliple sclerosis, a central demyelinating disease, is a disorder of Schwann cells.'
      'Peripheral demyelinating diseases usually impair motor abilities' #
      'Demyelination disrupts the neural code' #
      'The symptoms produced by all central demyelinating diseases are the same'
      'Diseases of different types of glial cells have different effects' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-6'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true about the meninges?'
    title: '1-3-1 Question 1'
    type: 'checkbox'
    options: [
      'The outermost meningeal layer, the dura, is the toughest' #
      'The brain is contained within a sack of fluid' #
      'The innermost meningeal layer, the pia, is the most delicate' #
      'There are two meningeal membranes'
      'Low impact blows to the head typically do not produce a concussion' #
    ]
    correct: [
      0, 1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are central neurons?'
    title: '1-3-1 Question 2'
    type: 'checkbox'
    options: [
      'Forebrain neurons' #
      'Motoneurons in the brainstem' #
      'Sensory neurons that respond to injury'
      'Autonomic motor neurons'
    ]
    correct: [
      0, 1
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true of viruses and large molecues such as toxins?'
    title: '1-3-2 Question 1'
    type: 'checkbox'
    options: [
      'They can affect peripheral neurons including sensory neurons' #
      'They can kill affected cells' #
      'They never get through the meninges to reach the central neurons'
      'They can cause changes in the skin innervated by sensory neurons' #
      'All of the above'
    ]
    correct: [
      0, 1, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of brain tumors?'
    title: '1-3-3 Question 1'
    type: 'checkbox'
    options: [
      'Tumors that start outside the brain can spread to the brain'
      'Intracranial tumors are problematic because they increase pressure within the skull'
      'The most common type of brain tumor is a tumor of immortalized neurons'
      'Glial cells are post-mitotic and therefore do not become cancerous'
    ]
    correct: [
      0, 1
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-3'
        degree: 1.0
        part: 0
      }
    ]
  }
]


do ->
  for question,idx in root.questions
    question.idx = idx

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



root.counter_values = {}

counterNext = root.counterNext = (name) ->
  if not root.counter_values[name]?
    root.counter_values[name] = 0
  else
    root.counter_values[name] += 1
  return root.counter_values[name]

counterCurrent = root.counterCurrent = (name) ->
  if not root.counter_values[name]
    return 0
  return root.counter_values[name]

timeUpdatedReal = (qnum) ->
  video = $("\#video_#qnum")
  console.log video[0].currentTime
  console.log qnum
  if not video.data('duration')?
    video.data 'duration', video[0].duration
  if not video.data('viewed')?
    video.data('viewed', [0]*(Math.round(video.data 'duration')+1))
  curtime = video[0].currentTime
  viewed = video.data('viewed')
  viewed[Math.round(curtime)] = 1
  percent-viewed = sum(viewed) / viewed.length
  $('#progress_' + qnum).text percent-viewed
  console.log percent-viewed

timeUpdated = root.timeUpdated = _.throttle timeUpdatedReal, 1000

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
    if timeParts.length == 3
      return timeParts[0]*3600 + timeParts[1]*60 + timeParts[2]
  return null

setStartTime = root.setStartTime = (time, qnum) ->
  video = $("\#video_#qnum")
  video[0].currentTime = time

insertAfter = (qnum, contents) ->
  console.log "insertAfter #qnum #contents"
  contents.insertAfter $("\#body_#qnum")

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

setVideoFocused = root.setVideoFocused = (isFocused) ->
  video = $(\.activevideo)
  if not video? or not video.length? or video.length < 1
    return false
  if isFocused
    video.data('timeVideoFocused', Date.now())
    video-top = video.offset().top
    $(window).scrollTop(video-top)
  else
    pauseVideo()
  video.data('focused', isFocused)

insertVideo = (vidname, partnum, reasonForInsertion) ->
  if partnum?
    {start,end} = root.video_info[vidname].parts[partnum]
  else
    start = 0
    end = root.video_info[vidname].parts[*-1].end
  qnum = counterNext 'qnum'
  body = J('.panel-body').attr('id', "body_#qnum")
  console.log vidname
  basefilename = root.video_info[vidname].filename
  fileurl = '/segmentvideo?video=' + basefilename + '&' + $.param {start: toSeconds(start), end: toSeconds(end)}
  title = root.video_info[vidname].title
  # {filename, title} = root.video_info[vidinfo.name]
  fulltitle = title
  if partnum?
    fulltitle = fulltitle + ' part ' + (partnum+1)
  body.append J('h3').text fulltitle
  if reasonForInsertion?
    body.append reasonForInsertion
  body.append J('h3#progress_' + qnum).text 'foobar'
  $('.activevideo').removeClass 'activevideo'
  videodiv = J \div
  video = J('video')
    .attr('id', "video_#qnum")
    .attr('controls', 'controls')
    .attr('ontimeupdate', 'timeUpdated(' + qnum + ')')
    .css('width', '100%')
    .addClass('activevideo')
    #.data('focused', true)
    .click (evt) ->
      setVideoFocused(true)
    .append J('source')
      .attr('src', fileurl)
  #setInterval ->
  #  console.log $("\#video_#qnum")[0].currentTime
  #, 1000
  console.log video
  videodiv.append video
  body.append videodiv
  body.append J 'br'
  if (partnum? and partnum > 0) or (root.video_dependencies[vidname]? and root.video_dependencies[vidname].length > 0)
    body.append J('button.btn.btn-primary.btn-lg').text("show related videos from earlier").click (evt) ->
      console.log 'do not understand video'
      console.log vidname
      dependencies = []
      for prevpart in [0 til partnum]
        dependencies.push [vidname, prevpart]
      dependencies = dependencies ++ [[x,null] for x in root.video_dependencies[vidname]]
      for [dependency,vidnum] in dependencies
        console.log dependency
        console.log root.video_info[dependency]
        insertAfter qnum, (insertVideo dependency, vidnum, "<h3>(to help you understand <a href='\#body_#qnum'>#title</a>)</h3>")
        addVideoDependsOnQuestion qnum, counterCurrent(\qnum)
        break
  return body

root.question-to-video-dependencies = {}

addVideoDependsOnQuestion = root.addVideoDependsOnQuestion = (qnum-question, qnum-video) ->
  if not root.question-to-video-dependencies[qnum-question]?
    root.question-to-video-dependencies[qnum-question] = []
  root.question-to-video-dependencies[qnum-question].push qnum-video

getVideosDependingOnQuestion = root.getVideosDependingOnQuestion = (qnum-question) ->
  return question-to-video-dependencies[qnum-question]

insertReview = (question) ->
  console.log 'reviewing!'
  numvideos = 0
  numvideos = question.videos.length if question.videos?
  qnum-question = counterCurrent(\qnum) + numvideos + 1
  console.log 'qnum-question ' + qnum-question
  #$('#quizstream').append J('h3').text('We suggest you review the following videos:')
  if question.videos?
    for vidinfo in question.videos
      $('#quizstream').append insertVideo vidinfo.name, vidinfo.part, "<h3>(to help you understand <a href='\#body_#{qnum-question}'>#{question.title}</a>)</h3>"
      addVideoDependsOnQuestion qnum-question, counterCurrent(\qnum)
  #$('#quizstream').append J('.panel.panel-default').append body
  insertQuestion question, {skip-video: true}
  console.log 'qnum-question and actual: ' + qnum-question + ' vs ' + counterCurrent(\qnum)

disableQuestion = (qnum) ->
  $("input[type=radio][name=radiogroup_#qnum]").attr('disabled', true)
  $("input[type=checkbox][name=checkboxgroup_#qnum]").attr('disabled', true)
  $('#check_' + qnum).attr('disabled', true)
  $('#review_' + qnum).attr('disabled', true)
  $('#skip_' + qnum).attr('disabled', true)
  $("\#body_#qnum").css 'background-color' 'grey'
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

createRadio = (qnum, idx, option, body) ->
  body.append J("input(type='radio' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "radiogroup_#qnum").attr('id', "radio_#{qnum}_#{idx}").attr('value', idx).click (evt) ->
    $('#check_' + qnum).attr('disabled', false)
  body.append J("label(style='display: inline-block; font-weight: normal' for='radio_#{qnum}_#{idx}')").html option
  body.append J('br')

createCheckbox = (qnum, idx, option, body) ->
  console.log option
  body.append J("input(type='checkbox' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "checkboxgroup_#{qnum}").attr('id', "checkbox_#{qnum}_#{idx}").attr('value', idx).click (evt) ->
    $('#check_' + qnum).attr('disabled', false)
  body.append J("label(style='display: inline-block; font-weight: normal' for='checkbox_#{qnum}_#{idx}')").html option
  body.append J('br')

createWidget = (type, qnum, idx, option, body) ->
  switch type
  | \radio => createRadio(qnum, idx, option, body)
  | \checkbox => createCheckbox(qnum, idx, option, body)
  | _ => throw 'nonexistant question type ' + type

getRadioValue = root.getRadioValue = (radioname) ->
  return parseInt $("input[type=radio][name=#radioname]:checked").val()

getCheckboxValue = root.getCheckboxValue = (checkboxname) ->
  return [parseInt(x) for x in $("input[type=checkbox][name=#checkboxname]:checked").map(-> $(this).val()).get()]

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
  | \radio => getRadioValue "radiogroup_#qnum"
  | \checkbox => getCheckboxValue "checkboxgroup_#qnum"
  | _ => throw 'nonexistant question type ' + type 

isAnswerCorrect = (question, answers) ->
  switch question.type
  | \radio => answers == question.correct
  | \checkbox => arraysEqual answers, question.correct
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

resetButtonFill = ->
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  button-fill = 0
  autotrigger.data('button-fill', button-fill)
  partialFillButton button-fill  

increaseButtonFill = ->
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  button-fill = 0
  if autotrigger.data('button-fill')?
    button-fill = autotrigger.data('button-fill')
  button-fill += 0.1
  if button-fill >= 1.0
    autotrigger.removeClass 'autotrigger'
    autotrigger.click()
    root.overlap-button.hide()
    return
  autotrigger.data('button-fill', button-fill)
  partialFillButton button-fill

partialFillButton = root.partialFillButton = (fraction) ->
  autotrigger = $('.autotrigger')
  if not autotrigger? or not autotrigger.length? or autotrigger.length == 0
    return
  if not root.overlap-button?
    root.overlap-button = J('button.btn.btn-success.btn-lg').css('position', 'absolute')
    $('.panel-body').append J('#overlapButtonContainer').append root.overlap-button
  root.overlap-button.text autotrigger.text()
  root.overlap-button.width autotrigger.width()
  root.overlap-button.height autotrigger.height()
  root.overlap-button.offset autotrigger.offset()
  root.overlap-button.css 'clip', 'rect(0px ' + (autotrigger.outerWidth() * fraction) + 'px auto 0px)' # top right bottom left
  root.overlap-button.show()

root.inserted-reviews = {}

haveInsertedReview = (qnum) ->
  if root.inserted-reviews[qnum]?
    return true
  return false

reviewInserted = (qnum) ->
  root.inserted-reviews[qnum] = true

showAnswer = (question, qnum, isCorrect) ->
  console.log 'answer shown!'
  feedback = J('div')
  if isCorrect
    feedback.append J('span').css('color', 'green').text 'correct'
    feedback.append J 'br'
  else
    feedback.append J('span').css('color', 'red').text 'incorrect'
    feedback.append J 'br'
  feedback.append question.explanation
  answer = $("\#answer_#qnum")
  answer.text question.explanation
  answer.html('')
  answer.append feedback

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

isVideoPlaying = ->
  video = $('.activevideo')
  return not video[0].paused

playVideoFromStart = ->
  video = $('.activevideo')
  video[0].currentTime = 0
  if video[0].paused
    video[0].play()

playVideo = ->
  video = $('.activevideo')
  if video[0].paused
    video[0].play()

pauseVideo = ->
  video = $('.activevideo')
  if not video[0].paused
    video[0].pause()

insertQuestion = root.insertQuestion = (question, options) ->
  options = {} if not options?
  qnum = counterNext 'qnum'
  body = J('.panel-body').attr('id', "body_#qnum")
  body.append J('h3').text question.title
  body.append J('span').text question.text
  body.append J('br')
  for option,idx in question.options
    createWidget(question.type, qnum, idx, option, body)
  insertCheckAnswerButton = ->
    body.append J('button.btn.btn-default.btn-lg#check_' + qnum).css('margin-right', '15px')/*.attr('disabled', true)*/.text('check answer').click (evt) ->
      answers = getAnswerValue question.type, qnum
      console.log answers
      if isAnswerCorrect question, answers
        showAnswer question, qnum, true
        questionCorrect question
        insertQuestion getNextQuestion()
        disableQuestion qnum
      else
        showAnswer question, qnum, false
        questionIncorrect question
        if not haveInsertedReview qnum
          disableQuestion qnum
          insertReview question
          reviewInserted (counterCurrent \qnum)
  insertWatchVideoButton = (autotrigger) ->
    watch-video-button = J('button.btn.btn-default.btn-lg#review_' + qnum).css('margin-right', '15px').text("watch video").click (evt) ->
      insertReview question
      #disableQuestion qnum
      hideQuestion qnum
      setVideoFocused(true)
      #$(window).scrollTop $('.activevideo').offset().top
    if autotrigger
      watch-video-button.addClass 'autotrigger'
      watch-video-button.removeClass 'btn-default'
      watch-video-button.addClass 'btn-primary'
    body.append watch-video-button
  insertSkipButton = ->
    body.append J('button.btn.btn-default.btn-lg#skip_' + qnum).css('margin-right', '15px').text('already know answer').click (evt) ->
      console.log 'skipping question'
      disableQuestion qnum
      questionSkip question
      insertQuestion getNextQuestion()
  if root.question_progress[question.idx].correct.length > 0
    insertCheckAnswerButton()
    if not options.skip-video?
      insertWatchVideoButton()
  else
    if not options.skip-video?
      insertWatchVideoButton(true)
    insertCheckAnswerButton()
  if root.question_progress[question.idx].correct.length > 0
    insertSkipButton()
  body.append J("\#answer_#qnum")
  $('#quizstream').append /*J('.panel.panel-default')*/ /*J('div').attr('id', "panel_#qnum").append*/ body

$(document).ready ->
  console.log 'ready'
  insertQuestion getNextQuestion()
  $(document).mousewheel (evt) ->
    #console.log evt
    if $('.activevideo').length > 0
      window-top = $(window).scrollTop()
      video-top = $('.activevideo').offset().top
      window-bottom = window-top + $(window).height()
      video-bottom = video-top + $('.activevideo').height()
      #if Math.abs(window-bottom - video-bottom) < 50
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
      /*
      if evt.deltaY < 0 and (Math.abs(window-top - video-top) <= 20) and not videoAtEnd() # scrolling downwards
        invideo = true
      if evt.deltaY > 0 and (Math.abs(window-top - video-top) <= 20) and not videoAtFront()
        invideo = true
      */
      if invideo
        $(window).scrollTop(video-top)
        if not isVideoPlaying() and not videoAtEnd()
          playVideoFromStart()
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
    if evt.deltaY < 0
      increaseButtonFill()
    else
      resetButtonFill()
    if not isVideoFocused()
      if evt.deltaY < 0
        $(window).scrollTop $(window).scrollTop()+10
      else if evt.deltaY > 0
        $(window).scrollTop $(window).scrollTop()-10
    evt.preventDefault()
    return false
  #insertQuestion questions[0]
  #for question in root.questions.slice 0,1
  #  insertQuestion question
    
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some text')
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some more text')
