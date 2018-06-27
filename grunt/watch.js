/**
 * ������ �� ����������� � ������ � ��������� ��������������� grunt-������ �� ������
 * TODO ��������� ������ ��������� ������ �� ���������� ������ ���������� ������
 */

module.exports = function (grunt, options) {

    grunt.loadNpmTasks("grunt-contrib-watch");
    //grunt.loadNpmTasks('grunt-newer');

    return {
        options: {
            spawn: true,           // ��������� �������� ��������
            debounceDelay: 500,     // �����������
            event: 'all',           // all|changed|added|deleted
            interrupt: true,        // ��������� ���������� ������� ��� ������������� ����� ���������
            forever: true,       // �� �������� ��� �������
            dateFormat: function (time) {
                grunt.log.writeln('Rebuild is finished in ' + time + 'ms at ' + (new Date()).toString());
                grunt.log.writeln('Waiting for more changes...');
            },
            //livereload: {         // ��������� ��� ���������� �������� ������� �� http(s)
            //    host: 'localhost',
            //    port: 9000,
            //    key: grunt.file.read('ssl.key'),
            //    cert: grunt.file.read('ssl.cert'),
            // },
            //cwd: '',                // cd


        },
        gruntfile: {
            files: 'Gruntfile.js'
        },

        css: {
            files: ['less/*.less'],
            tasks: ['less']
        },

        js: {
            files: ['front/*.coffee', 'views/*.jade', 'views/*/*.jade'],
            tasks: ['browserify']
        }
    }
}

