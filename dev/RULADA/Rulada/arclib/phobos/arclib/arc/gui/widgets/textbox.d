/******************************************************************************* 

	A Single Lined text box
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 
    
    Description:    
		A text box that supports only one line of text 

	Examples:
	--------------------
		import arc.gui.widgets.textbox; 
		
		TextBox box = new TextBox(); 
		box.setFont(font);
		box.setText("Hello"); 

		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process(); 
			arc.window.clear();

			box.setPosition(arc.input.mouseX, arc.input.mouseY); 
			box.process(); 
			box.draw();

			arc.window.swap();
		}
		--------------------

*******************************************************************************/

module arc.gui.widgets.textbox;

import 
	std.stream, 
	std.conv, 
	std.string; 

import
	arc.gui.widgets.widget,
	arc.gui.themes.theme, 
	arc.font,
	arc.input,
	arc.log,
	arc.time,
	arc.types,
	arc.math.point; 
		
/// TextBox widget supports a single line of text only
class TextBox : Widget 
{
  public: 

	this()
	{
		blink = new Blinker; 
	}

	~this()
	{
//		delete blink; 
	}

	/// draw textfield 
	void draw(Point parentPos = Point(0,0))
	{
		drawTextField(action, focus, position + parentPos, size, color); 
	}

	/// process textfield 
	void process(Point parentPos = Point(0,0))
	in
	{
		assert(blink !is null); 
	}
	body 
	{
		super.process(parentPos);

		// INPUT BOX PROCESSING ////////////
		// blink every half second
		blink.process(.5); 

		if (focus)
		{
			// delete keys 
			if (arc.input.keyPressed(ARC_DELETE) || arc.input.keyPressed(ARC_BACKSPACE))
			{
				if (text.length > 0)
				{
					// in middle of string 
					if (index < text.length && index >= 0)
					{
						char[] newstr = text.dup; 

						if (arc.input.keyPressed(ARC_DELETE))
						{
							text = newstr[0 .. index];
							text ~= newstr[index+1 .. newstr.length];	
	//							writefln("\ndel ", index);
						}
						else if (arc.input.keyDown(ARC_BACKSPACE))
						{
							if (index >= 1)
							{
								text = newstr[0 .. index-1];
								text ~= newstr[index .. newstr.length];			
								index--; 
		//						writefln("\nmid back ", index); 
							}
						}
					}
					// at the end of the string 
					else if (!arc.input.keyPressed(ARC_DELETE))
					{

						text = text[0 .. text.length-1];
						index--;
						
						
			//			writefln("\nback ", index); 
					}

				//	writefln(index); 
				//	writefln(text); 
				}
				//writefln("Index is ", index, " and str length is ", text.length); 
				//writefln(text); 
			}
			// add to string
			else if (arc.input.charHit && font.getWidth(text ~ " ") + parentPos.x + position.x < getWidth + parentPos.x + position.x)// && font.getWidth(text) < getWidth + parentPos.x + position.x)
			{
					//writefln("Index is ", index, " and str length is ", text.length); 
					if (index == text.length)
					{
						text ~= arc.input.lastChars; 
						index += arc.input.lastChars.length; 
						//writefln(index); 
					}
					else
					{
						text = insert(text, index, arc.input.lastChars); 
						index += arc.input.lastChars.length; 
						//writefln(index); 
					}
				//}
				
			//	writefln(text); 
			}

			if (arc.input.keyPressed(ARC_LEFT))
			{
				if (index > 0)
				{
					index--;
					//writefln(index); 
				}
			}

			
			if (arc.input.keyPressed(ARC_RIGHT))
			{
				if (index < text.length)
				{
					index++;
					//writefln(index);
				}
			}
		}

		if (blink.on)
		{
			showcursor = !showcursor; 
		}

		//writefln("Showcursor is ", showcursor); 
		//writefln("Focus is ", focus); 
        
		// compute font x and y locations 
        Point targetPos = position + parentPos; 
		targetPos.y += size.h/2 - font.getHeight/2; 
		
		if (showcursor && focus)
		{
			char[] cursortext = insert(text, index, "|");
			font.draw(cursortext, targetPos, fontColor);
		}
		else
		{
			font.draw(text, targetPos, fontColor); 
		}

		if (mouseOver(parentPos) && arc.input.mouseButtonPressed(LEFT))
		{
			focus = true; 
		}
		else if (arc.input.mouseButtonPressed(LEFT))
		{
			focus = false; 
		}

		// mouse click
		if (arc.input.mouseButtonPressed(LEFT))
		{
			if (showcursor)
			{
				char[] cursortext = insert(text, index, "|");
				index = font.calculateIndex(cursortext, targetPos, arc.input.mousePos);
//				writefln("Calculate index is ", index); 
			}
			else
				index = font.calculateIndex(text, targetPos, arc.input.mousePos);

			if (index > text.length)
				index = text.length;
			if (index == 0) index = text.length;
		}

	}

	/// set text of widget 
	void setText(char[] argText)
	{
		assert(font !is null); 
		char[][] lines = std.string.splitlines(argText); 
		assert(lines.length <= 1, "TextBox does not allow multiline, use MLTextBox");

		text = argText; 
	}

	/// set font and set widget size correctly
	void setFont(Font argFont)
	{
		font = argFont; 
	}

  private: 
	Blinker blink; 
	bool showcursor = false; 
	int index; 
}
