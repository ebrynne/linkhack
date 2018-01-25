chrome.alarms.create("check_for_updates", {delayInMinutes: 0.2, periodInMinutes: 0.2} );


get_regular_link = function(request) {
    chrome.storage.sync.get(request, function(stored) {
        if (stored) {
            console.log("WE HAVE A REGULAR LINK");
            return { redirectUrl: stored.url };
        } else {
            get_regex_link(request)
        }
    });
};

get_regex_link = function(request) {

};

fallback_to_server = function(request) {
    return {redirectUrl: go_server + '/' + request};
};

chrome.webRequest.onBeforeRequest.addListener(
    function(details) {
        request = details.url.match(/^https?:\/\/[^\/]+([\S\s]*)/)[1].replace(/^\//, '');
        console.log("REQUEST" + details);
        return {redirectUrl: go_server + details.url.match(/^https?:\/\/[^\/]+([\S\s]*)/)[1]};
    },
    {
        urls: [
            "*://go/*",
            "*://www.go/*"
        ],
        types: ["main_frame", "sub_frame", "stylesheet", "script", "image", "object", "xmlhttprequest", "other"]
    },
    ["blocking"]
);

chrome.alarms.onAlarm.addListener(function( alarm ) {
    chrome.storage.sync.get("go_url", function(stored){
        console.log("STORED HOST", stored);
        $.getJSON(stored['go_url'] + '/links.json', function (linkList) {
            regex_links = [];
            linkList.forEach(function(link) {
                shortlink = link['shortlink'];
                chrome.storage.sync.set({ shortlink: link })
            });
        });
    });
});
