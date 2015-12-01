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

    <!-- Specific Google Map styles -->
    <style type="text/css">
      html, body { 
        height: 90%; 
        margin: 0; 
        padding: 0; 
      }
    </style>
  </head>
  <body>
    <div class="container" style="height:100%; width:100%;">
      <cfinclude template = "navbar.cfm">
      <!-- <div class="starter-template" style="height:100%; width:100%;"> -->
      <div class="row">
        <div class="col-md-4">
          <h4 class="center">Pease International Tradeport</h4>
          <h5 class="center">Portsmouth, NH</h5>
          <p>This map shows the locations of the wells on the Pease Tradeport as well as
             the people who were exposed (and tested) to the contaminated water.</p>
          <p>The active wells are shown with a blue circle and the inactive well, Haven, 
             is shown with a red circle.  The size of the circle represents the well's
             yeild in millions of gallons from 2002 to 2008.</p>
          <p>The orage circles represent the people that were exposed to the PFCs from the
             Pease wells.  The location of the circle represents where they were exposed 
             and the size of the circle represents the levels of PFCs in their blood - 
             the larger the circle the higher the levels of PFCs present.</p>
        </div>
        <div class="col-md-8">
      
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

          <cfquery name="getPeopleLocations"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT nhHHSID, address, pfcLevel, shortName
              FROM tbPerson
              NATURAL JOIN tbPersonPFCLevel
              NATURAL JOIN tbChemical
              NATURAL JOIN tbAddress
              WHERE shortName = 'PFOS'
          </cfquery>

          <!-- Store some data to use in the map javascript -->
          <cfset wellLat = ListToArray(ValueList(getWells.wellLat)) />
          <cfset wellLong = ListToArray(ValueList(getWells.wellLong)) />
          <cfset wellYeild = ListToArray(ValueList(getWells.wellYeild)) />

          <div id="map"></div>

        </div>

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
            { saturation: -80 }
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

        <cfoutput query="getPeopleLocations">
          var #toScript(address, "address")#;

          var geocoder = new google.maps.Geocoder();

          geocoder.geocode( { 'address': address}, function(results, status) {

            var #toScript(pfcLevel, "pfcLevel")#;
            var #toScript(shortName, "shortName")#;

            if (status == google.maps.GeocoderStatus.OK) {
              // Introduce some variability into the lat & long to avoid bullseye effect
              var jitter = Math.random() / 1000;

              var latitude;
              var longitude;

              if (jitter % 2 === 0) {
                latitude = results[0].geometry.location.lat() + jitter;
                longitude = results[0].geometry.location.lng() - jitter;
              }
              else {
                latitude = results[0].geometry.location.lat() - jitter;
                longitude = results[0].geometry.location.lng() + jitter;  
              }
              

              

              var loc = new google.maps.Marker({
                position: {lat: latitude, lng: longitude},
                map: map,
                icon: getMarker(pfcLevel, 'orange'),
                title: shortName + ": " + pfcLevel
              });

            } 
          }); 
        </cfoutput>

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
          icon: getMarker(smithWellYeild, 'blue'),
          title: 'Smith Well'
        });

        var harrison = new google.maps.Marker({
          position: {lat: Number(harrisonWellLat), lng: Number(harrisonWellLong)},
          map: map,
          label: 'W',
          icon: getMarker(harrisonWellYeild, 'blue'),
          title: 'Harrison Well'
        });

        function getMarker(size, color) {
          var diameter;

          // Is the size for a well yield or a person exposed?
          if (size < 50) {
            diameter = size; 
          }
          else {
            diameter = size / 20;
          }

          var circle = {
            path: google.maps.SymbolPath.CIRCLE,
            fillColor: color,
            fillOpacity: .4,
            scale: diameter,
            strokeColor: 'white',
            strokeWeight: .5
          };
          return circle;
        }

        // Allows map to re-size when not 100% height and width
        $(window).resize(function () {
          var h = $(window).height(),
            offsetTop = 120;

          $('#map').css('height', (h - offsetTop));
        }).resize();



        map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
          document.getElementById('legend'));

        var legend = document.createElement('div');
        legend.id = 'legend';
        var content = [];
        content.push('<h4>Legend</h4>');
        content.push('<p>Well Shutdown<div class="circle red"></div></p>');
        content.push('<p><div class="circle blue"></div>Well Operational</p>');;
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