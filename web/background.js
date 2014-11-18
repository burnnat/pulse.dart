/**
 *
 */
chrome.app.runtime.onLaunched.addListener(function(launchData) {
  var openWindow = function(id) {
    chrome.app.window.create(
      'index.html',
      {
        id: id,
        bounds: {
          width: 800,
          height: 600
        }
      },
      function(createdWindow) {
        createdWindow.contentWindow.id = id;
      }
    );
  };

  openWindow('main');
  openWindow('test');
});
