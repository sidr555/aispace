module.exports = function (grunt) {

    var path = require('path');

    // вывести в конце отчет по времени работы задач грунта
    require('time-grunt')(grunt);

    // загружать автоматом задачи из папки /grunt
    //require('load-grunt-tasks')(grunt);

    // увеличивает скорость загрузки, только необходимые плагины
    require('jit-grunt')(grunt);

    // Записываем лог в файл для возможности просмотра, если не видим сразу
    require('logfile-grunt')(grunt, {
        filePath: './grunt.log',
        clearLogFile: true
    });

    // загрузим задачи из папки grunt
    require('load-grunt-config')(grunt, {
        //configPath: path.join(process.cwd(), 'grunt'),
        init: true,
        //data: {},
        loadGruntTasks: false,
        postProcess: function(config) {
            //console.log("POSTPROCESS");
            //grunt.log.error("grunt load config postProcess", config);
        },
        preMerge: function(config, data) {
            //console.log("PREMERGE");
            //grunt.log.error("grunt load config preMerge", config, data);
        }
    });
};

