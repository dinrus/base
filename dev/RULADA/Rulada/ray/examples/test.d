// Copyright (c) 2007, Shalkhakov Artyom.
// Program of various stress tests.
// Clamping test: compile with -version=HACKED_CLAMP
// Conversion test: compile with -version=HACKED_CONVERSION
// Sqrt test: compile with -version=FLOATHACK
import	auxd.ray.video.DisplayMode;
import	Math = auxd.ray.base.Math, auxd.ray.base.Angles,
		auxd.ray.base.Color, auxd.ray.base.Plane,
		auxd.ray.base.Pluecker, auxd.ray.base.Quat,
		auxd.ray.base.Ray, auxd.ray.base.Vector, auxd.ray.base.Transformation;
import	auxd.ray.bv.Bounds, auxd.ray.bv.Frustum,
		auxd.ray.bv.Sphere;
import	auxd.ray.ds.HashIndex;

import	tango.io.Stdout;
import	tango.math.Random;
import	tango.time.StopWatch;

void generateFloats( out float[] floats, size_t length, uint seed = 0 ) {
	const uint[]	exponents = [ 1, 1, 2, 126, 127, 128, 253, 254 ];
	scope			rand = new Random;
	size_t			len, idx;

	len = 8 * 2 * length;
	Stdout.format( "...generating {} random floats", len ).newline;

	floats = new float[len];
	if ( seed ) {
		rand.seed = seed;
	}
	for ( int outer = 0; outer < 8; outer++ ) {
		for ( int sign = 0; sign <= 1; sign++ ) {
			for ( int p = 0; p < length; p++ ) {
				int	mant = rand.next & ( ( 1 << 23 ) - 1 );

				floats[idx++] = Math.makeFloat( sign, exponents[outer], mant );
			}
		}
	}
}

void generateInts( out int[] ints, size_t length, uint seed = 0 ) {
	scope		rand = new Random;
	size_t		len, idx;

	len = 8 * 2 * length;
	Stdout.format( "...generating {} random ints", len ).newline;

	ints = new int[len];
	if ( seed ) {
		rand.seed = seed;
	}
	for ( int outer = 0; outer < 8; outer++ ) {
		for ( int sign = 0; sign <= 1; sign++ ) {
			for ( int p = 0; p < length; p++ ) {
				ints[idx++] = rand.next;
			}
		}
	}
}

void generateBounds( out float min, out float max, uint seed = 0 ) {
	scope			rand = new Random;

	if ( seed ) {
		rand.seed = seed;
	}
	min = rand.next & ( ( 1 << 23 ) - 1 );
	max = rand.next & ( ( 1 << 23 ) - 1 );
	if ( min > max ) {
		float t = max;
		max = min;
		min = t;
	}
}

//============================================================================

void testClamp( bool fast )( float[] floats ) {
	static float clamp( float f ) {
		if ( f < -1.0f ) {
			return -1.0f;
		}
		else if ( f > 1.0f ) {
			return 1.0f;
		}
		return f;
	}
	
	float	r;
	foreach ( float f; floats ) {
		static if ( fast ) {
			r = Math.clamp( f );
		}
		else {
			r = clamp( f );
		}
	}
}
	
void testClampToRange( bool fast )( float[] floats, float min, float max ) {
	static float clamp( float f, float min, float max ) {
		if ( f < min ) {
			return min;
		}
		else if ( f > max ) {
			return max;
		}
		return f;
	}

	float	r;
	foreach ( float f; floats ) {
		static if ( fast ) {
			r = Math.clamp( f, min, max );
		}
		else {
			r = clamp( f, min, max );
		}
	}
}
	
void testBiasedClamp( bool fast )( float[] floats ) {
	static float clampBiased( float f ) {
		if ( f < 0.0f ) {
			return 0.0f;
		}
		else if ( f > 1.0f ) {
			return 1.0f;
		}
		return f;
	}
	float	r;
	foreach ( float f; floats ) {
		static if ( fast ) {
			r = Math.clampBiased( f );
		}
		else {
			r = clampBiased( f );
		}
	}
}
	
void testPositiveClamp( bool fast )( float[] floats ) {
	static float clampPositive( float f ) {
		if ( f < 0.0f ) {
			return 0.0f;
		}
		return f;
	}

	float	r;
	foreach ( float f; floats ) {
		static if ( fast ) {
			r = Math.clampPositive( f );
		}
		else {
			r = clampPositive( f );
		}
	}
}
	
Interval stressClamping( bool fast, int which )( float[] floats, int iterations, float min, float max ) {
	scope			timer = new StopWatch;
	
	timer.start;
	for ( int i = 0; i < iterations; i++ ) {
		static if ( which == 0 ) {
			testClamp!( fast )( floats );
		}
		else static if ( which == 1 ) {
			testClampToRange!( fast )( floats, min, max );
		}
		else static if ( which == 2 ) {
			testBiasedClamp!( fast )( floats );
		}
		else static if ( which == 3 ) {
			testPositiveClamp!( fast )( floats );
		}
		else {
			static assert( false );
		}
	}
	
	return timer.stop / iterations;
}
	
void testClampFunctions( float[] floats, float min, float max, int iterations ) {
	static void print( float[] timers ) {
		Stdout.format( "[-1,1] clamping: {}", timers[0] ).newline;
		Stdout.format( "arbitrary range clamping: {}", timers[1] ).newline;
		Stdout.format( "[0,1] clamping: {}", timers[2] ).newline;
		Stdout.format( "[0, infinity] clamping: {}", timers[3] ).newline;
		Stdout.format( "{} total", timers[0] + timers[1] + timers[2] + timers[3] ).newline;
	}
	
	Interval[8]		timers;

	Stdout( "...testing clamp functions" ).newline;

	timers[0] = stressClamping!( false, 0 )( floats, iterations, min, max );
	timers[1] = stressClamping!( false, 1 )( floats, iterations, min, max );
	timers[2] = stressClamping!( false, 2 )( floats, iterations, min, max );
	timers[3] = stressClamping!( false, 3 )( floats, iterations, min, max );
	timers[4] = stressClamping!( true, 0 )( floats, iterations, min, max );
	timers[5] = stressClamping!( true, 1 )( floats, iterations, min, max );
	timers[6] = stressClamping!( true, 2 )( floats, iterations, min, max );
	timers[7] = stressClamping!( true, 3 )( floats, iterations, min, max );
	
	Stdout( "Standard way:" ).newline;
	print( timers[0..4] );
	Stdout( "Hacked way:" ).newline;
	print( timers[4..$] );
}

//=============================================================================

Interval stressFtoi( bool fast )( float[] floats, int iterations ) {
	scope			timer = new StopWatch;
		
	timer.start;
	for ( int i = 0; i < iterations; i++ ) {
		int	r;
		foreach ( float f; floats ) {
			static if ( fast ) {
				r = Math.ftoi( f );
			}
			else {
				r = cast( int )f;
			}
		}
	}
	
	return timer.stop / iterations;
}
	
Interval stressItof( bool fast )( int[] ints, int iterations ) {
	scope			timer = new StopWatch;
	
	timer.start;
	for ( int i = 0; i < iterations; i++ ) {
		float	r;
		foreach ( int x; ints ) {
			static if ( fast ) {
				r = Math.itof( x );
			}
			else {
				r = cast( float )x;
			}
		}
	}
	
	return timer.stop / iterations;
}
	
void testConversionFunctions( float[] floats, int[] ints, int iterations ) {
	static void print( Interval[] timers ) {
		Stdout.format( "cast float to int: {}", timers[0] ).newline;
		Stdout.format( "cast int to float: {}", timers[1] ).newline;
		Stdout.format( "total: {}", timers[0] + timers[1] ).newline;
	}

	Interval[4]		timers;

	Stdout( "...testing conversion functions" ).newline;

	timers[0] = stressFtoi!( false )( floats, iterations );
	timers[1] = stressItof!( false )( ints, iterations );
	timers[2] = stressFtoi!( true )( floats, iterations );
	timers[3] = stressItof!( true )( ints, iterations );

	Stdout( "Standard way:" ).newline;
	print( timers[0..2] );
	Stdout( "Hacked way (using ftoi()/itof()):" ).newline;
	print( timers[2..4] );
}

//=============================================================================

Interval stressMath( bool fast, int which )( float[] floats, int iterations ) {
	scope			timer = new StopWatch;
	
	timer.start;
	for ( int i = 0; i < iterations; i++ ) {
		float	r;
		foreach ( float f; floats ) {
			static if ( fast ) {
				static if ( which == 0 ) {
					r = tango.stdc.math.sqrtf( f );
				}
				else static if ( which == 1 ) {
					r = 1.0f / tango.stdc.math.sqrtf( f );
				}
				else static if ( which == 2 ) {
					r = tango.stdc.math.fabs( f );
				}
				else {
					static assert( false );
				}
			}
			else {
				static if ( which == 0 ) {
					r = Math.sqrt( f );
				}
				else static if ( which == 1 ) {
					r = Math.invSqrt( f );
				}
				else static if ( which == 2 ) {
					r = Math.abs( f );
				}
				else {
					static assert( false );
				}
			}
		}
	}
	
	return timer.stop / iterations;
}
	
void testMathFunctions( float[] floats, int iterations ) {
	static void print( Interval[] timers ) {
		Stdout.format( "sqrt: {}", timers[0] ).newline;
		Stdout.format( "1.0f / sqrt: {}", timers[1] ).newline;
		Stdout.format( "abs: {}", timers[2] ).newline;
		Stdout.format( "total: {}", timers[0] + timers[1] + timers[2] ).newline;
	}
	
	Interval[6]		timers;

	Stdout( "...testing math functions" ).newline;

	timers[0] = stressMath!( false, 0 )( floats, iterations );
	timers[1] = stressMath!( false, 1 )( floats, iterations );
	timers[2] = stressMath!( false, 2 )( floats, iterations );
	timers[3] = stressMath!( true, 0 )( floats, iterations );
	timers[4] = stressMath!( true, 1 )( floats, iterations );
	timers[5] = stressMath!( true, 2 )( floats, iterations );

	Stdout( "Standard way:" ).newline;
	print( timers[0..3] );
	Stdout( "Hacked way:" ).newline;
	print( timers[3..6] );
}

//=============================================================================

void main() {
	const size_t	length = 1000000;
	const int		iterations = 10;
	float[]			floats;
	int[]			ints;
	float			min, max;

	Stdout( "measuring units: seconds" ).newline;
	Stdout.format( "iterations: {}", iterations ).newline;
	generateFloats( floats, length, 255 );
	generateInts( ints, length, 255 );
	generateBounds( min, max, 127 );
	assert( min < max );
	testClampFunctions( floats, min, max, iterations );
	testConversionFunctions( floats, ints, iterations );
	testMathFunctions( floats, iterations );
}
