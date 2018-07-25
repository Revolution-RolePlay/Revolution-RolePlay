@extends('site.index')
@section('content')

<?php
if (isset($_POST['action'])) {
    switch ($_POST['action']) {

    }
}

function CreateNewSection($secid,$class=''){
    $secs=[
        1=>['href'=>'#destinations','label'=>'Choose Destinations'],
        2=>['href'=>'#activities','label'=>'Activities'],
        3=>['href'=>'#accommodation','label'=>'Accommodation'],
        4=>['href'=>'#transportation','label'=>'Transportation'],
        5=>['href'=>'#maspindzeli','label'=>'Choose your Host'],
        6=>['href'=>'#contactinfo','label'=>'Contact Information']
    ];

    if(!isset($secs[$secid])){
        // echo some default behavior or error message
    }else{
        $sec=$secs[$secid]; // merely to shorten the variable
        echo "\n\t\t<li>
                  <a href=\"{$sec['href']}\" data-number=\"{$secid}\" class=\"{$class}\">
                      <span class=\"cd-dot\"></span>
                      <span class=\"cd-label\">{$sec['label']}</span>
                  </a>
                </li>";
    }
}
echo "<nav id=\"cd-vertical-nav\">\n\t<ul>";
for($x=1; $x<7; ++$x){
    CreateNewSection($x);
}    
echo "\n\t</ul>\n</nav>";

$alreadyhaveinterestactbutton = FALSE;

function AddInterestButton($name, $active, $css, $filter)
{
	if($active == 1)
	{
		echo "<button class=\"{$css} active\" data-filter=\"{$filter}\">{$name}</button>";
	}
	if($active == 0)
	{
		echo "<button class=\"{$css}\" data-filter=\"{$filter}\">{$name}</button>";
	}
}
//KVARELIS STATIC LOC - https://www.google.ge/maps/place/Kvareli/@41.9384939,45.8586771,13.04z/data=!4m5!3m4!1s0x4045d9f0c20ba661:0x6be448955176df30!8m2!3d41.9483514!4d45.8147918
function AddDestination($name, $filter, $mapurl, $picurl)
{
	echo " <div class=\"destination-item col-lg-3 col-md-3 col-sm-3 col-xs-6 filter {$filter}\">
            	<div class=\"destination-thumbnail\">
            		<div class=\"destination-caption\">
	                    <div class=\"forsearch\"><h4 class=\"destname\">{$name}</h4></div>
	                    <div class=\"destination-choose\">
	                    <button class=\"btn btn-danger btn-round btn-sm\">
								<i class=\"material-icons\">favorite</i> CHOOSE DESTINATION
							<div class=\"ripple-container\"></div></button>
	                    </div>
	                    <div class=\"row destination-more\">
	                    <div class=\"col-lg-6\"><a href=\"#\"><i class=\"material-icons\">dehaze</i> Read More </a></div>
	                    <div class=\"col-lg-6\"><a href=\"{$mapurl}\" target=\"_blank\"><i class=\"material-icons\">location_on</i> Show on map </a></div>
	                    </div>
	                    <p><a href=\"\" class=\"label label-default hidden\" rel=\"tooltip\" title=\"Read more about this Destination\">READ MORE</a></p>
                	</div>
                	<img src=\"{$picurl}\" class=\"img-rounded img-responsive img-raised\">
            	</div>
            </div> ";
}

function AddActive($name, $imageurl)
{
	echo " <div class=\"activity-item col-lg-3 col-md-3 col-sm-3 col-xs-6 filter hdpe\">
	             <div class=\"activity-thumbnail\">
	            	<div class=\"activity-caption\">
		            	<h4>{$name}</h4>
		                <div class=\"activity-choose\">
		                <button class=\"btn btn-danger btn-round btn-sm\">
							<i class=\"material-icons\">favorite</i> CHOOSE ACTIVITY
						<div class=\"ripple-container\"></div></button>
		            </div>
		            <div class=\"row activity-more\">
		            <div class=\"col-lg-12\"><a href=\"#\"><i class=\"material-icons\">dehaze</i> What's included ?</a></div>
		          </div>
		          <p><a href=\"\" class=\"label label-default hidden\" rel=\"tooltip\" title=\"Read more about this activity\">READ MORE</a></p>
	        		</div>
	             <img src=\"{$imageurl}\" class=\"img-rounded img-responsive img-raised\">
	           </div>
	            </div>";
}            
//https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg
function AddHotel($name, $imageurl, $location)
{
	echo" <div class=\"col-xs-12 col-sm-6 col-md-4 col-lg-4 stay-card\">
				<a href=\"#\">
					<div class=\"thumbnail\">
						<img src=\"{$imageurl}\" alt=\"#\">
							<div class=\"caption\">
							    <h3>
							    	{$name}
							    	<small>
							    		{$location}
							    	</small>
							    </h3>
							    <hr>
							    	<button class=\"btn btn-default\" role=\"button\">View More</button>
							    </div>
							</div>
				</a>
			</div>";
}

?>
<div class="container">
        <div class="row">
        <div id="destinations" class="destination col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <h1 class="destination-title text-center">Destinations</h1>
        </div>

        <div align="center">
            <?php 
            	AddInterestButton("All", 1, "btn btn-default filter-button", "all"); 
            	AddInterestButton("Beach Side", 0, "btn btn-default filter-button", "hdpe");
            	AddInterestButton("Canyons", 0, "btn btn-default filter-button", "sprinkle");
            	AddInterestButton("Mountains", 0, "btn btn-default filter-button", "spray");
            	AddInterestButton("Wine Route", 0, "btn btn-default filter-button", "irrigation");
            ?>
            
        <div class="input-group">
			<span class="input-group-addon"
			<i class="material-icons">search</i>
			</span>
			<div class="form-group is-empty"><input type="text" class="form-control" placeholder="Use this quick search" id="searching-dest"><span class="material-input"></span></div>
		</div>
        </div>
        <br/>
        


			<?php 
				AddDestination("Kvareli", "hdpe", "https://www.google.ge/maps/place/Kvareli/@41.9384939,45.8586771,13.04z/data=!4m5!3m4!1s0x4045d9f0c20ba661:0x6be448955176df30!8m2!3d41.9483514!4d45.8147918", "https://media-cdn.tripadvisor.com/media/photo-s/09/47/24/34/kvareli-lake-resort.jpg");
            	AddDestination("Batumi", "hdpe", "https://www.google.ge/maps/place/Batumi/@41.6026183,41.5590668,12z/data=!3m1!4b1!4m5!3m4!1s0x406786304ea2d221:0x7a3053a9e12ea967!8m2!3d41.6167547!4d41.6367455", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/0873_-_Kaukasus_2014_-_Georgien_-_Batumi_%2817349857412%29.jpg/1200px-0873_-_Kaukasus_2014_-_Georgien_-_Batumi_%2817349857412%29.jpg");
            	AddDestination("Bakuriani", "spray", "https://www.google.ge/maps/place/Bakuriani/@41.7468816,43.5104082,14z/data=!3m1!4b1!4m5!3m4!1s0x404316197e7e1f63:0x74a1b8db49722b50!8m2!3d41.7509723!4d43.5291848", "http://rashitour.com/images/marcopolo-winter-01.jpg");
            	
            ?>
        </div>
    </div>
    

<hr class="featurette-divider">


<div id="activities" class="container">
        <div class="row">
        <div class="destination col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <h1 class="destination-title text-center">Activities</h1>
        </div>
        <?php
        	AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
			AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
			AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
			AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
			AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
			AddActive("Paraplan", "https://media-cdn.tripadvisor.com/media/photo-s/09/2f/b9/9c/crimea-paraplan.jpg");
		?>
</div>

</div>

<hr class="featurette-divider">


<div id="accommodation" class="container">
        <div class="row">
	        <div class="destination col-lg-12 col-md-12 col-sm-12 col-xs-12">
	            <h1 class="destination-title text-center">Accommodation</h1>
	        </div>
        	<div class="col-md-12">
				<div class="profile-tabs">
                    <div class="col-md-2">
						<ul class="nav nav-pills nav-pills-icons nav-stacked" role="tablist">
							<li class="active">
								<a href="#studio" role="tab" data-toggle="tab" aria-expanded="true">
									<i class="material-icons">domain</i>
									Hotels
								</a>
							</li>
							<li class="">
	                            <a href="#work" role="tab" data-toggle="tab" aria-expanded="false">
									<i class="material-icons">location_city</i>
									Apartments
	                            </a>
	                        </li>
	                        <li class="">
	                            <a href="#shows" role="tab" data-toggle="tab" aria-expanded="false">
									<i class="material-icons">hotel</i>
	                                Guest Houses
	                            </a>
	                        </li>
	                    </ul>
					</div>								
	                <div class="col-md-9">
	                    <div class="tab-content gallery">
							<div class="tab-pane active" id="studio">
	                            <div class="row">
								    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 stay-card">
							    		<a href="#">
							    		<div class="thumbnail">
							    		    <img src="http://lorempixel.com/600/400" alt="#">
							    			<div class="caption">
							    				<h3>
							    					Radisson
							    					<small>
							    						Tbilisi
							    					</small>
							    				</h3>
							    				<hr>
							    				<button class="btn btn-default" role="button">View More</button>
							    			</div>
							    		</div>
							    		</a>
							    	</div>
									<?php
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
											AddHotel("Radisson", "https://media-cdn.tripadvisor.com/media/photo-o/0e/d5/8e/98/hotel-carlos-i.jpg", "Tbilisi");
									?>	

							    	<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 stay-card">
							    		<a href="#">
							    		<div class="thumbnail">
							    		    <img src="http://lorempixel.com/600/400" alt="#">
							    			<div class="caption">
							    				<h3>
							    					Lorem ipsum
							    					<small>
							    						Lorem ipsum dolor sit amet
							    					</small>
							    				</h3>
							    				<hr>
							    				<button class="btn btn-default" role="button">View More</button>
							    			</div>
							    		</div>
							    		</a>
							    	</div>
							    	<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 stay-card">
							    		<a href="#">
							    		<div class="thumbnail">
							    		    <img src="http://lorempixel.com/600/400" alt="#">
							    			<div class="caption">
							    				<h3>
							    					Lorem ipsum
							    					<small>
							    						Lorem ipsum dolor sit amet
							    					</small>
							    				</h3>
							    				<hr>
							    				<button class="btn btn-default" role="button">View More</button>
							    			</div>
							    		</div>
							    		</a>
							    	</div>
								</div>
	                        </div>
	                        <div class="tab-pane text-center" id="work">
								<div class="row">
									<div class="col-md-6">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris5.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris7.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris9.jpg" class="img-rounded">
									</div>
									<div class="col-md-6">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris6.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris8.jpg" class="img-rounded">
									</div>
								</div>
	                        </div>
							<div class="tab-pane text-center" id="shows">
								<div class="row">
									<div class="col-md-6">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris4.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris6.jpg" class="img-rounded">
									</div>
									<div class="col-md-6">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris7.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris5.jpg" class="img-rounded">
										<img src="http://demos.creative-tim.com/material-kit/assets/img/examples/chris9.jpg" class="img-rounded">
									</div>
								</div>
	                        </div>
						 </div>
						 <ul class="pagination pagination-info">
							<li><a href="javascript:void(0);">&lt; prev</a></li>
							<li><a href="javascript:void(0);">1</a></li>
							<li><a href="javascript:void(0);">2</a></li>
							<li class="active"><a href="javascript:void(0);">3</a></li>
							<li><a href="javascript:void(0);">4</a></li>
							<li><a href="javascript:void(0);">5</a></li>
							<li><a href="javascript:void(0);">next &gt;</a></li>
	                    </ul>
	                    </div>
					</div>
				</div>
				<!-- End Profile Tabs -->
			<!-- Tabs on Plain Card -->

        	
        	
		</div>

</div>

</div>



<hr class="featurette-divider">


<div id="transportation" class="container">
        <div class="row">
        <div class="destination col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <h1 class="destination-title text-center">Transporation</h1>
        </div>
        	<div class="destination-item col-lg-4 col-md-4 col-sm-4 col-xs-6 filter hdpe">
                <img src="http://fakeimg.pl/365x180/" class="img-rounded img-responsive img-raised">
            </div>

            <div class="destination-item col-lg-4 col-md-4 col-sm-4 col-xs-6 filter sprinkle">
                <img src="http://fakeimg.pl/365x180/" class="img-rounded img-responsive img-raised">
            </div>

            <div class="destination-item col-lg-4 col-md-4 col-sm-4 col-xs-6 filter hdpe">
                <img src="http://fakeimg.pl/365x180/" class="img-rounded img-responsive img-raised">
            </div>


</div>

</div>

<hr class="featurette-divider">


      <div class="container">
        <h1 class="text-center destination-title">Choose Your Host</h1>
        <div class="col-lg-4">
          
          <div class="card card-profile">
	    							<div class="card-avatar">
	    								<a href="#pablo">
	    									<img class="img" src="https://randomuser.me/api/portraits/men/44.jpg">
	    								</a>
	    							</div>

	    							<div class="content">
	    								<h6 class="category text-gray">Culture Lovva</h6>

	    								<h4 class="card-title">HARRY DOMUNA</h4>

	    								<p class="card-description">
	    									Don't be scared of the truth because we need to restart the human foundation in truth And I love you like Kanye loves Kanye I love Rick Owens’ bed design but the back is...
	    								</p>
	    								<a href="#pablo" class="btn btn-info btn-round">Request Host</a>
	    							</div>
	    						</div>
          
          
        </div>
        
        <div class="col-lg-4">
          
          <div class="card card-profile">
	    							<div class="card-avatar">
	    								<a href="#pablo">
	    									<img class="img" src="https://randomuser.me/api/portraits/women/10.jpg">
	    								</a>
	    							</div>

	    							<div class="content">
	    								<h6 class="category text-gray">Mount Maniac</h6>
	    								<h4 class="card-title">EVA RODRIGUEZ</h4>

	    								<p class="card-description">
	    									Don't be scared of the truth because we need to restart the human foundation in truth And I love you like Kanye loves Kanye I love Rick Owens’ bed design but the back is...
	    								</p>
	    								<a href="#pablo" class="btn btn-info btn-round">Request Host</a>
	    							</div>
	    						</div>
          
          
        </div><div class="col-lg-4">
          
          <div class="card card-profile">
	    							<div class="card-avatar">
	    								<a href="#pablo">
	    									<img class="img" src="https://randomuser.me/api/portraits/men/84.jpg">
	    								</a>
	    							</div>

	    							<div class="content">
	    								<h6 class="category text-gray">Gastro Master</h6>

	    								<h4 class="card-title">ALEC THOMPSON</h4>

	    								<p class="card-description">
	    									Don't be scared of the truth because we need to restart the human foundation in truth And I love you like Kanye loves Kanye I love Rick Owens’ bed design but the back is...
	    								</p>
	    								<a href="#pablo" class="btn btn-info btn-round">Request Host</a>
	    							</div>
	    						</div>
          
          
        </div>
</div>
</div>



<hr class="featurette-divider">

      <div class="container">
        <h1 class="text-center destination-title">About You</h1>

<div class="col-sm-5">
	<div class="input-group">
		<span class="input-group-addon">
			<i class="material-icons">perm_identity</i>
		</span>
		<div class="form-group is-empty"><input type="text" class="form-control" placeholder="Type your Name and Surname"><span class="material-input"></span></div>
	</div>
</div>

<div class="col-sm-3">
	<div class="input-group">
		<span class="input-group-addon">
			<i class="material-icons">phone</i>
		</span>
		<div class="form-group is-empty"><input type="text" class="form-control" placeholder="Type your phone number"><span class="material-input"></span></div>
	</div>
</div>

<div class="col-sm-3">
	<div class="input-group">
		<span class="input-group-addon">
			<i class="material-icons">email</i>
		</span>
		<div class="form-group is-empty"><input type="text" class="form-control" placeholder="Type your email"><span class="material-input"></span></div>
	</div>
</div>



<br>
<div class="text-center generate">
	<div class="form-group label-floating">
		<a href="http://trip2.ge/en/generate" class="btn btn-danger">GENERATE TRIP<div class="ripple-container"></div></a>
	</div>
</div>


</div>
@endsection