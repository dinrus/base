/******************************************************************************* 

	AllFile Generated by AllDGenerator

	Authors:		ArcLib team, see AUTHORS file
	Maintainer:		Clay Smith (clayasaurus at gmail dot com)
	License:		zlib/libpng license: $(LICENSE) 
	Copyright:		ArcLib team 

	Description:    
		AllFile Module imports all files below subdirectory

*******************************************************************************/

module arc.serialization.all;

public import
	arc.serialization.basicarchive,
	arc.serialization.classregister,
	arc.serialization.serializer;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
