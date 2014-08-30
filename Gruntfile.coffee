'use strict'

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt

  config = app: 'app', dist: 'dist'

  grunt.initConfig {
    config: config
    watch: {
      gruntfile:
        files: [ 'Gruntfile.coffee' ]
      coffee:
        files: [ 'src/{,*/}*.coffee' ]
        tasks: [ 'coffee:dist' ]
      # TODO: add files if necessary
    }

    clean: {
      server: '.tmp'
    }

    coffee: dist:
      expand: true
      options: bare: true
      cwd: 'src/'
      src: '*.coffee'
      dest: '.tmp/scripts'
      ext: '.js'

    connect: {
      options:
        port: 9000
        open: true
        livereload: 35729
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) -> [
            connect.static '.tmp'
            connect().use('/bower_components', connect.static './bower_components')
            connect.static config.app
          ]
      dist:
        options:
          base: '<%= config.dist %>'
          livereload: false
    }

    copy: styles:
      expand: true
      dot: true
      cwd: '<%= config.app %>/styles'
      dest: '.tmp/styles'
      src: '{,*/}*.css'

    sass: {
      options: {
        loadPath: [
          'bower_components'
        ]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/styles',
          src: ['*.scss'],
          dest: '.tmp/styles',
          ext: '.css'
        }]
      },
      server: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/styles',
          src: ['*.scss'],
          dest: '.tmp/styles',
          ext: '.css'
        }]
      }
    }

    rev: {
      dist: {
        files: {
          src: [
              '<%= config.dist %>/scripts/{,*/}*.js',
              '<%= config.dist %>/styles/{,*/}*.css',
              '<%= config.dist %>/images/{,*/}*.*',
              '<%= config.dist %>/styles/fonts/{,*/}*.*',
              '<%= config.dist %>/*.{ico,png}'
          ]
        }
      }
    },

    concurrent: {
      server: [
        'coffee:dist'
        'sass:server',
        'copy:styles'
      ],
      test: [
        'copy:styles'
      ],
      dist: [
        'sass',
        'copy:styles',
        'imagemin',
        'svgmin'
      ]
    }
  } # grunt.initConfig

  grunt.registerTask 'serve', (target) ->
    grunt.task.run [
      'clean:server'
      'concurrent:server'
      'connect:livereload'
      'watch'
    ]
    return

  return

