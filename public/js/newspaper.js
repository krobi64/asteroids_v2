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
    $('.flybyContents').append('&nbsp;<a href="http://minorplanetcenter.net/asteroid_explorers/show/'+data.orbit_diagram.asteroid_id+'" target="_blank" style="text-decoration:underline">More Details</a>');
    $('.storyTitle').html(data.news_story.title);
    $('.storyContents').html(data.news_story.content);
    $('.storyContents').append('&nbsp;<a href="'+data.news_story.url+'" target="_blank" style="text-decoration:underline">Read More</a>');
    $('#entityId').val(data.id);
    $('.numberShares').html(data.shares);

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
// datestring: 2016-07-11
function getNewspaperByDay(datestring) {
    $.ajax({
        type: 'GET',
        url: "http://localhost:3000/editions/day/" + datestring,
        contentType: "application/json; charset=UTF-8",
        success: function(edition, status, error) {
            console.log( "success ",  edition );
            displayNewspaper(edition);
        },
        error: function(res, status, error) {
            console.log( "error: ", error );
        }
    });
}

// get the newspaper content for current edition
function getNewspaper() {
    $.ajax({
        type: 'GET',
        url: "http://localhost:3000/editions/current",
        contentType: "application/json; charset=UTF-8",
        success: function(edition, status, error) {
            console.log( "success ",  edition );
	        displayNewspaper(edition);
        },
        error: function(res, status, error) {
            console.log( "error: ", error );
        }
    });
}

// populate contents for social media
function populateSocialcontent(url){
    $('.rrssb-buttons').rrssb({
        // required:
        title: 'Get your daily dose of #asteroid today with @MinorPlanetCtr\'s #DailyMinorPlanet:',
        url: url
  });
}

// record social sharing
function shareNewspaper(channel) {
    var editionId = $('#entityId')[0].value;
    var payload = {};
    payload.channel = channel;

    $.ajax({
        type: 'PUT',
        url: "http://localhost:3000/editions/"+editionId+"/share",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify(payload),
        dataType: "json",
        success: function(edition, status, error) {
            console.log( "success ",  edition );
        },
        error: function(res, status, error) {
            console.log( "error: ", error );
        }
    });    
}


// detect WebGL setting of browser
function webgl_detect(return_context)
{
    if (!!window.WebGLRenderingContext) {
        var canvas = document.createElement("canvas"),
             names = ["webgl", "experimental-webgl", "moz-webgl", "webkit-3d"],
           context = false;

        for(var i=0;i<4;i++) {
            try {
                context = canvas.getContext(names[i]);
                if (context && typeof context.getParameter == "function") {
                    // WebGL is enabled
                    if (return_context) {
                        // return WebGL object if the function's argument is present
                        return {name:names[i], gl:context};
                    }
                    // else, return just true
                    return true;
                }
            } catch(e) {}
        }

        // WebGL is supported, but disabled
        return false;
    }

    // WebGL not supported
    return false;
}

function modern_theme(){
    if(!$('#themeModern').hasClass('selected')){
        $('#modern').removeClass('hide');
        $('#classic').addClass('hide');
        $('#themeModern').addClass('selected');
        $('#themeClassic').removeClass('selected');
        if($('#modern iframe').length == 0) modernIframe(diagramUrl);
    }
    $('#share-buttons').removeClass('classic');
    $('#share-buttons').addClass('modern');     
    $('#subscribe-btn').removeClass('classic');
    $('#subscribe-btn').addClass('modern');
    var top = $('#modern .subHeaderline').position().top-8;
    $('#share-buttons').css('top',top);
}

function classic_theme(){
    if(!$('#themeClassic').hasClass('selected')){
        $('#classic').removeClass('hide');
        $('#modern').addClass('hide');
        $('#themeClassic').addClass('selected');
        $('#themeModern').removeClass('selected');
        if($('#classic iframe').length == 0) classicIframe(diagramUrl);
    }
    $('#share-buttons').removeClass('modern');
    $('#share-buttons').addClass('classic');
    $('#subscribe-btn').addClass('classic');
    $('#subscribe-btn').removeClass('modern');
    var top = $('#classic .subHeaderline').position().top-8;
    $('#share-buttons').css('top',top);
}

function modernIframe(diagramUrl){
    if( webgl_detect()) {
        // properly set iframe width and height
        var diagramWidth = window.innerWidth*0.50;
        var iframeWidth = diagramWidth + 80;
        var iframeHeight = 800;
        var legendContent = '<div class="legendncredit"> <ul> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(139,69,19)"></div>Mecury</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(120,120,120)"></div>Venus</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(102,178,255)"></div>Earth</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(253,255,56)"></div>Asteroid</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(170,0,0)"></div>Mars</li> <li>&#169; Minor Planet Center</li> </ul> </div>';
        var iframeContent = '<iframe scrolling="no" src="'+diagramUrl+'" style="width:'+iframeWidth+'px;height:'+iframeHeight+'px"></iframe>';
        $('#modern .diagram').html(legendContent+iframeContent);
    }
}

function classicIframe(diagramUrl){
    if( webgl_detect()) {
        // properly set iframe width and height
        var diagramWidth = window.innerWidth*0.35;
        var iframeWidth = diagramWidth + 80;
        var iframeHeight = 800;
        var legendContent = '<div class="legendncredit"> <ul> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(139,69,19)"></div>Mecury</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(120,120,120)"></div>Venus</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(102,178,255)"></div>Earth</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(253,255,56)"></div>Asteroid</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(170,0,0)"></div>Mars</li> <li>&#169; Minor Planet Center</li> </ul> </div>';
        var iframeContent = '<iframe scrolling="no" src="'+diagramUrl+'" style="width:'+iframeWidth+'px;height:'+iframeHeight+'px"></iframe>';
        $('#classic .diagram').html(legendContent+iframeContent);
    }
}


// subscribe
$(function() { //shorthand document.ready function
    $('#subscription_form').on('submit', function(e) { 
        console.log('submit');
        e.preventDefault();  //prevent form from submitting

        var data = {};
        var uname = $('#inputName')[0].value;
        var uemail = $('#inputEmail')[0].value;
        if( uname != null && uemail != null ) {
            data.username = uname;
            data.email = uemail;
            console.log(data); 

            var msgContent = $('.modal-content').html();
                        
            // post to backend
            $.ajax({
                type: 'POST',
                url: "http://localhost:3000/subscribe",
                data: JSON.stringify(data),
                contentType: "application/json; charset=UTF-8",
                dataType: "json",
                success: function(res, status, error) {
                    console.log( "success ",  res );

                    // Confirmation message on popup UI
                    var title = "Confirm your email address";
                    var content = "<div style='font-size:1em;'>" + 
                        "Click on the link in the email to activate your subscription. We do this as a security precaution. " + 
                        "If you don't see the email, please check your junk mail folder. <br><br>" + 
                        "<strong>Thank you for subscribing Daily Minor Planet!</strong><br><br>" + 
                        "<button type='button' class='btn btn-default' data-dismiss='modal'>Close</button></div>";
                    


                    $('#subscription_form').parent().parent().find('.modal-title').text(title);
                    $('#subscription_form').parent().html(content);

                    // self-dismiss after some time
                    // setTimeout(function(){$('.modal').modal('hide');}, 4000);
                },
                error: function(res, status, error) {
                    console.log( "error: ", error );

                    var title = "Subscription failed";
                    $('#subscription_form').parent().parent().find('.modal-title').text(title);

                    $('#subscription_form').parent().html("<div style='font-size:1em;'>" + error +
                        "<br><br><button type='button' class='btn btn-default' data-dismiss='modal'>Close</button></div>");

                    // self-dismiss after some time
                    setTimeout(function(){$('.modal').modal('hide');}, 4000);
                }
            });
        }
    });

    $('.popup').on('click', function(e){
        var channel = e.currentTarget.id;
        shareNewspaper(channel);
    });
});
