var dailyMinorPlanetDraftForm = ( function() {
    var s;
    var newsSources = [];

    function populateForm(edition){
        // today's edition
        // console.log( "populate form: " + edition.title );
        var today = new Date();
        console.log( today );


        s.tagLine.val( edition.title );
        s.flybyTile.val( edition.flyby.title );
        s.flybyContent.val( edition.flyby.content );
        s.newsTitle.val( edition.news_story.title );
        s.newsContent.val( edition.news_story.content );
    }

    function populateDraft() {
        console.log("get draft content");

        $.ajax({
            type: 'GET',
            url: "http://localhost:3000/editions/12",
            contentType: "application/json: charset=UTF-8",
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

        // populate "newsSource" from backend, for now let's just hardcoded it. Need to add at backend too
        newsSources = [  {'name': 'NASA', 'url': 'http://www.nasa.gov/press-release/nasas-juno-spacecraft-in-orbit-around-mighty-jupiter', 'title': 'Juno Spacecraft in Orbit Around Mighty Jupiter', 'content': 'After an almost five-year journey to the solar system’s largest planet, NASA\'s Juno spacecraft successfully entered Jupiter\’s orbit during a 35-minute engine burn. Confirmation that the burn had completed was received on Earth at 8:53 p.m. PDT (11:53 p.m. EDT) Monday, July 4.'}, 
                {'name': 'JPL', 'url': 'http://www.jpl.nasa.gov/spaceimages/details.php?id=PIA20490', 'title': 'Pandemonium', 'content': 'Pan and moons like it have profound effects on Saturn\'s rings. The effects can range from clearing gaps, to creating new ringlets, to raising vertical waves that rise above and below the ring plane. All of these effects, produced by gravity, are seen in this image.'}, 
                {'name': 'Source3', 'url': 'URL for source #3 story', 'title': 'news title', 'content': 'news content from source #3'}, 
                {'name': 'Manual Input', 'url': 'Internal REST URL', 'title': 'news title after manual input', 'content': 'orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean condimentum, velit sagittis ultrices laoreet, neque nulla sagittis dolor, in tristique turpis ipsum vitae diam. Integer leo lorem, ornare non tristique quis, pharetra at dolor.'}];

        debugger;

        var radioSource = document.getElementById("sourceList");

        for(var i=0; i<newsSources.length; i++) {
            var src = newsSources[i];

            var radioButton = makeRadioButton(i, src.name);
            // s.sourceList.appendChild(radioButton);
            radioSource.appendChild(radioButton);
        }

        if( newsSources.length > 0 ) {
            // select the last one, since Editor may have modified and saved earlier
            var index = newsSources.length-1;
            $("#radio_"+index).prop("checked", true);
            selectNewsSource();
        }
    }


    function previewDraft(e) {
        // implement the Preview functionality here
        e.preventDefault();
        console.log( "preview draft");

        var draftData = getFormData();
        var options = {};
    }

    function publishDraft(e) {
        e.preventDefault();
        console.log( "publish draft");

        $.ajax({
            type: 'PUT',
            url: "http://localhost:3000/editions/24/publish",
            contentType: "application/json: charset=UTF-8",
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

        $.ajax({
            type: 'PUT',
            url: "http://localhost:3000/editions/24/unpublish",
            contentType: "application/json: charset=UTF-8",
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
        var news = {};

        flyby.title = s.flybyTile[0].value;
        flyby.content = s.flybyContent[0].value;
        news.title = s.newsTitle[0].value;
        news.content = s.newsContent[0].value;
        tagline = s.tagline[0].value;

        // TODO: get the theme value
        theme = "Classic";

        draft.flyby = flyby;
        draft.news_story = news;
        draft.title = tagline;
        draft.theme = theme;
        
        return draft;
    }


    function validateForm() {

    }

    function saveDraft(e) {
        e.preventDefault();
        var draft = getFormData();
        validateForm();

        $.ajax({
            type: 'PUT',
            url: "http://localhost:3000/editions/25",
            data: draft,
            contentType: "application/json: charset=UTF-8",
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
            tagLine: $('#tagline'),
            flybyTile: $('#flybyTitle'),
            flybyContent: $('#flybyContent'),
            flybyImageUrl: $('#flybyImageUrl'),
            newsTitle: $('#newsTitle'),
            newsContent: $('#newsContent'),
            newsUrl: $('#newsUrl'),
            sourceList: $('#sourceList'),

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
        },

    };             
})();
