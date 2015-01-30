(function(){
  var root, getUrlParameters, getPlatformForUnitNum, makeUrl, setPostStudyUrl, setPreStudyUrl, isFirefox, hideQuizzes, show1AfterTimeout, show2AfterTimeout, show1, show2, updateUrlBar, updateUsername, updateCondition, gotoTarget;
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
      course: 'neuro_' + (unitnum + 1),
      platform: getPlatformForUnitNum(unitnum)
    };
    return 'http://10.172.99.36:8080/?' + $.param(params);
  };
  root.studyTimeForUnit = 90 * 60 * 1000;
  setPostStudyUrl = function(unitnum){
    var platform, whichhalf, url;
    platform = getPlatformForUnitNum(unitnum);
    whichhalf = (function(){
      switch (unitnum) {
      case 0:
        return 'First+half';
      case 1:
        return 'Second+half';
      }
    }());
    url = 'https://docs.google.com/forms/d/1AcYedar8ZEmJ0UjGCCJ43pFvLSNsujgzdj0dIUMnXKk/viewform?entry.1110594938=' + whichhalf + '&entry.1656808541=' + platform;
    $('#poststudy' + unitnum).text('Post-Study Survey ' + (unitnum + 1));
    return $('#poststudy' + unitnum).attr('href', url);
  };
  setPreStudyUrl = function(){
    var url;
    url = 'https://docs.google.com/forms/d/1kvJiqjf4J2bm9b4_ZFjUViMP74tAXL8OpIJTy24Uv64/viewform?entry.142775808=' + root.username;
    $('#prestudy').text('Pre-Study Questionnaire');
    return $('#prestudy').attr('href', url);
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
    root.condition = parseInt(getUrlParameters().condition);
    if (root.condition != null && isFinite(root.condition) && [0, 1].indexOf(root.condition) !== -1) {
      return $.cookie('condition', root.condition);
    } else if ($.cookie('condition') != null) {
      return root.condition = parseInt($.cookie('condition'));
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
  $(document).ready(function(){
    var params, i$, ref$, len$, unitnum, url, platform, results$ = [];
    hideQuizzes();
    console.log('ready!');
    params = getUrlParameters();
    updateUsername();
    updateCondition();
    setPreStudyUrl();
    if (!isFirefox()) {
      $('body').html('Please view this page using <a href="http://www.mozilla.org/en-US/firefox">Firefox</a>');
      return;
    }
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
      $('#url' + unitnum).text(url).attr('href', url);
      results$.push($('#cond' + unitnum).text(platform));
    }
    return results$;
  });
}).call(this);
