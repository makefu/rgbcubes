var canvas = document.getElementById("colorPicker");
// TODO trigger all the time, locking is implemented
// canvas.addEventListener("touchstart", doTouch);
canvas.addEventListener("click", doClick);

var context = canvas.getContext('2d');
var centerX = canvas.width / 2;
var centerY = canvas.height / 2;
var innerRadius = canvas.width / 5;
var outerRadius = (canvas.width - 10) / 2

context.beginPath();
context.arc(centerX, centerY, outerRadius, 0, 2 * Math.PI, false);
context.lineWidth = 4;
context.strokeStyle = '#000000';
context.stroke();
context.closePath();

for (var angle = 0; angle <= 360; angle += 1) {
    var startAngle = (angle - 2) * Math.PI / 180;
    var endAngle = angle * Math.PI / 180;
    context.beginPath();
    context.moveTo(centerX, centerY);
    context.arc(centerX, centerY, outerRadius, startAngle, endAngle, false);
    context.closePath();
    context.fillStyle = 'hsl(' + angle + ', 100%, 50%)';
    context.fill();
    context.closePath();
}

context.beginPath();
context.arc(centerX, centerY, innerRadius, 0, 2 * Math.PI, false);
context.fillStyle = 'white';
context.fill();

context.lineWidth = 2;
context.strokeStyle = '#000000';
context.stroke();
context.closePath();

function getMousePos(canvas, evt) {
    var rect = canvas.getBoundingClientRect();
    return {
        x: evt.clientX - rect.left,
        y: evt.clientY - rect.top
    };
}
function debug(text){
  //document.getElementById('status').innerHTML = "<br>" + text
}
var changeLock = false
function changeColor(color) {
    var colordata = {
        r: color[0],
        g: color[1],
        b: color[2]
    }
    if (changeLock) {
      // DEBUG:
      debug("DEBUG: led currently changing, please wait")
    } else {
      changeLock = true
      $.ajax({
          url: "/color",
          type: "GET",
          data: colordata,
          success: function (data) {
              changeLock = false
          }
      })
    }
}

function doTouch(event) {
    event.preventDefault();
    var pos = {
        x: Math.round(event.targetTouches[0].pageX - canvas.offsetLeft),
        y: Math.round(event.targetTouches[0].pageY - canvas.offsetTop)
    };
    var color = context.getImageData(pos.x, pos.y, 1, 1).data;
    debug("color: " + color + " - " + "<br>x: " + pos.x + " - y: " + pos.y + " - offset: " + canvas.offsetLeft + "/" + canvas.offsetTop);
    changeColor(color);
}

function doClick(event) {
    var pos = getMousePos(canvas, event);
    var color = context.getImageData(pos.x, pos.y, 1, 1).data;
    changeColor(color);
}

$(function () {
    $('#saveButton').click(function () {
        $.ajax({
            url: "/save",
            type: "GET"
        })
    })
    $('#restartButton').click(function () {
        $.ajax({
            url: "/restart",
            type: "GET"
        })
    })
    $('#onButton').click(function () {
        $.ajax({
            url: "/on",
            type: "GET"
        })
    })
    $('#offButton').click(function () {
        $.ajax({
            url: "/off",
            type: "GET"
        })
    })
    $('#normalModeButton').click(function () {
        $.ajax({
            url: "/mode",
            data: { "id": "single" },
            type: "GET"
        })
    })
    $('#fadeModeButton').click(function () {
        $.ajax({
            url: "/mode",
            data: { "id": "fade" },
            type: "GET"
        })
    })
    $('#partyModeButton').click(function () {
        $.ajax({
            url: "/mode",
            data: { "id": "party" },
            type: "GET"
        })
    })
	$("#brightness").slider();
	$("#brightness").on("change", function(slideEvt) {
		value = slideEvt.value.newValue
		if (changeLock) {
			// DEBUG:
			debug("already changing brightness" + value)
		} else {
			changeLock = true
			$.ajax({
				url: "/brightness",
				data: { "brightness": value },
				type: "GET",
				success: function (data) {
					debug("brightness changed to" + value)
					changeLock = false
				}
			})
		}
	});

})
function updateColor(event) {
  //touch position
  var pos = {
    x: Math.round(event.targetTouches[0].pageX-canvas.offsetLeft),
    y: Math.round(event.targetTouches[0].pageY-canvas.offsetTop)
  };
  //color
  var color = context.getImageData(pos.x, pos.y, 1, 1).data;
  debug ("changing to"+ color)
  changeColor(color);
}

$("#colorPicker").swipe( {
  //Generic swipe handler for all directions
  swipeStatus:function(event, phase, direction, distance, fingerCount) {
    var str = "";
    switch (phase) {
      case "move" : updateColor(event); break;
    }
  },
  threshold:10
});
