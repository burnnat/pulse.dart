(function() {
  var chrome = window.chrome;

  if (!chrome) {
    chrome = window.chrome = {};
  }
  else if (chrome.runtime) {
    return;
  }

  var globals = {};

  var wrap = function(name) {
    globals[name] = function() {
      window[name].apply(window, arguments);
    };
  };

  wrap('addEventListener');
  wrap('removeEventListener');
  wrap('dispatchEvent');

  chrome.runtime = {
    getBackgroundPage: function(callback) {
      callback(globals);
    }
  };

  chrome.storage = {
    local: {
      get: function(keys, callback) {
        var values = {};
        var storeValue = function(key) {
          values[key] = localStorage.getItem(key);
        };

        if (typeof keys === 'string' || keys instanceof String) {
          storeValue(keys);
        }
        else if (Array.isArray(keys)) {
          keys.forEach(storeValue);
        }
        else if (keys == null) {
          for (var i = 0; i < localStorage.length; i++) {
            storeValue(localStorage.key(i));
          }
        }

        callback(values);
      },

      getBytesInUse: function(keys, callback) {
        this.get(keys, function(values) {
          callback(JSON.stringify(values).length);
        });
      },

      set: function(items, callback) {
        for (var key in items) {
          if (items.hasOwnProperty(key)) {
            localStorage.setItem(key, items[key]);
          }
        }

        callback();
      },

      remove: function(keys, callback) {
        var removeValue = function(key) {
          localStorage.removeItem(key);
        };

        if (typeof keys === 'string' || keys instanceof String) {
          removeValue(keys);
        }
        else if (Array.isArray(keys)) {
          keys.forEach(removeValue);
        }

        callback();
      },

      clear: function(callback) {
        localStorage.clear();
        callback();
      }
    }
  };
})();