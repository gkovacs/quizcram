(function(){
  var root, J, ref$, sum, reverse, consolelog, stringEach, listVideos, getAllDependencies, getQuestionsForVideoPart, createQuestionsForVideosWithoutQuizzes, randomFromList, randomString, getlog, postJSON, clearlog, ensureLoggedToServer, addlogvideo, addlogReal, addlog, counterNext, counterSet, counterCurrent, toPercent, toPercentCss, toSeconds, getVideoEnd, getVideoStartEnd, getVideoPartSeenCompressed, getVideoPartsSeenThatNeedToBeSent, getVideoPartsSeenThatNeedToBeSentCompressed, decompressBinaryArray, sendVideoPartsSeen, getVideoProgress, isCurrentPortionPreviouslySeen, skipToEndOfSeenPortion, getVideoSeenIntervalsRaw, getVideoSeenIntervals, markVideoSecondWatched, setWatchButtonProgress, updateWatchButtonProgress, updateCurrentTimeText, updateTickLocation, updateSeenIntervals, setSubtitleText, updateSubtitle, timeUpdatedReal, timeUpdated, setStartTime, insertAfter, seekVideoToPercent, seekVideoTo, seekVideoByOffset, playPauseVideo, isVideoFocused, timeSinceVideoFocus, getVideoPanel, getOuterBody, getRightbar, setVideoFocused, getQnumOfPanelAbove, removeAllVideos, getVideoFileUrl, fixVideoHeight, fixVideoHeightFull, getLastVideoForQuestion, addStartMarker, setTickPercentage, setHoverTickPercentage, setRelevantPortion, setSeenIntervals, getPercentageOnProgressBar, getbot, insertVideo, addVideoDependsOnQuestion, getVideosDependingOnQuestion, getType, bodyExists, getBody, getQidx, getVidnameForQidx, getVidpartForQidx, getVidnameForQuestion, getVidpartForQuestion, getVidnamePartForQuestion, toVidnamePart, getVidnamePart, getVidname, getVidpart, insertBefore, insertReviewForQuestion, childVideoAlreadyInserted, getChildVideoQnum, isParentAnimated, printStack, scrollToElement, scrollWindow, applyTransform, haveTransform, removeActiveVideoAndShrink, gotoQuestionNum, makeVideoActiveByVideoPanel, makeVideoActiveByVideoTag, makeVideoActive, gotoVideoNum, gotoNum, disableAnswerOptions, enableAnswerOptions, disableQuestion, hideQuestion, initializeQuestion, havePassedQuestion, mostRecentCorrect, mostRecentSkip, mostRecentCorrectOrSkip, scoreQuestion, maxidx, getNextQuestionOld, getNextQuestion, interleavedConcat, toBrainData, getInitialTrainData, getClassifier, setExplanationHtml, setExplanation, getExplanation, needAnswerForQuestion, clearNeedAnswerForQuestion, tryClearWaitBeforeAnswering, clearWaitBeforeAnswering, waitBeforeAnswering, createRadio, shouldBeChecked, createCheckbox, setCheckboxOption, setOption, createWidget, getRadioValue, getCheckboxes, getCheckboxValue, arraysEqualUnsorted, arraysEqual, getAnswerValue, isAnswerCorrect, markQuestion, questionSkip, questionCorrect, questionIncorrect, resetButtonFill, increaseButtonFill, partialFillButton, haveInsertedReview, reviewInserted, showIsCorrect, scrambleAnswerOptionsCheckbox, scrambleAnswerOptions, hideAnswer, showAnswer, videoAtFront, videoAtEnd, scrollVideoForward, scrollVideoBackward, isVideoPlaying, playVideoFromStart, getCurrentQuestionQnum, playVideo, setPlaybackSpeed, increasePlaybackSpeed, decreasePlaybackSpeed, pauseVideo, disableButtonAutotrigger, getButton, showButton, hideButton, turnOffAllDefaultbuttons, turnOffDefaultButton, setDefaultButton, showChildVideoForQuestion, getVideoDependencies, showChildVideoForVideo, showChildVideo, resetIfNeeded, resetVideoBody, setVideoBody, getVideo, showVideo, viewPreviousClip, appendWithSlideDown, placeVideoBefore, getPartialScoreCheckbox, getPartialScoreSelfRate, getPartialScore, computeScoreFromHistory, haveCorrectlyAnsweredQuestion, haveSeenQuestion, getScoreForQuestion, updateQuestionScore, getRecencyScoreForQuestion, getVideoScoreForQuestion, getMasteryScoreForQuestion, updateRecencyInfo, showInVideoQuiz, hideInVideoQuizAndForward, hideInVideoQuiz, insertInVideoQuiz, insertQuestion, isMouseInVideo, isScrollAtBottom, replayLogs, replayLogsOrig, videoHeightFractionVisible, fixVideoHeightProcess, questionAlwaysShownProcess, getUrlParameters, prepadTo2, secondsToDisplayableMinutes, millisecToDisplayable, updateUrlBar, updateUrlHash, updateUsername, updateTimeStarted, updateCourseName, updateHalfNum, filterQuestionsByHalf, filterVideosByHalf, filterQuestions, filterVideos, updateVideos, downloadAndParseSubtitle, downloadAndParseAllSubtitles, updateQuestions, updateExamQuestions, updateOptions, updateMasteryScoreDisplay, updateMasteryScoreDisplayProcess, updateUrlBarProcess, setKeyBindings, quizCramInitialize, courseraInitialize, testExamInitialize, testQuizInitialize, slice$ = [].slice;
  root = typeof exports != 'undefined' && exports !== null ? exports : this;
  J = $.jade;
  ref$ = require('prelude-ls'), sum = ref$.sum, reverse = ref$.reverse;
  consolelog = function(line){};
  stringEach = function(l){
    var output, i$, len$, x, y;
    output = [];
    for (i$ = 0, len$ = l.length; i$ < len$; ++i$) {
      x = l[i$];
      if (x.split != null) {
        output.push((fn$()).join('<br>'));
      } else {
        output.push(x.toString());
      }
    }
    return output;
    function fn$(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = x.split("\n")).length; i$ < len$; ++i$) {
        y = ref$[i$];
        results$.push($('<span>').text(y).html());
      }
      return results$;
    }
  };
  root.video_dependencies = {
    '1-1-1': [],
    '1-2-1': [],
    '1-2-2': ['1-2-1'],
    '1-3-1': ['1-2-2'],
    '1-3-2': ['1-3-1'],
    '1-3-3': [],
    '1-3-4': [],
    '1-3-5': ['1-3-4'],
    '1-3-6': ['1-3-5'],
    '1-4-1': ['1-3-6'],
    '1-4-2': ['1-4-1'],
    '1-4-3': ['1-4-2'],
    '1-4-4': ['1-4-3'],
    '2-1-1': [],
    '2-1-2': ['2-1-1'],
    '2-1-3': ['2-1-2'],
    '2-2-1': ['2-1-3'],
    '2-2-2': ['2-2-1'],
    '2-2-3': ['2-2-2'],
    '2-2-4': ['2-2-3'],
    '2-2-5': ['2-2-4'],
    '2-2-6': ['2-2-5']
  };
  listVideos = root.listVideos = function(){
    var videoNames, res$, vidname, ref$, vidinfo;
    res$ = [];
    for (vidname in ref$ = root.video_info) {
      vidinfo = ref$[vidname];
      res$.push(vidname);
    }
    videoNames = res$;
    videoNames.sort();
    return videoNames;
  };
  getAllDependencies = root.getAllDependencies = function(videoname){
    var output, i$, ref$, len$, x;
    if (root.video_dependencies[videoname] == null) {
      return [];
    } else {
      output = root.video_dependencies[videoname];
      for (i$ = 0, len$ = (ref$ = root.video_dependencies[videoname]).length; i$ < len$; ++i$) {
        x = ref$[i$];
        output = output.concat(getAllDependencies(x));
      }
      return output;
    }
  };
  getQuestionsForVideoPart = root.getQuestionsForVideoPart = function(vidname, vidpart){
    var output, i$, ref$, len$, question, j$, ref1$, len1$, video;
    output = [];
    for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
      question = ref$[i$];
      for (j$ = 0, len1$ = (ref1$ = question.videos).length; j$ < len1$; ++j$) {
        video = ref1$[j$];
        if (video.name === vidname && video.part === vidpart) {
          output.push(question);
        }
      }
    }
    return output;
  };
  createQuestionsForVideosWithoutQuizzes = function(){
    var newQuestions, vidname, ref$, vidinfo, i$, ref1$, len$, vidpart, partinfo, videoQuestions, j$, len1$, question;
    newQuestions = [];
    for (vidname in ref$ = root.video_info) {
      vidinfo = ref$[vidname];
      for (i$ = 0, len$ = (ref1$ = vidinfo.parts).length; i$ < len$; ++i$) {
        vidpart = i$;
        partinfo = ref1$[i$];
        videoQuestions = getQuestionsForVideoPart(vidname, vidpart);
        for (j$ = 0, len1$ = videoQuestions.length; j$ < len1$; ++j$) {
          question = videoQuestions[j$];
          newQuestions.push(question);
        }
        if (videoQuestions.length === 0) {
          newQuestions.push({
            text: 'How well do you understand this video?',
            title: 'some question',
            type: 'radio',
            course: vidinfo.course,
            autoshowvideo: true,
            nocheckanswer: true,
            needanswer: true,
            selfrate: true,
            options: ['Understand the video', 'Somewhat unclear, would like to rewatch it later', 'Do not understand the video at all, would like to rewatch it soon'],
            correct: 0,
            explanation: 'some explanation',
            videos: [{
              name: vidname,
              degree: 1.0,
              part: vidpart
            }]
          });
        }
      }
    }
    return root.questions = newQuestions;
  };
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
  root.username = null;
  randomFromList = function(list){
    return list[Math.floor(Math.random() * list.length)];
  };
  randomString = function(length){
    var alphabet, x;
    alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"].concat(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"], ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);
    return (function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
        x = ref$[i$];
        results$.push(randomFromList(alphabet));
      }
      return results$;
      function fn$(){
        var i$, to$, results$ = [];
        for (i$ = 0, to$ = length; i$ < to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }
    }()).join('');
  };
  getlog = root.getlog = function(callback){
    return $.getJSON('/viewlog?' + $.param({
      username: root.username
    }), function(logs){
      return callback(logs);
    });
  };
  postJSON = root.postJSON = function(url, jsondata, callback){
    return $.ajax({
      type: 'POST',
      url: url,
      data: JSON.stringify(jsondata),
      success: function(data){
        if (callback != null) {
          return callback(data);
        } else {
          return console.log(data);
        }
      },
      contentType: 'application/json'
    });
  };
  clearlog = root.clearlog = function(){
    return postJSON('/clearlog', {
      username: root.username
    });
  };
  root.loggedData = [];
  root.loggingDisabledGlobally = false;
  root.loggingDisabled = false;
  root.serverReceivedLogidx = {};
  ensureLoggedToServer = function(list, name){
    if (name == null) {
      name = randomString(14);
    }
    if (root.serverReceivedLogidx[name] != null) {
      consolelog('already ensuring logged to server: ' + name);
      return;
    }
    root.serverReceivedLogidx[name] = -1;
    return setInterval(function(){
      var nextidx;
      nextidx = root.serverReceivedLogidx[name] + 1;
      if (nextidx < list.length) {
        return postJSON('/addlog', list[nextidx], function(updatedIdx){
          updatedIdx = parseInt(updatedIdx);
          if (isFinite(updatedIdx)) {
            return root.serverReceivedLogidx[name] = updatedIdx;
          }
        });
      }
    }, 350);
  };
  addlogvideo = root.addlogvideo = function(logdata){
    var videotag, video, qnum, vidname, vidpart, data;
    if (root.loggingDisabled || root.loggingDisabledGlobally) {
      return;
    }
    videotag = $('.activevideo');
    if (videotag == null || videotag.length === 0) {
      return;
    }
    video = getVideoPanel(videotag);
    if (video == null || video.length === 0) {
      return;
    }
    qnum = video.data('qnum');
    vidname = video.data('vidname');
    vidpart = video.data('vidpart');
    data = $.extend({}, logdata);
    data.vidname = vidname;
    data.vidpart = vidpart;
    data.qnum = qnum;
    data.type = 'video';
    data.curtime = videotag[0].currentTime;
    data.paused = videotag[0].paused;
    data.speed = videotag[0].playbackRate;
    data.partsseen = getVideoPartSeenCompressed(vidname);
    return addlog(data);
  };
  addlogReal = root.addlogReal = function(data){
    if (data.logidx == null) {
      data.logidx = root.loggedData.length;
    }
    root.loggedData.push(data);
    return postJSON('/addlog', data);
  };
  addlog = root.addlog = function(logdata){
    var data;
    if (root.loggingDisabled || root.loggingDisabledGlobally) {
      return;
    }
    data = $.extend({}, logdata);
    if (data.username == null) {
      data.username = root.username;
    }
    if (data.course == null) {
      data.course = root.coursename;
    }
    if (data.halfnum == null) {
      data.halfnum = root.halfnum;
    }
    if (data.platform == null) {
      data.platform = root.platform;
    }
    if (data.time == null) {
      data.time = Date.now();
    }
    if (data.timeloc == null) {
      data.timeloc = new Date().toString();
    }
    if (data.started == null) {
      data.started = root.timeStarted;
    }
    if (data.qnumcurq == null) {
      data.qnumcurq = getCurrentQuestionQnum();
    }
    if (data.automatic == null && root.automaticTrigger) {
      data.automatic = true;
      root.automaticTrigger = false;
    }
    return addlogReal(data);
  };
  root.counter_values = {};
  counterNext = root.counterNext = function(name){
    if (root.counter_values[name] == null) {
      root.counter_values[name] = 0;
    } else {
      root.counter_values[name] += 1;
    }
    return root.counter_values[name];
  };
  counterSet = root.counterSet = function(name, val){
    return root.counter_values[name] = val;
  };
  counterCurrent = root.counterCurrent = function(name){
    if (!root.counter_values[name]) {
      return 0;
    }
    return root.counter_values[name];
  };
  toPercent = function(num){
    return (num * 100).toFixed(0);
  };
  toPercentCss = function(num){
    return (Math.min(1, num) * 100).toString() + '%';
  };
  toSeconds = root.toSeconds;
  getVideoEnd = function(vidinfo){
    var ref$;
    return toSeconds((ref$ = vidinfo.parts)[ref$.length - 1].end);
  };
  getVideoStartEnd = function(vidname, vidpart){
    var vidinfo, ref$, start, end;
    vidinfo = root.video_info[vidname];
    if (vidpart != null) {
      ref$ = vidinfo.parts[vidpart], start = ref$.start, end = ref$.end;
      return [toSeconds(start), toSeconds(end)];
    } else {
      start = 0;
      end = getVideoEnd(vidinfo);
      return [toSeconds(start), toSeconds(end)];
    }
  };
  root.videoPartsSeen = {};
  root.videoPartsSeenServer = {};
  console.log('vidinfo!!!---------------------===================');
  (function(){
    var vidname, ref$, vidinfo, seen, results$ = [];
    for (vidname in ref$ = root.video_info) {
      vidinfo = ref$[vidname];
      seen = repeatArray$([0], Math.round(getVideoEnd(vidinfo)) + 1);
      results$.push(root.videoPartsSeen[vidname] = seen);
    }
    return results$;
  })();
  getVideoPartSeenCompressed = function(vidname){
    var seenpart;
    seenpart = root.videoPartsSeen[vidname];
    if (seenpart == null) {
      return '';
    }
    return LZString.compressToBase64(seenpart.join(''));
  };
  getVideoPartsSeenThatNeedToBeSent = root.getVideoPartsSeenThatNeedToBeSent = function(){
    var output, vidname, ref$, seenpart;
    output = {};
    for (vidname in ref$ = root.videoPartsSeen) {
      seenpart = ref$[vidname];
      if (root.videoPartsSeenServer[vidname] == null || !deepEq$(seenpart, root.videoPartsSeenServer[vidname], '===')) {
        output[vidname] = slice$.call(seenpart, 0);
      }
    }
    return output;
  };
  getVideoPartsSeenThatNeedToBeSentCompressed = root.getVideoPartsSeenThatNeedToBeSentCompressed = function(){
    var vidname, seenpart;
    return (function(){
      var ref$, results$ = {};
      for (vidname in ref$ = getVideoPartsSeenThatNeedToBeSent()) {
        seenpart = ref$[vidname];
        results$[vidname] = LZString.compressToBase64(seenpart.join(''));
      }
      return results$;
    }());
  };
  decompressBinaryArray = function(compressedData){
    var uncompressed, x;
    uncompressed = LZString.decompressFromBase64(compressedData);
    return (function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = uncompressed).length; i$ < len$; ++i$) {
        x = ref$[i$];
        results$.push(parseInt(x));
      }
      return results$;
    }());
  };
  sendVideoPartsSeen = root.sendVideoPartsSeen = function(){
    var toBeSent, qnum, qidx, vidname, compressedData, results$ = [];
    toBeSent = getVideoPartsSeenThatNeedToBeSentCompressed();
    if (Object.keys(toBeSent).length === 0) {
      return;
    }
    qnum = getCurrentQuestionQnum();
    qidx = getQidx(qnum);
    addlog({
      event: 'videopartsseen',
      type: 'video',
      partsseen: toBeSent,
      qnum: qnum,
      qidx: qidx
    });
    for (vidname in toBeSent) {
      compressedData = toBeSent[vidname];
      results$.push(root.videoPartsSeenServer[vidname] = decompressBinaryArray(compressedData));
    }
    return results$;
  };
  getVideoProgress = root.getVideoProgress = function(vidname, vidpart){
    var ref$, start, end, viewingHistory, relevantSection;
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    viewingHistory = root.videoPartsSeen[vidname];
    relevantSection = slice$.call(viewingHistory, Math.round(start), Math.round(end) + 1 || 9e9);
    return sum(relevantSection) / relevantSection.length;
  };
  isCurrentPortionPreviouslySeen = root.isCurrentPortionPreviouslySeen = function(qnum){
    var video, curtime, vidname, vidpart, ref$, start, end, length, viewingHistory, relevantSection;
    video = $('#video_' + qnum);
    if (video.length < 1) {
      return false;
    }
    curtime = Math.round(video[0].currentTime);
    vidname = getVidname(qnum);
    vidpart = getVidpart(qnum);
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    start = 0;
    length = end - start;
    viewingHistory = root.videoPartsSeen[vidname];
    relevantSection = slice$.call(viewingHistory, Math.round(start), Math.round(end) + 1 || 9e9);
    if (sum(slice$.call(relevantSection, curtime, curtime + 3 + 1 || 9e9)) >= 4) {
      return true;
    }
    return false;
  };
  skipToEndOfSeenPortion = root.skipToEndOfSeenPortion = function(qnum){
    var curtime, vidname, vidpart, seenIntervals, i$, len$, ref$, start, end;
    if (root.platform === 'invideo') {
      return;
    }
    curtime = Math.round($('#video_' + qnum)[0].currentTime);
    vidname = getVidname(qnum);
    vidpart = getVidpart(qnum);
    seenIntervals = getVideoSeenIntervalsRaw(vidname, vidpart);
    for (i$ = 0, len$ = seenIntervals.length; i$ < len$; ++i$) {
      ref$ = seenIntervals[i$], start = ref$[0], end = ref$[1];
      if (start <= curtime && curtime < end - 1) {
        addlogvideo({
          event: 'skipToEndOfSeenPortion',
          newtime: end - 1
        });
        seekVideoTo(end - 1);
        getVideo(vidname, vidpart).find('.skipseen').hide();
        return;
      }
    }
  };
  getVideoSeenIntervalsRaw = root.getVideoSeenIntervalsRaw = function(vidname, vidpart){
    var ref$, start, end, length, viewingHistory, relevantSection, seenIntervals, intervalStart, i$, len$, i, val;
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    start = 0;
    length = end - start;
    viewingHistory = root.videoPartsSeen[vidname];
    relevantSection = slice$.call(viewingHistory, Math.round(start), Math.round(end) + 1 || 9e9);
    seenIntervals = [];
    intervalStart = null;
    for (i$ = 0, len$ = relevantSection.length; i$ < len$; ++i$) {
      i = i$;
      val = relevantSection[i$];
      if (val === 0) {
        if (intervalStart != null) {
          seenIntervals.push([intervalStart, i]);
          intervalStart = null;
        }
      } else {
        if (intervalStart == null) {
          intervalStart = i;
        }
      }
    }
    if (intervalStart != null) {
      seenIntervals.push([intervalStart, relevantSection.length - 1]);
    }
    return seenIntervals;
  };
  getVideoSeenIntervals = root.getVideoSeenIntervals = function(vidname, vidpart){
    var ref$, start, end, length, seenIntervals;
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    start = 0;
    length = end - start;
    seenIntervals = getVideoSeenIntervalsRaw(vidname, vidpart);
    return (function(){
      var i$, ref$, len$, ref1$, results$ = [];
      for (i$ = 0, len$ = (ref$ = seenIntervals).length; i$ < len$; ++i$) {
        ref1$ = ref$[i$], start = ref1$[0], end = ref1$[1];
        results$.push([start / length, end / length]);
      }
      return results$;
    }());
  };
  markVideoSecondWatched = root.markVideoSecondWatched = function(vidname, vidpart, second){
    var ref$, start, end, viewingHistory;
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    start = 0;
    viewingHistory = root.videoPartsSeen[vidname];
    return viewingHistory[Math.round(second + start)] = 1;
  };
  setWatchButtonProgress = root.setWatchButtonProgress = function(vidname, vidpart, percentViewed){
    var seenmsg;
    seenmsg = '% seen';
    $('.videoprogress_' + toVidnamePart(vidname, vidpart)).data('progress', percentViewed).text(toPercent(percentViewed) + seenmsg);
    return $('.watch_' + toVidnamePart(vidname, vidpart)).data('progress', percentViewed).html('<span class="glyphicon glyphicon-play"></span> watch video (' + toPercent(percentViewed) + '% seen)');
  };
  updateWatchButtonProgress = root.updateWatchButtonProgress = function(vidname, vidpart){
    var percentViewed;
    percentViewed = getVideoProgress(vidname, vidpart);
    return setWatchButtonProgress(vidname, vidpart, percentViewed);
  };
  updateCurrentTimeText = root.updateCurrentTimeText = function(vidname, vidpart){
    var video, timeIndicator, videoTag, duration, durationDisplay, currentTime, currentTimeDisplay;
    video = getVideo(vidname, vidpart);
    timeIndicator = video.find('.timeindicator');
    videoTag = video.find('video')[0];
    duration = videoTag.duration;
    durationDisplay = secondsToDisplayableMinutes(duration);
    currentTime = videoTag.currentTime;
    currentTimeDisplay = secondsToDisplayableMinutes(currentTime);
    return timeIndicator.text(currentTimeDisplay + " / " + durationDisplay);
  };
  updateTickLocation = root.updateTickLocation = function(qnum){
    var video, vidname, vidpart, ref$, start, end, length, curtime, curpercent;
    video = $("#video_" + qnum);
    if (video.length === 0) {
      return;
    }
    vidname = getVidname(qnum);
    vidpart = getVidpart(qnum);
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    start = 0;
    length = end - start;
    curtime = video[0].currentTime;
    curpercent = curtime / length;
    return setTickPercentage(vidname, vidpart, curpercent);
  };
  updateSeenIntervals = function(vidname, vidpart){
    var percentViewed, vidnamepart, seenIntervals;
    percentViewed = getVideoProgress(vidname, vidpart);
    vidnamepart = getVidnamePart(vidname, vidpart);
    setWatchButtonProgress(vidname, vidpart, percentViewed);
    seenIntervals = getVideoSeenIntervals(vidname, vidpart);
    if (root.platform === 'invideo') {
      return;
    }
    return setSeenIntervals(vidname, vidpart, seenIntervals);
  };
  setSubtitleText = root.setSubtitleText = function(vidname, vidpart, text){
    var video, subtitleDisplay;
    video = getVideo(vidname, vidpart);
    subtitleDisplay = video.find('.subtitles');
    if (text === '') {
      return subtitleDisplay.hide();
    } else {
      subtitleDisplay.text(text);
      return subtitleDisplay.show();
    }
  };
  updateSubtitle = root.updateSubtitle = function(vidname, vidpart, curtime){
    var vidinfo, i$, ref$, len$, line, start, end;
    vidinfo = root.video_info[vidname];
    if (vidinfo.subtitle != null) {
      for (i$ = 0, len$ = (ref$ = vidinfo.subtitle).length; i$ < len$; ++i$) {
        line = ref$[i$];
        start = toSeconds(line.startTime);
        end = toSeconds(line.endTime);
        if (start <= curtime && curtime <= end) {
          setSubtitleText(vidname, vidpart, line.text);
          return;
        }
      }
    }
    return setSubtitleText(vidname, vidpart, '');
  };
  root.mostRecentTimeQuizSkipped = {};
  timeUpdatedReal = function(qnum){
    var video, vidname, vidpart, qnumCurrent, curtime, i$, ref$, len$, partidx, partinfo, partend, skippedtime, curvidpart, results$ = [];
    video = $("#video_" + qnum);
    vidname = getVidname(qnum);
    vidpart = getVidpart(qnum);
    qnumCurrent = getCurrentQuestionQnum();
    tryClearWaitBeforeAnswering(qnumCurrent);
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
    if (video.length > 0) {
      curtime = video[0].currentTime;
      markVideoSecondWatched(vidname, vidpart, curtime);
      updateSubtitle(vidname, vidpart, curtime);
      updateCurrentTimeText(vidname, vidpart);
      if (root.platform === 'invideo') {
        for (i$ = 0, len$ = (ref$ = slice$.call(root.video_info[vidname].parts, 0, -1)).length; i$ < len$; ++i$) {
          partidx = i$;
          partinfo = ref$[i$];
          partend = toSeconds(partinfo.end);
          if (partend < curtime && curtime < partend + 0.7) {
            skippedtime = root.mostRecentTimeQuizSkipped[vidname + '_' + partidx];
            if (skippedtime != null && Date.now() < skippedtime + 1300) {
              continue;
            }
            pauseVideo();
            showInVideoQuiz(vidname, partidx);
          }
        }
      }
    }
    updateTickLocation(qnum);
    if (isCurrentPortionPreviouslySeen(qnum)) {
      getVideo(vidname, vidpart).find('.skipseen').show();
    } else {
      getVideo(vidname, vidpart).find('.skipseen').hide();
    }
    if (root.video_info[vidname] != null && root.video_info[vidname].parts != null) {
      for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
        curvidpart = ref$[i$];
        if (getVideo(vidname, curvidpart).length > 0) {
          results$.push(updateSeenIntervals(vidname, curvidpart));
        }
      }
      return results$;
    }
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = root.video_info[vidname].parts.length; i$ < to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  timeUpdated = root.timeUpdated = _.throttle(timeUpdatedReal, 300);
  setStartTime = root.setStartTime = function(time, qnum){
    var video;
    video = $("#video_" + qnum);
    return video[0].currentTime = time;
  };
  insertAfter = function(qnum, contents){
    return contents.insertAfter($("#body_" + qnum));
  };
  seekVideoToPercent = function(percent){
    var video, newtime;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return;
    }
    newtime = percent * video[0].duration;
    addlogvideo({
      event: 'seek',
      subevent: 'seekVideoToPercent',
      percent: percent,
      newtime: newtime
    });
    hideInVideoQuiz();
    return video[0].currentTime = newtime;
  };
  seekVideoTo = function(time){
    var video;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return;
    }
    addlogvideo({
      event: 'seek',
      subevent: 'seekVideoTo',
      newtime: time
    });
    hideInVideoQuiz();
    return video[0].currentTime = time;
  };
  seekVideoByOffset = function(offset){
    var video, newtime;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return;
    }
    newtime = video[0].currentTime + offset;
    addlogvideo({
      event: 'seek',
      subevent: 'seekVideoByOffset',
      offset: offset,
      newtime: newtime
    });
    hideInVideoQuiz();
    return video[0].currentTime = newtime;
  };
  playPauseVideo = function(){
    var video;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return;
    }
    if (video[0].paused) {
      return playVideo();
    } else {
      return pauseVideo();
    }
  };
  isVideoFocused = root.isVideoFocused = function(){
    var video;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return false;
    }
    return video.data('focused');
  };
  timeSinceVideoFocus = root.timeSinceVideoFocus = function(){
    var video;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return 0;
    }
    if (!video.data('focused')) {
      return 0;
    }
    if (!video.data('timeVideoFocused')) {
      return 0;
    }
    return (Date.now() - video.data('timeVideoFocused')) / 1000;
  };
  getVideoPanel = root.getVideoPanel = function(elem){
    while (elem != null && elem.length != null && elem.length > 0 && elem.parent != null) {
      if (elem.hasClass('videopanel')) {
        return elem;
      }
      elem = elem.parent();
    }
  };
  getOuterBody = function(elem){
    while (elem != null && elem.length != null && elem.length > 0 && elem.parent != null) {
      if (elem.hasClass('outerbody')) {
        return elem;
      }
      elem = elem.parent();
    }
  };
  getRightbar = function(elem){
    while (elem != null && elem.length != null && elem.length > 0 && elem.parent != null) {
      if (elem.hasClass('rightbar')) {
        return elem;
      }
      elem = elem.parent();
    }
  };
  setVideoFocused = root.setVideoFocused = function(isFocused){
    var video;
    video = $('.activevideo');
    if (video == null || video.length == null || video.length < 1) {
      return false;
    }
    if (isFocused) {
      video.data('timeVideoFocused', Date.now());
      scrollToElement(video);
      fixVideoHeight(video);
      setTimeout(function(){
        return fixVideoHeight(video);
      }, 250);
    } else {
      pauseVideo();
    }
    return video.data('focused', isFocused);
  };
  getQnumOfPanelAbove = root.getQnumOfPanelAbove = function(qnum){
    var panels, panelQnums, targetIdx;
    panels = $('.panel-body-new').filter(function(idx, elem){
      return $(elem).data('qnum') != null;
    });
    panels.sort(function(a, b){
      return $(a).offset().top - $(b).offset().top;
    });
    panelQnums = $.map(panels, function(elem){
      return $(elem).data('qnum');
    });
    targetIdx = panelQnums.indexOf(qnum);
    if (targetIdx <= 0) {
      return panelQnums[0];
    }
    return panelQnums[targetIdx - 1];
  };
  removeAllVideos = root.removeAllVideos = function(){
    return $('.videopanel').remove();
  };
  getVideoFileUrl = function(video, start, end){
    var video_base, video_path, output_file;
    video_base = video.split('.')[0];
    video_path = video;
    output_file = video_base + '_' + start + '_' + end + '.webm';
    return 'http://educrowd.stanford.edu/' + output_file;
  };
  fixVideoHeight = root.fixVideoHeight = function(video){
    var height, width, maxHeight, maxWidth, panel, outerbody, realHeight;
    if (video.length < 1) {
      return;
    }
    height = video[0].videoHeight;
    width = video[0].videoWidth;
    maxHeight = $(window).height();
    maxWidth = $(window).width() * 0.7;
    maxWidth = Math.min(maxWidth, maxHeight * width / height);
    maxHeight = Math.min(maxHeight, maxWidth * height / width);
    if (video.height !== maxHeight) {
      video.height(maxHeight);
    }
    if (video.width !== maxWidth) {
      video.width(maxWidth);
    }
    panel = getVideoPanel(video);
    if (panel.height() !== maxHeight) {
      panel.height(maxHeight);
    }
    if (panel.width() !== maxWidth) {
      panel.width(maxWidth);
    }
    outerbody = getOuterBody(video);
    realHeight = maxHeight;
    if (!video.hasClass('activevideo')) {
      realHeight = maxHeight / 2;
      applyTransform(outerbody, 'scale(0.5) translateY(-50%) translateX(-50%)');
    }
    if (outerbody.height() !== realHeight) {
      return outerbody.height(realHeight);
    }
  };
  fixVideoHeightFull = root.fixVideoHeightFull = function(video){
    var height, width, maxHeight, maxWidth;
    if (video.length < 1) {
      return;
    }
    height = video[0].videoHeight;
    width = video[0].videoWidth;
    maxHeight = $(window).height();
    maxWidth = $(window).width();
    maxWidth = Math.min(maxWidth, maxHeight * width / height);
    maxHeight = Math.min(maxHeight, maxWidth * height / width);
    if (video.height !== maxHeight) {
      return video.height(maxHeight);
    }
  };
  getLastVideoForQuestion = root.getLastVideoForQuestion = function(qnum){
    var childVideos;
    childVideos = $('#prebody_' + qnum).find('.videopanel');
    childVideos.sort(function(a, b){
      return $(a).offset().top - $(b).offset().top;
    });
    return childVideos[childVideos.length - 1];
  };
  addStartMarker = root.addStartMarker = function(vidname, vidpart, percentage, labelText, active){
    var video, qnum, progressBar, color, tick, tickLabel, tickLabelText;
    if (active == null) {
      active = false;
    }
    video = getVideo(vidname, vidpart);
    qnum = video.data('qnum');
    progressBar = video.find('.videoprogressbar');
    color = 'rgba(196, 8, 8, 0.8)';
    if (active) {
      color = 'rgba(196, 8, 8, 0.8)';
    }
    if (active) {
      labelText = labelText + ' (current)';
    }
    tick = J('.videostarttick.tick').css({
      position: 'absolute',
      zIndex: 6,
      height: 'calc(100% + 1px)',
      width: '5px',
      bottom: '0%',
      borderRadius: '5px',
      border: "2px " + color,
      backgroundColor: color,
      pointerEvents: 'none'
    });
    tickLabel = J('.videostartlabel.tick').css({
      position: 'absolute',
      display: 'table',
      overflow: 'hidden',
      zIndex: 6,
      height: '20px',
      marginLeft: '-15px',
      paddingLeft: '3px',
      paddingRight: '3px',
      paddingBottom: '3px',
      paddingTop: '3px',
      bottom: '100%',
      backgroundColor: color,
      color: 'white',
      border: "5px " + color,
      borderRadius: '5px',
      fontSize: '16px',
      cursor: 'pointer'
    }).mousemove(function(evt){
      $('.videohovertick').hide();
      evt.preventDefault();
      return false;
    }).click(function(evt){
      makeVideoActive(qnum);
      seekVideoToPercent(percentage);
      playVideo();
      evt.preventDefault();
      return false;
    });
    tickLabelText = J('div').css({
      display: 'table-cell',
      verticalAlign: 'middle',
      cursor: 'pointer'
    }).text(labelText);
    if (active) {
      tickLabelText.css('font-weight', 'bold');
    }
    tickLabel.append(tickLabelText);
    progressBar.append([tick, tickLabel]);
    tick.css('left', toPercentCss(percentage));
    return tickLabel.css('left', toPercentCss(percentage));
  };
  setTickPercentage = root.setTickPercentage = function(vidname, vidpart, percentage){
    var video, progressBar, tick;
    video = getVideo(vidname, vidpart);
    progressBar = video.find('.videoprogressbar');
    tick = progressBar.find('.videotick');
    if (tick == null || tick.length === 0) {
      tick = J('.videotick.tick').css({
        position: 'absolute',
        zIndex: 7,
        height: '90%',
        width: '5px',
        top: '5%',
        borderRadius: '5px',
        border: '2px white',
        backgroundColor: 'white',
        pointerEvents: 'none'
      });
      progressBar.append(tick);
    }
    return tick.css('left', toPercentCss(percentage));
  };
  setHoverTickPercentage = root.setHoverTickPercentage = function(vidname, vidpart, percentage){
    var video, progressBar, tick;
    video = getVideo(vidname, vidpart);
    progressBar = video.find('.videoprogressbar');
    tick = progressBar.find('.videohovertick');
    if (tick == null || tick.length === 0) {
      tick = J('.videohovertick.tick').css({
        position: 'absolute',
        zIndex: 8,
        height: '90%',
        width: '5px',
        top: '5%',
        borderRadius: '5px',
        border: '2px rgba(0, 100, 255, 1.0)',
        backgroundColor: 'rgba(0, 100, 255, 1.0)',
        pointerEvents: 'none'
      });
      progressBar.append(tick);
    }
    tick.css('left', toPercentCss(percentage));
    return tick.show();
  };
  setRelevantPortion = root.setRelevantPortion = function(vidname, vidpart, startpercent, endpercent){
    var video, progressBar, relevantPortion;
    if (root.platform !== 'quizcram') {
      return;
    }
    video = getVideo(vidname, vidpart);
    progressBar = video.find('.videoprogressbar');
    relevantPortion = J('.tick.relevantportion').css({
      position: 'absolute',
      left: toPercentCss(startpercent),
      width: toPercentCss(endpercent - startpercent),
      height: '10%',
      top: '45%',
      zIndex: 1,
      backgroundColor: 'yellow'
    });
    return progressBar.append(relevantPortion);
  };
  setSeenIntervals = root.setSeenIntervals = function(vidname, vidpart, intervals){
    var video, videostart, videostartfraction, progressBar, barWidth, newIntervals, i$, len$, ref$, start, end, watchedPortion, results$ = [];
    video = getVideo(vidname, vidpart);
    videostart = video.data('start');
    videostartfraction = videostart / video.data('end');
    progressBar = video.find('.videoprogressbar');
    barWidth = progressBar.width();
    progressBar.children().not('.unwatched').not('.tick').remove();
    newIntervals = [];
    for (i$ = 0, len$ = intervals.length; i$ < len$; ++i$) {
      ref$ = intervals[i$], start = ref$[0], end = ref$[1];
      if (start < videostartfraction && videostartfraction < end) {
        newIntervals.push([start, videostartfraction]);
        newIntervals.push([videostartfraction, end]);
      } else {
        newIntervals.push([start, end]);
      }
    }
    for (i$ = 0, len$ = newIntervals.length; i$ < len$; ++i$) {
      ref$ = newIntervals[i$], start = ref$[0], end = ref$[1];
      watchedPortion = J('div').css({
        position: 'absolute',
        left: start * barWidth + 'px',
        width: (end - start) * barWidth + 'px',
        height: '50%',
        top: '25%',
        backgroundColor: 'rgba(50, 255, 50, 0.7)',
        float: 'left',
        borderRadius: '5px',
        border: '2px rgba(50, 255, 50, 0.7)',
        pointerEvents: 'none'
      });
      if (start < videostartfraction) {
        watchedPortion.css({
          backgroundColor: 'rgba(50, 255, 255, 0.7)',
          border: '2px rgba(50, 255, 255, 0.7)'
        });
      }
      results$.push(progressBar.append(watchedPortion));
    }
    return results$;
  };
  getPercentageOnProgressBar = function(evt, progressBar){
    var offsetX, progressBarWidth, percent;
    if (!evt.pageX) {
      return;
    }
    offsetX = evt.pageX - progressBar.offset().left;
    progressBarWidth = progressBar.width();
    if (progressBarWidth === 0) {
      return;
    }
    if (haveTransform(getOuterBody(progressBar))) {
      progressBarWidth /= 2;
    }
    percent = offsetX / progressBarWidth;
    return percent;
  };
  getbot = root.getbot = function(elem){
    if (typeof elem === typeof '') {
      elem = $(elem);
    }
    return elem.offset().top + elem.height();
  };
  insertVideo = function(vidname, vidpart, options){
    var ref$, start, end, qnum, vidnamepart, outerBody, body, basefilename, fileurl, title, fulltitle, numparts, videodiv, video, videoHeader, videoFooter, playButton, slowerButton, fasterButton, currentSpeed, progressBar, unwatchedPortion, timeIndicator, videoSkip, subtitleDisplayContainer, subtitleDisplay, playbuttonOverlay, i$, len$, viewPreviousVideoButton, closeButton, relevantPortionStart, relevantPortionEnd, fullVideoLength, partIdx, startTimeForPart, isCurrentPart;
    if (options == null) {
      options = {};
    }
    ref$ = getVideoStartEnd(vidname, vidpart), start = ref$[0], end = ref$[1];
    if (options.nopart) {
      start = 0;
    }
    qnum = counterNext('qnum');
    vidnamepart = toVidnamePart(vidname, vidpart);
    outerBody = J('.outerbody').attr('id', "outerbody_" + qnum).css({
      paddingTop: '0px',
      paddingLeft: '0px',
      paddingRight: '0px',
      paddingBottom: '0px',
      marginTop: '0px',
      marginBottom: '10px',
      marginLeft: '0px',
      marginRight: '0px',
      position: 'relative'
    });
    body = J('.panel-body-new').attr('id', "body_" + qnum).addClass('videopanel').addClass("video_" + vidnamepart).css({
      paddingTop: '0px',
      paddingLeft: '0px',
      paddingRight: '0px',
      paddingBottom: '0px',
      marginTop: '0px',
      marginBottom: '0px',
      marginLeft: '0px',
      marginRight: '0px',
      position: 'relative'
    }).data('qnum', qnum).data('type', 'video').data('vidname', vidname).data('vidpart', vidpart).data('start', start).data('end', end);
    setVideoBody(vidname, vidpart, body);
    basefilename = root.video_info[vidname].filename;
    fileurl = getVideoFileUrl(basefilename, 0, end + 1);
    title = root.video_info[vidname].title;
    fulltitle = title;
    if (vidpart != null && !options.nopart) {
      numparts = root.video_info[vidname].parts.length;
      if (vidpart === 0) {
        if (numparts > 1) {
          fulltitle = fulltitle + ' part 1/' + numparts;
        }
      } else {
        fulltitle = fulltitle + ' part ' + (vidpart + 1) + '/' + numparts;
      }
    }
    removeActiveVideoAndShrink();
    videodiv = J('div').css({
      position: 'relative',
      width: '100%',
      paddingBottom: '0px',
      marginBottom: '0px',
      borderBottom: '0px'
    });
    video = J('video').attr('id', "video_" + qnum).attr('ontimeupdate', 'timeUpdated(' + qnum + ')').prop('playbackRate', parseFloat(root.playbackSpeed)).prop('defaultPlaybackRate', parseFloat(root.playbackSpeed)).css({
      width: '100%',
      paddingBottom: '0px',
      marginBottom: '0px',
      borderBottom: '0px'
    }).addClass('activevideo').data('qnum', qnum).click(function(evt){
      fixVideoHeight($(this));
      consolelog('mousedown video ' + qnum);
      makeVideoActive(qnum);
      if (!isVideoPlaying()) {
        playVideo();
        evt.preventDefault();
        return false;
      }
    }).on('loadedmetadata', function(evt){
      this.currentTime = start;
      return addlogvideo({
        event: 'loadedmetadata',
        newstart: start
      });
    }).on('ended', function(evt){
      this.pause();
      addlogvideo({
        event: 'ended',
        newstart: start
      });
      hideInVideoQuiz();
      return this.currentTime = start;
    }).append(J('source').attr('src', fileurl)).on('play', function(evt){
      getVideo(vidname, vidpart).find('.playbuttonoverlay').hide();
      return getVideo(vidname, vidpart).find('.playbutton').removeClass('glyphicon-play').addClass('glyphicon-pause');
    }).on('pause', function(evt){
      getVideo(vidname, vidpart).find('.playbuttonoverlay').show();
      return getVideo(vidname, vidpart).find('.playbutton').removeClass('glyphicon-pause').addClass('glyphicon-play');
    }).on('timeupdate', function(evt){
      return updateTickLocation(qnum);
    }).on('seeked', function(evt){
      return updateTickLocation(qnum);
    });
    videoHeader = J('div').css({
      width: '100%',
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      position: 'absolute',
      zIndex: '2',
      top: '0px',
      height: '38px',
      paddingLeft: '10px',
      paddingTop: '2px',
      paddingBottom: '2px',
      marginTop: '0px',
      marginBottom: '0px',
      display: 'none'
    });
    videoHeader.append(J('span').css('color', 'white').css('font-size', '24px').css('pointer-events', 'none').text(fulltitle));
    if (!options.noprogressdisplay) {
      videoHeader.append(J('span#progress_' + qnum).addClass('videoprogress_' + vidnamepart).css({
        pointerEvents: 'none',
        color: 'white',
        marginLeft: '30px',
        fontSize: '24px'
      }).text('0% seen'));
    }
    videoFooter = J('.videofooter').css({
      width: '100%',
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      position: 'absolute',
      display: 'table',
      bottom: '0px',
      paddingTop: '0px',
      paddingLeft: '0px',
      paddingRight: '0px',
      paddingBottom: '0px',
      marginLeft: '0px',
      marginRight: '0px',
      marginTop: '0px',
      marginBottom: '0px',
      height: '38px'
    });
    playButton = J('span.playbutton.glyphicon.glyphicon-play').css({
      display: 'table-cell',
      width: '30px',
      color: 'white',
      fontSize: '24px',
      paddingLeft: '5px',
      paddingRight: '10px',
      verticalAlign: 'middle',
      cursor: 'pointer'
    }).attr('title', 'play / pause video [shortcut: space key]').click(function(evt){
      consolelog('play button clicked');
      makeVideoActive(qnum);
      return playPauseVideo();
    });
    slowerButton = J('span.slowerbutton.glyphicon.glyphicon-minus-sign').css({
      display: 'table-cell',
      width: '30px',
      color: 'white',
      fontSize: '24px',
      paddingLeft: '5px',
      paddingRight: '5px',
      verticalAlign: 'middle',
      cursor: 'pointer'
    }).attr('title', 'slow down playback speed [shortcut: -/_ key]').click(function(evt){
      makeVideoActive(qnum);
      console.log('slower button clicked');
      return decreasePlaybackSpeed(video);
    });
    fasterButton = J('span.fasterbutton.glyphicon.glyphicon-plus-sign').css({
      display: 'table-cell',
      width: '30px',
      color: 'white',
      fontSize: '24px',
      paddingLeft: '5px',
      paddingRight: '10px',
      verticalAlign: 'middle',
      cursor: 'pointer'
    }).attr('title', 'speed up playback speed [shortcut: =/+ key]').click(function(evt){
      makeVideoActive(qnum);
      consolelog('faster button clicked');
      return increasePlaybackSpeed(video);
    });
    currentSpeed = J('span.currentspeed').css({
      display: 'table-cell',
      width: '30px',
      color: 'white',
      fontSize: '18px',
      paddingLeft: '0px',
      paddingRight: '0px',
      verticalAlign: 'middle',
      pointerEvents: 'none'
    }).text(root.playbackSpeed + 'x');
    progressBar = J('.videoprogressbar').css({
      height: '100%',
      display: 'table-cell',
      width: 'auto',
      color: 'black',
      position: 'relative',
      backgroundColor: 'rgba(0, 0, 0, 0.0)'
    }).mouseleave(function(evt){
      return $('.videohovertick').hide();
    }).mousemove(function(evt){
      var percent;
      percent = getPercentageOnProgressBar(evt, progressBar);
      if (percent == null || !isFinite(percent) || (!0 < percent && percent <= 1)) {
        return;
      }
      return setHoverTickPercentage(vidname, vidpart, percent);
    }).click(function(evt){
      var percent;
      percent = getPercentageOnProgressBar(evt, progressBar);
      if (percent == null || !isFinite(percent) || (!0 < percent && percent <= 1)) {
        return;
      }
      makeVideoActive(qnum);
      setTickPercentage(vidname, vidpart, percent);
      return seekVideoToPercent(percent);
    });
    unwatchedPortion = J('.unwatched').css({
      position: 'absolute',
      width: '100%',
      height: '10%',
      left: '0%',
      top: '45%',
      zIndex: 0,
      backgroundColor: 'rgba(150, 150, 150, 1.0)'
    });
    timeIndicator = J('.timeindicator').css({
      height: '100%',
      display: 'table-cell',
      width: '50px',
      position: 'relative',
      color: 'white',
      verticalAlign: 'middle',
      paddingLeft: '10px',
      fontSize: '12px'
    });
    progressBar.append(unwatchedPortion);
    videoFooter.append([playButton, slowerButton, currentSpeed, fasterButton, progressBar, timeIndicator]);
    videoSkip = J('.skipseen').css({
      position: 'absolute',
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      paddingLeft: '10px',
      paddingRight: '10px',
      paddingTop: '10px',
      paddingBottom: '10px',
      border: '15px',
      borderRadius: '15px',
      color: 'white',
      fontSize: '20px',
      top: '10px',
      left: '10px',
      textAlign: 'center',
      display: 'none',
      cursor: 'pointer'
    }).html('skip to unseen portion<br><span style="font-size: 14px; text-align: center">shortcut: Enter/Return key</span>').click(function(evt){
      makeVideoActive(qnum);
      playVideo();
      return skipToEndOfSeenPortion(qnum);
    });
    subtitleDisplayContainer = J('.subtitlecontainer').css({
      position: 'absolute',
      left: 0,
      right: 0,
      bottom: '70px',
      margin: '0 auto',
      width: '100%',
      textAlign: 'center',
      pointerEvents: 'none'
    });
    subtitleDisplay = J('.subtitles').attr('align', 'center').css({
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      paddingLeft: '10px',
      paddingRight: '10px',
      paddingTop: '10px',
      paddingBottom: '10px',
      border: '15px',
      borderRadius: '15px',
      color: 'white',
      fontSize: '20px',
      display: 'inline-block',
      textAlign: 'center',
      pointerEvents: 'none'
    }).text('loading video and subtitles');
    subtitleDisplayContainer.append(subtitleDisplay);
    playbuttonOverlay = J('img.playbuttonoverlay').attr('src', 'play.svg').css({
      position: 'absolute',
      left: 0,
      right: 0,
      top: '25%',
      opacity: 0.5,
      margin: '0 auto',
      width: '50%',
      height: '50%',
      textAlign: 'center',
      verticalAlign: 'center',
      cursor: 'pointer',
      color: 'white'
    }).attr('title', 'play video [shortcut: space key]').click(function(evt){
      makeVideoActive(qnum);
      return playVideo();
    });
    body.append([videoHeader, subtitleDisplayContainer, playbuttonOverlay, video, videoFooter]);
    if (!options.novideoskip) {
      body.append(videoSkip);
    }
    if (options.quizzes) {
      for (i$ = 0, len$ = (fn$()).length; i$ < len$; ++i$) {
        (fn1$.call(this, (fn$())[i$]));
      }
    }
    if ((root.video_dependencies[vidname] != null && root.video_dependencies[vidname].length > 0) && !options.noprevvideo) {
      viewPreviousVideoButton = J('span.linklike').css({
        marginLeft: '30px',
        fontSize: '24px'
      }).html('<span class="glyphicon glyphicon-step-backward"></span> previous video').click(function(evt){
        consolelog('do not understand video');
        consolelog(vidname);
        return viewPreviousClip(vidname, vidpart);
      });
      videoHeader.append(viewPreviousVideoButton);
    }
    closeButton = J('span.glyphicon.glyphicon-remove-circle').css({
      fontSize: '24px',
      position: 'absolute',
      top: '5px',
      right: '5px',
      color: 'white',
      display: 'block',
      cursor: 'pointer'
    }).click(function(){
      var amountToScrollUp, targetQnum;
      amountToScrollUp = $('#body_' + qnum).height();
      targetQnum = getVideo(vidname, vidpart).data('prebody');
      $('#body_' + qnum).remove();
      $('#outerbody_' + qnum).remove();
      resetVideoBody(vidname, vidpart);
      return getButton(targetQnum, 'watch').show();
    });
    videoHeader.append(closeButton);
    relevantPortionStart = toSeconds(root.video_info[vidname].parts[vidpart].relstart);
    relevantPortionEnd = toSeconds(root.video_info[vidname].parts[vidpart].relend);
    fullVideoLength = toSeconds(root.video_info[vidname].parts[vidpart].end);
    setRelevantPortion(vidname, vidpart, relevantPortionStart / fullVideoLength, relevantPortionEnd / fullVideoLength);
    if (root.video_info[vidname].parts.length > 1) {
      if (vidpart != null) {
        for (i$ = 0, len$ = (ref$ = (fn2$())).length; i$ < len$; ++i$) {
          partIdx = ref$[i$];
          startTimeForPart = toSeconds(root.video_info[vidname].parts[partIdx].start);
          isCurrentPart = partIdx === vidpart;
          if (options.nopart) {
            isCurrentPart = false;
          }
          if (options.quizzes) {
            if (partIdx === 0) {
              continue;
            }
            addStartMarker(vidname, vidpart, startTimeForPart / end, "quiz " + partIdx, false);
          } else {
            addStartMarker(vidname, vidpart, startTimeForPart / end, "part " + (partIdx + 1), isCurrentPart);
          }
        }
      }
    }
    outerBody.append(body);
    return outerBody;
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = vidpart; i$ <= to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
    function fn1$(vidpartidx){
      var questionForQuizOverlay, quizOverlay;
      questionForQuizOverlay = getQuestionsForVideoPart(vidname, vidpartidx);
      if (questionForQuizOverlay == null || questionForQuizOverlay.length < 1) {
        return;
      }
      quizOverlay = J('#quizoverlay_' + vidname + '_' + vidpartidx).addClass('quizoverlay').data('quizvidname', vidname).data('quizvidpart', vidpartidx).css({
        position: 'absolute',
        left: '0px',
        right: '0px',
        top: '0px',
        bottom: '40px',
        border: '3px solid black',
        display: 'none',
        zIndex: 5,
        backgroundColor: 'white'
      });
      body.append(quizOverlay);
      insertInVideoQuiz(questionForQuizOverlay[0], body, vidpartidx);
    }
    function fn2$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = vidpart; i$ <= to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  root.questionToVideoDependencies = {};
  addVideoDependsOnQuestion = root.addVideoDependsOnQuestion = function(qnumQuestion, qnumVideo){
    if (root.questionToVideoDependencies[qnumQuestion] == null) {
      root.questionToVideoDependencies[qnumQuestion] = [];
    }
    return root.questionToVideoDependencies[qnumQuestion].push(qnumVideo);
  };
  getVideosDependingOnQuestion = root.getVideosDependingOnQuestion = function(qnumQuestion){
    return questionToVideoDependencies[qnumQuestion];
  };
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
  getType = function(qnum){
    return $("#body_" + qnum).data('type');
  };
  bodyExists = function(qnum){
    return $("#body_" + qnum).length > 0;
  };
  getBody = root.getBody = function(qnum){
    return $("#body_" + qnum);
  };
  getQidx = root.getQidx = function(qnum){
    return $("#body_" + qnum).data('qidx');
  };
  getVidnameForQidx = function(qidx){
    var question;
    question = root.questions[qidx];
    return getVidnameForQuestion(question);
  };
  getVidpartForQidx = function(qidx){
    var question;
    question = root.questions[qidx];
    return getVidpartForQuestion(question);
  };
  getVidnameForQuestion = function(question){
    var vidinfo, vidname;
    vidinfo = question.videos[0];
    vidname = vidinfo.name;
    return vidname;
  };
  getVidpartForQuestion = function(question){
    var vidinfo, vidpart;
    vidinfo = question.videos[0];
    vidpart = vidinfo.part;
    return vidpart;
  };
  getVidnamePartForQuestion = function(question){
    var vidinfo, vidname, vidpart;
    vidinfo = question.videos[0];
    vidname = vidinfo.name;
    vidpart = vidinfo.part;
    if (vidpart != null) {
      return vidname + '_' + vidpart;
    } else {
      return vidname;
    }
  };
  toVidnamePart = function(vidname, vidpart){
    if (vidpart != null) {
      return vidname + '_' + vidpart;
    } else {
      return vidname;
    }
  };
  getVidnamePart = function(qnum){
    var body, vidname, vidpart;
    body = $("#body_" + qnum);
    vidname = body.data('vidname');
    vidpart = body.data('vidpart');
    if (vidpart != null) {
      return vidname + '_' + vidpart;
    } else {
      return vidname;
    }
  };
  getVidname = function(qnum){
    return $("#body_" + qnum).data('vidname');
  };
  getVidpart = function(qnum){
    return $("#body_" + qnum).data('vidpart');
  };
  insertBefore = function(qnum, content){
    return content.insertBefore($("#body_" + qnum));
  };
  insertReviewForQuestion = function(qnum){
    var body, qidx, question, i$, ref$, len$, vidinfo, results$ = [];
    body = getBody(qnum);
    qidx = getQidx(qnum);
    consolelog('qidx is: ' + qidx);
    question = root.questions[qidx];
    if (question.videos != null) {
      for (i$ = 0, len$ = (ref$ = question.videos).length; i$ < len$; ++i$) {
        vidinfo = ref$[i$];
        insertBefore(qnum, insertVideo(vidinfo.name, vidinfo.part));
        addVideoDependsOnQuestion(qnum, counterCurrent('qnum'));
        results$.push(body.data('video', counterCurrent('qnum')));
      }
      return results$;
    }
  };
  childVideoAlreadyInserted = function(qnum){
    var body, videoQnum;
    body = $("#body_" + qnum);
    if (body == null || body.length < 1) {
      return false;
    }
    videoQnum = body.data('video');
    if (videoQnum != null && $('#body_' + videoQnum).length > 0) {
      return true;
    }
    return false;
  };
  getChildVideoQnum = function(qnum){
    return $("#body_" + qnum).data('video');
  };
  isParentAnimated = function(elem){
    while (!(elem.hasClass('.panel-body-new') || elem.attr('id') === '#quizstream')) {
      if (elem.is(':animated')) {
        return true;
      }
      elem = elem.parent();
    }
    return false;
  };
  printStack = function(){
    var e, stack;
    e = new Error('dummy');
    stack = e.stack.replace(/^[^\(]+?[\n$]/gm, '').replace(/^\s+at\s+/gm, '').replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@').split('\n');
    return consolelog(stack);
  };
  root.scrollElemIdx = 0;
  scrollToElement = function(elem){
    var curElemIdx, offset;
    root.scrollElemIdx += 1;
    curElemIdx = root.scrollElemIdx;
    offset = elem.offset().top;
    scrollWindow(offset);
    if (isParentAnimated(elem)) {
      return setTimeout(function(){
        var newoffset;
        if (curElemIdx !== root.scrollElemIdx) {
          return;
        }
        newoffset = elem.offset().top;
        if (Math.abs(newoffset - offset) > 30) {
          return scrollWindow(newoffset);
        }
      }, 350);
    }
  };
  scrollWindow = function(offsetTop){
    return $('html, body').animate({
      scrollTop: offsetTop
    }, '1000', 'swing');
  };
  applyTransform = function(elem, transform){
    if (elem.data('transform') === transform) {
      return;
    }
    elem.data('transform', transform);
    return elem.css({
      webkitTransform: transform,
      mozTransform: transform,
      msTransform: transform,
      transform: transform
    });
  };
  haveTransform = function(elem){
    var transform;
    if (elem == null || elem.data == null) {
      return false;
    }
    transform = elem.data('transform');
    if (transform != null && transform !== '') {
      return true;
    }
    return false;
  };
  removeActiveVideoAndShrink = root.removeActiveVideoAndShrink = function(){
    var video;
    video = $('.activevideo');
    return video.removeClass('activevideo');
  };
  gotoQuestionNum = function(qnum){
    var panel, body;
    pauseVideo();
    panel = getVideoPanel($('.activevideo'));
    if (panel != null && qnum !== panel.data('prebody')) {
      removeActiveVideoAndShrink();
    }
    body = getBody(qnum);
    return scrollToElement(body);
  };
  makeVideoActiveByVideoPanel = function(videopanel){
    var video;
    video = videopanel.find('video');
    return makeVideoActiveByVideoTag(video);
  };
  makeVideoActiveByVideoTag = function(video){
    var outerbody;
    if (!video.hasClass('activevideo')) {
      pauseVideo();
      removeActiveVideoAndShrink();
      outerbody = getOuterBody(video);
      if (outerbody != null) {
        applyTransform(outerbody, '');
      }
      video.addClass('activevideo');
      return addlogvideo({
        event: 'makeactive'
      });
    }
  };
  makeVideoActive = root.makeVideoActive = function(qnum){
    var body, video;
    body = $("#body_" + qnum);
    video = body.find('video');
    return makeVideoActiveByVideoTag(video);
  };
  gotoVideoNum = function(qnum){
    makeVideoActive(qnum);
    return setVideoFocused(true);
  };
  gotoNum = root.gotoNum = function(qnum){
    var body;
    body = $("#body_" + qnum);
    switch (body.data('type')) {
    case 'video':
      return gotoVideoNum(qnum);
    case 'question':
      return gotoQuestionNum(qnum);
    default:
      throw 'unexpected body type: ' + body.data('type') + ' for qnum: ' + qnum;
    }
  };
  disableAnswerOptions = function(qnum){
    $("input[type=radio][name=radiogroup_" + qnum + "]").attr('disabled', true);
    return $("input[type=checkbox][name=checkboxgroup_" + qnum + "]").attr('disabled', true);
  };
  enableAnswerOptions = function(qnum){
    $("input[type=radio][name=radiogroup_" + qnum + "]").attr('disabled', false);
    return $("input[type=checkbox][name=checkboxgroup_" + qnum + "]").attr('disabled', false);
  };
  disableQuestion = root.disableQuestion = function(qnum){
    var type, body, i$, ref$, len$, qnumVideo, results$ = [];
    type = getType(qnum);
    body = getBody(qnum);
    switch (type) {
    case 'video':
      body.remove();
      break;
    case 'question':
      disableAnswerOptions(qnum);
      /*
      $('#check_' + qnum).attr('disabled', true)
      $('#watch_' + qnum).attr('disabled', true)
      #$('#skip_' + qnum).attr('disabled', true)
      $('#show_' + qnum).attr('disabled', true)
      $('#next_' + qnum).attr('disabled', true)
      */
      hideButton(qnum, 'check');
      hideButton(qnum, 'watch');
      hideButton(qnum, 'show');
      hideButton(qnum, 'next');
      break;
    default:
      throw 'unknown body type ' + type;
    }
    body.css('background-color', 'rgb(232,232,232)');
    if (getVideosDependingOnQuestion(qnum) != null) {
      for (i$ = 0, len$ = (ref$ = getVideosDependingOnQuestion(qnum)).length; i$ < len$; ++i$) {
        qnumVideo = ref$[i$];
        results$.push(disableQuestion(qnumVideo));
      }
      return results$;
    }
  };
  hideQuestion = function(qnum){
    return $("#body_" + qnum).hide();
  };
  initializeQuestion = function(){
    return {
      correct: [],
      incorrect: [],
      skip: []
    };
  };
  root.question_progress = null;
  havePassedQuestion = function(question){
    return question.correct.length > 0 || question.skip.length > 0;
  };
  mostRecentCorrect = function(question){
    var ref$;
    if (question.correct.length > 0) {
      return (ref$ = question.correct)[ref$.length - 1];
    }
    return 0;
  };
  mostRecentSkip = function(question){
    var ref$;
    if (question.skip.length > 0) {
      return (ref$ = question.skip)[ref$.length - 1];
    }
    return 0;
  };
  mostRecentCorrectOrSkip = function(question){
    return Math.max(mostRecentCorrect(question), mostRecentSkip(question));
  };
  scoreQuestion = function(now, question){
    return now - mostRecentCorrectOrSkip(question);
  };
  maxidx = function(list){
    var maxidx, maxval, i$, len$, idx, item;
    maxidx = 0;
    maxval = Number.MIN_VALUE;
    for (i$ = 0, len$ = list.length; i$ < len$; ++i$) {
      idx = i$;
      item = list[i$];
      if (item > maxval) {
        maxval = item;
        maxidx = idx;
      }
    }
    return maxidx;
  };
  getNextQuestionOld = function(){
    var now, scores, res$, i$, ref$, len$, idx, question, qidx;
    now = Date.now();
    res$ = [];
    for (i$ = 0, len$ = (ref$ = root.question_progress).length; i$ < len$; ++i$) {
      idx = i$;
      question = ref$[i$];
      res$.push(scoreQuestion(now, question));
    }
    scores = res$;
    qidx = maxidx(scores);
    return root.questions[qidx];
  };
  getNextQuestion = function(){
    var curqnum, curbody, curqidx, scores, res$, i$, ref$, len$, qidx, score, newQidx;
    curqnum = getCurrentQuestionQnum();
    curbody = getBody(curqnum);
    curqidx = -1;
    if (curbody != null && curbody.data('qidx') != null && isFinite(curbody.data('qidx'))) {
      curqidx = curbody.data('qidx');
    }
    res$ = [];
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      qidx = ref$[i$];
      if (qidx !== curqidx) {
        res$.push({
          score: getMasteryScoreForQuestion(qidx),
          qidx: qidx
        });
      }
    }
    scores = res$;
    res$ = [];
    for (i$ = 0, len$ = scores.length; i$ < len$; ++i$) {
      ref$ = scores[i$], score = ref$.score, qidx = ref$.qidx;
      if (score !== null) {
        res$.push({
          score: score,
          qidx: qidx
        });
      }
    }
    scores = res$;
    scores.sort(function(a, b){
      return a.score - b.score;
    });
    newQidx = scores[0].qidx;
    consolelog('new-qidx is: ' + newQidx);
    consolelog('question is: ' + root.questions[newQidx]);
    return root.questions[newQidx];
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = root.questions.length; i$ < to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  interleavedConcat = function(list1, list2){
    var output, l1, l2;
    output = [];
    l1 = 0;
    l2 = 0;
    while (l1 < list1.length || l2 < list2.length) {
      if (l1 === list1.length && l2 === list2.length) {
        break;
      } else if (l1 === list1.length) {
        output.push(list2[l2++]);
      } else if (l2 === list2.length) {
        output.push(list1[l1++]);
      } else if ((l1 + l2) % 0 === 0) {
        output.push(list1[l1++]);
      } else {
        output.push(list2[l2++]);
      }
    }
    return output;
  };
  toBrainData = function(list, outval){
    return {
      input: list,
      output: [outval]
    };
  };
  getInitialTrainData = function(){
    var positiveInstancesRaw, positiveInstances, res$, i$, len$, x, negativeInstancesRaw, negativeInstances;
    positiveInstancesRaw = [[1.0, 0.0, 0.0], [1.0, 1.0, 0.5]];
    res$ = [];
    for (i$ = 0, len$ = positiveInstancesRaw.length; i$ < len$; ++i$) {
      x = positiveInstancesRaw[i$];
      res$.push(toBrainData(x, 1.0));
    }
    positiveInstances = res$;
    negativeInstancesRaw = [[0.0, 0.0, 0.0]];
    res$ = [];
    for (i$ = 0, len$ = negativeInstancesRaw.length; i$ < len$; ++i$) {
      x = negativeInstancesRaw[i$];
      res$.push(toBrainData(x, 0.0));
    }
    negativeInstances = res$;
    return interleavedConcat(positiveInstances, negativeInstances);
  };
  getClassifier = root.getClassifier = function(){
    var net;
    net = new brain.NeuralNetwork();
    net.train(getInitialTrainData());
    return net;
  };
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
  setExplanationHtml = root.setExplanationHtml = function(qnum, html){
    return $("#explanation_" + qnum).html(html);
  };
  setExplanation = root.setExplanation = function(qnum, text){
    return $("#explanation_" + qnum).text(text);
  };
  getExplanation = root.getExplanation = function(qnum){
    return $("#explanation_" + qnum).text();
  };
  needAnswerForQuestion = function(qnum){
    return setExplanationHtml(qnum, '<b>Please answer the question</b> before moving to the next video');
  };
  clearNeedAnswerForQuestion = function(qnum){
    if (getExplanation(qnum) === 'Please answer the question before moving to the next video') {
      return setExplanation(qnum, '');
    }
  };
  tryClearWaitBeforeAnswering = root.tryClearWaitBeforeAnswering = function(qnum){
    var explanation, qbody, vidname, vidpart, progress, targetAmount, ref$;
    explanation = getExplanation(qnum);
    if (explanation.indexOf('Please watch at least ') === 0) {
      qbody = getBody(qnum);
      vidname = qbody.data('vidname');
      vidpart = qbody.data('vidpart');
      progress = getVideoProgress(vidname, vidpart);
      targetAmount = parseInt((ref$ = explanation.split('%')[0].split(' '))[ref$.length - 1]);
      if (100 * progress >= targetAmount) {
        enableAnswerOptions(qnum);
        setExplanation(qnum, '');
        return showButton(qnum, 'check');
      }
    }
  };
  clearWaitBeforeAnswering = root.clearWaitBeforeAnswering = function(qnum){
    if (getExplanation(qnum).indexOf('Please watch at least ') === 0) {
      enableAnswerOptions(qnum);
      setExplanation(qnum, '');
      return showButton(qnum, 'check');
    }
  };
  waitBeforeAnswering = root.waitBeforeAnswering = function(qnum, target){
    disableAnswerOptions(qnum);
    return setExplanationHtml(qnum, "<span style='font-size: 20px'><b>Please watch at least " + toPercent(target) + "% of this video part</b> before trying to answer again.</span>");
  };
  createRadio = function(qnum, idx, option, body){
    var inputbox;
    inputbox = J("input.radiogroup_" + qnum + "(type='radio' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "radiogroup_" + qnum).attr('id', "radio_" + qnum + "_" + idx).attr('value', idx).change(function(evt){
      clearNeedAnswerForQuestion(qnum);
      return addlog({
        event: 'radiobox',
        type: 'selection',
        qnum: qnum,
        optionidx: idx
      });
    });
    return body.append(J('.radio').append(J('label').append(inputbox).append(option)));
  };
  shouldBeChecked = function(qnum, idx){
    var question;
    question = root.questions[getQidx(qnum)];
    if (question.correct.indexOf(idx) !== -1) {
      return true;
    }
    return false;
  };
  createCheckbox = function(qnum, idx, option, body){
    var inputbox;
    inputbox = J("input.checkboxgroup_" + qnum + "(type='checkbox' style='vertical-align: top; display: inline-block; margin-right: 5px')").attr('name', "checkboxgroup_" + qnum).attr('id', "checkbox_" + qnum + "_" + idx).attr('value', idx).change(function(evt){
      var value, shouldbechecked;
      clearNeedAnswerForQuestion(qnum);
      value = $('#checkbox_' + qnum + '_' + idx).is(':checked');
      shouldbechecked = shouldBeChecked(qnum, idx);
      return addlog({
        event: 'checkbox',
        type: 'selection',
        value: value,
        shouldbechecked: shouldbechecked,
        qnum: qnum,
        optionidx: idx
      });
    });
    return body.append(J('.checkbox').append(J('label').append(inputbox).append(option)));
  };
  setCheckboxOption = root.setCheckboxOption = function(qnum, idx, value){
    return $('#checkbox_' + qnum + '_' + idx).prop('checked', value);
  };
  setOption = function(type, qnum, idx, value){
    switch (type) {
    case 'radio':
      throw 'selectOption not implemented for radio';
    case 'checkbox':
      return setCheckboxOption(qnum, idx, value);
    default:
      return 'selectOption not implemented for ' + type;
    }
  };
  createWidget = function(type, qnum, idx, option, body){
    switch (type) {
    case 'radio':
      return createRadio(qnum, idx, option, body);
    case 'checkbox':
      return createCheckbox(qnum, idx, option, body);
    default:
      throw 'nonexistant question type ' + type;
    }
  };
  getRadioValue = root.getRadioValue = function(qnum){
    var radioname;
    radioname = 'radiogroup_' + qnum;
    return parseInt($("input[type=radio][name=" + radioname + "]:checked").val());
  };
  getCheckboxes = root.getCheckboxes = function(qnum){
    var numoptions, i;
    numoptions = $('.checkboxgroup_' + qnum).length;
    return (function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
        i = ref$[i$];
        results$.push($('#checkbox_' + qnum + '_' + i)[0]);
      }
      return results$;
      function fn$(){
        var i$, to$, results$ = [];
        for (i$ = 0, to$ = numoptions; i$ < to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }
    }());
  };
  getCheckboxValue = root.getCheckboxValue = function(qnum){
    var output, i$, ref$, len$, i, checkbox;
    output = [];
    for (i$ = 0, len$ = (ref$ = getCheckboxes(qnum)).length; i$ < len$; ++i$) {
      i = i$;
      checkbox = ref$[i$];
      if (checkbox.checked) {
        output.push(i);
      }
    }
    return output;
  };
  arraysEqualUnsorted = root.arraysEqualUnsorted = function(a, b){
    a = slice$.call(a, 0);
    a.sort();
    b = slice$.call(b, 0);
    b.sort();
    return arraysEqual(a, b);
  };
  arraysEqual = root.arraysEqual = function(a, b){
    return deepEq$(a, b, '===');
  };
  getAnswerValue = function(type, qnum){
    switch (type) {
    case 'radio':
      return getRadioValue(qnum);
    case 'checkbox':
      return getCheckboxValue(qnum);
    default:
      throw 'nonexistant question type ' + type;
    }
  };
  isAnswerCorrect = function(question, answers){
    switch (question.type) {
    case 'radio':
      return answers === question.correct;
    case 'checkbox':
      return arraysEqualUnsorted(answers, question.correct);
    default:
      throw 'nonexistant question type ' + type;
    }
  };
  markQuestion = function(question_idx, mark){
    var question_progress;
    if (question_idx.idx != null) {
      return markQuestion(question_idx.idx, mark);
    }
    question_progress = root.question_progress[question_idx];
    return question_progress[mark].push(Date.now());
  };
  questionSkip = function(question){
    return markQuestion(question, 'skip');
  };
  questionCorrect = function(question){
    return markQuestion(question, 'correct');
  };
  questionIncorrect = function(question){
    return markQuestion(question, 'incorrect');
  };
  root.overlapButton = null;
  root.automaticTrigger = false;
  resetButtonFill = function(){
    var autotrigger, buttonFill;
    if (root.overlapButton != null) {
      root.overlapButton.hide();
    }
    autotrigger = $('.autotrigger');
    if (autotrigger == null || autotrigger.length == null || autotrigger.length === 0) {
      return;
    }
    buttonFill = 0;
    return autotrigger.data('button-fill', buttonFill);
  };
  increaseButtonFill = function(){
    var autotrigger, buttonFill;
    autotrigger = $('.autotrigger');
    if (autotrigger == null || autotrigger.length == null || autotrigger.length === 0) {
      return;
    }
    buttonFill = 0;
    if (autotrigger.data('button-fill') != null) {
      buttonFill = autotrigger.data('button-fill');
    }
    buttonFill += 0.1;
    if (buttonFill >= 1.0) {
      resetButtonFill();
      root.automaticTrigger = true;
      autotrigger.click();
      root.automaticTrigger = false;
      return;
    }
    autotrigger.data('button-fill', buttonFill);
    return partialFillButton(buttonFill);
  };
  partialFillButton = root.partialFillButton = function(fraction){
    var autotrigger, ref$, top, left;
    autotrigger = $('.autotrigger');
    if (autotrigger == null || autotrigger.length == null || autotrigger.length === 0) {
      return;
    }
    if (root.overlapButton == null) {
      root.overlapButton = J('button.btn.btn-success.btn-lg').css('position', 'absolute').css('pointer-events', 'none');
      $('#quizstream').append(root.overlapButton);
    }
    root.overlapButton.text(autotrigger.text());
    root.overlapButton.width(autotrigger.width());
    root.overlapButton.height(autotrigger.height());
    ref$ = autotrigger.offset(), top = ref$.top, left = ref$.left;
    root.overlapButton.css('top', top);
    root.overlapButton.css('left', left);
    root.overlapButton.css('clip', 'rect(0px ' + autotrigger.outerWidth() * fraction + 'px auto 0px)');
    return root.overlapButton.show();
  };
  root.insertedReviews = {};
  haveInsertedReview = function(qnum){
    if (root.insertedReviews[qnum] != null) {
      return true;
    }
    return false;
  };
  reviewInserted = function(qnum){
    return root.insertedReviews[qnum] = true;
  };
  showIsCorrect = function(qnum, isCorrect, options){
    var qidx, question, feedback, correcttext, incorrecttext, feedbackDisplay;
    if (options == null) {
      options = {};
    }
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    feedback = J('span');
    if (isCorrect) {
      feedback.append(J('b').css('color', 'green').text('Correct'));
      if (question.explanation == null || question.explanation === '(see correct answers above)') {
        correcttext = 'Move on to the next question!';
        if (options.correcttext != null) {
          correcttext = options.correcttext;
        }
        $("#explanation_" + qnum).text(correcttext);
      } else {
        $("#explanation_" + qnum).text(question.explanation);
      }
    } else {
      feedback.append(J('b').css('color', 'red').text('Incorrect'));
      incorrecttext = 'We suggest you watch the video and try answering again, or see solution';
      if (options.incorrecttext != null) {
        incorrecttext = options.incorrecttext;
      }
      $("#explanation_" + qnum).text(incorrecttext);
    }
    feedbackDisplay = $("#iscorrect_" + qnum);
    feedbackDisplay.html('');
    return feedbackDisplay.append(feedback);
  };
  scrambleAnswerOptionsCheckbox = function(qnum){
    var optionsdiv, options, i$, ref$, len$, i, randidx, curopt, results$ = [];
    optionsdiv = $("#options_" + qnum);
    options = optionsdiv.find('.checkbox');
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      i = ref$[i$];
      randidx = Math.floor(Math.random() * options.length);
      curopt = $(options[randidx]).detach();
      results$.push(optionsdiv.append(curopt));
    }
    return results$;
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = options.length; i$ < to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  scrambleAnswerOptions = root.scrambleAnswerOptions = function(qnum){
    return scrambleAnswerOptionsCheckbox(qnum);
  };
  hideAnswer = root.hideAnswer = function(qnum){
    var qidx, question, body, feedbackDisplay;
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    body = getBody(qnum);
    if (question.type === 'checkbox') {
      $(".checkboxgroup_" + qnum).prop('checked', false);
    } else if (question.type === 'radio') {
      $(".radiogroup_" + qnum).prop('checked', false);
    }
    feedbackDisplay = $("#iscorrect_" + qnum);
    feedbackDisplay.html('');
    setExplanation(qnum, '');
    hideButton(qnum, 'show');
    hideButton(qnum, 'next');
    showButton(qnum, 'check');
    hideButton(qnum, 'review');
    enableAnswerOptions(qnum);
    return scrambleAnswerOptions(qnum);
  };
  root.forcedreview = false;
  showAnswer = root.showAnswer = function(qnum){
    var qidx, question, body, i$, ref$, len$, answeridx, feedbackDisplay, vidname, vidpart;
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    body = getBody(qnum);
    if (question.type === 'checkbox') {
      $(".checkboxgroup_" + qnum).prop('checked', false);
      for (i$ = 0, len$ = (ref$ = question.correct).length; i$ < len$; ++i$) {
        answeridx = ref$[i$];
        $("#checkbox_" + qnum + "_" + answeridx).prop('checked', true);
      }
    } else if (question.type === 'radio') {
      $(".radiogroup_" + qnum).prop('checked', false);
      $("#radio_" + qnum + "_" + question.correct).prop('checked', true);
    }
    feedbackDisplay = $("#iscorrect_" + qnum);
    feedbackDisplay.html('<b style="color: red">Incorrect - see correct answer above</b>');
    setExplanation(qnum, question.explanation);
    hideButton(qnum, 'show');
    hideButton(qnum, 'check');
    vidname = question.videos[0].name;
    vidpart = question.videos[0].part;
    showButton(qnum, 'review');
    if (root.platform === 'quizcram') {
      root.forcedreview = true;
    }
    hideButton(qnum, 'watch');
    updateWatchButtonProgress(vidname, vidpart);
    return disableAnswerOptions(qnum);
  };
  videoAtFront = function(){
    var video;
    video = $('.activevideo');
    if (video[0].currentTime < 1.0) {
      return true;
    }
    return false;
  };
  videoAtEnd = function(){
    var video;
    video = $('.activevideo');
    if (Math.abs(video[0].currentTime - video[0].duration) < 1.0) {
      return true;
    }
    return false;
  };
  scrollVideoForward = function(){
    var video;
    video = $('.activevideo');
    return video[0].currentTime += 5.0;
  };
  scrollVideoBackward = function(){
    var video;
    video = $('.activevideo');
    return video[0].currentTime -= 5.0;
  };
  isVideoPlaying = root.isVideoPlaying = function(){
    var video;
    video = $('.activevideo');
    if (video.length === 0) {
      return false;
    }
    return !video[0].paused;
  };
  playVideoFromStart = function(){
    var video;
    video = $('.activevideo');
    if (video.length < 1) {
      return;
    }
    video[0].currentTime = 0;
    if (video[0].paused) {
      return video[0].play();
    }
  };
  root.currentQuestionQnum = 0;
  getCurrentQuestionQnum = root.getCurrentQuestionQnum = function(){
    return root.currentQuestionQnum;
  };
  playVideo = root.playVideo = function(){
    var qnum, video, videopanel, vidname, vidpart, percentSeen;
    qnum = getCurrentQuestionQnum();
    resetIfNeeded(qnum);
    video = $('.activevideo');
    if (video.length < 1) {
      return;
    }
    if (!video[0].paused) {
      return;
    }
    videopanel = getVideoPanel(video);
    vidname = videopanel.data('vidname');
    vidpart = videopanel.data('vidpart');
    console.log('vidname played:' + vidname + ' vidpart: ' + vidpart);
    console.log('forcedreivew:' + forcedreview);
    if (root.platform === 'quizcram' && root.forcedreview) {
      root.forcedreview = false;
      percentSeen = getVideoProgress(vidname, vidpart);
      console.log('percent-seen:' + percentSeen);
      if (percentSeen < 0.75) {
        waitBeforeAnswering(qnum, Math.min(0.75, percentSeen + 0.10));
        hideButton(qnum, 'check');
      }
    }
    addlogvideo({
      event: 'play'
    });
    hideInVideoQuizAndForward();
    return video[0].play();
  };
  root.playbackSpeed = '1.00';
  setPlaybackSpeed = function(newSpeed){
    if (newSpeed == null) {
      return;
    }
    root.playbackSpeed = newSpeed;
    $('.currentspeed').text(newSpeed + 'x');
    newSpeed = parseFloat(newSpeed);
    addlogvideo({
      event: 'setPlaybackSpeed',
      newspeed: newSpeed
    });
    return $('video').prop('playbackRate', newSpeed);
  };
  increasePlaybackSpeed = root.increasePlaybackSpeed = function(){
    var speedMap, newSpeed;
    speedMap = {
      '0.75': '1.00',
      '1.00': '1.25',
      '1.25': '1.50',
      '1.50': '1.75',
      '1.75': '2.00',
      '2.00': '2.00'
    };
    newSpeed = speedMap[root.playbackSpeed];
    return setPlaybackSpeed(newSpeed);
  };
  decreasePlaybackSpeed = root.decreasePlaybackSpeed = function(){
    var speedMap, newSpeed;
    speedMap = {
      '0.75': '0.75',
      '1.00': '0.75',
      '1.25': '1.00',
      '1.50': '1.25',
      '1.75': '1.50',
      '2.00': '1.75'
    };
    newSpeed = speedMap[root.playbackSpeed];
    return setPlaybackSpeed(newSpeed);
  };
  pauseVideo = function(){
    var video, i$, len$, vid, results$ = [];
    video = $('.activevideo');
    for (i$ = 0, len$ = video.length; i$ < len$; ++i$) {
      vid = video[i$];
      if (!vid.paused) {
        results$.push(vid.pause());
      }
    }
    return results$;
  };
  disableButtonAutotrigger = function(){
    var button;
    resetButtonFill();
    button = $('.autotrigger');
    button.removeClass('autotrigger');
    if (button.hasClass('btn-primary')) {
      button.removeClass('btn-primary');
      return button.addClass('btn-default');
    }
  };
  getButton = root.getButton = function(qnum, buttontype){
    switch (buttontype) {
    case 'show':
      return $("#show_" + qnum);
    case 'check':
      return $("#check_" + qnum);
    case 'watch':
      return $("#watch_" + qnum);
    case 'next':
      return $("#next_" + qnum);
    case 'review':
      return $("#review_" + qnum);
    case 'skip':
      return $("#skip_" + qnum);
    case 'continue':
      return $("#continue_" + qnum);
    case 'submit':
      return $("#submit_" + qnum);
    default:
      throw 'unknown button type ' + buttontype;
    }
  };
  showButton = function(qnum, buttontype){
    return getButton(qnum, buttontype).show();
  };
  hideButton = function(qnum, buttontype){
    return getButton(qnum, buttontype).hide();
  };
  turnOffAllDefaultbuttons = function(){
    var buttons;
    buttons = $('.btn-primary');
    buttons.removeClass('btn-primary');
    return buttons.addClass('btn-default');
  };
  turnOffDefaultButton = function(button, buttontype){
    if (typeof button === typeof 0) {
      button = getButton(button, buttontype);
    }
    if (button.hasClass('btn-primary')) {
      button.removeClass('btn-primary');
      return button.addClass('btn-default');
    }
  };
  setDefaultButton = function(button, buttontype){
    return;
    if (typeof button === typeof 0) {
      button = getButton(button, buttontype);
    }
    if (!button.hasClass('autotrigger')) {
      disableButtonAutotrigger();
      button.addClass('autotrigger');
    }
    if (!button.hasClass('btn-primary')) {
      button.removeClass('btn-default');
      return button.addClass('btn-primary');
    }
  };
  showChildVideoForQuestion = function(qnum){
    if (childVideoAlreadyInserted(qnum)) {
      gotoNum(getChildVideoQnum(qnum));
    } else {
      insertReviewForQuestion(qnum);
      gotoNum(getChildVideoQnum(qnum));
    }
    return setVideoFocused(true);
  };
  getVideoDependencies = function(vidname, vidpart){
    var dependencies, x;
    dependencies = [];
    if (root.video_dependencies[vidname] != null) {
      dependencies = dependencies.concat((function(){
        var i$, ref$, len$, results$ = [];
        for (i$ = 0, len$ = (ref$ = root.video_dependencies[vidname]).length; i$ < len$; ++i$) {
          x = ref$[i$];
          results$.push([x, root.video_info[x].parts.length - 1]);
        }
        return results$;
      }()));
    }
    return dependencies;
  };
  showChildVideoForVideo = function(qnum){
    var vidname, vidpart, prebodyQnum, dependency, ref$, dvidname, dvidpart, body;
    setVideoFocused(false);
    vidname = getVidname(qnum);
    vidpart = getVidpart(qnum);
    prebodyQnum = getVideo(vidname, vidpart).data('prebody');
    if (childVideoAlreadyInserted(qnum)) {
      gotoNum(getChildVideoQnum(qnum));
    } else {
      dependency = (ref$ = getVideoDependencies(vidname, vidpart))[ref$.length - 1];
      dvidname = dependency[0], dvidpart = dependency[1];
      /*
      if vidpart?
        insertBefore qnum, (insertVideo dvidname, dvidpart, "<h3>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{vidname} part #{vidpart+1}</span>)</h3>")
      else
        insertBefore qnum, (insertVideo dvidname, dvidpart, "<h3>(to help you understand <span class='linklike' onclick='gotoNum(#qnum)'>#{vidname}</span>)</h3>")
      */
      placeVideoBefore(dvidname, dvidpart, prebodyQnum);
      addVideoDependsOnQuestion(qnum, counterCurrent('qnum'));
      body = getBody(qnum);
      body.data('video', counterCurrent('qnum'));
      gotoNum(getChildVideoQnum(qnum));
    }
    setVideoFocused(true);
    return playVideo();
  };
  showChildVideo = root.showChildVideo = function(qnum){
    var type;
    type = getType(qnum);
    switch (type) {
    case 'question':
      return showChildVideoForQuestion(qnum);
    case 'video':
      return showChildVideoForVideo(qnum);
    default:
      throw 'unknown item type ' + type;
    }
  };
  resetIfNeeded = root.resetIfNeeded = function(qnum){
    if (getBody(qnum).data('answered')) {
      if (!getBody(qnum).data('correct')) {
        getBody(qnum).data('answered', false);
        getBody(qnum).data('correct', false);
        return hideAnswer(qnum);
      }
    }
  };
  root.vidnamepartToVideos = {};
  resetVideoBody = function(vidname, vidpart){
    var vidnamepart, ref$, ref1$;
    vidnamepart = toVidnamePart(vidname, vidpart);
    return ref1$ = (ref$ = root.vidnamepartToVideos)[vidnamepart], delete ref$[vidnamepart], ref1$;
  };
  setVideoBody = function(vidname, vidpart, body){
    var vidnamepart;
    vidnamepart = toVidnamePart(vidname, vidpart);
    return root.vidnamepartToVideos[vidnamepart] = body;
  };
  getVideo = root.getVideo = function(vidname, vidpart){
    var vidnamepart;
    vidnamepart = toVidnamePart(vidname, vidpart);
    if (root.vidnamepartToVideos[vidnamepart] != null) {
      return root.vidnamepartToVideos[vidnamepart];
    }
    return $('.video_' + vidnamepart);
  };
  showVideo = function(vidname, vidpart){
    var curvid;
    curvid = getVideo(vidname, vidpart);
    return gotoNum(curvid.data('qnum'));
  };
  viewPreviousClip = function(vidname, vidpart){
    var curvid, qnum, prebodyQnum, dependency, ref$, dvidname, dvidpart;
    pauseVideo();
    curvid = getVideo(vidname, vidpart);
    qnum = curvid.data('qnum');
    prebodyQnum = curvid.data('prebody');
    dependency = (ref$ = getVideoDependencies(vidname, vidpart))[ref$.length - 1];
    dvidname = dependency[0], dvidpart = dependency[1];
    placeVideoBefore(dvidname, dvidpart, prebodyQnum);
    showVideo(dvidname, dvidpart);
    return playVideo();
  };
  appendWithSlideDown = function(elem, parent, time){
    if (time == null) {
      time = 300;
    }
    return elem.appendTo(parent).hide().slideDown(time);
  };
  placeVideoBefore = root.placeVideoBefore = function(vidname, vidpart, qnum){
    var vidnamepart, curvid, targetBody, outerbody, newvideo;
    vidnamepart = toVidnamePart(vidname, vidpart);
    curvid = getVideo(vidname, vidpart);
    if (curvid.length > 0) {
      if (curvid.data('prebody') === qnum) {} else {
        targetBody = $('#prebody_' + qnum);
        getButton(curvid.data('prebody'), 'watch').show();
        outerbody = getOuterBody(curvid);
        outerbody.detach();
        appendWithSlideDown(outerbody, targetBody);
        return curvid.data('prebody', qnum);
      }
    } else {
      newvideo = insertVideo(vidname, vidpart);
      appendWithSlideDown(newvideo, $('#prebody_' + qnum));
      return getVideo(vidname, vidpart).data('prebody', qnum);
    }
  };
  getPartialScoreCheckbox = root.getPartialScoreCheckbox = function(qnum){
    var qidx, question, numoptions, scores, i$, ref$, len$, optidx, checkbox, myanswer, realanswer, score;
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    numoptions = $('.checkboxgroup_' + qnum).length;
    scores = [];
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      optidx = ref$[i$];
      checkbox = $('#checkbox_' + qnum + '_' + optidx);
      myanswer = checkbox.is(':checked');
      realanswer = question.correct.indexOf(optidx) !== -1;
      score = 0;
      if (myanswer === realanswer) {
        score = 1;
      }
      scores.push(score);
    }
    return sum(scores) / scores.length;
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = numoptions; i$ < to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  getPartialScoreSelfRate = root.getPartialScoreSelfRate = function(qnum){
    var radioidx;
    radioidx = getRadioValue(qnum);
    switch (radioidx) {
    case 0:
      return 1.0;
    case 1:
      return 0.75;
    case 2:
      return 0.5;
    default:
      return 0.75;
    }
  };
  getPartialScore = root.getPartialScore = function(qnum){
    var qidx, question;
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    if (question.type === 'checkbox') {
      return getPartialScoreCheckbox(qnum);
    }
    if (question.type === 'radio') {
      if (question.selfrate) {
        return getPartialScoreSelfRate(qnum);
      }
    }
    throw 'getScoreForAnswers does not support question type: ' + question.type;
  };
  root.question_scores = [];
  computeScoreFromHistory = function(qnumhistory, scorehistory){
    var total, divisor, power, i$, len$, qnum, j$, ref$, len1$, score;
    total = 0;
    divisor = 0;
    power = 1;
    for (i$ = 0, len$ = qnumhistory.length; i$ < len$; ++i$) {
      qnum = qnumhistory[i$];
      for (j$ = 0, len1$ = (ref$ = scorehistory[qnum]).length; j$ < len1$; ++j$) {
        score = ref$[j$];
        total += power * score;
        divisor += power;
      }
      power = power * 0.25;
    }
    return total / divisor;
  };
  haveCorrectlyAnsweredQuestion = root.haveCorrectlyAnsweredQuestion = function(qidx){
    if (root.question_recency_info[qidx] != null) {
      return true;
    }
    return false;
  };
  haveSeenQuestion = root.haveSeenQuestion = function(qidx){
    if (root.question_scores[qidx] != null) {
      return true;
    }
    return false;
  };
  getScoreForQuestion = root.getScoreForQuestion = function(qidx){
    if (root.question_scores[qidx] == null) {
      return 0;
    }
    return root.question_scores[qidx].current;
  };
  updateQuestionScore = root.updateQuestionScore = function(qnum){
    var qidx, question, score, overallscore, scoreinfo;
    qidx = getQidx(qnum);
    question = root.questions[qidx];
    score = getPartialScore(qnum);
    overallscore = score;
    if (root.question_scores[qidx] == null) {
      root.question_scores[qidx] = {
        current: score,
        qnumhistory: [],
        scorehistory: {}
      };
    }
    scoreinfo = root.question_scores[qidx];
    if (scoreinfo.scorehistory[qnum] == null) {
      scoreinfo.scorehistory[qnum] = [];
      scoreinfo.qnumhistory.unshift(qnum);
    }
    scoreinfo.scorehistory[qnum].unshift(score);
    scoreinfo.current = computeScoreFromHistory(scoreinfo.qnumhistory, scoreinfo.scorehistory);
    overallscore = scoreinfo.current;
    addlog({
      event: 'questionscore',
      newscore: score,
      overallscore: overallscore,
      qnum: qnum,
      qidx: qidx,
      scoreinfo: root.question_scores[qidx]
    });
    return $('#questionscore_' + qnum).text(overallscore);
  };
  root.question_recency_info = [];
  getRecencyScoreForQuestion = root.getRecencyScoreForQuestion = function(qidx){
    var qcycle, curQcycle, cyclesSinceSeen;
    if (root.question_recency_info[qidx] == null) {
      return 0;
    }
    qcycle = root.question_recency_info[qidx].qcycle;
    curQcycle = counterCurrent('qcycle');
    cyclesSinceSeen = Math.min(root.questions.length, curQcycle - qcycle);
    if (cyclesSinceSeen === 0) {
      return 10;
    }
    return 1.0 / cyclesSinceSeen;
  };
  getVideoScoreForQuestion = root.getVideoScoreForQuestion = function(qidx){
    var vidinfo, vidname, vidpart;
    vidinfo = root.questions[qidx].videos[0];
    vidname = vidinfo.name;
    vidpart = vidinfo.part;
    return getVideoProgress(vidname, vidpart);
  };
  getMasteryScoreForQuestion = root.getMasteryScoreForQuestion = function(qidx){
    var questionscore, recencyscore, videoscore;
    questionscore = getScoreForQuestion(qidx) * 4.0;
    recencyscore = getRecencyScoreForQuestion(qidx) * 1.0;
    videoscore = getVideoScoreForQuestion(qidx) * 2.0;
    if (qidx === 0 || haveCorrectlyAnsweredQuestion(qidx) || haveCorrectlyAnsweredQuestion(qidx - 1)) {
      return Math.max(0, Math.min(1, (questionscore + recencyscore + videoscore) / 7));
    }
    return null;
  };
  updateRecencyInfo = root.updateRecencyInfo = function(qnum){
    var qidx, qcycle;
    qidx = getQidx(qnum);
    qcycle = getBody(qnum).data('qcycle');
    if (root.question_recency_info[qidx] == null) {
      root.question_recency_info[qidx] = {};
    }
    root.question_recency_info[qidx].qcycle = qcycle;
    root.question_recency_info[qidx].time = Date.now();
    return addlog({
      event: 'recencyinfo',
      qnum: qnum,
      qidx: qidx,
      recencyinfo: root.question_recency_info[qidx]
    });
  };
  root.numIncorrectAnswers = 0;
  showInVideoQuiz = root.showInVideoQuiz = function(vidname, vidpart){
    var quizOverlay;
    if (root.platform === 'invideo') {
      quizOverlay = $('#quizoverlay_' + vidname + '_' + vidpart);
      if (quizOverlay.filter(':visible').length > 0) {
        return;
      }
      quizOverlay.show();
      return addlogvideo({
        event: 'quizshow',
        quizvidname: vidname,
        quizvidpart: vidpart
      });
    }
  };
  hideInVideoQuizAndForward = root.hideInVideoQuizAndForward = function(){
    var quizOverlay, quizvidname, quizvidpart;
    if (root.platform === 'invideo') {
      quizOverlay = $('.quizoverlay');
      if (quizOverlay.filter(':visible').length === 0) {
        return;
      }
      quizOverlay.hide();
      quizvidname = quizOverlay.data('quizvidname');
      quizvidpart = quizOverlay.data('quizvidpart');
      root.mostRecentTimeQuizSkipped[quizvidname + '_' + quizvidpart] = Date.now();
      return addlogvideo({
        event: 'quizhide',
        quizvidname: quizvidname,
        quizvidpart: quizvidpart
      });
    }
  };
  hideInVideoQuiz = root.hideInVideoQuiz = function(){
    var quizOverlay, quizvidname, quizvidpart;
    if (root.platform === 'invideo') {
      quizOverlay = $('.quizoverlay');
      if (quizOverlay.filter(':visible').length === 0) {
        return;
      }
      quizOverlay.hide();
      quizvidname = quizOverlay.data('quizvidname');
      quizvidpart = quizOverlay.data('quizvidpart');
      return addlogvideo({
        event: 'quizhide',
        quizvidname: quizvidname,
        quizvidpart: quizvidpart
      });
    }
  };
  insertInVideoQuiz = root.insertInVideoQuiz = function(question, video, vidpart){
    var vidname, target;
    vidname = video.data('vidname');
    target = video.find('#quizoverlay_' + vidname + '_' + vidpart);
    return insertQuestion(question, {
      immediate: true,
      novideo: true,
      append: true,
      target: target,
      nobuttons: true,
      nocontainer: true,
      invideo: true,
      video: video
    });
  };
  insertQuestion = root.insertQuestion = function(question, options){
    var qnum, qcycle, vidname, vidpart, body, vidnamepart, questionTitle, questionSubtitle, questionSubtitleDiv, questionScoreDiv, optionsdiv, i$, ref$, len$, idx, option, insertShowAnswerButton, quizvidname, quizvidpart, insertInVideoSubmitButton, insertInVideoContinueButton, insertInVideoSkipButton, insertCheckAnswerButton, insertVideoHere, insertWatchVideoButton, insertReviewVideoButton, insertNextQuestionButton, containerdiv, targetToAddQuestionTo, autoShowVideo;
    if (options == null) {
      options = {};
    }
    if (options.qnum != null) {
      qnum = options.qnum;
      counterSet('qnum', qnum);
    } else {
      qnum = counterNext('qnum');
    }
    if (options.qcycle != null) {
      qcycle = options.qcycle;
      counterSet('qcycle', qcycle);
    } else {
      qcycle = counterNext('qcycle');
    }
    root.currentQuestionQnum = qnum;
    root.numIncorrectAnswers = 0;
    turnOffAllDefaultbuttons();
    vidname = getVidnameForQuestion(question);
    vidpart = getVidpartForQuestion(question);
    body = J('.panel-body-new').attr('id', "body_" + qnum).data('qnum', qnum).data('qcycle', qcycle).data('qidx', question.idx).data('type', 'question').data('vidname', vidname).data('vidpart', vidpart).css({
      paddingTop: '0px',
      paddingLeft: '10px',
      paddingRight: '10px',
      paddingBottom: '10px'
    });
    vidnamepart = getVidnamePartForQuestion(question);
    if (question.exam) {
      questionTitle = question.title;
    } else {
      questionTitle = root.video_info[vidname].title + ', part ' + (vidpart + 1) + '/' + root.video_info[vidname].parts.length;
    }
    if (root.platform === 'quizcram') {
      questionSubtitle = 'Question ' + (question.idx + 1) + ' of ' + root.questions.length;
      if (haveCorrectlyAnsweredQuestion(question.idx)) {
        questionSubtitle = 'Question ' + (question.idx + 1) + ' of ' + root.questions.length + ' (review)';
      }
      questionSubtitleDiv = J('span').text(questionSubtitle);
      questionScoreDiv = J('span.questionscore_' + question.idx).css({
        float: 'right'
      });
      body.append(J('div').css({
        fontSize: '14px',
        paddingTop: '10px',
        clear: 'both'
      }).append([questionSubtitleDiv, questionScoreDiv]));
    }
    body.append(J('div').css({
      fontSize: '24px',
      paddingTop: '0px'
    }).text(questionTitle));
    body.append(J('div').text(question.text));
    optionsdiv = J("#options_" + qnum);
    for (i$ = 0, len$ = (ref$ = question.options).length; i$ < len$; ++i$) {
      idx = i$;
      option = ref$[i$];
      createWidget(question.type, qnum, idx, option, optionsdiv);
    }
    body.append(optionsdiv);
    addlog({
      event: 'insertquestion',
      type: 'question',
      qidx: question.idx,
      qnum: qnum,
      qcycle: qcycle
    });
    insertShowAnswerButton = function(){
      return body.append(J('button.btn.btn-default.btn-lg#show_' + qnum).css('display', 'none').css('margin-right', '15px').text('see solution').click(function(evt){
        questionSkip(question);
        showAnswer(qnum);
        showButton(qnum, 'next');
        setDefaultButton(qnum, 'next');
        return addlog({
          event: 'show',
          type: 'button',
          qidx: question.idx,
          qnum: qnum
        });
      }));
    };
    quizvidname = question.videos[0].name;
    quizvidpart = question.videos[0].part;
    insertInVideoSubmitButton = function(){
      return body.append(J('button.btn.btn-primary.btn-lg#submit_' + qnum).css('margin-right', '15px').html('<span class="glyphicon glyphicon-check"></span> submit answer').click(function(evt){
        var answers, isCorrect, partialscore;
        consolelog('in video submit button clicked');
        answers = getAnswerValue(question.type, qnum);
        isCorrect = isAnswerCorrect(question, answers);
        partialscore = getPartialScore(qnum);
        if (isCorrect) {
          showIsCorrect(qnum, true, {
            correcttext: ''
          });
          hideButton(qnum, 'submit');
          hideButton(qnum, 'skip');
          showButton(qnum, 'continue');
          return addlogvideo({
            event: 'check',
            qidx: question.idx,
            questionqnum: qnum,
            correct: true,
            partialscore: partialscore,
            answers: answers,
            numIncorrectAnswers: root.numIncorrectAnswers,
            quizvidname: quizvidname,
            quizvidpart: quizvidpart
          });
        } else {
          root.numIncorrectAnswers += 1;
          if (root.numIncorrectAnswers >= 3) {
            showIsCorrect(qnum, false, {
              incorrecttext: 'See correct answer above'
            });
            hideButton(qnum, 'skip');
            hideButton(qnum, 'submit');
            showButton(qnum, 'continue');
            addlogvideo({
              event: 'check',
              qidx: question.idx,
              questionqnum: qnum,
              correct: false,
              partialscore: partialscore,
              answers: answers,
              numIncorrectAnswers: root.numIncorrectAnswers,
              quizvidname: quizvidname,
              quizvidpart: quizvidpart
            });
            return showAnswer(qnum);
          } else {
            showIsCorrect(qnum, false, {
              incorrecttext: 'Try again'
            });
            return addlogvideo({
              event: 'check',
              qidx: question.idx,
              questionqnum: qnum,
              correct: false,
              partialscore: partialscore,
              answers: answers,
              numIncorrectAnswers: root.numIncorrectAnswers,
              quizvidname: quizvidname,
              quizvidpart: quizvidpart
            });
          }
        }
      }));
    };
    insertInVideoContinueButton = function(){
      return body.append(J('button.btn.btn-primary.btn-lg#continue_' + qnum).css('margin-right', '15px').css('display', 'none').html('<span class="glyphicon glyphicon-forward"></span> continue').click(function(evt){
        consolelog('in video continue button clicked');
        addlogvideo({
          event: 'continue',
          qidx: question.idx,
          questionqnum: qnum,
          quizvidname: quizvidname,
          quizvidpart: quizvidpart
        });
        root.mostRecentTimeQuizSkipped[quizvidname + '_' + quizvidpart] = Date.now();
        hideInVideoQuiz();
        return playVideo();
      }));
    };
    insertInVideoSkipButton = function(){
      return body.append(J('button.btn.btn-primary.btn-lg#skip_' + qnum).css('margin-right', '15px').html('<span class="glyphicon glyphicon-forward"></span> skip question').click(function(evt){
        consolelog('in video skip button clicked');
        addlogvideo({
          event: 'skip',
          qidx: question.idx,
          questionqnum: qnum,
          quizvidname: quizvidname,
          quizvidpart: quizvidpart
        });
        root.mostRecentTimeQuizSkipped[quizvidname + '_' + quizvidpart] = Date.now();
        hideInVideoQuiz();
        return playVideo();
      }));
    };
    insertCheckAnswerButton = function(){
      return body.append(J('button.btn.btn-primary.btn-lg#check_' + qnum).css('margin-right', '15px').css('width', '100%').html('<span class="glyphicon glyphicon-check"></span> check answer').click(function(evt){
        var answers, partialscore;
        gotoNum(qnum);
        answers = getAnswerValue(question.type, qnum);
        updateQuestionScore(qnum);
        partialscore = getPartialScore(qnum);
        if (isAnswerCorrect(question, answers)) {
          addlog({
            event: 'check',
            type: 'button',
            correct: true,
            partialscore: partialscore,
            qidx: question.idx,
            answers: answers,
            numIncorrectAnswers: root.numIncorrectAnswers,
            qnum: qnum
          });
          showIsCorrect(qnum, true);
          questionCorrect(question);
          hideButton(qnum, 'review');
          hideButton(qnum, 'check');
          hideButton(qnum, 'show');
          showButton(qnum, 'next');
          disableAnswerOptions(qnum);
          updateRecencyInfo(qnum);
          getBody(qnum).data('answered', true);
          return getBody(qnum).data('correct', true);
        } else {
          root.numIncorrectAnswers += 1;
          addlog({
            event: 'check',
            type: 'button',
            correct: false,
            partialscore: partialscore,
            qidx: question.idx,
            answers: answers,
            numIncorrectAnswers: root.numIncorrectAnswers,
            qnum: qnum
          });
          showIsCorrect(qnum, false);
          questionIncorrect(question);
          showAnswer(qnum);
          getBody(qnum).data('answered', true);
          return getBody(qnum).data('correct', false);
        }
      }));
    };
    insertVideoHere = function(){
      placeVideoBefore(vidname, vidpart, qnum);
      showVideo(vidname, vidpart);
      return setVideoFocused(true);
    };
    insertWatchVideoButton = function(autotrigger){
      var watchVideoButton;
      watchVideoButton = J('button.btn.btn-primary.btn-lg#watch_' + qnum).css('display', 'none').data('vidname', vidname).data('vidpart', vidpart).addClass('watch_' + vidnamepart).css('margin-right', '15px').css('width', '100%').click(function(evt){
        pauseVideo();
        addlog({
          event: 'watch',
          type: 'button',
          qidx: question.idx,
          qnum: qnum
        });
        resetIfNeeded(getCurrentQuestionQnum());
        if (!root.replayingLogs) {
          insertVideoHere();
          playVideo();
        }
        return getButton(qnum, 'watch').hide();
      });
      if (autotrigger) {
        setDefaultButton(watchVideoButton);
      }
      return body.append(watchVideoButton);
    };
    insertReviewVideoButton = function(){
      var reviewVideoButton;
      reviewVideoButton = J('button.btn.btn-primary.btn-lg.reviewbutton#review_' + qnum).addClass('review_' + vidnamepart).css('display', 'none').css('margin-right', '15px').css('width', '100%').html('<span class="glyphicon glyphicon-play"></span> review video before answering again').click(function(evt){
        return getButton(qnum, 'watch').click();
      });
      return body.append(reviewVideoButton);
    };
    insertNextQuestionButton = function(){
      return body.append(J('button.btn.btn-primary.btn-lg#next_' + qnum).css('display', 'none').css('margin-right', '15px').css('width', '100%').html('<span class="glyphicon glyphicon-forward"></span> next video').click(function(evt){
        var answer;
        if (question.needanswer != null && question.needanswer) {
          answer = getAnswerValue('radio', qnum);
          if (answer == null || !isFinite(answer)) {
            needAnswerForQuestion(qnum);
            return;
          }
        }
        if (!root.replayingLogs) {
          sendVideoPartsSeen();
        }
        addlog({
          event: 'next',
          type: 'button',
          qidx: question.idx,
          qnum: qnum
        });
        body.css('padding-top', '0px');
        pauseVideo();
        questionCorrect(question);
        hideButton(qnum, 'next');
        clearNeedAnswerForQuestion(qnum);
        disableAnswerOptions(qnum);
        if (question.selfrate) {
          updateQuestionScore(qnum);
          updateRecencyInfo(qnum);
        }
        return insertQuestion(getNextQuestion());
      }));
    };
    /*
    insertSkipButton = ->
      body.append J('button.btn.btn-default.btn-lg#skip_' + qnum).css('margin-right', '15px').text('already know answer').click (evt) ->
        console.log 'skipping question'
        disableQuestion qnum
        questionSkip question
        insertQuestion getNextQuestion()
    */
    body.append(J('hr.vspace').css('height', '3px'));
    body.append(J("span#iscorrect_" + qnum).html(''));
    body.append(J("span#explanation_" + qnum).css('margin-left', '5px').html(''));
    body.append(J('br'));
    if (options.invideo) {
      insertInVideoSubmitButton();
      insertInVideoSkipButton();
      insertInVideoContinueButton();
    }
    if (!options.nobuttons) {
      insertWatchVideoButton(true);
      insertCheckAnswerButton();
      insertReviewVideoButton();
      insertShowAnswerButton();
      insertNextQuestionButton();
    }
    if (options.nocontainer) {
      containerdiv = J('.container_' + qnum).css({
        width: '100%'
      }).append([
        J('.leftbar.leftbar_' + qnum).css({
          width: '100%',
          float: 'left'
        }).append(body), J('.rightbar.rightbar_' + qnum).css({
          width: '0%',
          float: 'right'
        }).append(J('#prebody_' + qnum)), J('div').css({
          clear: 'both'
        })
      ]);
    } else {
      containerdiv = J('.container_' + qnum).css({
        width: '100%'
      }).append([
        J('.leftbar.leftbar_' + qnum).css({
          width: '30%',
          float: 'left'
        }).append(body), J('.rightbar.rightbar_' + qnum).css({
          width: '70%',
          float: 'right'
        }).append(J('#prebody_' + qnum)), J('div').css({
          clear: 'both'
        })
      ]);
    }
    targetToAddQuestionTo = $('#quizstream');
    if (options.target) {
      targetToAddQuestionTo = options.target;
    }
    if (options.append) {
      containerdiv.appendTo(targetToAddQuestionTo);
    } else {
      containerdiv.prependTo(targetToAddQuestionTo);
    }
    autoShowVideo = function(){
      return getButton(qnum, 'watch').click();
    };
    if (options.immediate == null) {
      body.hide();
      setTimeout(function(){
        if (question.autoshowvideo) {
          body.slideDown(300);
          return setTimeout(function(){
            return playVideo();
          }, 500);
        } else {
          body.slideDown(300);
          return scrollToElement(body);
        }
      }, 0);
    }
    scrambleAnswerOptions(qnum);
    updateWatchButtonProgress(vidname, vidpart);
    setTimeout(function(){
      if (options.novideo) {
        return;
      }
      insertVideoHere();
      if (options.immediate && question.autoshowvideo) {
        return playVideo();
      }
    }, 0);
    if (question.nocheckanswer) {
      getButton(qnum, 'check').hide();
      return getButton(qnum, 'next').show();
    }
  };
  isMouseInVideo = function(evt){
    var video, videoTop, videoBottom, ref$;
    video = $('.activevideo');
    if (video.length < 1) {
      return false;
    }
    videoTop = video.offset().top;
    videoBottom = videoTop + video.height();
    return videoTop <= (ref$ = parseFloat(evt.pageY)) && ref$ <= videoBottom;
  };
  isScrollAtBottom = function(){
    return $(window).scrollTop() + $(window).height() === $(document).height();
  };
  root.replayingLogs = false;
  replayLogs = root.replayLogs = function(logs){
    var i$, len$, log, vidname, ref$, compressedData, decompressed;
    if (root.platform !== 'quizcram') {
      return;
    }
    root.replayingLogs = true;
    for (i$ = 0, len$ = logs.length; i$ < len$; ++i$) {
      log = logs[i$];
      if (log.course !== root.coursename) {
        continue;
      }
      if (log.platform !== root.platform) {
        continue;
      }
      switch (log.event) {
      case 'insertquestion':
        counterSet('qnum', log.qnum);
        counterSet('qcycle', log.qcycle);
        break;
      case 'questionscore':
        root.question_scores[log.qidx] = log.scoreinfo;
        break;
      case 'recencyinfo':
        root.question_recency_info[log.qidx] = log.recencyinfo;
        break;
      case 'videopartsseen':
        for (vidname in ref$ = log.partsseen) {
          compressedData = ref$[vidname];
          decompressed = decompressBinaryArray(compressedData);
          root.videoPartsSeenServer[vidname] = decompressed;
          root.videoPartsSeen[vidname] = slice$.call(decompressed, 0);
        }
        break;
      default:
        consolelog(log);
      }
    }
    return root.replayingLogs = false;
  };
  replayLogsOrig = function(logs){
    var i$, len$, log;
    root.replayingLogs = true;
    for (i$ = 0, len$ = logs.length; i$ < len$; ++i$) {
      log = logs[i$];
      consolelog('replaying: ' + JSON.stringify(log));
      switch (log.event) {
      case 'insertquestion':
        if (log.qnum !== 0) {
          continue;
        }
        insertQuestion(root.questions[log.qidx], {
          qnum: log.qnum
        });
        break;
      case 'watch':
        getButton(log.qnum, 'watch').click();
        break;
      case 'check':
        getButton(log.qnum, 'check').click();
        break;
      case 'show':
        getButton(log.qnum, 'show').click();
        break;
      case 'next':
        getButton(log.qnum, 'next').click();
        break;
      case 'checkbox':
        setOption('checkbox', log.qnum, log.optionidx, log.value);
        break;
      case 'radio':
        setOption('radio', log.qnum, log.optionidx, log.value);
        break;
      default:
        consolelog(log);
      }
    }
    return root.replayingLogs = false;
  };
  videoHeightFractionVisible = function(){
    var video, videoHeight, windowHeight, windowTop, windowBottom, videoTop, videoBottom, videoHiddenTop, videoHiddenBottom, videoHidden, videoShown, fractionShown;
    video = $('.activevideo');
    if (video.length === 0) {
      return 0;
    }
    videoHeight = video.height();
    if (videoHeight <= 0 || !isFinite(videoHeight)) {
      return 0;
    }
    windowHeight = $(window).height();
    windowTop = $(window).scrollTop();
    windowBottom = windowTop + windowHeight;
    videoTop = video.offset().top;
    videoBottom = videoTop + videoHeight;
    videoHiddenTop = Math.max(0, windowTop - videoTop);
    videoHiddenBottom = Math.max(0, videoBottom - windowBottom);
    videoHidden = videoHiddenTop + videoHiddenBottom;
    videoShown = videoHeight - videoHidden;
    fractionShown = videoShown / Math.min(windowHeight, videoHeight);
    return fractionShown;
  };
  fixVideoHeightProcess = function(){
    return setInterval(function(){
      var i$, ref$, len$, x, results$ = [];
      for (i$ = 0, len$ = (ref$ = $('video')).length; i$ < len$; ++i$) {
        x = ref$[i$];
        results$.push(fixVideoHeight($(x)));
      }
      return results$;
    }, 250);
  };
  questionAlwaysShownProcess = function(){
    root.prevScrollTop = 0;
    return setInterval(function(){
      var scrollTop, qnum, body, bodyBottom, bodyHeight;
      scrollTop = $(window).scrollTop();
      if (scrollTop === root.prevScrollTop) {
        return;
      }
      root.prevScrollTop = scrollTop;
      qnum = getCurrentQuestionQnum();
      body = getBody(qnum);
      bodyBottom = body.parent().parent().height();
      bodyHeight = body.height();
      scrollTop = Math.min(scrollTop, bodyBottom - bodyHeight - 10);
      return body.animate({
        paddingTop: scrollTop
      }, 200);
    }, 500);
  };
  getUrlParameters = root.getUrlParameters = function(){
    var url, hash, map, parts;
    url = window.location.href;
    hash = url.lastIndexOf('#');
    if (hash !== -1) {
      url = url.slice(0, hash);
    }
    map = {};
    parts = url.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m, key, value){
      return map[key] = decodeURI(value);
    });
    return map;
  };
  prepadTo2 = function(num){
    num = num.toString();
    if (num.length === 1) {
      num = '0' + num;
    }
    return num;
  };
  secondsToDisplayableMinutes = function(seconds){
    var minutes;
    seconds = Math.round(seconds);
    minutes = Math.floor(seconds / 60);
    seconds -= minutes * 60;
    minutes = prepadTo2(minutes);
    seconds = prepadTo2(seconds);
    return minutes + ":" + seconds;
  };
  millisecToDisplayable = function(millisec){
    var seconds, hours, minutes;
    seconds = Math.round(millisec / 1000);
    hours = Math.floor(seconds / 3600);
    seconds -= hours * 3600;
    minutes = Math.floor(seconds / 60);
    seconds -= minutes * 60;
    hours = prepadTo2(hours);
    minutes = prepadTo2(minutes);
    seconds = prepadTo2(seconds);
    return hours + ":" + minutes + ":" + seconds;
  };
  root.baseparams = null;
  root.haveShownDone = false;
  updateUrlBar = function(){
    var pdict, millisecsElapsed, elapsed;
    if (root.baseparams == null) {
      pdict = {
        user: root.username,
        half: root.halfnum,
        platform: root.platform,
        started: root.timeStarted
      };
      if (root.loggingDisabledGlobally) {
        pdict.nolog = true;
      }
      if (root.limitNumquestions) {
        pdict.numquestions = root.limitNumquestions;
      }
      root.baseparams = '?' + $.param(pdict);
    }
    millisecsElapsed = Date.now() - root.timeStarted;
    elapsed = millisecToDisplayable(millisecsElapsed);
    if (!root.haveShownDone && millisecsElapsed > 40 * 60 * 1000) {
      root.haveShownDone = true;
      window.alert('40 minutes study time is over!');
    }
    return history.replaceState({}, '', root.baseparams + '#elapsed=' + elapsed);
  };
  updateUrlHash = root.updateUrlHash = function(){
    var elapsed;
    elapsed = millisecToDisplayable(Date.now() - root.timeStarted);
    return window.location.hash = 'elapsed=' + elapsed;
  };
  updateUsername = function(){
    var ref$, pastUsernames, mostRecentUsername;
    root.username = (ref$ = getUrlParameters().user) != null
      ? ref$
      : getUrlParameters().username;
    pastUsernames = [];
    if ($.cookie('usernames')) {
      pastUsernames = JSON.parse($.cookie('usernames'));
    }
    if (pastUsernames.length > 0) {
      mostRecentUsername = pastUsernames[pastUsernames.length - 1].name;
      if (root.username == null) {
        root.username = mostRecentUsername;
      }
      if (mostRecentUsername !== root.username) {
        pastUsernames.push({
          name: root.username,
          time: Date.now()
        });
        return $.cookie('usernames', JSON.stringify(pastUsernames));
      }
    } else if (root.username != null) {
      pastUsernames.push({
        name: root.username,
        time: Date.now()
      });
      return $.cookie('usernames', JSON.stringify(pastUsernames));
    } else if (root.username == null) {
      root.username = randomString(14);
      pastUsernames.push({
        name: root.username,
        time: Date.now()
      });
      return $.cookie('usernames', JSON.stringify(pastUsernames));
    }
  };
  root.timeStarted = null;
  updateTimeStarted = function(){
    root.timeStarted = parseInt(getUrlParameters().started);
    if (root.timeStarted == null || !isFinite(root.timeStarted)) {
      return root.timeStarted = Date.now();
    }
  };
  root.coursename = null;
  root.halfnum = null;
  root.platform = 'quizcram';
  updateCourseName = root.updateCourseName = function(){
    var ref$;
    root.coursename = (ref$ = getUrlParameters().coursename) != null
      ? ref$
      : getUrlParameters().course;
    if (root.coursename == null) {
      root.coursename = 'neuro_1';
    }
    if (root.coursename === '1') {
      root.coursename = 'neuro_1';
    }
    if (root.coursename === '2') {
      return root.coursename = 'neuro_2';
    }
  };
  updateHalfNum = root.updateHalfNum = function(){
    var ref$;
    root.halfnum = (ref$ = getUrlParameters().halfnum) != null
      ? ref$
      : getUrlParameters().half;
    if (root.halfnum == null) {
      return root.halfnum = 1;
    } else {
      return root.halfnum = parseInt(root.halfnum);
    }
  };
  filterQuestionsByHalf = root.filterQuestionsByHalf = function(){
    var x;
    return root.questions = (function(){
      var i$, ref$, len$, results$ = [];
      for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
        x = ref$[i$];
        if (x.half === root.halfnum) {
          results$.push(x);
        }
      }
      return results$;
    }());
  };
  filterVideosByHalf = root.filterVideosByHalf = function(){
    var vidname, vidinfo;
    return root.video_info = (function(){
      var ref$, results$ = {};
      for (vidname in ref$ = root.video_info) {
        vidinfo = ref$[vidname];
if (vidinfo.half === root.halfnum) {
          results$[vidname] = vidinfo;
        }
      }
      return results$;
    }());
  };
  filterQuestions = root.filterQuestions = function(){
    var x;
    root.questions = (function(){
      var i$, ref$, len$, results$ = [];
      switch (root.coursename) {
      case 'neuro_1':
        for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
          x = ref$[i$];
          if (x.course === 1 || x.course === 'neuro_1') {
            results$.push(x);
          }
        }
        return results$;
        break;
      case 'neuro_2':
        for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
          x = ref$[i$];
          if (x.course === 2 || x.course === 'neuro_2') {
            results$.push(x);
          }
        }
        return results$;
        break;
      default:
        throw 'unknown course: ' + root.coursename;
      }
    }());
    return root.exam_questions = (function(){
      var i$, ref$, len$, results$ = [];
      switch (root.coursename) {
      case 'neuro_1':
        for (i$ = 0, len$ = (ref$ = root.exam_questions).length; i$ < len$; ++i$) {
          x = ref$[i$];
          if (x.course === 1 || x.course === 'neuro_1') {
            results$.push(x);
          }
        }
        return results$;
        break;
      case 'neuro_2':
        for (i$ = 0, len$ = (ref$ = root.exam_questions).length; i$ < len$; ++i$) {
          x = ref$[i$];
          if (x.course === 2 || x.course === 'neuro_2') {
            results$.push(x);
          }
        }
        return results$;
        break;
      default:
        throw 'unknown course: ' + root.coursename;
      }
    }());
  };
  filterVideos = root.filterVideos = function(){
    var vidname, vidinfo;
    return root.video_info = (function(){
      var ref$, results$ = {};
      for (vidname in ref$ = root.video_info) {
        vidinfo = ref$[vidname];
if (vidinfo.course === root.coursename) {
          results$[vidname] = vidinfo;
        }
      }
      return results$;
    }());
  };
  updateVideos = root.updateVideos = function(){
    var vidname, ref$, vidinfo, lresult$, i$, ref1$, len$, part, results$ = [];
    for (vidname in ref$ = root.video_info) {
      vidinfo = ref$[vidname];
      lresult$ = [];
      if (vidinfo.course == null) {
        if (vidname.indexOf('1-') === 0) {
          vidinfo.course = 'neuro_1';
        } else if (vidname.indexOf('2-') === 0) {
          vidinfo.course = 'neuro_2';
        }
      }
      if (vidinfo.srtfile == null) {
        vidinfo.srtfile = vidname + '.srt';
      }
      for (i$ = 0, len$ = (ref1$ = vidinfo.parts).length; i$ < len$; ++i$) {
        part = ref1$[i$];
        if (part.relstart == null) {
          part.relstart = part.start;
        }
        if (part.relend == null) {
          lresult$.push(part.relend = part.end);
        }
      }
      results$.push(lresult$);
    }
    return results$;
  };
  downloadAndParseSubtitle = root.downloadAndParseSubtitle = function(srtfile, callback){
    return $.get(srtfile, function(data){
      var subs;
      subs = parser.fromSrt(data);
      return callback(subs);
    });
  };
  downloadAndParseAllSubtitles = root.downloadAndParseAllSubtitles = function(){
    var tasks, i$;
    tasks = [];
    for (i$ in root.video_info) {
      (fn$.call(this, i$, root.video_info[i$]));
    }
    return async.series(tasks, function(){
      return consolelog('downloadAndParseAllSubtitles done!');
    });
    function fn$(vidname, vidinfo){
      tasks.push(function(callback){
        return downloadAndParseSubtitle(vidinfo.srtfile, function(subs){
          vidinfo.subtitle = subs;
          return callback(null);
        });
      });
    }
  };
  updateQuestions = root.updateQuestions = function(){
    var i$, ref$, len$, idx, question, results$ = [];
    for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
      idx = i$;
      question = ref$[i$];
      question.idx = idx;
      if (question.course === '1' || question.course === 1) {
        question.course = 'neuro_1';
      }
      if (question.course === '2' || question.course === 2) {
        question.course = 'neuro_2';
      }
      if (question.course !== 'neuro_1' && question.course !== 'neuro_2') {
        throw 'unknown course: ' + question.course;
      }
    }
    return results$;
  };
  updateExamQuestions = root.updateExamQuestions = function(){
    var i$, ref$, len$, idx, question, results$ = [];
    for (i$ = 0, len$ = (ref$ = root.exam_questions).length; i$ < len$; ++i$) {
      idx = i$;
      question = ref$[i$];
      question.idx = idx;
      question.exam = true;
      if (question.course === '1' || question.course === 1) {
        question.course = 'neuro_1';
      }
      if (question.course === '2' || question.course === 2) {
        question.course = 'neuro_2';
      }
      if (question.course !== 'neuro_1' && question.course !== 'neuro_2') {
        throw 'unknown course: ' + question.course;
      }
    }
    return results$;
  };
  root.limitNumquestions = null;
  updateOptions = function(){
    var params;
    params = getUrlParameters();
    if (params.nolog != null && params.nolog !== 'false') {
      root.loggingDisabledGlobally = true;
    }
    if (params.numquestions != null && isFinite(parseInt(params.numquestions))) {
      root.limitNumquestions = parseInt(params.numquestions);
    }
    if (params.platform != null) {
      return root.platform = params.platform;
    }
  };
  updateMasteryScoreDisplay = root.updateMasteryScoreDisplay = function(qidx){
    var scoredisplay, questionscore, videoprogress;
    scoredisplay = $('.questionscore_' + qidx);
    if (scoredisplay.length < 1) {
      return;
    }
    questionscore = getScoreForQuestion(qidx);
    videoprogress = getVideoScoreForQuestion(qidx);
    if (haveCorrectlyAnsweredQuestion(qidx)) {
      return scoredisplay.text(toPercent(questionscore) + '% correct, ' + toPercent(videoprogress) + '% seen');
    }
  };
  updateMasteryScoreDisplayProcess = function(){
    return setInterval(function(){
      var i$, ref$, len$, curqidx, results$ = [];
      for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
        curqidx = ref$[i$];
        results$.push(updateMasteryScoreDisplay(curqidx));
      }
      return results$;
      function fn$(){
        var i$, to$, results$ = [];
        for (i$ = 0, to$ = root.questions.length; i$ < to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }
    }, 1000);
  };
  updateUrlBarProcess = function(){
    return setInterval(function(){
      return updateUrlBar();
    }, 10000);
  };
  setKeyBindings = function(){
    return $(document).keydown(function(evt){
      var key;
      key = evt.which;
      if ($('.activevideo').length > 0) {
        switch (key) {
        case 27:
          pauseVideo();
          break;
        case 37:
          seekVideoByOffset(-5);
          break;
        case 39:
          seekVideoByOffset(5);
          break;
        case 8:
          pauseVideo();
          break;
        case 46:
          pauseVideo();
          break;
        case 187:
          increasePlaybackSpeed();
          break;
        case 61:
          increasePlaybackSpeed();
          break;
        case 221:
          increasePlaybackSpeed();
          break;
        case 219:
          decreasePlaybackSpeed();
          break;
        case 189:
          decreasePlaybackSpeed();
          break;
        case 173:
          decreasePlaybackSpeed();
          break;
        case 13:
          skipToEndOfSeenPortion($('.activevideo').data('qnum'));
          playVideo();
          break;
        case 32:
          playPauseVideo();
          break;
        default:
          consolelog(key);
          return true;
        }
        evt.preventDefault();
        return false;
      }
    });
  };
  quizCramInitialize = function(){
    updateMasteryScoreDisplayProcess();
    consolelog('ready');
    fixVideoHeightProcess();
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
    if (root.loggingDisabledGlobally) {
      return insertQuestion(getNextQuestion(), {
        immediate: true
      });
    } else {
      return getlog(function(logs){
        if (logs != null && logs.length > 0) {
          root.loggingDisabled = true;
          consolelog('replaying logs!');
          root.loggedData = logs;
          replayLogs(logs);
          root.loggingDisabled = false;
        }
        insertQuestion(getNextQuestion(), {
          immediate: true,
          qnum: counterCurrent('qnum'),
          qcycle: counterCurrent('qcycle')
        });
        return ensureLoggedToServer(root.loggedData, 'logged-data');
      });
    }
  };
  root.currentVideoQnum = -1;
  root.currentVideoVidname = null;
  root.currentVideoVidpart = null;
  courseraInitialize = function(){
    var idx, i$;
    console.log('coursera initialize');
    $('#quizstream').append([
      J('.leftbar').css({
        width: '30%',
        height: '100%',
        float: 'left'
      }), J('.rightbar').css({
        width: '70%',
        height: '100%',
        float: 'right'
      }), J('div').css({
        clear: 'both'
      })
    ]);
    idx = -1;
    for (i$ in root.video_info) {
      (fn$.call(this, i$, root.video_info[i$]));
    }
    $('#videoselector_0').click();
    if (!root.loggingDisabledGlobally) {
      return getlog(function(logs){
        if (logs != null && logs.length > 0) {
          root.loggedData = logs;
        }
        return ensureLoggedToServer(root.loggedData, 'logged-data');
      });
    }
    function fn$(vidname, vidinfo){
      var vidpart, videoSelector;
      consolelog(vidname);
      vidpart = vidinfo.parts.length - 1;
      idx += 1;
      videoSelector = J('#videoselector_' + idx).data('idx', idx).css({
        cursor: 'pointer',
        fontSize: '16px',
        marginBottom: '10px'
      }).mouseenter(function(evt){
        return $(this).css('text-decoration', 'underline');
      }).mouseleave(function(evt){
        return $(this).css('text-decoration', '');
      }).text(vidname.split('-').join('.') + ': ' + vidinfo.title).click(function(evt){
        var oldvidname, oldvidpart, oldqnum, newvideo;
        oldvidname = root.currentVideoVidname;
        oldvidpart = root.currentVideoVidpart;
        oldqnum = root.currentVideoQnum;
        $('.activevideoselect').removeClass('activevideoselect');
        $('#body_' + root.currentVideoQnum).remove();
        $('#outerbody_' + root.currentVideoQnum).remove();
        if (root.currentVideoVidname != null) {
          resetVideoBody(root.currentVideoVidname, root.currentVideoVidpart);
        }
        videoSelector.addClass('activevideoselect');
        root.currentVideoVidname = vidname;
        root.currentVideoVidpart = vidpart;
        consolelog(vidname);
        newvideo = insertVideo(vidname, vidpart, {
          nopart: true,
          quizzes: true,
          noprevvideo: true,
          noprogressdisplay: true,
          novideoskip: true
        });
        $('.rightbar').append(newvideo);
        root.currentVideoQnum = getVideo(vidname, vidpart).data('qnum');
        addlog({
          event: 'switchvideo',
          vidname: vidname,
          vidpart: vidpart,
          oldvidname: oldvidname,
          oldvidpart: oldvidpart,
          qnum: root.currentVideoQnum,
          oldqnum: oldqnum
        });
        return playVideo();
      });
      $('.leftbar').append(videoSelector);
    }
  };
  testExamInitialize = function(){
    var i$, ref$, len$, question, submitButton;
    for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
      question = ref$[i$];
      if (question.selfrate) {
        continue;
      }
      insertQuestion(question, {
        immediate: true,
        novideo: true,
        append: true,
        nobuttons: true,
        nocontainer: true
      });
    }
    submitButton = J('button.btn.btn-primary.btn-lg#submitquiz').html('<span class="glyphicon glyphicon-check"></span> Submit Quiz').click(function(evt){
      var numcorrect, numincorrect, idxcorrect, idxincorrect, partialscores, i$, ref$, len$, panel, qnum, qidx, question, answers, isCorrect, partialscore;
      console.log('submit quiz clicked');
      numcorrect = 0;
      numincorrect = 0;
      idxcorrect = [];
      idxincorrect = [];
      partialscores = [];
      for (i$ = 0, len$ = (ref$ = $('.panel-body-new')).length; i$ < len$; ++i$) {
        panel = ref$[i$];
        qnum = $(panel).data('qnum');
        qidx = getQidx(qnum);
        question = root.questions[qidx];
        answers = getAnswerValue(question.type, qnum);
        isCorrect = isAnswerCorrect(question, answers);
        if (isCorrect) {
          numcorrect += 1;
          idxcorrect.push(qidx);
        } else {
          numincorrect += 1;
          idxincorrect.push(qidx);
        }
        showIsCorrect(qnum, isCorrect);
        partialscore = getPartialScore(qnum);
        partialscores.push(partialscore);
        addlog({
          event: 'testexamcheck',
          correct: isCorrect,
          partialscore: partialscore,
          qidx: question.idx,
          answers: answers,
          qnum: qnum
        });
      }
      return addlog({
        event: 'submittestexam',
        numcorrect: numcorrect,
        numincorrect: numincorrect,
        idxcorrect: idxcorrect,
        idxincorrect: idxincorrect,
        partialscores: partialscores
      });
    });
    $('#quizstream').append(submitButton);
    if (!root.loggingDisabledGlobally) {
      return getlog(function(logs){
        if (logs != null && logs.length > 0) {
          root.loggedData = logs;
        }
        return ensureLoggedToServer(root.loggedData, 'logged-data');
      });
    }
  };
  testQuizInitialize = function(){
    var i$, ref$, len$, question, submitButton;
    for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
      question = ref$[i$];
      if (question.selfrate) {
        continue;
      }
      console.log(JSON.stringify(question));
      insertQuestion(question, {
        immediate: true,
        novideo: true,
        append: true,
        nobuttons: true,
        nocontainer: true
      });
    }
    submitButton = J('button.btn.btn-primary.btn-lg#submitquiz').html('<span class="glyphicon glyphicon-check"></span> Submit Quiz').click(function(evt){
      var numcorrect, numincorrect, idxcorrect, idxincorrect, partialscores, i$, ref$, len$, panel, qnum, qidx, question, answers, isCorrect, partialscore;
      console.log('submit quiz clicked');
      numcorrect = 0;
      numincorrect = 0;
      idxcorrect = [];
      idxincorrect = [];
      partialscores = [];
      for (i$ = 0, len$ = (ref$ = $('.panel-body-new')).length; i$ < len$; ++i$) {
        panel = ref$[i$];
        qnum = $(panel).data('qnum');
        qidx = getQidx(qnum);
        question = root.questions[qidx];
        answers = getAnswerValue(question.type, qnum);
        isCorrect = isAnswerCorrect(question, answers);
        if (isCorrect) {
          numcorrect += 1;
          idxcorrect.push(qidx);
        } else {
          numincorrect += 1;
          idxincorrect.push(qidx);
        }
        showIsCorrect(qnum, isCorrect);
        partialscore = getPartialScore(qnum);
        partialscores.push(partialscore);
        addlog({
          event: 'testquizcheck',
          correct: isCorrect,
          partialscore: partialscore,
          qidx: question.idx,
          answers: answers,
          qnum: qnum
        });
      }
      return addlog({
        event: 'submittestquiz',
        numcorrect: numcorrect,
        numincorrect: numincorrect,
        idxcorrect: idxcorrect,
        idxincorrect: idxincorrect,
        partialscores: partialscores
      });
    });
    $('#quizstream').append(submitButton);
    if (!root.loggingDisabledGlobally) {
      return getlog(function(logs){
        if (logs != null && logs.length > 0) {
          root.loggedData = logs;
        }
        return ensureLoggedToServer(root.loggedData, 'logged-data');
      });
    }
  };
  $(document).ready(function(){
    var res$, i$, ref$, len$, x;
    updateOptions();
    if (root.platform === 'quizcram') {
      root.questions = root.questions_extra;
      root.video_info = root.video_info_extra;
    }
    if (root.platform === 'invideo') {
      root.questions = root.questions_std;
      root.video_info = root.video_info_std;
    }
    updateUsername();
    updateTimeStarted();
    updateCourseName();
    updateHalfNum();
    updateVideos();
    filterVideos();
    filterVideosByHalf();
    downloadAndParseAllSubtitles();
    if (root.platform === 'quizcram') {
      createQuestionsForVideosWithoutQuizzes();
    }
    filterQuestions();
    filterQuestionsByHalf();
    if (root.platform === 'exam') {
      updateExamQuestions();
      root.questions = root.exam_questions;
    } else {
      updateQuestions();
    }
    if (root.limitNumquestions !== null) {
      root.questions = slice$.call(root.questions, 0, root.limitNumquestions);
    }
    res$ = [];
    for (i$ = 0, len$ = (ref$ = root.questions).length; i$ < len$; ++i$) {
      x = ref$[i$];
      res$.push(initializeQuestion());
    }
    root.question_progress = res$;
    updateUrlBarProcess();
    setKeyBindings();
    switch (root.platform) {
    case 'quizcram':
      return quizCramInitialize();
    case 'invideo':
      return courseraInitialize();
    case 'exam':
      return testExamInitialize();
    case 'quiz':
      return testQuizInitialize();
    default:
      throw 'unknown platform name: ' + root.platform;
    }
  });
  function repeatArray$(arr, n){
    for (var r = []; n > 0; (n >>= 1) && (arr = arr.concat(arr)))
      if (n & 1) r.push.apply(r, arr);
    return r;
  }
  function deepEq$(x, y, type){
    var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
        has = function (obj, key) { return hasOwnProperty.call(obj, key); };
    var first = true;
    return eq(x, y, []);
    function eq(a, b, stack) {
      var className, length, size, result, alength, blength, r, key, ref, sizeB;
      if (a == null || b == null) { return a === b; }
      if (a.__placeholder__ || b.__placeholder__) { return true; }
      if (a === b) { return a !== 0 || 1 / a == 1 / b; }
      className = toString.call(a);
      if (toString.call(b) != className) { return false; }
      switch (className) {
        case '[object String]': return a == String(b);
        case '[object Number]':
          return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
        case '[object Date]':
        case '[object Boolean]':
          return +a == +b;
        case '[object RegExp]':
          return a.source == b.source &&
                 a.global == b.global &&
                 a.multiline == b.multiline &&
                 a.ignoreCase == b.ignoreCase;
      }
      if (typeof a != 'object' || typeof b != 'object') { return false; }
      length = stack.length;
      while (length--) { if (stack[length] == a) { return true; } }
      stack.push(a);
      size = 0;
      result = true;
      if (className == '[object Array]') {
        alength = a.length;
        blength = b.length;
        if (first) { 
          switch (type) {
          case '===': result = alength === blength; break;
          case '<==': result = alength <= blength; break;
          case '<<=': result = alength < blength; break;
          }
          size = alength;
          first = false;
        } else {
          result = alength === blength;
          size = alength;
        }
        if (result) {
          while (size--) {
            if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
          }
        }
      } else {
        if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
          return false;
        }
        for (key in a) {
          if (has(a, key)) {
            size++;
            if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
          }
        }
        if (result) {
          sizeB = 0;
          for (key in b) {
            if (has(b, key)) { ++sizeB; }
          }
          if (first) {
            if (type === '<<=') {
              result = size < sizeB;
            } else if (type === '<==') {
              result = size <= sizeB
            } else {
              result = size === sizeB;
            }
          } else {
            first = false;
            result = size === sizeB;
          }
        }
      }
      stack.pop();
      return result;
    }
  }
}).call(this);
