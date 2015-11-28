<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Individual Data</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">
  </head>

  <body>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <cfif IsDefined("Form.search") or IsDefined("Form.update")>

          <cfquery name="validatePerson"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT nhHHSID FROM tbPerson WHERE nhHHSID =
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#nhHHSID#">
          </cfquery>

          <cfquery name="getPersonRecord"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT nhHHSID, age, adult, shortName, longname, pfcLevel,  pfcMin, pfcMax, 
              pfcMean, pfcGeoMean, pfcMedian, studyID, studyName, participants, exposureType
              FROM tbPerson
              NATURAL JOIN tbPersonPFCLevel
              NATURAL JOIN tbChemical
              NATURAL JOIN tbStudyPFCLevel
              NATURAL JOIN tbStudy
              NATURAL JOIN tbExposureType
              WHERE adult = (
                CASE 
                  WHEN age < 18 
                  THEN 'N' ELSE 'Y' 
                END)
              AND nhHHSID =
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#nhHHSID#">
              AND studyID =
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#studyID#">
          </cfquery>

          <cfquery name="getStudies"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
             SELECT studyID, studyName FROM tbStudy
          </cfquery>

          <h3>Individual Data</h3>
            <div class="form-group">
              <cfform action="individualdata.cfm" method="post" class="form-inline">
              <cfoutput>
                <strong>Participant:</strong> <cfinput class="form-control" name="nhHHSID" type="text" maxlength="6" size="8" value="#nhHHSID#">
              </cfoutput>
                <p>&nbsp;</p>
                  <strong>Study:</strong> <select name="studyID" class="form-control">
                           <cfoutput query="getStudies">
                             <cfif "#getStudies.studyID#" neq "#getPersonRecord.studyID#">
                               <option value="#studyID#">#studyName#</option>
                             <cfelse>
                               <option value="#studyID#" selected>#studyName#</option>
                             </cfif>  
                           </cfoutput>
                         </select>
                <p><br /><strong>Number of Participants:</strong> <cfoutput>#getPersonRecord.participants#</cfoutput></p>
                <p><strong>Exposure Type:</strong> <cfoutput>#getPersonRecord.exposureType#</cfoutput></p>
                <p>&nbsp;</p>
                <button type="submit" name="update" class="btn btn-primary">Update</button>
              </cfform>
            </div>
            <p>&nbsp;</p>
          <table class="table table-striped">
            <tr>
              <th>Chemical</th>
              <th>Personal Level</th>
              <th>Min</th>
              <th>Max</th>
              <th>Mean</th>
              <th>Geometric Mean</th>
              <th>Median</th>
            </tr>

          <cfif getPersonRecord.recordCount LT 1 and validatePerson.recordCount LT 1>
            <tr>
              <td colspan="7" class="center">No participant record found.</td>
            </tr>

          <cfelseif getPersonRecord.recordCount LT 1>
            <tr>
              <td colspan="7" class="center">No comparable studies found.</td>
            </tr>

          <cfelse>
            <cfoutput query="getPersonRecord">
            <tr>
              <td>#shortName# <br /><small>(#longName#)</small></td>
              <td class="info">#pfcLevel#</td>
              <cfif "#pfcMin#" eq "">
                <td> - </td>
              <cfelse>
                <td>#pfcMin#</td>
              </cfif>
              <cfif "#pfcMax#" eq "">
                <td> - </td>
              <cfelse>
                <td>#pfcMax#</td>
              </cfif>
              <cfif "#pfcMean#" eq "">
                <td> - </td>
              <cfelse>
                <td>#pfcMean#</td>
              </cfif>
              <cfif "#pfcGeoMean#" eq "">
                <td> - </td>
              <cfelse>
                <td>#pfcGeoMean#</td>
              </cfif>
              <cfif "#pfcMedian#" eq "">
                <td> - </td>
              <cfelse>
                <td>#pfcMedian#</td>
              </cfif>
            </tr>
          </cfoutput>
        </cfif>

          </table>

        <cfelse>

        <p>&nbsp;</p>
          <h3>Type in your Participant ID number</h3>
          <div class="form-group">
            <cfform action="individualdata.cfm" method="post" class="form-inline">
              <input name="nhHHSID" type="text" maxlength="6" class="formcontrol input-lg" size="20" placeholder="nhHHSID" aria-describedby="nhHHSIDHelp">
              <span id="nhHHSIDHelp" class="help-block">nhHHSID Participant IDs can be found on your blood sample record.</span>
              <input name="studyID" type="hidden" value="9">
              <button type="submit" name="search" class="btn btn-primary btn-lg">Search</button>
            </cfform>
          </div>
        </cfif>

      </div>
    </div><!-- /.container -->



     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>