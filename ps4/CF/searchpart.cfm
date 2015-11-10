<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Project #2</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>
    <cfinclude template = "navbar.cfm">
    <cfquery name="getParts"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT partNo, partDescr
        FROM tbPart
        ORDER BY partDescr;
    </cfquery>

    <cfquery name="getQuotes"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT vendorNo, vendorName, a.priceQuote 
        FROM tbVendor 
        NATURAL JOIN tbQuote a 
        JOIN tbPart b ON (a.partNo = b.partNo) 
        WHERE (SELECT count(priceQuote) FROM tbQuote c 
                WHERE a.partNo = c.partNo 
                GROUP BY a.partNo) > 1  
        AND b.partDescr = 'Tub';
    </cfquery>

    <div class="container">

      <div class="starter-template">
        <h4>Select a Part Description</h4>
        <form action="showquotes.cfm" method="post">
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
              <td>&nbsp;</td>
              <td><input name="submit" type="submit" value="Display Quotes" /></td>
             </tr>
           </table>
         </form>
      </div>

    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>