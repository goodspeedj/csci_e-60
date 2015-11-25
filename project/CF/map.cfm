<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Map</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">

    <style type="text/css">
      html, body { height: 100%; margin: 0; padding: 0; }
      #map { height: 100%; }
      #legend {
        background: white;
        padding: 5px;
        border-radius: 3px;
        border:2px solid #fff;
        box-shadow: 0 2px 6px rgba(0,0,0,.3);
        color: rgb(25,25,25);
        font-family: Roboto,Arial,sans-serif;
        font-size: 12px;
        padding-right: 5px;
      }
    </style>
  </head>
  <body>
    <div class="container" style="height:100%; width:100%;">
      <div class="starter-template" style="height:100%; width:100%;">
        <cfinclude template = "navbar.cfm">

        <cfquery name="getWells"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT wellID, wellTypeID, wellName, wellLat, wellLong, wellYeild, wellActive
            FROM tbWell
            NATURAL JOIN tbWellType
            WHERE wellType = 'Well'
            ORDER BY wellID
        </cfquery>

        <!-- Store some data to use in the map javascript -->
        <cfset wellLat = ListToArray(ValueList(getWells.wellLat)) />
        <cfset wellLong = ListToArray(ValueList(getWells.wellLong)) />
        <cfset wellYeild = ListToArray(ValueList(getWells.wellYeild)) />
        <div id="map"></div>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script type="text/javascript">

      // pull in data dynamically from the database
      <cfoutput>
        var #toScript(wellLat[1], "havenWellLat")#;
        var #toScript(wellLong[1], "havenWellLong")#;
        var #toScript(wellLat[2], "smithWellLat")#;
        var #toScript(wellLong[2], "smithWellLong")#;
        var #toScript(wellLat[3], "harrisonWellLat")#;
        var #toScript(wellLong[3], "harrisonWellLong")#;
        var #toScript(wellYeild[1], "havenWellYeild")#;
        var #toScript(wellYeild[2], "smithWellYeild")#;
        var #toScript(wellYeild[3], "harrisonWellYeild")#;
      </cfoutput>

      var map;
      var styles = [
        {
          stylers: [
            { saturation: -60 }
          ]
        },{
          featureType: "road",
          elementType: "geometry",
          stylers: [
            { lightness: 0 },
            { visibility: "simplified" }
          ]
        }
      ];
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: 43.069537, lng: -70.803328},
          zoom: 14
        });

        map.setOptions({ styles: styles });

        var haven = new google.maps.Marker({
          position: {lat: Number(havenWellLat), lng: Number(havenWellLong)},
          map: map,
          label: 'W',
          icon: getMarker(havenWellYeild, 'red'),
          title: 'Haven Well'
        });

        var smith = new google.maps.Marker({
          position: {lat: Number(smithWellLat), lng: Number(smithWellLong)},
          map: map,
          label: 'W',
          icon: getMarker(smithWellYeild, 'green'),
          title: 'Smith Well'
        });

        var harrison = new google.maps.Marker({
          position: {lat: Number(harrisonWellLat), lng: Number(harrisonWellLong)},
          map: map,
          label: 'W',
          icon: getMarker(harrisonWellYeild, 'green'),
          title: 'Harrison Well'
        });

        function getMarker(size, color) {
          var circle = {
            path: google.maps.SymbolPath.CIRCLE,
            fillColor: color,
            fillOpacity: .4,
            scale: size / 20,
            strokeColor: 'white',
            strokeWeight: .5
          };
          return circle;
        }

        map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
          document.getElementById('legend'));

        var legend = document.createElement('div');
        legend.id = 'legend';
        var content = [];
        content.push('<h4>Legend</h4>');
        content.push('<p>Well Shutdown<div class="circle red"></div></p>');
        content.push('<p><div class="circle green"></div>Well Operational</p>');;
        legend.innerHTML = content.join('');
        legend.index = 1;
        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(legend);
      }

    </script>

    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCPQ8HbMqX86au-RHRw5pUQF2sq28v7d2g&callback=initMap">
    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

  </body>
</html>