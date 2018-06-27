/**
 * LESS
 */
module.exports = function(grunt, options) {
    grunt.loadNpmTasks("grunt-contrib-less");
    return {
        options: {
        },
        main: {
            src: ['less/index.less'],
            dest: 'web/css/aispace.css',
            options: {
                compress: true
            }
        }
    }
};
