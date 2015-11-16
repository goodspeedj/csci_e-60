<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Project #2</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>

    <!-- Self submitting form for Project #2 -->
    
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">
        <cfparam name="URL.partNo" default="AAA" type="string">

        <cfif URL.partNo NEQ "AAA">
          <cfquery name="getQuotes"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT vendorNo, vendorName, a.priceQuote AS quote
              FROM tbVendor 
              NATURAL JOIN tbQuote a 
              JOIN tbPart b ON (a.partNo = b.partNo) 
              WHERE (SELECT count(priceQuote) FROM tbQuote c 
                      WHERE a.partNo = c.partNo 
                      GROUP BY a.partNo) > 0 
              AND b.partNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#URL.partNo#">
          </cfquery>

          <cfquery name="getPartName"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SElECT partDescr 
              FROM tbPart
              WHERE partNo = 
              <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                value="#URL.partNo#">
          </cfquery>

          <cfoutput>
            <h4>Quotes for #getPartName.partDescr#</h4>
            <h5>Total Quotes: #getQuotes.recordCount#</h5>
            <cfif getQuotes.recordCount LT 2>
              <p class="bg-danger">WARNING: This part has less than 2 quotes.</p>
            </cfif>
          </cfoutput>
          
          <table class="table table-striped">
            <tr>
              <th>Vendor Number</th>
              <th>Vendor Name</th>
              <th>Quote</th>
            </tr>

          <cfoutput query="getQuotes">

            <tr>
              <td>#vendorNo#</td>
              <td>#vendorName#</td>
              <td>#quote#</td>
            </tr>
          </cfoutput>

          </table>



        <cfelse>
          <cfquery name="getParts"
                   datasource="#Request.DSN#"
                   username="#Request.username#"
                   password="#Request.password#">
            SELECT partNo, partDescr
              FROM tbPart
              ORDER BY partDescr
          </cfquery>

          <h4>Select a Part Description</h4>
          <form action="searchandshowquotes.cfm?#URL.partNo#" method="get">
            <table>
              <tr>
                <th>Parts: </th>
                <td>
                    <select name="partNo">
                      <cfoutput query="getParts">
                        <option value="#partNo#">#partDescr#</option>
                      </cfoutput>
                    </select>
                </td>
               </tr>
               <tr>
                <td span="2">&nbsp;</td>
               </tr>
               <tr>
                <td>&nbsp;</td>
                <td><input name="submit" type="submit" value="Display Quotes" /></td>
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