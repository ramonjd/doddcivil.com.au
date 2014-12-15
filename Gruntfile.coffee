module.exports = (grunt)->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    # task definitions
    autoprefixer:
      options:
        browsers: [
          'Android 2.3'
          'Android >= 4'
          'Chrome >= 20'
          'Firefox >= 24'
          'Explorer >= 9'
          'iOS >= 6'
          'Opera >= 12'
          'Safari >= 6'
        ]
      dev:
        options:
          map: true
        src: 'src/css/base.css'
    browserify:
      dev:
        files:
          'src/js/main.js' : ['src/coffee/main.coffee']
        options:
          transform : ['coffeeify']
    less:
      dev:
        files:
          'src/css/base.css' : 'src/less/base.less'
    copy:
      dev:
        files: [
          {
            expand:true
            filter:'isFile'
            flatten:true
            src: [
              'bower_components/jquery/dist/jquery.js'
              'bower_components/jquery-touchswipe/jquery.touchSwipe.js'
              'bower_components/bootstrap/dist/js/bootstrap.js'
              'bower_components/modernizr/modernizr.js'
              'bower_components/velocity/velocity.js'
              'bower_components/velocity/velocity.ui.js'
            ]
            dest: 'src/js/'
          }
          {
            expand:true
            cwd: 'bower_components/bootstrap/less/'
            src: [
              '**'
            ]
            dest: 'src/less/bootstrap/'
          }
          {
            expand:true
            cwd: 'bower_components/bootstrap/fonts/'
            src: [
              '**'
            ]
            dest: 'src/fonts/'
          }
        ]
      dist:
        files: [
          {
            expand:true
            cwd: 'bower_components/bootstrap/fonts/'
            src: [
              '**'
            ]
            dest: 'dist/fonts/'
          }
          {
            expand:true
            cwd: 'src/img/'
            src: [
              '**'
            ]
            dest: 'dist/img/'
          }
          {
            expand:true
            cwd: 'src/api/'
            src: [
              '**'
            ]
            dest: 'dist/api/'
          }
          {
            expand:true
            filter:'isFile'
            flatten:true
            src: [
              'src/*.html'
            ]
            dest: 'dist/'
          }
        ]
    coffee:
      compileTests:
        options:
          bare: true
        files:
          'tests/app.spec.js' : ['tests/*.coffee']
    coffeelint:
      src: ['src/coffee/*.coffee', 'tests/*.coffee']
    clean:
      src: [
        'src/css'
        'src/less/bootstrap'
        'src/js'
        'src/*.html'
      ]
      dist: [
        'dist'
      ]
    cssmin:
      prod:
        files:[
          {
            expand: true
            cwd: 'src/css/',
            src: 'base.css'
            dest: 'dist/css/'
          }
        ]
    jade:
      compile:
        options:
          data: (dest, src)->
            require './config/locals.json'
        files:
          'src/index.html' : 'src/jade/index.jade'
    karma:
      unit:
        configFile: 'config/karma.conf.js'
    php:
      dev:
        options:
          base: './src/'
          keepalive: true
          port: 3000
          open: true
    shell:
      bowerinstall:
        command: 'bower install'
    uglify:
      options:
        mangle: false
      dist:
        files: 'dist/js/main.js': ['src/js/main.js']
    watch:
      html:
        files: 'src/jade/*.jade'
        tasks: ['jade']
      coffee:
        files: 'src/coffee/*.coffee'
        tasks: ['coffeelint', 'browserify']
      less:
        files: 'src/less/*.less'
        tasks: ['less', 'autoprefixer']
      tests:
        files: 'tests/*.coffee'
        tasks: ['coffee:compileTests', 'karma']
    concurrent:
      start: [
        'watch'
        'php'
        ]
      options:
        logConcurrentOutput: true
    )
  
  # load modules
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-php'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-autoprefixer'

  
  
  # register tasks
  grunt.registerTask 'server', [
    'concurrent'
  ]
  grunt.registerTask 'test', [
    'compile'
    'coffee:compileTests'
    'karma'
  ]
  grunt.registerTask 'compile', [
    'jade'
    'browserify'
    'less'
    'autoprefixer'
  ]
  grunt.registerTask 'dev', [
    'clean:src'
    'shell:bowerinstall'
    'copy:dev'
    'compile'
    'coffeelint'
    'coffee:compileTests'
    'karma'
  ]
  grunt.registerTask 'default', [
    'dev'
    'server'
  ]
  grunt.registerTask 'dist', [
    'dev'
    'clean:dist'
    'copy:dist'
    'uglify'
    'cssmin'
  ]
  # return grunt
  grunt