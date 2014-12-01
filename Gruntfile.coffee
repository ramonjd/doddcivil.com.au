module.exports = (grunt)->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    # task definitions
    copy:
      main:
        files: [
          {
            expand:true
            filter:'isFile'
            flatten:true
            src: ['bower_components/jquery/dist/jquery.min.js',
                  'bower_components/semantic/dist/semantic.min.js',
                  'bower_components/semantic/dist/semantic.min.css']
            dest: 'src/assets'
          }
          {
            expand:true
            cwd: 'bower_components/semantic/dist/themes/default/',
            src : ['**']
            dest: 'src/assets/themes/default/'
          }
        ]
    clean:
      src: ['src/assets']
    coffee:
      compile:
        options:
          bare:true
        files:
          'server.js' : 'server.coffee'
      jsx:
        options:
          bare:true
        expand: true
        flatten: false
        cwd: 'react'
        src: '**/*.coffee'
        dest: 'react'
        ext: '.jsx'
    watch:
      react:
        files: 'react/**/*.coffee'
        tasks: ['compile']

    )
  # load modules
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  
  
  # register tasks
  grunt.registerTask 'compile', ['coffee', 'browserify']
  grunt.registerTask 'default', ['clean', 'copy']
  
  # return grunt
  grunt