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

        <cfif !IsDefined("Form.update") and !IsDefined("Form.updateParticipant") and !IsDefined("Form.deleteParticipant")>
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

        <cfelseif IsDefined("Form.updateParticipant")>

          <p>Updated

        <cfelseif IsDefined("Form.deleteParticipant")>

          <p>Deleted

        <cfelse>

          <cfquery name="getPerson"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT * FROM tbPerson WHERE personID =
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.personID#">
          </cfquery>

          <div class="form-group">
            <cfoutput query="getPerson">
              <cfform id="updateParticipantData" action="updateparticipant.cfm" method="post" class="form-horizontal">

                <div class="form-group">
                  <label for="nhHHSID" class="col-sm-2 control-label">nhHHSID</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="nhHHSID" aria-describedby="helpnhHHSID" value="#nhHHSID#">
                    <span id="helpnhHHSID" class="help-block">NH Health and Human Services ID.</span>
                  </div>
                </div>

                <div class="form-group">
                  <label for="age" class="col-sm-2 control-label">Age</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="age" aria-describedby="helpAge" value="#age#">
                    <span id="helpAge" class="help-block">THe Participants Age</span>
                  </div>
                </div>

                <div class="form-group">
                  <label for="yearsExposed" class="col-sm-2 control-label">Years Exposed</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="yearsExposed" aria-describedby="helpYearsExposed" value="#yearsExposed#">
                    <span id="helpYearsExposed" class="help-block">The Years Exposed</span>
                  </div>
                </div>

                <div class="form-group">
                  <label for="sex" class="col-sm-2 control-label">Sex</label>
                  <div class="col-sm-4">
                    <div class="radio">
                      <label>
                        <cfif "#sex#" eq "F">
                          <input type="radio" name="sex" id="sexRadios1" value="M">
                        <cfelse>
                          <input type="radio" name="sex" id="sexRadios1" value="M" checked>
                        </cfif>
                        Male
                      </label>
                      <label>
                        <cfif "#sex#" eq "F">
                          <input type="radio" name="sex" id="sexRadios2" value="F" checked>
                        <cfelse>
                          <input type="radio" name="sex" id="sexRadios2" value="F">
                        </cfif>
                        Female
                      </label>
                    </div>
                    <span id="helpSex" class="help-block">The sex of the participant.</span>
                  </div>
                </div>

                <p>&nbsp;</p>

                <div class="form-group">
                  <div class="col-sm-2 control-label"></div>
                  <div class="col-sm-4 center">
                    <button type="submit" name="updateParticipant" class="btn btn-primary">Update</button>
                    <button type="submit" name="deleteParticipant" class="btn btn-danger">Delete</button>
                  </div>
                </div>

              </cfform>
            </cfoutput>
          </div>
        </cfif>

      </div>
    </div><!-- /.container -->

    <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>