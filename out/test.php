<html lang="en" class="js canvas canvastext webgl">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Haxe Application</title>
	<script src="https://dinox.io/js/jquery-3.5.1.min.js"></script>
</head>
<body style="margin: 0;padding: 0;background: #141414;">
<div class="header" style="width: 100%;height: 64px;background: black; display: flex; justify-content: space-between;"><div class="header-logo"><img src="./images/logo.png" /></div><div class="header-topright"><img src="./images/topright.png" /></div></div>
<div class="content" style="display: flex;width: 100%;position: absolute;left: 0;top: 64px;height: calc(100% - 64px);">
    <div class="menuleft" style="width: 96px;background: black;height: 100%;"><img src="./images/menu.png" />
    </div>
    <div class="contentright" style="width: calc(100% - 96px); padding: 2rem;">
        <h2 style="margin: 0; letter-spacing:5px; line-height:3.5rem; font-size:3rem; font-family: Tahoma; color: #ffffff; margin-bottom: 2rem;">WORLD MAP</h2>
        <canvas tabindex="0" id="canvas" height="650" style="outline: none; width: 100%; max-width: 1200px; min-width:640px; height: 650px; cursor: auto;"></canvas>

        <script crossorigin="anonymous" type="text/javascript" src="js/test.js"></script>
        <script>
           $(document).ready(function(){
            var mapw = $('#canvas').width();
            if (mapw > 1200) {
                mapw = 1200;
            }
            if (mapw < 640) {
                mapw = 640;
            }
            $('#canvas').attr("width", mapw);
            window.resizeMap(mapw,650);

            window.setUsersTickets([59,61,61,62,63]);
            window.setMyLands([5,6,1447,5410,2234]);
        });
        $(window).resize(function(){
            var mapw = $('#canvas').width();
            if (mapw > 1200) {
                mapw = 1200;
            }
            if (mapw < 640) {
                mapw = 640;
            }
            $('#canvas').attr("width", mapw);
            window.resizeMap(mapw,650);
        });
        </script>
        
    </div>
</div>

</body>
</html>
