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

          <h3>Well Sample Data - by Well</h3>

          <p>This chart shows the PFC levels from the selected well from April 2014 to the last 
             sample collected (in the case of the Haven Well the last sample was May 2014 right
             before the well was shutdown).</p>
          <p>Hovering over the lines will give the PFC level for that particular point in time.
             Selecting the PFC in the legend will enable/disable that PFC from the chart.</p>

          <p>&nbsp;</p>

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

          <cfquery name="getPFHxSSamples"
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
              AND chemID = 3
          </cfquery>

          <cfquery name="getPFUASamples"
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
              AND chemID = 4
          </cfquery>

          <cfquery name="getPFOSASamples"
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
              AND chemID = 5
          </cfquery>

          <cfquery name="getPFNASamples"
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
              AND chemID = 6
          </cfquery>

          <cfquery name="getPFDeASamples"
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
              AND chemID = 7
          </cfquery>

          <cfquery name="getPFPeASamples"
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
              AND chemID = 8
          </cfquery>

          <cfquery name="getPFHxASamples"
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
              AND chemID = 9
          </cfquery>

          <cfquery name="getPFBASamples"
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
              AND chemID = 10
          </cfquery>

          <cfform id="selectWell" action="wellchart_bywell.cfm" method="post" class="form-inline">

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

          <!-- Hack to get the dates to display correctly -->
          <cfset aryData  = [] />

          <cfloop from="1" to="#getPFOASamples.recordcount#" index="i">
            <cfset ArrayAppend(aryData, DateFormat(getPFOASamples.sampleDate[i], "dd-mmm-yyyy")) />
          </cfloop>

          <cfset QueryAddColumn(getPFOASamples, "smpDate", "VarChar", aryData) />

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
                          itemColumn="smpDate"
                          seriesLabel="PFOA">

            <cfchartseries type="line"
                          query="getPFOSSamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFOS">

            <cfchartseries type="line"
                          query="getPFHxSSamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFHxS">

            <cfchartseries type="line"
                          query="getPFUASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFUA">

            <cfchartseries type="line"
                          query="getPFOSASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFOSA">

            <cfchartseries type="line"
                          query="getPFNASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFNA">

            <cfchartseries type="line"
                          query="getPFDeASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFDeA">

            <cfchartseries type="line"
                          query="getPFPeASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFPeA">

            <cfchartseries type="line"
                          query="getPFHxASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFHxA">

            <cfchartseries type="line"
                          query="getPFBASamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="PFBA">


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