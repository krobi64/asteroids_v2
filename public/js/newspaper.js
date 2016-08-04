// newspaper.js
// functions for facilitating newspaper rendering

var dayOfWeek = ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var fixdata = {
	tagline:"The nerve center of asteroid detection in our Solar System",
	est:"Est. 1947",
	diagram:"diagram.png"
};
var currentTheme = "modern";
var interactiveUrl = "";

// plugin live data into the display
function displayNewspaper(data) {
	// fixed
	$('.tagline').html(fixdata.tagline);
	$('.est').html(fixdata.est);

	// live
    $('.heroline').html(data.title);
    $('.flybyTitle').html(data.flyby.title);
    $('.flybyContents').html(data.flyby.content);
    $('.flybyContents').append('&nbsp;<a href="http://minorplanetcenter.net/db_search/show_object?object_id='+data.orbit_diagram.asteroid_id+'" target="_blank" style="text-decoration:underline">More Details</a>');
    $('.storyTitle').html(data.news_story.title);
    $('.storyContents').html(data.news_story.content);
    $('.storyContents').append('&nbsp;<a href="'+data.news_story.story_url+'" target="_blank" style="text-decoration:underline">Read More</a>');
    $('#entityId').val(data.id);
    $('.numberShares').html(data.shares);
    var theme = data.theme.name;
    if( theme === "classic") {
        classic_theme();
    }
    else if (theme === "modern") {
        modern_theme();
    }

    var today = new Date(data.publish_date);
    data.year = today.getFullYear();
    data.date = today.getDate();
    data.dayofweek = dayOfWeek[today.getDay()];
    data.month = monthNames[today.getMonth()];

    $('.day').html(data.date);
    $('.month').html(data.month);
    $('.year').html(data.year);
    $('.dayofweek').html(data.dayofweek);

	// TODO: use the live image URL
    // The image URL is generated at backend by commandline and named as "/images/orbit/2016-07-21.png" convention
    var static_image_url = "/images/orbit/" + data.publish_date.substring(0,10) + ".png";
    $('.diagram').css('background-image','url("'+ static_image_url +'")');
    $('.mobile-diagram').css('background-image','url("' + static_image_url + '")');
}

// get the newspaper content for current edition
// datestring: 2016-07-11
function getNewspaperByDay(datestring) {
    $.ajax({
        type: 'GET',
        url: "/editions/day/" + datestring,
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
        url: "/editions/current",
        contentType: "application/json; charset=UTF-8",
        success: function(edition, status, error) {
            console.log( "success ",  edition );

            // ask backend for more asteroid properties for interactive diagram rendering
            getInteractiveUrl(edition.orbit_diagram.asteroid_id);

	        displayNewspaper(edition);
        },
        error: function(res, status, error) {
            console.log( "error: ", error );
        }
    });
}

// http://minorplanetcenter.net/db_search/show_orbit?utf8=%E2%9C%93&object_id=2008+VA15&epoch=2016-07-31.0&number=&designation=2008+VA15&name=&peri=96.8053975&m=137.95785&node=335.1056427&incl=1.82044&e=0.303886146&a=1.4499345&commit=Interactive+Orbit+Sketch
function showInteractive(orbit) {
    var aURL = "/db_search/show_orbit_dmp?utf8=%E2%9C%93";

    for( var key in orbit ) {
        if( orbit.hasOwnProperty(key) ) {
            var val = orbit[key];
            aURL = aURL + "&" + key + "=" + encodeURIComponent(val);
        }
    }

    console.log("interactive url: " + aURL);
    interactiveUrl = aURL;

    if( currentTheme === "modern" ) {
        modernIframe(interactiveUrl);
    }
    else if( currentTheme === "classic" ) {
        classicIframe(interactiveUrl);
    }

}

function getInteractiveUrl(designation) {
    var formatted = encodeURIComponent(designation);
    $.ajax({
        type: 'GET',
        url: "/flyby2/orbit_params?designation="+formatted,
        contentType: "application/json; charset=UTF-8",
        dataType: "json",
        success: function(orbit, status, error) {
            console.log( "success ",  orbit );
            showInteractive(orbit);
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
        url: "/editions/"+editionId+"/share",
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
                        // return WebGL object if the function's argument exists
                        return {name:names[i], gl:context};
                    }
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
        if($('#modern iframe').length == 0) modernIframe(interactiveUrl);
    }
    $('#share-buttons').removeClass('classic');
    $('#share-buttons').addClass('modern');
    $('#subscribe-btn').removeClass('classic');
    $('#subscribe-btn').addClass('modern');
    if( $('#modern .subHeaderline').position() !== undefined ) {
        var top = $('#modern .subHeaderline').position().top-8;
        $('#share-buttons').css('top',top);
    }
    currentTheme = "modern";
}

function classic_theme(){
    if(!$('#themeClassic').hasClass('selected')){
        $('#classic').removeClass('hide');
        $('#modern').addClass('hide');
        $('#themeClassic').addClass('selected');
        $('#themeModern').removeClass('selected');
        if($('#classic iframe').length == 0) classicIframe(interactiveUrl);
    }
    $('#share-buttons').removeClass('modern');
    $('#share-buttons').addClass('classic');
    $('#subscribe-btn').addClass('classic');
    $('#subscribe-btn').removeClass('modern');
    if( $('#classic .subHeaderline').position() !== undefined ) {
        var top = $('#classic .subHeaderline').position().top-8;
        $('#share-buttons').css('top',top);
    }
    currentTheme = "classic";
}

function modernIframe(diagramUrl){
    if( webgl_detect()) {
        var legendContent = '<div class="legendncredit"> <ul> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(139,69,19)"></div>Mecury</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(120,120,120)"></div>Venus</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(102,178,255)"></div>Earth</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(253,255,56)"></div>Asteroid</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(170,0,0)"></div>Mars</li> <li>&#169; Minor Planet Center</li> </ul> </div>';
        var iframeContent = '<iframe scrolling="no" src="'+diagramUrl+'" style="width:100%;height:100%"></iframe>';
        var newdiagramUrl = diagramUrl.replace('show_orbit_dmp','show_orbit');
        var linkToInteractive = '<a href="'+newdiagramUrl+'" target="_blank" class="interactiveLink"><span style="color:white;font-size:1em" class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span></a>';
        $('#modern .diagram').html(legendContent+linkToInteractive+iframeContent);
    }
}

function classicIframe(diagramUrl){
    if( webgl_detect()) {
        var legendContent = '<div class="legendncredit"> <ul> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(139,69,19)"></div>Mecury</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(120,120,120)"></div>Venus</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(102,178,255)"></div>Earth</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(253,255,56)"></div>Asteroid</li> <li><div class="rect" style="width:10px;height:10px;background-color:rgb(170,0,0)"></div>Mars</li> <li>&#169; Minor Planet Center</li> </ul> </div>';
        var iframeContent = '<iframe scrolling="no" src="'+diagramUrl+'" style="width:100%;height:100%"></iframe>';
        var newdiagramUrl = diagramUrl.replace('show_orbit_dmp','show_orbit');
        var linkToInteractive = '<a href="'+newdiagramUrl+'" target="_blank" class="interactiveLink"><span style="color:white;font-size:1em" class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span></a>';
        $('#classic .diagram').html(legendContent+linkToInteractive+iframeContent);
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
                url: "/subscribe",
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
