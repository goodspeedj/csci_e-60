<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Update Participant</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <cfif !IsDefined("Form.update")>
          <h3>Participant Record Data</h3>

          <cfquery name="getParticipants"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT * FROM tbPerson ORDER BY nhHHSID
          </cfquery>

          <table class="table table-striped">
            <tr>
              <th>nhHHSID</th>
              <th>Age</th>
              <th>Years Exposed</th>
              <th>Sex</th>
              <th>Action</th>
            </tr>
            
            <cfif getParticipants.recordCount LT 1>
              <tr>
                <td colspan="3" class="center">No Participants Found</td>
              </tr>
            </cfif>

            <cfoutput query="getParticipants">
            <tr>
              <td>#nhHHSID#</td>
              <td>#age#</td>
              <td>#yearsExposed#</td>
              <td>#sex#</td>
              <td>
                <cfform action="updateparticipant.cfm" method="post">
                  <input name="personID" type="hidden" value="#personID#">
                  <button type="submit" name="update" class="btn btn-primary btn-xs">Update/Delete</button>
                </cfform>
              </td>
            </tr>
            </cfoutput>

          </table>

        <cfelse>
          <cfoutput>#Form.personID#</cfoutput>
        </cfif>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>