<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Project #4</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>
    
    <!--protects against people going directly to this page -->
    <cfif !IsDefined("Form.partNo") and !IsDefined("Form.prodNo")>
      <cflocation url="searchandshowcomps.cfm">
    </cfif>

    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <cfif IsDefined("Form.update")>

          <cfquery name="updateQuantity"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            UPDATE tbComponent 
              SET noPartsReq = #Form.noPartsReqUpdate#
              WHERE partNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#partNo#">
              AND prodNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#prodNo#">
          </cfquery>

          <cflocation url="searchandshowcomps.cfm?prodNo=#Form.prodNo#">
        <cfelse>

          <cfquery name="getComponent"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT prodNo, productName, compNo, partNo, partDescr, noPartsReq
              FROM tbProduct 
              NATURAL JOIN tbComponent 
              NATURAL JOIN tbPart WHERE partNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#partNo#">
              AND prodNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#prodNo#">
          </cfquery>

          <cfoutput>
            <h4>Component:  #getComponent.partDescr#</h4>
          </cfoutput>
          
          <table class="table table-striped">
            <tr>
              <th>Component No.</th>
              <th>Part No.</th>
              <th>Part Name</th>
              <th>Parts Required</th>
              <th>Update</th>
            </tr>

          <cfoutput query="getComponent">

            <cfform action="updatepart.cfm" method="post">
              <tr>
                <td>#compNo#</td>
                <td>#partNo#</td>
                <td>#partDescr#</td>
                <td>
                  <cfinput name="noPartsReqUpdate" type="text" value="#getComponent.noPartsReq#"
                           maxlength="2" range="0,99"
                           required="yes" validate="integer"
                           message="Parts required must be a number between 0 and 99">
                </td>
                <input type="hidden" name="noPartsReq" value="#noPartsReq#">
                <input type="hidden" name="partNo" value="#partNo#">
                <input type="hidden" name="prodNo" value="#prodNo#">
                <td><button type="submit" name="update" class="btn btn-primary btn-sm">Update Quantity</button></td>
              </tr>
            </cfform>
          </cfoutput>

          </table>

        </cfif>

      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>