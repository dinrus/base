/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
module ui.Exec;

private import ui.Main;

private import gtkD.gtk.MainWindow;
private import gtkD.gtk.Widget;
private import gtkD.gtk.ProgressBar;
private import gtkD.gtk.Label;
private import gtkD.gtk.VBox;

private import gtkD.glib.Spawn;

private import gtkD.gdk.Event;

private import compd.Compiler;
private import compd.Executor;

private import std.io;

/**
 * Executes a command from the compiler
 */
class Exec : Executor
{
	
	int exitStatus;
	
	char[][] output;
	char[][] error;
	
	void delegate(int) executionEnded;
	
	public bool execute(char[] command, void delegate(int) executionEnded)
	{

		this.executionEnded = executionEnded;
		
		//writefln("\ncwd : ", std.file.getcwd());
		//writefln("exec command : %s", command);
		
		version(Win32)
		{
			command = std.string.replace(command, "\\", "\\\\");
		}
		
		Spawn spawn = new Spawn(command);
		
		int result = spawn.commandLineSync(
						&childEnd,
						&appendOutputLine, 
						&appendErrorLine
					);
		return result != 0;
	}
	
	public int getStatus()
	{
		return exitStatus;
	}
	
	public char[][] getOutput()
	{
		return output;
	}
	
	public char[][] getError()
	{
		return error;
	}

	bool childEnd(Spawn spawn)
	{
		exitStatus = spawn.exitStatus;
		if ( executionEnded != null )
		{
			executionEnded(exitStatus);
		}

		return false;
	}

	/**
	 * Add the line to the output text view and adds the line to the outputQueue
	 * Params:
	 *    	line = 	The line received from the child output stream
	 * Returns: false
	 */
	bool appendOutputLine(char[] line)
	{
		//writefln("Output - %s", line);
		output ~= line;
		return false;
	}
	
	/**
	 * Add the line to the output text view and adds the line to the outputQueue
	 * Params:
	 *    	line = 	The line received from the child error stream
	 * Returns: false
	 */
	bool appendErrorLine(char[] line)
	{
		//writefln("Error - %s", line);
		error ~= line;
		return true;
	}

	
}