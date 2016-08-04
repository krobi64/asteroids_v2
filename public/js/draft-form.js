var dailyMinorPlanetDraftForm = ( function() {
    var s;
    var newsSources = [];

    function populateForm(edition){
        // today's edition
        var timestring = "05:00";  // default to: UTC 05:00 -> EDT 01:00 AM
        var d = new Date();
        if( edition.publish_date == null ) {
            d.setDate(d.getDate() + 1);
        }
        else {
            // parse the date from backend
            d = new Date(edition.publish_date);
            timestring = ("0"+d.getHours()).slice(-2) + ":" + ("0"+d.getMinutes()).slice(-2);
        }
        var datestring =  d.getFullYear() + "-" + ("0"+(d.getMonth()+1)).slice(-2) + "-" + ("0" + d.getDate()).slice(-2);
        s.publishDay.val(datestring);
        s.publishTime.val(timestring);

        s.tagLine.val( edition.title );
        s.flybyTile.val( edition.flyby.title );
        s.flybyContent.val( edition.flyby.content );
        s.flybyImageUrl.val( edition.orbit_diagram.url );
        s.newsTitle.val( edition.news_story.title );
        s.newsContent.val( edition.news_story.content );
        s.newsUrl.val( edition.news_story.story_url );
        s.entityId.val( edition.id );
        s.designation.val( edition.orbit_diagram.asteroid_id );

        // set the theme
        // s.theme.val( edition.theme.name);
        for( var i=0; i<s.themeType.length; i++) {
            if( edition.theme.name == s.themeType[i].value ) {
                s.themeType[i].checked = true;
            }
            else {
                s.themeType[i].checked = false;
            }
        }
    }

    function populateDraft() {
        console.log("get draft content");

        $.ajax({
            type: 'GET',
            url: "/editions/draft",
            contentType: "application/json; charset=UTF-8",
            success: function(res, status, error) {
                console.log( "success ",  res );
                populateForm(res);
            },
            error: function(res, status, error) {
                console.log( "error: ", error );
            }
        });
    }

    function makeRadioButton(count, text) {
        var label = document.createElement("label");
        var radio = document.createElement("input");
        radio.type = "radio";
        radio.name = "newsSource";
        radio.value = "source_"+count;
        radio.id = "radio_"+count;
        radio.style="margin-left:10px";
        radio.onclick = radioSelected;

        label.appendChild(radio);

        var display = document.createTextNode(text);
        // if need style the text label, do it here
        label.appendChild(display);

        return label;
    }

    function radioSelected(e) {
        console.log("radio selected: ", e);
        // e.target.prop('checked', true);
        $('#'+e.target.id).prop("checked", true);
        selectNewsSource();
    }

    function selectNewsSource() {
        var checkedValue = $('input[name=newsSource]:checked').val();
        var index = checkedValue.slice(-1);

        s.newsUrl.val( newsSources[index].url );
        s.newsTitle.val( newsSources[index].title );
        s.newsContent.val( newsSources[index].content );
    }

    function populateSource() {
        console.log("TODO: get list of news sources");

        // defer to future for news source
        return;

        // populate "newsSource" from backend, for now let's just hardcoded it. Need to add at backend too
        newsSources = [  {'name': 'NASA', 'url': 'http://www.nasa.gov/press-release/nasas-juno-spacecraft-in-orbit-around-mighty-jupiter', 'title': 'Juno Spacecraft in Orbit Around Mighty Jupiter', 'content': 'After an almost five-year journey to the solar system’s largest planet, NASA\'s Juno spacecraft successfully entered Jupiter\’s orbit during a 35-minute engine burn. Confirmation that the burn had completed was received on Earth at 8:53 p.m. PDT (11:53 p.m. EDT) Monday, July 4.'},
                {'name': 'JPL', 'url': 'http://www.jpl.nasa.gov/spaceimages/details.php?id=PIA20490', 'title': 'Pandemonium', 'content': 'Pan and moons like it have profound effects on Saturn\'s rings. The effects can range from clearing gaps, to creating new ringlets, to raising vertical waves that rise above and below the ring plane. All of these effects, produced by gravity, are seen in this image.'},
                {'name': 'Source3', 'url': 'URL for source #3 story', 'title': 'news title', 'content': 'news content from source #3'},
                {'name': 'Manual Input', 'url': 'Internal REST URL', 'title': 'news title after manual input', 'content': 'orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean condimentum, velit sagittis ultrices laoreet, neque nulla sagittis dolor, in tristique turpis ipsum vitae diam. Integer leo lorem, ornare non tristique quis, pharetra at dolor.'}];


        var radioSource = document.getElementById("sourceList");

        for(var i=0; i<newsSources.length; i++) {
            var src = newsSources[i];

            var radioButton = makeRadioButton(i, src.name);
            // s.sourceList.appendChild(radioButton);
            // radioSource.appendChild(radioButton);
        }

        if( newsSources.length > 0 ) {
            // select the last one, since Editor may have modified and saved earlier
            var index = newsSources.length-1;
            $("#radio_"+index).prop("checked", true);
            selectNewsSource();
        }
    }


var dayOfWeek = ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    function previewDraft(e) {
        // implement the Preview functionality here
        e.preventDefault();
        console.log( "preview draft");

        var data = getFormData();

            // get default theme
        var previewTheme = $('input[name="themeType"]:checked').val();

        //contents fill
        // today's edition
        $('.heroline').html(data.title);
        $('.flybyTitle').html(data.flyby.title);
        $('.flybyContents').html(data.flyby.content);
        $('.storyTitle').html(data.news_story.title);
        $('.storyContents').html(data.news_story.content);
        $('.diagram').css('background-image','url(/images/'+data.diagram+')');
        $('.mobile-diagram').css('background-image','url(/images/'+data.diagram+')');

        var today = new Date(data.publish_date);

        data.year = today.getFullYear();
        data.date = today.getDate();
        data.dayofweek = dayOfWeek[today.getDay()];
        data.month = monthNames[today.getMonth()];

        $('.day').html(data.date);
        $('.month').html(data.month);
        $('.year').html(data.year);
        $('.dayofweek').html(data.dayofweek);

        //chagne theme in preview
        if (previewTheme == 'modern'){
            $('#preview #modern').removeClass('hide');
            $('#preview #classic').addClass('hide');
        }else{
            $('#preview #classic').removeClass('hide');
            $('#preview #modern').addClass('hide');
        }

    }

    function publishDraft(e) {
        e.preventDefault();
        console.log( "publish draft");

        var draftId = s.entityId[0].value;

        $.ajax({
            type: 'PUT',
            url: "/editions/" + draftId + "/publish",
            contentType: "application/json; charset=UTF-8",
            success: function(res, status, error) {
                console.log( "success ",  res );
            },
            error: function(res, status, error) {
                console.log( "error: ", error );
            }
        });
    }

    function unpublishDraft(e) {
        e.preventDefault();
        console.log( "unpublish draft");

        var draftId = s.entityId[0].value;

        $.ajax({
            type: 'PUT',
            url: "/editions/" + draftId + "/unpublish",
            contentType: "application/json; charset=UTF-8",
            success: function(res, status, error) {
                console.log( "success ",  res );
            },
            error: function(res, status, error) {
                console.log( "error: ", error );
            }
        });
    }

    function getFormData() {
        var draft = {};
        var flyby = {};
        var diagram = {};
        var news = {};
        var theme = {};

        var pdate = s.publishDay[0].value;
        var ptime = s.publishTime[0].value;
        var pGMT = pdate + "T" + ptime + ":00+00:00";
        console.log( pGMT );

        flyby.title = s.flybyTile[0].value;
        flyby.content = s.flybyContent[0].value;

        diagram.asteroid_designation = s.designation[0].value;

        // this diagram url should not be edited manually
        // diagram.url = s.flybyImageUrl[0].value;
        news.title = s.newsTitle[0].value;
        news.content = s.newsContent[0].value;
        news.story_url = s.newsUrl[0].value;
        tagline = s.tagLine[0].value;

        for( var i=0; i<s.themeType.length; i++) {
            if( s.themeType[i].checked ) {
                theme.name = s.themeType[i].value;
                break;
            }
        }

        draft.id = s.entityId[0].value;
        draft.title = tagline;
        draft.publish_date = pGMT;
        draft.flyby = flyby;
        draft.news_story = news;
        draft.orbit_diagram = diagram;
        draft.theme = theme;

        return draft;
    }

// generate static flyby image
function showFlybyImage(){
    var designation = s.designation[0].value;
    var pdate = s.publishDay[0].value;
    if( designation === undefined || pdate === undefined ) {
        alert("Require asteroid designation and flyby date to generate flyby diagram image");
    }
    // reformat pdate
    pdate = pdate.replace('/', '-');

    // open up a window and load a page
    var url ="http://mpc.eps.harvard.edu/db_search/show_orbit_png?designation="+designation +"&date="+pdate;
    var width = 620; 
    var height = 620; 
    
    $("#staticImageModal iframe").attr({
        'src': url,
        'height': height,
        'width': width
    });
}

// fetch
function fetchFlybyInfo(e){

    var asteroid = s.designation[0].value;

    if( asteroid !== null && asteroid.trim().length > 0 ) {
        var formatted = encodeURIComponent(asteroid);

        $.ajax({
            type: 'GET',
            url: "/flyby2/search?designation="+formatted,
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            success: function(res, status, error) {
                console.log( "success ",  res );

                var title = res[0].designation;
                var content = "Approach date: " + res[0].close_app_date + ", Impact Probability: " + res[0].impact_prob;
                var url = res[0].url;

                s.flybyTile.val(title);
                s.flybyContent.val(content);
                s.flybyImageUrl.val(url);
                $('#downloadCheck').html('');
            },
            error: function(res, status, error) {
                console.log( "error: ", error );
            }
        });
    }
};


    function validateForm() {

    }

    function saveDraft(e) {
        e.preventDefault();
        var draft = getFormData();
        validateForm();

        $.ajax({
            type: 'PUT',
            url: "/editions/" + draft.id,
            data: JSON.stringify(draft),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            success: function(res, status, error) {
                console.log( res );
            },
            error: function(res, status, error) {
                console.log( error );
            }
        });
    }

    return {
        settings: {
            saveAction: $('.save'),
            previewAction: $('.preview'),
            publishAction: $('.publish'),
            unpublishAction: $('.unpublish'),
            fetchAction: $('#dmp-flyby-fetch'),
            showFlybyImageAction: $('#downloadImage'),
            publishDay: $('#publishDay'),
            publishTime: $('#publishTime'),
            tagLine: $('#tagline'),
            designation: $('#designation'),
            flybyTile: $('#flybyTitle'),
            flybyContent: $('#flybyContent'),
            flybyImageUrl: $('#flybyImageUrl'),
            newsTitle: $('#newsTitle'),
            newsContent: $('#newsContent'),
            newsUrl: $('#newsUrl'),
            themeType: $("input[name='themeType']"),
            sourceList: $('#sourceList'),
            entityId: $('#entityId')
        },

        init: function() {
            s = this.settings;
            this.bindActions();
            populateDraft();
            populateSource();
        },

        bindActions: function() {
            s.saveAction.on("click", function(e) {
                saveDraft(e);
            });

            s.previewAction.on("click", function(e) {
                previewDraft(e);
            });

            s.publishAction.on("click", function(e) {
                publishDraft(e);
            });

            s.unpublishAction.on("click", function(e) {
                unpublishDraft(e);
            });

            s.fetchAction.on("click", function(e) {
                fetchFlybyInfo(e);
            });

            s.showFlybyImageAction.on("click", function(e) {
                showFlybyImage();
            });
        },

    };
})();
