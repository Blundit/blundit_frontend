'use strict';

// included gulp components
var gulp = require('gulp');
var argv = require('yargs').argv;
var sass = require('gulp-sass');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');
var browserify = require('gulp-browserify');
var buffer = require('vinyl-buffer');
var uglifycss = require("gulp-uglifycss");

// variables
var config = {
  toWatch: {
    coffee: [
      './assets/coffee/**/*.coffee'
    ],
    sass: [
      './assets/sass/**/*.sass',
    ],
    mainSass: [
      './assets/sass/main.sass'
    ]
  },
  outputFiles: {
    coffee: 'main.js',
    sass: 'main.css',
  },
  outputDirs: {
    css: './dist/styles',
    js: './dist/scripts',
  }
};

// converts coffee files into main.js
gulp.task('scripts', function() {
  gulp
    .src(config.toWatch.coffee)
    .pipe(concat(config.outputFiles.coffee))
    .pipe(coffee({base: true}).on('error', gutil.log))
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee'],
      paths: ['./assets/coffee/']
    }))
    // .pipe(buffer())
    // .pipe(uglify())
    .pipe(gulp.dest(config.outputDirs.js))
});

gulp.task('css', function() {
  return gulp
    .src(config.toWatch.mainSass)
    .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
    .pipe(concat(config.outputFiles.sass))
    .pipe(uglifycss())
    .pipe(gulp.dest(config.outputDirs.css));
});

gulp.task('watchFiles', function() {
  gulp.watch(config.toWatch.coffee).on("change", function(file) {
    gulp.start('scripts');
  });

  gulp.watch(config.toWatch.sass, {interval: 500}).on("change", function(file) {
    gulp.start('css');
  });

});

gulp.task('default', ['scripts', 'css', 'watchFiles']);
gulp.task('build', ['scripts', 'css']);
gulp.task('watch', ['scripts', 'css', 'watchFiles']);
