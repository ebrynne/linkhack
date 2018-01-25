var config = {
    setUrl: function(e) {
        var input = document.getElementById('go_url');
        localStorage['go_url'] = input.value
        window.close();
    },

    setup: function() {
        var button = document.getElementById('go_button');
        button.addEventListener('click',  config.setUrl );
    }
};

document.addEventListener('DOMContentLoaded', function () {
    config.setup();
});
