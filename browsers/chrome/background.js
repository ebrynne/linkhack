chrome.alarms.create("check_for_updates", {delayInMinutes: 0.2, periodInMinutes: 0.2} );
REGEX_KEY = '___REGEX___';

chrome.webRequest.onBeforeRequest.addListener(
    function(details) {
        request = details.url.match(/^https?:\/\/[^\/]+([\S\s]*)/)[1].replace(/^\//, '');
        request = request.split('/');
        shortlink = request[0];
        args = request.slice(1).join('');

        stored = localStorage[shortlink];
        if (stored) {
            parsed = JSON.parse(stored);
            console.log(stored, parsed);
            console.log("WE HAVE A REGULAR LINK: " + parsed['url'].replace('%s', args));
            return { redirectUrl: parsed['url'].replace('%s', args) };
        }

        JSON.parse(localStorage[REGEX_KEY]).forEach(function(link) {
            re = new RegExp(link.shortlink);
            matches = re.exec(request);
            if(matches) {
                matched = matches.length === 2 ? matches[1] : matches[0];
                url = link['url'] + (link['argsstr'] ? link['argsstr'].replace('%s', matched) : matched);
                return { redirectUrl: url };
            }
        });
        return { redirectUrl: localStorage['go_url'] + '/' + request };
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
    go_url = localStorage['go_url']
    $.getJSON(go_url + '/links.json', function (linkList) {
        regex_links = [];
        linkList.forEach(function(link) {
            if(link['type'] === 'RegexLink') {
                regex_links.push(link)
            } else {
                shortlink = link['shortlink'];
                localStorage[shortlink] = JSON.stringify(link)
            }
        });
        localStorage[REGEX_KEY] = JSON.stringify(regex_links)
    });
});
