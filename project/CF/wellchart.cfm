<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Well Chart</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/formValidation/formValidation.min.css" rel="stylesheet">
    <link href="css/bootstrap-datepicker3.min.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">
  </head>

  <body>
    
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

          <h3>Well Sample Data</h3>

          <cfquery name="getSamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID = 1
          </cfquery>

          <cfoutput>
            #SerializeJSON(getSamples,true)#
          </cfoutput>
          

      </div>
    </div><!-- /.container -->

    

    <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/formValidation/formValidation.min.js"></script>
    <script src="js/formValidation/bootstrap.min.js"></script>
    <script src="js/bootstrap-datepicker.min.js"></script>

  </body>
</html>