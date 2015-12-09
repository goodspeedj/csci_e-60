<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Background Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sticky-footer-navbar.css" rel="stylesheet">
  </head>

  <body>
    
    <div class="container">
      <div class="starter-template">
        <cfinclude template = "navbar.cfm">

        <div class="jumbotron">
          <div class="container">
          <h1>Pease Water Contamination</h1>
            <p>Background Information</p>
          </div>
        </div>

        <div class="row">
          <div class="col-md-4">
            <h2>History</h2>
            <p>
              In April 2014 a test of the water from the Haven well on the Pease International Tradeport showed levels of perfluorooctane sulfonic acid (PFOS) above the EPAs 'provisional health advisory.'  No one knows for sure when the contaminate entered the water supply because the first time the city of Portsmouth, NH detected the contaminant was also the first time they had tested for it.  The contamination likely occurred due to the use of firefighting foam on the nearby Air Force base some time between the 1970s and the 1990s.  Two additional wells serve Pease Tradeport and also show PFC contamination, but at levels below the EPAs provisional health advisory.  It should be noted that 10 different PFC chemicals have been found in the well water at Pease, but only two of the chemicals (PFOS and PFOA) have EPA health advisories associated with them.
            </p>
          </div>
          <div class="col-md-4">
            <h2>Effects</h2>
            <p>
              Subsequent testing also found elevated levels of other perfluorochemicals or PFCs including Perfluorooctanoic acid (PFOS) and Perfluorohexanesulphonic acid (PFHxS) among others.  The EPA has classified these chemicals as "contaminants of emerging concern because the risk to human health...may not be known."  These chemicals are also used in a variety of consumer products such as stain repellent and non-stick cookware.  While there are no known human health effects studies on animals have shown impacts to growth and development, reproductive issues, and liver damage.
            </p>
         </div>
          <div class="col-md-4">
            <h2>Action</h2>
            <p>
              Due to overwhelming public concern over the containments the New Hampshire Health and Human Services Department conducted blood testing on individuals exposed to this water, including children from two day care facilities on the former Air Force base.  The first round of testing showed elevated levels of PFCs in the blood of the majority of participants.
            </p>

            <p>
              This application will allow people to view the blood sample results (for these purposes I have inserted some dummy data along with real data) as well as track the ongoing well sampling data from the remaining two wells that still serve the Pease Tradeport.  Additionally there is a map of the Pease Tradeport showing the locations of the wells as well as the participants exposed to the PFCs.
            </p>
          </div>
        </div>

      </div>
    </div><!-- /.container -->

    

     <cfinclude template = "footer.cfm">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>