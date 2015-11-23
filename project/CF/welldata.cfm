<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Well Data</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <h3>Well Data</h3>

        <cfquery name="getComponent"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT * FROM 
            (SELECT sampleDate, wellID, shortName, pfcLevel 
              FROM tbWellSample NATURAL JOIN tbChemical) 
            PIVOT 
            (MAX(pfcLevel) FOR shortName IN ('PFOA', 'PFOS', 'PFHxS', 'PFUA', 'PFOSA', 'PFNA', 'PFDeA', 'PFPeA', 'PFHxA', 'PFBA')) 
            WHERE wellId = 2 ORDER BY sampleDate
        </cfquery>

        <table class="table table-striped">
          <tr>
            <th>Date</th>
            <th>Level</th>
          </tr>

        <cfoutput query="getComponent">
          <tr>
            <td>#sampleDate#</td>
            <td>#pfcLevel#</td>
          </tr>
        </cfoutput>

        </table>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>