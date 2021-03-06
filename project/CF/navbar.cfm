    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.cfm">CSCI E-60: Final Project</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="index.cfm">Home</a></li>
            <li><a href="info.cfm">Info</a></li>
            <li class="dropdown">
              <a href="welldata.cfm" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Well Data<span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li><a href="welldata.cfm">Well Data - tabular</a></li>
                <li><a href="wellchart_bywell.cfm">Chart - by Well</a></li>
                <li><a href="wellchart_bypfc.cfm">Chart - by PFC</a></li>
              </ul>
            </li>
            <li><a href="individualdata.cfm">Individual Data</a></li>
            <li><a href="map.cfm">Map</a></li>
            <li class="dropdown">
              <a href="admin.cfm" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Admin<span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li><a href="addwellsample.cfm">Add Well Sample</a></li>
                <li><a href="addparticipant.cfm">Add Participant Record</a></li>
                <li><a href="updateparticipant.cfm">Update/Delete Participant Record</a></li>
                <li><a href="updatewellsample.cfm">Update/Delete Well Sample</a></li>
              </ul>
            </li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>