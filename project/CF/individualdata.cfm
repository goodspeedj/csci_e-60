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

        <cfif IsDefined("Form.search") or IsDefined("Form.update")>

          <cfquery name="getPersonRecord"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT nhHHSID, age, adult, shortName, longname, pfcLevel,  pfcMin, pfcMax, 
              pfcMean, pfcGeoMean, pfcMedian, studyID, studyName, participants
              FROM tbPerson
              NATURAL JOIN tbPersonPFCLevel
              NATURAL JOIN tbChemical
              NATURAL JOIN tbStudyPFCLevel
              NATURAL JOIN tbStudy
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
            <cfform action="individualdata.cfm" method="post">
            <cfoutput>
              <h5>
                Participant: <cfinput name="nhHHSID" type="text" maxlength="6" size="8" value="#getPersonRecord.nhHHSID#">
              </h5>
            </cfoutput>
              <h5>
                Study: <select name="studyID">
                         <cfoutput query="getStudies">
                           <cfif "#getStudies.studyID#" eq "#getPersonRecord.studyID#">
                             <option value="#studyID#" selected>#studyName#</option>
                           <cfelse>
                             <option value="#studyID#">#studyName#</option>
                           </cfif>  
                         </cfoutput>
                       </select>
              </h5>
            <button type="submit" name="update" class="btn btn-primary btn-sm">Update</button>
            </cfform>
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

          <cfoutput query="getPersonRecord">
            <tr>
              <td>#shortName# <br /><small>(#longName#)</small></td>
              <td>#pfcLevel#</td>
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

          </table>

        <cfelse>

          <h4>Type in your Participant ID number</h4>
          <cfform action="individualdata.cfm" method="post">
            <cfinput name="nhHHSID" type="text" maxlength="6" size="8">
            <cfinput name="studyID" type="hidden" value="9">
            <button type="submit" name="search" class="btn btn-primary btn-sm">Search</button>
          </cfform>
        </cfif>

      </div>
    </div><!-- /.container -->



     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>