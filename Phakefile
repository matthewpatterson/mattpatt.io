<?php

desc("Clean the build directory");
task("clean", function() {
	writeln(red("clean >> Not implemented"));
});

desc("Run a complete build");
task("build", 'clean', 'build:html', 'build:coffee', 'build:less');

group('build', function() {
	desc("Build static HTML files from Twig templates");
	task("html", function() {
		writeln(red("build:html >> Not implemented"));
	});

	desc("Compile CoffeeScript files into JavaScript");
	task("coffee", function() {
		writeln(red("build:coffee >> Not implemented"));
	});

	desc("Compile LESS files into Cascading Style Sheets");
	task("less", function() {
		writeln(red("build:less >> Not implemented"));
	});
});

desc("Copy all build files to the web server root directory");
task("install", function() {
	writeln(red("install >> Not implemented"));
});

