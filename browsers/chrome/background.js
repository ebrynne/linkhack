chrome.alarms.create("check_for_updates", {delayInMinutes: 1, periodInMinutes: 5} );
REGEX_KEY = '___REGEX___';

chrome.webRequest.onBeforeRequest.addListener(
    function(details) {
        original_request = details.url.match(/^https?:\/\/[^\/]+([\S\s]*)/)[1].replace(/^\//, '');
        request = original_request.split('/');
        shortlink = request[0];
        args = request.slice(1).join('');

        stored = localStorage[shortlink];
        if (stored) {
            parsed = JSON.parse(stored);
            url = parsed['url'];
            url += parsed['argsstr'] ? parsed['argsstr'].replace('%s', args) : '';
            return { redirectUrl: url };
        }

        var regex_url = null;
        regexes = localStorage[REGEX_KEY]
        if (regexes) {
          JSON.parse(regexes).forEach(function(link) {
              re = new RegExp(link.shortlink);
              matches = re.exec(request);
              if(matches) {
                  matched = matches.length === 2 ? matches[1] : matches[0];
                  url = link['url'] + (link['argsstr'] ? link['argsstr'].replace('%s', matched) : matched);
                  regex_url = url;
              }
          });
        }

        var url = regex_url ? regex_url : localStorage['go_url'] + '/' + original_request
        return { redirectUrl: url };
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
