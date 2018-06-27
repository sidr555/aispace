/**
 * Следим за изменениями в файлах и запускаем соответствующие grunt-задачи на сборку
 * TODO придумать способ запускать задачи на пересборку только измененных файлов
 */

module.exports = function (grunt, options) {

    grunt.loadNpmTasks("grunt-contrib-watch");
    //grunt.loadNpmTasks('grunt-newer');

    return {
        options: {
            spawn: true,           // запускать дочерние процессы
            debounceDelay: 500,     // антидребезг
            event: 'all',           // all|changed|added|deleted
            interrupt: true,        // прерывать предыдущий процесс при возникновении новых изменений
            forever: true,       // не вылетать при ошибках
            dateFormat: function (time) {
                grunt.log.writeln('Rebuild is finished in ' + time + 'ms at ' + (new Date()).toString());
                grunt.log.writeln('Waiting for more changes...');
            },
            //livereload: {         // настройки для удаленного рестарта вотчера по http(s)
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

