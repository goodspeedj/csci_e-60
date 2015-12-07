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

        <cfparam name="chemID" default="1" type="string">

          <h3>Well Sample Data - by PFC</h3>

          <p>This chart shows the PFC levels across the three Pease wells by PFC chemical from 
             April 2014 to the last sample collected (in the case of the Haven Well the last 
             sample was May 2014 right before the well was shutdown).</p>
          <p>Hovering over the lines will give the PFC level for that particular point in time.
             Selecting the PFC in the legend will enable/disable that PFC from the chart.</p>

          <p>&nbsp;</p>

          <cfquery name="getChemicals"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT chemID, shortName
              FROM tbChemical 
              WHERE chemID NOT IN (4, 7)
          </cfquery>

          <cfquery name="getHavenSamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, chemID, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID = 1
              AND chemID = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#chemID#">
          </cfquery>

          <cfquery name="getSmithSamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, chemID, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID = 2
              AND chemID = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#chemID#">
          </cfquery>

          <cfquery name="getHarrisonSamples"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleDate, chemID, wellName, shortName, pfcLevel
              FROM tbWellSample
              NATURAL JOIN tbWell
              NATURAL JOIN tbChemical
              WHERE wellID = 3
              AND chemID = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#chemID#">
          </cfquery>

          <cfform id="selectChemical" action="wellchart_bypfc.cfm" method="post" class="form-inline">

            <div class="form-group">
              <label for="chemID">PFC Name</label>
                <select name="chemID" class="form-control" aria-describedby="helpChem">
                  <cfoutput query="getChemicals">
                   <cfif "#getChemicals.chemID#" neq "#getHarrisonSamples.chemID#">
                     <option value="#chemID#">#shortName#</option>
                   <cfelse>
                     <option value="#chemID#" selected>#shortName#</option>
                   </cfif> 
                  </cfoutput> 
                </select>
            </div>

            <div class="form-group">
              <button type="submit" name="updateChem" class="btn btn-primary">Update</button>
            </div>

          </cfform>

          <p>&nbsp;</p>

          <!-- Hack to get the dates to display correctly -->
          <cfset aryData  = [] />

          <cfloop from="1" to="#getHarrisonSamples.recordcount#" index="i">
            <cfset ArrayAppend(aryData, DateFormat(getHarrisonSamples.sampleDate[i], "dd-mmm-yyyy")) />
          </cfloop>

          <cfset QueryAddColumn(getHarrisonSamples, "smpDate", "VarChar", aryData) />

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
                          query="getHavenSamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="Haven">

            <cfchartseries type="line"
                          query="getSmithSamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="Smith">

            <cfchartseries type="line"
                          query="getHarrisonSamples"
                          valueColumn="pfcLevel"
                          itemColumn="smpDate"
                          seriesLabel="Harrison">

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