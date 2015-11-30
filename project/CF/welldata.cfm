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

        <cfparam name="wellID" default="1" type="string">

        <h3>Well Sample Data</h3>

        <cfquery name="getWells"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT wellID, wellName 
            FROM tbWell
            NATURAL JOIN tbWellType
            WHERE wellType = 'Well'
        </cfquery>

        <cfquery name="getWellSamples"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT * FROM 
            (SELECT sampleDate, wellID, shortName, pfcLevel 
              FROM tbWellSample NATURAL JOIN tbChemical) 
            PIVOT 
              (MAX(pfcLevel) FOR shortName IN ('PFOA', 'PFOS', 'PFHxS', 'PFUA', 'PFOSA', 'PFNA', 'PFDeA', 'PFPeA', 'PFHxA', 'PFBA')) 
              WHERE wellId = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#wellID#">
            ORDER BY sampleDate DESC
        </cfquery>

        <cfform id="selectWell" action="welldata.cfm" method="post" class="form-inline">

          <div class="form-group">
            <label for="wellID">Well Name</label>
              <select name="wellID" class="form-control" aria-describedby="helpWell">
                <cfoutput query="getWells">
                 <cfif "#getWells.wellID#" neq "#getWellSamples.wellID#">
                   <option value="#wellID#">#wellName#</option>
                 <cfelse>
                   <option value="#wellID#" selected>#wellName#</option>
                 </cfif> 
                </cfoutput> 
              </select>
          </div>

          <div class="form-group">
            <button type="submit" name="updateWell" class="btn btn-primary">Update</button>
          </div>

        </cfform>

        <p>&nbsp;</p>

        <cfoutput>

        <!-- Following code based on: http://stackoverflow.com/questions/33876129/displaying-results-from-pivot-query-in-coldfusion/33877746 -->

        <table class="table table-striped">
          <tr>
            <cfloop array="#getWellSamples.getcolumnlist()#" index="pfcName">
              <cfif #pfcName# neq "WELLID">
                <cfif #pfcName# eq "SAMPLEDATE">
                  <th>Sample Date</th>
                <cfelse>
                  <th>#pfcName#</th>
                </cfif>
              </cfif>
            </cfloop>
          </tr>

          <cfloop query="getWellSamples">
          <tr>
            <cfloop array="#getWellSamples.getcolumnlist()#" index="pfcLevel">
              <cfif #pfcLevel# neq "WELLID">
                <cfif #pfcLevel# eq "SAMPLEDATE">
                  <td>#DateFormat(getWellSamples[pfcLevel][currentrow], "dd-mmm-yyyy")#</td>
                <cfelse>
                  <td>#getWellSamples[pfcLevel][currentrow]#</td>
                </cfif>
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