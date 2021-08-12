/******************************************************************************* 

	AllFile Generated by AllDGenerator

	Authors:		ArcLib team, see AUTHORS file
	Maintainer:		Clay Smith (clayasaurus at gmail dot com)
	License:		zlib/libpng license: $(LICENSE) 
	Copyright:		ArcLib team 

	Description:    
		AllFile Module imports all files below subdirectory

*******************************************************************************/

module arc.templates.all;

public import
	arc.templates.array,
	arc.templates.dlinkedlist,
	arc.templates.flexsignal,
	arc.templates.redblacktree,
	arc.templates.signalencapsulation,
	arc.templates.signalobj,
	arc.templates.singleton;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
