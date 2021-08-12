/******************************************************************************* 

	AllFile Generated by AllDGenerator

	Authors:		ArcLib team, see AUTHORS file
	Maintainer:		Clay Smith (clayasaurus at gmail dot com)
	License:		zlib/libpng license: $(LICENSE) 
	Copyright:		ArcLib team 

	Description:    
		AllFile Module imports all files below subdirectory

*******************************************************************************/

module arc.gui.widgets.all;

public import
	arc.gui.widgets.button,
	arc.gui.widgets.image,
	arc.gui.widgets.label,
	arc.gui.widgets.mltextbox,
	arc.gui.widgets.textbox,
	arc.gui.widgets.types,
	arc.gui.widgets.widget;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
