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

        <cfquery name="getWellSamples"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT * FROM 
            (SELECT sampleDate, wellID, shortName, pfcLevel 
              FROM tbWellSample NATURAL JOIN tbChemical) 
            PIVOT 
            (MAX(pfcLevel) FOR shortName IN ('PFOA', 'PFOS', 'PFHxS', 'PFUA', 'PFOSA', 'PFNA', 'PFDeA', 'PFPeA', 'PFHxA', 'PFBA')) 
            WHERE wellId = 1 ORDER BY sampleDate DESC
        </cfquery>

        <cfoutput>

        <!-- Following code based on: http://stackoverflow.com/questions/33876129/displaying-results-from-pivot-query-in-coldfusion/33877746 -->

        <table class="table table-striped">
          <tr>
            <cfloop array="#getWellSamples.getcolumnlist()#" index="pfcName">
              <cfif #pfcName# neq "WELLID">
                <th>#pfcName#</th>
              </cfif>
            </cfloop>
          </tr>

          <cfloop query="getWellSamples">
          <tr>
            <cfloop array="#getWellSamples.getcolumnlist()#" index="pfcLevel">
              <cfif #pfcLevel# neq "WELLID">
                <td>#getWellSamples[pfcLevel][currentrow]#</td>
              </cfif>
            </cfloop>
          </tr>
          </cfloop>

        </table>
        </cfoutput>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>