<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Update Well Sample</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/bootstrap-datepicker3.min.css" rel="stylesheet">
    <link href="css/formValidation/formValidation.min.css" rel="stylesheet">
  </head>

  <body>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <cfif !IsDefined("Form.update") and !IsDefined("Form.updateWellSample") and !IsDefined("Form.deleteWellSample")>

          <cfparam name="wellID" default="1" type="string">

          <h3>Well Sample Record Data</h3>

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
            SELECT * 
            FROM ( 
              SELECT a.*, rownum r 
                FROM ( 
                  SELECT sampleID, wellID, sampleDate, shortName, pfcLevel 
                    FROM tbWellSample 
                    NATURAL JOIN  tbWell 
                    NATURAL JOIN tbChemical
                    WHERE wellID = 
                    <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                      value="#wellID#">
                    ORDER BY sampleDate
                ) a 
                WHERE rownum < (
                  (3 * 10) + 1
                )
            ) 
            WHERE r >= (
              ((3-1) * 10) + 1
            )
          </cfquery>

          <cfform id="selectWell" action="updatewellsample.cfm" method="post" class="form-inline">

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

        <div id="pager"></div>

          <table class="table table-striped">
            <tr>
              <th>Sample Date</th>
              <th>PFC</th>
              <th>PFC Level</th>
              <th>Action</th>
            </tr>
            
            <cfif getWellSamples.recordCount LT 1>
              <tr>
                <td colspan="3" class="center">No Samples Found</td>
              </tr>
            </cfif>

            <cfoutput query="getWellSamples">
            <tr>
              <td>#DateFormat(sampleDate, "dd-mmm-yyyy")#</td>
              <td>#shortName#</td>
              <td>#pfcLevel#</td>
              <td>
                <cfform action="updatewellsample.cfm" method="post">
                  <input name="sampleID" type="hidden" value="#sampleID#">
                  <button type="submit" name="update" class="btn btn-primary btn-xs">Update/Delete</button>
                </cfform>
              </td>
            </tr>
            </cfoutput>

          </table>

        <cfelseif IsDefined("Form.updateWellSample")>

          <cfquery name="udpateWellSample"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            UPDATE tbWellSample
              SET 
                sampleDate = 
                TO_DATE(
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.sampleDate#">, 'MM/DD/YYYY'), 
                pfcLevel = 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel#">
              WHERE sampleID = 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.sampleID#">
          </cfquery>

          <cflocation url="updatewellsample.cfm">

        <cfelseif IsDefined("Form.deleteWellSample")>

          <cfquery name="deleteWellSample"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            DELETE FROM tbWellSample 
              WHERE sampleID =
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.sampleID#">
          </cfquery>

          <cflocation url="updatewellsample.cfm">

        <cfelse>

          <cfquery name="getSample"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT sampleID, sampleDate, shortName, longName, pfcLevel 
              FROM tbWellSample 
              NATURAL JOIN  tbWell 
              NATURAL JOIN tbChemical 
              WHERE sampleID = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.sampleID#">
          </cfquery>

          <div class="form-group">
            <cfoutput query="getSample">
              <cfform id="updateWellSampleData" action="updatewellsample.cfm" method="post" class="form-horizontal">

                <div class="form-group">
                  <label for="sampleDate" class="col-sm-2 control-label">Sample Date</label>
                  <div class="col-sm-4 date">
                    <div class="input-group input-append date" id="datePicker">
                      <input type="text" class="form-control" name="sampleDate" value="#DateFormat(sampleDate, "mm/dd/yyyy")#">
                      <span class="input-group-addon add-on"><span class="glyphicon glyphicon-calendar"></span></span>
                    </div>
                    <span id="helpDate" class="help-block">Enter the date this sample was taken.</span>
                  </div>
                </div>

                <div class="form-group">
                  <label for="shortName" class="col-sm-2 control-label">PFC</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="shortName" aria-describedby="helpShortName" value="#shortName#" disabled>
                    <span id="helpShortName" class="help-block">#longName#</span>
                  </div>
                </div>

                <div class="form-group">
                  <label for="pfcLevel" class="col-sm-2 control-label">PFC Level</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="pfcLevel" aria-describedby="helpPfcLevel" value="#pfcLevel#">
                    <span id="helpPfcLevel" class="help-block">The PFC Level for #shortName#</span>
                  </div>
                </div>

                <p>&nbsp;</p>

                <div class="form-group">
                  <div class="col-sm-2 control-label"></div>
                  <div class="col-sm-4 center">
                    <input name="sampleID" type="hidden" value="#sampleID#">
                    <button type="submit" name="updateWellSample" class="btn btn-primary">Update</button>
                    <button type="submit" name="deleteWellSample" class="btn btn-danger">Delete</button>
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
    <script src="js/formValidation/formValidation.min.js"></script>
    <script src="js/formValidation/bootstrap.min.js"></script>
    <script src="js/bootstrap-datepicker3.min.js"></script>
    <script src="js/jquery.bootpag.min.js"></script>

    <script>
        // init bootpag
        $('#pager').bootpag({
            total: 10
        }).on("page", function(event, /* page number here */ num){
             $("#content").html("Insert content"); // some ajax content loading...
        });
    </script>

    <script>
    $(document).ready(function() {

        $('#datePicker')
            .datepicker({
                format: 'mm/dd/yyyy'
            })
            .on('changeDate', function(e) {
                // Revalidate the date field
                $('#updateWellSampleData').formValidation('revalidateField', 'date');
            });

        $('#updateWellSampleData').formValidation({
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