var canvas = document.getElementById("colorPicker");
canvas.addEventListener("touchstart", doTouch);
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

function changeColor(color) {
    var colordata = {
        r: color[0],
        g: color[1],
        b: color[2]
    }

    $.ajax({
        url: "/color",
        type: "GET",
        data: colordata,
        success: function (data) {}
    })
}

function doTouch(event) {
    event.preventDefault();
    var pos = {
        x: Math.round(event.targetTouches[0].pageX - canvas.offsetLeft),
        y: Math.round(event.targetTouches[0].pageY - canvas.offsetTop)
    };
    var color = context.getImageData(pos.x, pos.y, 1, 1).data;
    document.getElementById('status').innerHTML = "<br>color: " + color + " - " + "<br>x: " + pos.x + " - y: " + pos.y + " - offset: " + canvas.offsetLeft + "/" + canvas.offsetTop;
    changeColor(color);
}

function doClick(event) {
    var pos = getMousePos(canvas, event);
    var color = context.getImageData(pos.x, pos.y, 1, 1).data;
    changeColor(color);
}

$(function () {
    $('#windButton').click(function () {
        $.ajax({
            url: "/windrad",
            type: "GET"
        })
    })
    $('#openDoorButton').click(function () {
        $.ajax({
            url: "/door/open",
            type: "GET"
        })
    })
    $('#closeDoorButton').click(function () {
        $.ajax({
            url: "/door/close",
            type: "GET"
        })
    })
})
