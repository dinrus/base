// Copyright (c) 2007, Shalkhakov Artyom.
// This program runs unittests for ray.video.DisplayMode.
import tango.io.Stdout;
import Integer = tango.text.convert.Integer;
import tango.util.ArgParser;
import auxd.ray.video.DisplayMode;

void main( char[][] args ) {
	ArgParser	parser = new ArgParser;
	int			width, height;
	int			displayRefresh;
	int			bitdepth;
	
	Stdout( "dispmode --help to get some help" ).newline;
	
	parser.bind( "--", "help", delegate void() {
		Stdout( "command line options:" ).newline;
		Stdout( "-width <pixels>" ).newline;
		Stdout( "-height <pixels>" ).newline;
		Stdout( "-freq <Hz> -- vertical refresh rate" ).newline;
		Stdout( "-depth <bits> -- bits per pixel" ).newline;
	} );
	parser.bind( "-", "width", delegate void( char[] value ) {
		width = Integer.parse( value );
	} );
	parser.bind( "-", "height", delegate void( char[] value ) {
		height = Integer.parse( value );
	} );
	parser.bind( "-", "freq", delegate void( char[] value ) {
		displayRefresh = Integer.parse( value );
	} );
	parser.bind( "-", "depth", delegate void( char[] value ) {
		bitdepth = Integer.parse( value );
	} );
	parser.parse( args[1..$] );

	Stdout.format( "calling DisplaySettings.change( false, {0}, {1}, {2}, {3} ):", width, height, bitdepth, displayRefresh ).newline;
	if ( !DisplaySettings.change( false, width, height, bitdepth, displayRefresh ) ) {
		Stdout( "failed" ).newline;
	}
	else {
		Stdout( "succeeded" ).newline;
	}
	
	Stdout( "restoring display settings:" ).newline;
	if ( !DisplaySettings.restore ) {
		Stdout( "failed" ).newline;
	}
	else {
		Stdout( "succeeded" ).newline;
	}
}
