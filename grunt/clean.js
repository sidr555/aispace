/**
 * ������� ��� ��������� � ������ ������� �����
 */
module.exports = function(grunt, options) {
    //console.error("CLEANNN");
    grunt.loadNpmTasks("grunt-contrib-clean");
    return {
        options: {
            //'no-write': false, // �������� ��������, ��� �������
            force: true

        },
        js: ['web/js/aistuff.js'],
        css: ['web/css/aistuff.css']
    }
//    return {}
};
