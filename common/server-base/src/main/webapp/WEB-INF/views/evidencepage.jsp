<%
// added to overcome double quotes issue
String keywords="";
if(request.getParameter("keyword")!=null) {
keywords = request.getParameter("keyword");
keywords = keywords.replaceAll("^\"|\"$", "###");
}
// added to display evidencepage API - query summary above rendered network
String datasetDescription= "Discover the <a target='_blank' href='https://knetminer.org' style='color:darkOrange'>KnetMiner</a> knowledge network for the top <b>genes</b> linked to your <b>evidence term</b>. <u>Tip:</u> <i>Right-click-hold</i> on nodes to add labels or to show their properties. Use the Interactive Legend to add (<i>single-click</i>) or hide (<i>double-click</i>) other types of information to/from the network.";
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="https://knetminer.rothamsted.ac.uk/KnetMaps/css_demo/index-style.css">
<link rel="stylesheet" type="text/css" href="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/css/knetmaps.css"/>
<script type="text/javascript" src="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/js/knetmaps-lib.min.js"></script>
<script type="text/javascript" src="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/js/knetmaps.min.js"></script>
<title>KnetMiner network</title>
</head>
<body>
   <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
	   <a target="_blank" href="https://knetminer.org"><img class="logo-top" src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/logo-regular.png" height="48" alt="Logo"></a>   
       <ul class="nav navbar-nav" id="top">
          <li>
		    <a target="_blank" href="https://pub.uni-bielefeld.de/publication/2915227">Cite Us</a>
            <a target="_blank" href="http://knetminer.rothamsted.ac.uk/KnetMiner/KnetMiner_Tutorial-v3.1.pdf">User Guide</a>
		    <a target="_blank" href="https://github.com/Rothamsted/KnetMiner/issues">Report Issues</a>
		  </li>
    </ul>
 	</nav>  <!-- end navbar -->
 
<div id="content">
    <div id="dataset-description"><p id="dataset-desc"><%=datasetDescription%></p></div><br/>
	<!-- KnetMaps -->
	<div id="knetmap"></div>
</div>  <!-- content -->

       <div class="contact-footer">
	      <ul style="overflow:hidden;margin-bottom: 0px;">
		     <li class="left-footer">
			   <a target="_blank" title="Rothamsted Research" href="http://www.rothamsted.ac.uk/" class="logos"><img src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/rothamsted_logo.png" width="80" height="80"/></a>
			   <a target="_blank" title="BBSRC" href="http://www.bbsrc.ac.uk/" class="logos"><img class="bbsrc-logo" src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/bbsrc_logo.png"/></a>
			 </li>
		     <li class="center-footer">
			   <a target="_blank" title="KnetMaps" href="https://f1000research.com/articles/7-1651/v1" class="logos"><img src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/knetmaps.jpg" width="380" height="82"/></a>
			   <!--<p id="footer-text">Powered by <a target="_blank" href="https://f1000research.com/articles/7-1651/v1" style="color:darkOrange">KnetMaps.js</a></p>
			   <p id="footer-text-sub">Supported by the UK Biotechnology and Biological Sciences Research Council</p>-->
			 </li>
			 <li class="right-footer">
			   <ul class="nav navbar-nav" id="bottom">
			     <li>
				   <a target="_blank" href="https://www.npmjs.com/package/knetmaps">NPM</a>
				   <a target="_blank" href="https://github.com/Rothamsted/knetmaps.js/blob/master/LICENSE">License</a>
				   <a target="_blank" href="https://twitter.com/knetminer">Twitter</a>
				 </li>
			   </ul>
			 </li>
		  </ul>
       </div>

	<script type="text/javascript">
		$.ajax({
            url: "evidencePath",
            type: "post",
            headers: {
                "Accept": "application/json; charset=utf-8",
                "Content-Type": "application/json; charset=utf-8"
            },
            dataType: "json",
            data: JSON.stringify({
                keyword: "<%=keywords%>",
                list: ${list}
            })
        }).success(function (data) {
            KNETMAPS.KnetMaps().drawRaw("#knetmap", data.graph);
        });
		</script>
</body>
</html>
