<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Participant Record</title>
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

        <cfif IsDefined("Form.addParticipant")>


          <cfquery name="addPerson"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPerson
              VALUES (
                seq_person.nextval, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.nhHHSID#">, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.age#">, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.yearsExposed#">,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.sex#">
              )
          </cfquery>

          <cfquery name="addPersonAddress"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbAddress
              VALUES (
                seq_address.nextval,
                seq_person.currval, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.address# Portsmouth, NH  03801">
              )
          </cfquery>

          <cfquery name="addPersonPFOS"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                1, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel1#">
              )
          </cfquery>

          <cfquery name="addPersonPFOA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                2, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel2#">
              )
          </cfquery>

          <cfquery name="addPersonPFHxS"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                3, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel3#">
              )
          </cfquery>

          <cfquery name="addPersonPFUA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                4, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel4#">
              )
          </cfquery>

          <cfquery name="addPersonPFOSA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                5, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel5#">
              )
          </cfquery>

          <cfquery name="addPersonPFNA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                6, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel6#">
              )
          </cfquery>

          <cfquery name="addPersonPFDeA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                7, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel7#">
              )
          </cfquery>

          <cfquery name="addPersonPFPeA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                8, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel8#">
              )
          </cfquery>

          <cfquery name="addPersonPFHxA"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            INSERT INTO tbPersonPFCLevel
              VALUES (
                seq_person.currval, 
                9, 
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                  value="#Form.pfcLevel9#">
              )
          </cfquery>
          <cflocation url="individualdata.cfm">
        <cfelse>

          <h3>Add Participant Record</h3>

          <cfquery name="getChemicals"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT * 
              FROM tbChemical
              WHERE chemID < 10
          </cfquery>

          <div class="form-group">

            <cfform id="addParticipantData" action="addparticipant.cfm" method="post" class="form-horizontal">

              <div class="form-group">
                <label for="nhHHSID" class="col-sm-2 control-label">nhHHSID</label>
                <div class="col-sm-4">
                  <input type="text" class="form-control" name="nhHHSID" aria-describedby="helpnhHHSID" placeholder="PTXXXX">
                  <span id="helpnhHHSID" class="help-block">Enter the NH Health and Human Services ID.</span>
                </div>
              </div>

              <div class="form-group">
                <label for="age" class="col-sm-2 control-label">Age</label>
                <div class="col-sm-4">
                  <input type="text" class="form-control" name="age" aria-describedby="helpAge" placeholder="e.g. 35">
                  <span id="helpAge" class="help-block">Enter the age of the participant.</span>
                </div>
              </div>

              <div class="form-group">
                <label for="yearsExposed" class="col-sm-2 control-label">Years Exposed</label>
                <div class="col-sm-4">
                  <input type="text" class="form-control" name="yearsExposed" aria-describedby="helpYearsExposed" placeholder="e.g. 10">
                  <span id="helpYearsExposed" class="help-block">Enter the number of years the participant was exposed.</span>
                </div>
              </div>

              <div class="form-group">
                <label for="address" class="col-sm-2 control-label">Location of Exposure</label>
                <div class="col-sm-4">
                  <input type="text" class="form-control" name="address" aria-describedby="helpAddress" placeholder="1 Main St">
                  <input class="form-control" type="text" placeholder="Portsmouth, NH  03801" readonly>
                  <span id="helpAddress" class="help-block">Enter the address the participant was exposed at.</span>
                </div>
              </div>

              <div class="form-group">
                <label for="sex" class="col-sm-2 control-label">Sex</label>
                <div class="col-sm-4">
                  <div class="radio">
                    <label>
                      <input type="radio" name="sex" id="sexRadios1" value="M">
                      Male
                    </label>
                    <label>
                      <input type="radio" name="sex" id="sexRadios2" value="F">
                      Female
                    </label>
                  </div>
                  <span id="helpSex" class="help-block">Enter the sex of the participant.</span>
                </div>
              </div>

              <cfoutput query="getChemicals">
                <div class="form-group">
                  <label for="chemID" class="col-sm-2 control-label">#shortName#</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" name="pfcLevel#chemID#" aria-describedby="helpChemID" placeholder="e.g. 0.01">
                    <span id="helpChemID" class="help-block">Enter the value for #shortName#.</span>
                  </div>
                </div>
              </cfoutput>

              <p>&nbsp;</p>

              <div class="form-group">
                <div class="col-sm-2 control-label"></div>
                <div class="col-sm-4 center">
                  <button type="submit" name="addParticipant" class="btn btn-primary">Add Participant Record</button>
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

        $('#addParticipantData').formValidation({
            framework: 'bootstrap',
            icon: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                nhHHSID: {
                    validators: {
                        notEmpty: {
                            message: 'The nhHHSID is required'
                        },
                        regexp: {
                            regexp: /^PT[0-9][0-9][0-9][0-9]$/,
                            message: 'The nhHHSID should start with "PT" followed by four digits'
                        }
                    }
                },
                age: {
                    validators: {
                        notEmpty: {
                            message: 'The participant age is required'
                        },
                        numeric: {
                            message: 'The participant age must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The participants age must be greater than 0'
                        }
                    }
                },
                yearsExposed: {
                    validators: {
                        notEmpty: {
                            message: 'The number of years exposed is required'
                        },
                        numeric: {
                            message: 'The number of years exposed must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The number of years exposed must be greater than 0'
                        }
                    }
                },
                pfcLevel1: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel2: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel3: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel4: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel5: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel6: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel7: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel8: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                },
                pfcLevel9: {
                    validators: {
                        notEmpty: {
                            message: 'The PFC level fields are required'
                        },
                        numeric: {
                            message: 'The PFC level field must be a number'
                        },
                        greaterThan: {
                          value: 0,
                          message: 'The PFC level field must be greater than 0'
                        }
                    }
                }
            }
        });
    });
    </script>
  </body>
</html>