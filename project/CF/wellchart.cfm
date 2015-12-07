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

          <cfquery name="getPFOASamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, wellID, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID =
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#wellID#">
              AND chemID = 1
          </cfquery>

          <cfquery name="getPFOSSamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, wellID, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#wellID#">
              AND chemID = 2
          </cfquery>

          <cfform id="selectWell" action="wellchart.cfm" method="post" class="form-inline">

            <div class="form-group">
              <label for="wellID">Well Name</label>
                <select name="wellID" class="form-control" aria-describedby="helpWell">
                  <cfoutput query="getWells">
                   <cfif "#getWells.wellID#" neq "#getPFOASamples.wellID#">
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

          <cfchart format="html"
                   chartwidth="800"
                   chartheight="400"
                   xaxistitle="Sample Date"
                   yaxistitle="PFC Level"
                   showlegend="yes"
                   fontsize="12"
                   font="Arial"
                   showMarkers="no"
                   labelmask="MM-DD" 
                   xAxisType="Date" >

            <cfchartseries type="line"
                          query="getPFOASamples"
                          valueColumn="pfcLevel"
                          itemColumn="sampleDate"
                          seriesLabel="PFOA">


          </cfchart>
          

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