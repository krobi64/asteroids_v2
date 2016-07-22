// newspaper.js
// functions for facilitating newspaper rendering

var dayOfWeek = ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var fixdata = {
	tagline:"The nerve center of asteroid detection in our Solar System",
	est:"Est. 1947",
	diagram:"diagram.png"
};

// plugin live data into the display
function displayNewspaper(data) {
	// fixed 
	$('.tagline').html(fixdata.tagline);
	$('.est').html(fixdata.est);

	// live
    $('.heroline').html(data.title);
    $('.flybyTitle').html(data.flyby.title);
    $('.flybyContents').html(data.flyby.content);
    $('.storyTitle').html(data.news_story.title);
    $('.storyContents').html(data.news_story.content);

	// TODO: use the live image URL    
	// $('.diagram').css('background-image','url('+ data.orbit_diagram.url + ')');
    $('.diagram').css('background-image','url(/images/diagram.png)');
    $('.mobile-diagram').css('background-image','url(/images/diagram.png');

    var today = new Date(data.publish_date);
    data.year = today.getFullYear();
    data.date = today.getDate();
    data.dayofweek = dayOfWeek[today.getDay()];
    data.month = monthNames[today.getMonth()];

    $('.day').html(data.date);
    $('.month').html(data.month);
    $('.year').html(data.year);
    $('.dayofweek').html(data.dayofweek);
}

// get the newspaper content for current edition
function getNewspaper() {
    $.ajax({
        type: 'GET',
        url: "http://localhost:3000/editions/current",
        contentType: "application/json: charset=UTF-8",
        success: function(edition, status, error) {
            console.log( "success ",  edition );
	        displayNewspaper(edition);
        },
        error: function(res, status, error) {
            console.log( "error: ", error );
        }
    });
}

// subscribe
$(function() { //shorthand document.ready function
    $('#subscription_form').on('submit', function(e) { 
        e.preventDefault();  //prevent form from submitting
        // var data = $("#subscription_form :input").serializeArray();
        var data = {};
        var uname = $('#inputName')[0].value;
        var uemail = $('#inputEmail')[0].value;
        
        if( uname != null && uemail != null ) {
        	data.username = uname;
        	data.email = uemail;
	
	        console.log(data); 
        	// post to backend
	        $.ajax({
	            type: 'POST',
	            url: "http://localhost:3000/subscribe",
	            data: JSON.stringify(data),
	            contentType: "application/json; charset=UTF-8",
	            dataType: "json",
	            success: function(res, status, error) {
	                console.log( "success ",  res );
	            },
	            error: function(res, status, error) {
	                console.log( "error: ", error );
	            }
	        });
        }
    });
});
