module.exports = function (grunt, options) {

    grunt.loadNpmTasks("grunt-browserify");

    return {
        options: {
            browserifyOptions: { // sourceMap �� ����� ��� release
                debug: true,
                //standalone: "admin"
            },
            transform: ['coffeeify'],
            //standalone: "admin",
            //ignore: ["jquery"],
            verbose: true,
            exclude: ["framework7"]
        },
        js: {
            files: {
                'web/js/aispace.js': 'front/index.coffee'
            }
        }
    };

};

