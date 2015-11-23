<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Individual Data</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <cfquery name="getPersonRecord"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT nhHHSID, age, shortName, longname, pfcLevel
            FROM tbPerson
            NATURAL JOIN tbPersonPFCLevel
            NATURAL JOIN tbChemical
            WHERE nhHHSID = 'PT0576'
        </cfquery>

        <h3>Individual Data</h3>
        <cfoutput>
          <h5>Participant: #getPersonRecord.nhHHSID#</h5>
        </cfoutput>

        <table class="table table-striped">
          <tr>
            <th>Chemical</th>
            <th>Level</th>
          </tr>

        <cfoutput query="getPersonRecord">
          <tr>
            <td>#shortName# <br /><small>(#longName#)</small></td>
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