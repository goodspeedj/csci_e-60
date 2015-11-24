<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Map</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">

    <style type="text/css">
      html, body { height: 100%; margin: 0; padding: 0; }
      #map { height: 100%; }
    </style>
  </head>
  <body>
    <div class="container" style="height:100%; width:100%;">
      <div class="starter-template" style="height:100%; width:100%;">
        <cfinclude template = "navbar.cfm">
        <div id="map"></div>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script type="text/javascript">

      var map;
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: 43.076018, lng: -70.818631},
          zoom: 14
        });

        var haven = new google.maps.Marker({
          position: {lat: 43.076018, lng: -70.818631},
          map: map,
          label: 'W',
          title: 'Haven Well'
        });

        var smith = new google.maps.Marker({
          position: {lat: 43.061068, lng: -70.804976},
          map: map,
          label: 'W',
          title: 'Smith Well'
        });

        var harrison = new google.maps.Marker({
          position: {lat: 43.065879, lng: -70.804495},
          map: map,
          label: 'W',
          title: 'Harrison Well'
        });

        var wwtp = new google.maps.Marker({
          position: {lat: 43.083631, lng: -70.795990},
          map: map,
          label: 'D',
          title: 'WWTP Distribution'
        });

        var des = new google.maps.Marker({
          position: {lat: 43.074757, lng: -70.802534},
          map: map,
          label: 'D',
          title: 'DES Office Distribution'
        });


      }

    </script>

    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCPQ8HbMqX86au-RHRw5pUQF2sq28v7d2g&callback=initMap">
    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

  </body>
</html>