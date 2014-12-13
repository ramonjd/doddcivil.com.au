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
      src:
        files:
          'src/js/main.js' : ['src/js/main.coffee']
        options:
          transform : ['coffeeify']
    less:
      dev:
        files:
          'src/css/base.css' : 'src/less/base.less'
    copy:
      main:
        files: [
          {
            expand:true
            cwd: 'bower_components/bootstrap/less/'
            src: [
              '**'
            ]
            dest: 'src/less/bootstrap/'
          }
        ]
    coffee:
      compileTests:
        options:
          bare: true
        files:
          'tests/app.spec.js' : ['tests/*.coffee']
    coffeelint:
      src: ['src/js/*.coffee', 'tests/*.coffee']
    clean:
      src: [
        'src/css'
        'src/less/bootstrap'
        'src/js/*.js'
        'src/js/*.map'
        'src/*.html'
      ]
    cssmin:
      options:
        ext: '.min.css'
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
      dev:
        options:
          mangle: false
          sourceMap: true
          beautify: true
        files:
          'src/js/bundle.js' : [
            'bower_components/modernizr/modernizr.js'
            'bower_components/jquery/dist/jquery.js'
            'bower_components/bootstrap/dist/js/bootstrap.js'
            'src/js/main.js'
          ]
    watch:
      html:
        files: 'src/jade/*.jade'
        tasks: ['jade']
      coffee:
        files: 'src/js/*.coffee'
        tasks: ['coffeelint', 'browserify', 'uglify:dev']
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
  grunt.registerTask 'test', ['compile', 'coffee:compileTests', 'karma']
  grunt.registerTask 'compile', [
    'jade'
    'browserify'
    'uglify:dev'
    'less'
    'autoprefixer'
  ]
  grunt.registerTask 'default', [
    'clean:src'
    'shell:bowerinstall'
    'copy'
    'compile'
    'coffeelint'
    'coffee:compileTests'
    'karma'
    'concurrent'
  ]
  
  # return grunt
  grunt