<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Manage Well Data</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">
  </head>

  <body>
    
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <h3>Add Well Sample</h3>
        <cfquery name="getWells"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT * 
            FROM tbWell 
            NATURAL JOIN tbWellType
            WHERE wellType = 'Well'
            ORDER BY wellName
        </cfquery>

        <cfquery name="getChemicals"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          SELECT * 
            FROM tbChemical
        </cfquery>

        <div class="form-group">

          <cfform action="managewell.cfm" method="post" class="form-horizontal">

            <div class="form-group">
              <label for="wellID" class="col-sm-2 control-label">Well Name</label>
              <div class="col-sm-4">
                <select name="wellID" class="form-control" aria-describedby="helpWell">
                    <option disabled selected> -- Select a Well -- </option>
                  <cfoutput query="getWells">
                    <option value="#wellID#">#wellName#</option>
                  </cfoutput>
                </select>
                <span id="helpWell" class="help-block">Choose the well for this sample.</span>
              </div>
            </div>

            <div class="form-group">
              <label for="chemID" class="col-sm-2 control-label">Chemical Name</label>
              <div class="col-sm-4">
                <select name="chemID" class="form-control" aria-describedby="helpChemical">
                    <option disabled selected> -- Select a PFC -- </option>
                  <cfoutput query="getChemicals">
                    <option value="#chemID#">#longName# (#shortName#)</option>
                  </cfoutput>
                </select>
                <span id="helpChemical" class="help-block">Choose the PFC for this sample.</span>
              </div>
            </div>

          </cfform>
        </div>

      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>