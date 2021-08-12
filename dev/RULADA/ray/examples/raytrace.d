// Copyright (c) 2007, Shalkhakov Artyom.
// Very simple raytracing example using Ray. Traces primary and shadow rays,
// does 2x2 anti-aliasing; the scene is composed of two spheres and one directional light.
// PGM file is output to stdout.
// BUGS: strange pattern on lit spheres. How to fix this? I guess I'm wrong somewhere.
import auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Ray;

import auxd.ray.bv.Sphere;

import tango.math.Math;	// max()

import tango.io.Stdout;

version = SHADOWS;		// uncomment to enable shadow rays

enum {
	WIDTH	= 1024,
	HEIGHT	= WIDTH,
	SS		= 2,
	SS_SQR	= SS * SS
}

struct Hit {
	float	dist;
	Vec3	normal;
}

static this() {
	lightDir = Vec3( -0.5f, -0.65f, 0.9f ).normalize;
	spheres ~= Sphere( Vec3( 0.0f, 0.0f, 0.0f ), 1.0f );
	spheres ~= Sphere( Vec3( 0.65f, 0.25f, -1.5f ), 0.25f );
	Stdout.format( "P2\n{0} {1}\n256", WIDTH, HEIGHT ).newline;
}

Vec3 normalForPointOnSphere( ref Sphere sphere, ref Vec3 p ) {
	return ( p - sphere.origin ).normalize;
}

void intersectRay( bool shadow )( ref Ray ray, ref Hit hit ) {
	hit.dist = float.infinity;
	hit.normal.zero;

	foreach ( ref Sphere sphere; spheres ) {
		float	t = sphere.rayIntersection( ray.origin, ray.dir );

		if ( t >= hit.dist ) {
			continue;
		}
		hit.dist = t;
		static if ( shadow ) {
			break;
		}
		else {
			hit.normal = normalForPointOnSphere( sphere, ray.origin + ray.dir * t );
		}
	}
}

float traceRay( ref Ray ray ) {
	Hit		hit = void;

	// trace primary
	intersectRay!( false )( ray, hit );

	float	diffuse = hit.dist == float.infinity ? 0.0f : -hit.normal * lightDir;

	if ( diffuse <= 0.0f ) {
		return 0.0f;
	}

	version ( SHADOWS ) {
		Ray		shadowRay = Ray( ray.origin + ( ray.dir * hit.dist ) + ( hit.normal * 0.1f ), -lightDir );
		Hit		shadowHit = void;

		// trace shadow
		intersectRay!( true )( shadowRay, shadowHit );

		return shadowHit.dist == float.infinity ? diffuse : 0.0f;
	}
	else {
		return diffuse;
	}
}

void traceRays( int width, int height ) {
	// rotated grid
	const float[2][SS_SQR] grid = [
		[ -3.0f / 3.0f, -1.0f / 3.0f ], [ +1.0f / 3.0f, -3.0f / 3.0f ],

		[ -1.0f / 3.0f, +3.0f / 3.0f ], [ +3.0f / 3.0f, +1.0f / 3.0f ]
	];
	const double	rcp = 1.0 / SS, scale = 256.0 / SS_SQR;
	double			w = width, h = height;
	Vec3[SS_SQR]	rgss;
	Ray				ray = Ray( Vec3( 0.0f, 0.0f, -4.5f ) );
	Vec3			scan = void;

	// precompute
	for ( int i = 0; i < SS_SQR; i++ ) {
		rgss[i] = Vec3( grid[i][0] * rcp - w / 2.0f, grid[i][1] * rcp - h / 2.0f, 0.0f );
	}

	scan.set( 0.0f, w - 1.0f, max( w, h ) );
	for ( int i = height; i; i-- ) {
		for ( int j = width; j; j-- ) {
			float	g = 0.0f;

			// 2x2 anti-aliasing
			for ( int idx = 0; idx < SS_SQR; idx++ ) {
				ray.dir = ( scan + rgss[idx] ).normalize;
				g += traceRay( ray );
			}
			Stdout.format( "{} ", cast( int )( g * scale ) );
			scan.x += 1.0f;
		}
		Stdout.flush;
		scan.x = 0.0f;
		scan.y -= 1.0f;
	}
	Stdout.newline;
}

Vec3		lightDir;
Sphere[]	spheres;

int main( char[][] args ) {
	traceRays( WIDTH, HEIGHT );
	return 0;
}
