//= require jquery

var // The iFrame
    showFrame = document.getElementById("frame"),
    xdm = window.easyXDM.noConflict("FACTLINK"),
    // The global remote object
    remote = new xdm.Rpc({}, {
      remote: {
        hide: {},
        show: {},
        highlightNewFactlink: {},
        stopHighlightingFactlink: {}
      },
      local: {
        showFactlink: function(id, successFn) {
          var successCalled  = 0;
          var onLoadSuccess = function(){
            console.info('modal opened callback ('+successCalled+')', new Date().getTime());
            if (! successCalled ){
              successCalled++;
              successFn();
            }

          }
          showFrame.onload = onLoadSuccess;

          // Somehow only lower case letters seem to work for those events --mark
          $(document).bind("modalready", onLoadSuccess);

          showFrame.src = "/facts/" + id;

          // Show the overlay
          showFrame.className = "overlay";
        },

        createFactlink: function(text, successFn) {
          var successCalled  = 0;
          var onLoadSuccess = function(){
            console.info('modal opened callback ('+successCalled+')', new Date().getTime());
            if (! successCalled ){
              successCalled++;
              successFn();
            }

          }
          showFrame.onload = onLoadSuccess;

          // Somehow only lower case letters seem to work for those events --mark
          $(document).bind("modalready", onLoadSuccess);

          showFrame.src = "/facts/new?fact=" + text;

          // Show the overlay
          showFrame.className = "overlay";
        },

        position: function(top, left) {
          try {
            showFrame.contentWindow.position(top, left);
          } catch (e) { // Window not yet loaded
            showFrame.onload = function() {
              showFrame.contentWindow.position(top, left);
            };
          }
        },
        // easyXDM does not support passing functions wrapped in objects (such as options in this case)
        // so therefore we need this workaround
        ajax: function(path, options, successFn, errorFn) {
          ajax(path, $.extend({
            success: successFn,
            error: errorFn
          },options));
        }
      }
    });

function ajax(path, options) {
  $.ajax(path, $.extend({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  }, options));
}
