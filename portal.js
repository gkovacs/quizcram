(function(){
  var root, getUrlParameters, getPlatformForUnitNum, makeUrl, setPostStudyUrl, setPreStudyUrl, getlog, isFirefox, hideQuizzes, show1AfterTimeout, show2AfterTimeout, show1, show2, updateUrlBar, updateUsername, updateCondition, gotoTarget, toUserName, submitname, showquiz;
  root = typeof exports != 'undefined' && exports !== null ? exports : this;
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
  getPlatformForUnitNum = function(unitnum){
    switch (root.condition) {
    case 0:
      if (unitnum === 0) {
        return 'invideo';
      } else {
        return 'quizcram';
      }
      break;
    case 1:
      if (unitnum === 0) {
        return 'quizcram';
      } else {
        return 'invideo';
      }
    }
  };
  makeUrl = function(unitnum){
    var params;
    params = {
      user: root.username,
      half: unitnum + 1,
      platform: getPlatformForUnitNum(unitnum)
    };
    return '/?' + $.param(params);
  };
  root.studyTimeForUnit = 90 * 60 * 1000;
  setPostStudyUrl = function(unitnum){
    var platform, url;
    platform = getPlatformForUnitNum(unitnum);
    url = (function(){
      switch (unitnum) {
      case 0:
        return 'https://docs.google.com/forms/d/1f3fHYPzUofCFrkEdIt0L4PuV7O4JtvkA26Q1nPUH4TU/viewform?entry.1047354409=' + root.username + '&entry.1656808541=' + platform;
      case 1:
        return 'https://docs.google.com/forms/d/1yKeFXh-Bqv7-nMA0Cdpfo6GUv9YLmjJ7EIWbalsCmsY/viewform?entry.1047354409=' + root.username + '&entry.1656808541=' + platform;
      }
    }());
    $('#poststudy' + unitnum).text('Post-Viewing Survey for part ' + (unitnum + 1));
    return $('#poststudy' + unitnum).attr('href', url);
  };
  setPreStudyUrl = function(){
    var url;
    url = 'https://docs.google.com/forms/d/1UIvXiC1kgci59J9lsWrTjDRthqysA6KoYLVklx2JZTs/viewform?entry.142775808=' + root.username;
    $('#prestudy').text('Pre-Study Questionnaire');
    return $('#prestudy').attr('href', url);
  };
  getlog = root.getlog = function(callback){
    return $.getJSON('/viewlog?' + $.param({
      username: root.username
    }), function(logs){
      return callback(logs);
    });
  };
  isFirefox = function(){
    return navigator.userAgent.search('Firefox') !== -1;
  };
  hideQuizzes = root.hideQuizzes = function(){
    $('#quiz0').hide();
    return $('#quiz1').hide();
  };
  show1AfterTimeout = root.show1AfterTimeout = function(){
    return setTimeout(show1, root.studyTimeForUnit);
  };
  show2AfterTimeout = root.show2AfterTimeout = function(){
    return setTimeout(show2, root.studyTimeForUnit);
  };
  show1 = root.show1 = function(){
    return $('#quiz0').show();
  };
  show2 = root.show2 = function(){
    return $('#quiz1').show();
  };
  updateUrlBar = function(){
    var params;
    params = {
      user: root.username,
      condition: root.condition
    };
    return history.replaceState({}, '', '?' + $.param(params));
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
      return root.username = null;
    }
  };
  updateCondition = function(){
    var x;
    root.condition = parseInt(getUrlParameters().condition);
    if (root.condition == null || !isFinite(root.condition)) {
      return root.condition = require('prelude-ls').sum((function(){
        var i$, ref$, len$, results$ = [];
        for (i$ = 0, len$ = (ref$ = root.username).length; i$ < len$; ++i$) {
          x = ref$[i$];
          results$.push(x.charCodeAt(0));
        }
        return results$;
      }())) % 2;
    }
  };
  gotoTarget = function(){
    var url, platform, whichhalf;
    url = (function(){
      switch (getUrlParameters().target) {
      case 'poststudy1':
        platform = getPlatformForUnitNum(0);
        whichhalf = 'First+half';
        return 'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform;
      case 'poststudy2':
        platform = getPlatformForUnitNum(1);
        whichhalf = 'Second+half';
        return 'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform;
      case 'quiz1':
        return "https://docs.google.com/forms/d/1gOLtZuVO5HIuIgKAaYJMg91DyRKkZFbXgF8XFgtzibk/viewform";
      case 'exam1':
        return "https://docs.google.com/forms/d/1wToigTH9pglQApRf0g-t02134rRv9gvBJEaJfG31gsg/viewform";
      case 'quiz2':
        return "https://docs.google.com/forms/d/1h-CcxVTnXGNcZ5mYKLdcygYi92lNbJJEu9Uua6SsH2I/viewform";
      case 'exam2':
        return "https://docs.google.com/forms/d/1N78vFuHeoyBlwFdJfgk2PY9ATwnqRpe02_PZNusc32Y/viewform";
      }
    }());
    return window.location.href = url;
  };
  toUserName = function(fullname){
    var output, allowedletters, i$, len$, c;
    output = [];
    allowedletters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"].concat(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);
    for (i$ = 0, len$ = fullname.length; i$ < len$; ++i$) {
      c = fullname[i$];
      c = c.toLowerCase();
      if (allowedletters.indexOf(c) !== -1) {
        output.push(c);
      }
    }
    return output.join('');
  };
  submitname = root.submitname = function(){
    var fullname, username, params;
    fullname = $('#nameinput').val();
    username = toUserName(fullname);
    params = getUrlParameters();
    params.user = username;
    return window.location = window.location.pathname + '?' + $.param(params);
  };
  showquiz = root.showquiz = function(){
    $('#quizlater').hide();
    $('#quizsection').show();
    $('#q00').attr('href', 'https://docs.google.com/forms/d/13jOTdfcGtcxdaCXp4SQSe3yW3MwFISQhowX8a3uKgHI/viewform?entry.1982045070=' + root.username);
    $('#q01').attr('href', 'https://docs.google.com/forms/d/1zpkzXj9TF0hmGVNaQgc3gqUnRQJhjyJhm0D2FsFaeW0/viewform?entry.56085394=' + root.username);
    $('#q10').attr('href', 'https://docs.google.com/forms/d/1mNZWkc-VGk0XjPKvH5be74NC1XyQlM2VxjKFYq1G7ic/viewform?entry.565234045=' + root.username);
    $('#q11').attr('href', 'https://docs.google.com/forms/d/1F5DeOZYtN2w0O-mGi1nyU_s47ccgk5RcZWDd3nupQko/viewform?entry.565234045=' + root.username);
    $('#q20').attr('href', 'https://docs.google.com/forms/d/1YxjqtoBldX1tH6fZlMNrtQwYzVb0sgRlb88GJM1TV0I/viewform?entry.894447393=' + root.username);
    $('#q21').attr('href', 'https://docs.google.com/forms/d/1y4swiqx33sPFxjJ6Awnted-dJoAH2_oAqb-MtNme0NA/viewform?entry.894447393=' + root.username);
    $('#q30').attr('href', 'https://docs.google.com/forms/d/1UANjvn-9pmDNPYYlvJcy1Id_ZbHUINrBq_AHktOC4Vc/viewform?entry.1893730634=' + root.username);
    return $('#q31').attr('href', 'https://docs.google.com/forms/d/1c8g43cDWAMlcfpM4eIlGrL1bHgIjj1cfu-9LYh1LaV8/viewform?entry.1827769055=' + root.username);
  };
  $(document).ready(function(){
    var params, i$, ref$, len$, unitnum, url, platform;
    $('#nameinput').keydown(function(evt){
      if (evt.keyCode === 13) {
        return submitname();
      }
    });
    console.log('ready!');
    params = getUrlParameters();
    if (!isFirefox()) {
      $('#studycontents').html('<b>Please open this page using <a href="http://www.mozilla.org/en-US/firefox">Firefox</a> to do the study, it does not work on other browsers at the moment.</b>');
      return;
    }
    updateUsername();
    if (root.username == null) {
      $('#entername').show();
      $('#studycontents').hide();
      return;
    }
    updateCondition();
    setPreStudyUrl();
    if (root.username == null) {
      $('body').text('need user param');
      return;
    }
    if ([0, 1].indexOf(root.condition) === -1) {
      $('body').text('need condition param, either 0 or 1');
      return;
    }
    if (params.target != null) {
      gotoTarget();
      return;
    }
    updateUrlBar();
    for (i$ = 0, len$ = (ref$ = [0, 1]).length; i$ < len$; ++i$) {
      unitnum = ref$[i$];
      url = makeUrl(unitnum);
      platform = getPlatformForUnitNum(unitnum);
      setPostStudyUrl(unitnum);
      $('#url' + unitnum).attr('href', url);
      $('#cond' + unitnum).text(platform);
    }
    return getlog(function(logs){
      var starttime, day2time, currenttime, hoursleft;
      if (logs == null || logs.length < 1) {
        return;
      }
      starttime = logs[0].time;
      day2time = starttime + 1000 * 60 * 60 * 24;
      currenttime = Date.now();
      if (day2time > currenttime) {
        hoursleft = (day2time - currenttime) / (1000 * 60 * 60);
        return $('#quiztimedetails').text('Please wait ' + hoursleft.toFixed(2) + ' hours, then revisit this page to do the quizzes');
      } else {
        return showquiz();
      }
    });
  });
}).call(this);
