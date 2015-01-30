(function(){
  var root, toSeconds;
  root = typeof exports != 'undefined' && exports !== null ? exports : this;
  toSeconds = root.toSeconds = function(time){
    var timeParts, res$, i$, ref$, len$, x;
    if (time == null) {
      return null;
    }
    if (typeof time === 'number') {
      return time;
    }
    if (typeof time === 'string') {
      if (time.lastIndexOf(',') !== -1) {
        time = time.split(',').join('.');
      }
      res$ = [];
      for (i$ = 0, len$ = (ref$ = time.split(':')).length; i$ < len$; ++i$) {
        x = ref$[i$];
        res$.push(parseFloat(x));
      }
      timeParts = res$;
      if (timeParts.length === 0) {
        return null;
      }
      if (timeParts.length === 1) {
        return timeParts[0];
      }
      if (timeParts.length === 2) {
        return timeParts[0] * 60 + timeParts[1];
      }
      if (timeParts.length === 3) {
        return timeParts[0] * 3600 + timeParts[1] * 60 + timeParts[2];
      }
    }
    return null;
  };
}).call(this);
