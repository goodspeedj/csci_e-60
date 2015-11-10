<!DOCTYPE html>
<html>
  <head>
    <title>Project #2</title>
  </head>

  <body>
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
  </body>
</html>