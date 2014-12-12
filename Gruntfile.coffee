module.exports = (grunt)->
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    # task definitions
    browserify:
      src:
        files:
          'src/js/main.js' : ['src/js/main.coffee']
        options:
          transform : ['coffeeify']
    compass:
      vendor:
        options:
          sassDir: 'bower_components/kube-scss/scss/'
          cssDir: 'src/css'
      dev:
        options:
          sassDir: 'src/scss/'
          cssDir: 'src/css'
    copy:
      main:
        files: [
          {
            expand:true
            filter:'isFile'
            flatten:true
            src: [
              'bower_components/jquery/dist/jquery.js'
              'bower_components/modernizr/modernizr.js'
            ]
            dest: 'src/js/'
          },
          {
            expand:true
            cwd: 'bower_components/gumby/sass/'
            src : ['**']
            dest: 'src/sass/'
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
      src: ['src/css', 'src/js/*.js', 'src/*.html']
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
    watch:
      html:
        files: 'src/jade/*.jade'
        tasks: ['jade']
      coffee:
        files: 'src/js/*.coffee'
        tasks: ['coffeelint', 'browserify']
      scss:
        files: 'src/scss/*.scss'
        tasks: ['compass']
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
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-php'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  
  
  # register tasks
  grunt.registerTask 'test', ['compile', 'coffee:compileTests', 'karma']
  grunt.registerTask 'compile', ['jade', 'browserify', 'compass']
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