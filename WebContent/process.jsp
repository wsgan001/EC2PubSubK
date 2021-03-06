<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.compute.Engine"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>
<%@ page import="com.amazonaws.services.kinesis.model.Record"%>
<%@ page import="java.nio.charset.Charset"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="com.pubsub.model.Publication"%>





<%
	

	System.out.println("Amazon EC2 Publish/Subscribe");
	System.out.println("Streaming Service");
	System.out.println("--------------------------------------");

	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Demonstration">
<meta name="author" content="Y.S.Horawalavithana">

<title>EC2 Publish/Subscribe</title>

<!-- Bootstrap Core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="css/sb-admin.css" rel="stylesheet">

<!-- Morris Charts CSS -->
<link href="css/plugins/morris.css" rel="stylesheet">

<!-- Custom Fonts -->
<link href="font-awesome-4.1.0/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">

	<!-- jQuery Version 1.11.0 -->
	<script src="js/jquery-1.11.0.js"></script>
	
	<script type="text/javascript" src="js/control.js"></script>

  <!-- Include Flotchart.org scripts and dependencies -->
  <!--[if lte IE 8]><script language="javascript" type="text/javascript" src="flot-0.8.2/excanvas.min.js"></script><![endif]-->
  <script src="js/flot-0.8.2/jquery.min.js"></script>
  <script src="js/flot-0.8.2/jquery.flot.min.js"></script>
  <script src="js/flot-0.8.2/jquery.flot.time.min.js"></script>

  <!-- Include graph script and stylesheet -->
  <script src="js/graph.js"></script>
  
  <link rel="stylesheet" href="css/graph.css" type="text/css"></link>

</head>
<body>
	<%
		//allow access only if session exists		
		Boolean isLoggedIn = false;
		String userName = "Hacker!!";
		String sessionID = "Hacker!!!";

		if (session.getAttribute("isLoggedIn") == null) {
			response.sendRedirect("welcome.jsp");
			return;
		} else {
			isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");

			if (isLoggedIn) {
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (Cookie cookie : cookies) {
						if (cookie.getName().equals("user"))
							userName = cookie.getValue();
						if (cookie.getName().equals("JSESSIONID"))
							sessionID = cookie.getValue();
					}
				}

			} else {
				response.sendRedirect("welcome.html");
				return;
			}
		}

		System.out.println("User Authorized Flag: " + isLoggedIn
				+ " User: " + userName + " sessionID: " + sessionID);
	%>



	<div id="wrapper">

		<!-- Navigation -->
		<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-ex1-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="about.jsp">About the project</a>
			</div>
			<!-- Top Menu Items -->
			<ul class="nav navbar-right top-nav">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"><i class="fa fa-envelope"></i> <b
						class="caret"></b></a>
					<ul class="dropdown-menu message-dropdown">
						<!-- <li class="message-preview">
                            <a href="#">
                                <div class="media">
                                    <span class="pull-left">
                                        <img class="media-object" src="http://placehold.it/50x50" alt="">
                                    </span>
                                    <div class="media-body">
                                        <h5 class="media-heading"><strong>Log in</strong>
                                        </h5>
                                        <p class="small text-muted"><i class="fa fa-clock-o"></i> Yesterday at 4:32 PM</p>
                                        <p>Lorem ipsum dolor sit amet, consectetur...</p>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="message-preview">
                            <a href="#">
                                <div class="media">
                                    <span class="pull-left">
                                        <img class="media-object" src="http://placehold.it/50x50" alt="">
                                    </span>
                                    <div class="media-body">
                                        <h5 class="media-heading"><strong>John Smith</strong>
                                        </h5>
                                        <p class="small text-muted"><i class="fa fa-clock-o"></i> Yesterday at 4:32 PM</p>
                                        <p>Lorem ipsum dolor sit amet, consectetur...</p>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="message-preview">
                            <a href="#">
                                <div class="media">
                                    <span class="pull-left">
                                        <img class="media-object" src="http://placehold.it/50x50" alt="">
                                    </span>
                                    <div class="media-body">
                                        <h5 class="media-heading"><strong>John Smith</strong>
                                        </h5>
                                        <p class="small text-muted"><i class="fa fa-clock-o"></i> Yesterday at 4:32 PM</p>
                                        <p>Lorem ipsum dolor sit amet, consectetur...</p>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="message-footer">
                            <a href="#">Read All New Messages</a>
                        </li> -->
					</ul></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"><i class="fa fa-bell"></i> <b
						class="caret"></b></a>
					<ul class="dropdown-menu alert-dropdown">
						<!-- <li>
                            <a href="#">Alert Name <span class="label label-default">Alert Badge</span></a>
                        </li>
                        <li>
                            <a href="#">Alert Name <span class="label label-primary">Alert Badge</span></a>
                        </li>
                        <li>
                            <a href="#">Alert Name <span class="label label-success">Alert Badge</span></a>
                        </li>
                        <li>
                            <a href="#">Alert Name <span class="label label-info">Alert Badge</span></a>
                        </li>
                        <li>
                            <a href="#">Alert Name <span class="label label-warning">Alert Badge</span></a>
                        </li>
                        <li>
                            <a href="#">Alert Name <span class="label label-danger">Alert Badge</span></a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">View All</a>
                        </li> -->
					</ul></li>

				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"><i class="fa fa-user"></i> Profile <%=userName%><b
						class="caret"></b></a>



					<ul class="dropdown-menu">
						<li><a href="#"><i class="fa fa-fw fa-user"></i> Profile</a>
						</li>
						<li><a href="#"><i class="fa fa-fw fa-envelope"></i>
								Inbox</a></li>
						<li><a href="#"><i class="fa fa-fw fa-gear"></i> Settings</a>
						</li>
						<li class="divider"></li>
						<li>
							<form id="logOutForm" method="post" action="alogout">
								<!-- <button type="submit" class="btn btn-danger">Publish Stream</button> -->
								<button id="blogout" type="submit" class="btn btn-danger">Log
									Out</button>
							</form>

						</li>
					</ul></li>
			</ul>
			<!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<ul class="nav navbar-nav side-nav">
					<li class="active"><a href="index.jsp"><i
							class="fa fa-fw fa-dashboard"></i> Dashboard</a></li>
					<li><a href="#"><i class="fa fa-fw fa-table"></i> Virtual
							Private Cloud</a></li>
					<li><a href="#"><i class="fa fa-fw fa-edit"></i> Load
							Balancer</a></li>
					<li><a href="#"><i class="fa fa-fw fa-desktop"></i> Queue
							Service</a></li>
					<li><a href="#"><i class="fa fa-fw fa-wrench"></i>
							Notification Service</a></li>					
					<li><a href="javascript:;" data-toggle="collapse"
						data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i>
							Streaming Service <i class="fa fa-fw fa-caret-down"></i></a>
						<ul id="demo" class="collapse">
							<li><a href="stream.jsp">Generate</a></li>
							<li><a href="processstream.jsp">Process</a></li>
						</ul></li>
					<li><a href="javascript:;" data-toggle="collapse"
						data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i>
							History <i class="fa fa-fw fa-caret-down"></i></a>
						<ul id="demo" class="collapse">
							<li><a href="#">Active Subscription</a></li>
							<li><a href="#">Delivered Publications</a></li>
						</ul></li>
					<!-- <li>
                        <a href="charts.html"><i class="fa fa-fw fa-bar-chart-o"></i> Charts</a>
                    </li>
                    <li>
                        <a href="tables.html"><i class="fa fa-fw fa-table"></i> Tables</a>
                    </li>
                    <li>
                        <a href="forms.html"><i class="fa fa-fw fa-edit"></i> Forms</a>
                    </li>
                    <li>
                        <a href="bootstrap-elements.html"><i class="fa fa-fw fa-desktop"></i> Bootstrap Elements</a>
                    </li>
                    <li>
                        <a href="bootstrap-grid.html"><i class="fa fa-fw fa-wrench"></i> Bootstrap Grid</a>
                    </li>
                    <li>
                        <a href="javascript:;" data-toggle="collapse" data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i> Dropdown <i class="fa fa-fw fa-caret-down"></i></a>
                        <ul id="demo" class="collapse">
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="blank-page.html"><i class="fa fa-fw fa-file"></i> Blank Page</a>
                    </li> -->
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</nav>

		<div id="page-wrapper">

			<div class="container-fluid">

				<!-- Page Heading -->
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">
							Amazon EC2 Top-k Publish/Subscribe <small> Live Streaming
								Details</small>
						</h1>
						<ol class="breadcrumb">
							<li class="active"><i class="fa fa-dashboard"></i> Dashboard
							</li>
						</ol>
					</div>
				</div>
				<!-- /.row -->




				 <div class="row"> 									
							
									
								
								

								
								<div class="col-xs-12 col-sm-6 col-md-8">
									<div class="input-group">
										<form id="processStream">											
											<button type="submit" class="btn btn-danger btn-lg">Process
												Generated Stream</button>
										</form>
										
									</div>
									<!-- /input-group -->
								</div>
								<!-- /.col-lg-6 -->


					
					





				</div>




				<div class="row">

					<div id="description"></div>
					<div id="graph"></div>
					<div id="updatedBy"></div>
					<div id="topNContainer">
						<div id="topNDescription"></div>
						<div id="topN"></div>
					</div>



				</div>

			</div>
			<!-- /.container-fluid -->

		</div>
		<!-- /#page-wrapper -->

	</div>
	<!-- /#wrapper -->

	

	<!-- Bootstrap Core JavaScript -->
	<script src="js/bootstrap.min.js"></script>

	
</body>
</html>
