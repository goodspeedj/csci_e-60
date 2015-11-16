<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Project #3</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">
  </head>

  <body>
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">
        <cfparam name="URL.prodNo" default="AAA" type="string">

        <cfif URL.prodNo NEQ "AAA">
          <cfquery name="getComponents"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT prodNo, productName, compNo, partNo, partDescr, noPartsReq
              FROM tbProduct 
              NATURAL JOIN tbComponent 
              NATURAL JOIN tbPart WHERE prodNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#URL.prodNo#">
          </cfquery>

          <cfoutput>
            <h4>Components for #getComponents.productName#</h4>
          </cfoutput>
          
          <table class="table table-striped">
            <tr>
              <th>Component No.</th>
              <th>Part No.</th>
              <th>Part Name</th>
              <th>Parts Required</th>
              <th>Update</th>
            </tr>

          <cfoutput query="getComponents">
            <cfform action="updatepart.cfm" method="post">

              <tr>
                <td>#compNo#</td>
                <td>#partNo#</td>
                <td>#partDescr#</td>
                <td>#noPartsReq#</td>
                <input type="hidden" name="partNo" value="#partNo#">
                <input type="hidden" name="prodNo" value="#prodNo#">
                <td><button type="submit" class="btn btn-primary btn-sm">Update</button></td>
              </tr>
            </cfform>
          </cfoutput>

          </table>


        <cfelse>
          <cfquery name="getProducts"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT prodNo, productName
              FROM tbProduct
              ORDER BY productName
          </cfquery>

          <h4>Select a Product</h4>
          <form action="searchandshowcomps.cfm?#URL.prodNo#" method="get">
            <table>
              <tr>
                <th>Products: </th>
                <td>
                    <select name="prodNo">
                      <cfoutput query="getProducts">
                        <option value="#prodNo#">#productName#</option>
                      </cfoutput>
                    </select>
                </td>
              </tr>
              <tr>
                <td span="2">&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td><input name="submit" type="submit" value="Display Components" /></td>
              </tr>
            </table>
          </form>

        </cfif>

      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>