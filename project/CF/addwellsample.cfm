<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Manage Well Data</title>
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

        <cfif IsDefined("Form.addWellData")>
          <p>Record Added</p>
          <!-- <cflocation url="welldata.cfm"> -->
        <cfelse>

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

            <cfform id="addWellData" action="managewell.cfm" method="post" class="form-horizontal">

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

              <div class="form-group">
                <label for="sampleDate" class="col-sm-2 control-label">Sample Date</label>
                <div class="col-sm-4 date">
                  <div class="input-group input-append date" id="datePicker">
                    <input type="text" class="form-control" name="sampleDate">
                    <span class="input-group-addon add-on"><span class="glyphicon glyphicon-calendar"></span></span>
                  </div>
                  <span id="helpDate" class="help-block">Enter the date this sample was taken.</span>
                </div>
              </div>

              <div class="form-group">
                <label for="pfcLevel" class="col-sm-2 control-label">PFC Level</label>
                <div class="col-sm-4">
                  <input type="text" class="form-control" name="pfcLevel" aria-describedby="helpPfcLevel">
                  <span id="helpPfcLevel" class="help-block">Enter the PFC level for this sample.</span>
                </div>
              </div>

              <p>&nbsp;</p>

              <div class="form-group">
                <div class="col-sm-2 control-label"></div>
                <div class="col-sm-4 center">
                  <button type="addSample" name="Add Sample Record" class="btn btn-primary">Add Sample Record</button>
                </div>
              </div>
              
            </cfform>
          </div>

        </cfif>

      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/formValidation/formValidation.min.js"></script>
    <script src="js/formValidation/bootstrap.min.js"></script>
    <script src="js/bootstrap-datepicker.min.js"></script>

    <script>
    $(document).ready(function() {
        $('#datePicker')
            .datepicker({
                format: 'mm/dd/yyyy'
            })
            .on('changeDate', function(e) {
                // Revalidate the date field
                $('#addWellData').formValidation('revalidateField', 'date');
            });

        $('#addWellData').formValidation({
            framework: 'bootstrap',
            icon: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                sampleDate: {
                    validators: {
                        notEmpty: {
                            message: 'The date is required'
                        },
                        date: {
                            format: 'MM/DD/YYYY',
                            message: 'The date is not a valid'
                        }
                    }
                },
                pfcLevel: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level is required'
                        },
                        numeric: {
                            message: 'The PFC level must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The value must be greater than or equal to 0'
                        }
                    }
                }

            }
        });
    });
    </script>
  </body>
</html>