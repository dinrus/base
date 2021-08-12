﻿/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Sept 2009: Initial release

        since:          0.99.9

        author:         Kris

*******************************************************************************/

module util.container.more.BitSet;

private import std.intrinsic;

/******************************************************************************

        A fixed or dynamic установи of биты. Note that this does no память 
        allocation of its own when Размер != 0, и does куча allocation 
        when Размер is zero. Thus you can have a fixed-размер low-overhead 
        'экземпляр, or a куча oriented экземпляр. The latter имеется support
        for resizing, whereas the former does not.

        Note that leveraging intrinsics is slower when using dmd ...

******************************************************************************/

struct НаборБит (цел Счёт=0) 
{               
        public alias и        opAnd;
        public alias или         opOrAssign;
        public alias иили        opXorAssign;
        private const           ширина = т_мера.sizeof * 8;

        static if (Счёт == 0)
                   private т_мера[] биты;
               else
                  private т_мера [(Счёт+ширина-1)/ширина] биты;

        /**********************************************************************

                Набор the indexed bit, resizing as necessary for куча-based
                экземпляры (IndexOutOfBounds for statically-sized экземпляры)

        **********************************************************************/

        проц добавь (т_мера i);

        /**********************************************************************

                Test whether the indexed bit is включен 

        **********************************************************************/

        бул имеется (т_мера i);

        /**********************************************************************

                Like получи() but a little faster for when you know the range
                is действителен

        **********************************************************************/

        бул и (т_мера i);

        /**********************************************************************

                Turn on an indexed bit

        **********************************************************************/

        проц или (т_мера i);
        
        /**********************************************************************

                Invert an indexed bit

        **********************************************************************/

        проц иили (т_мера i);
        
        /**********************************************************************

                Clear an indexed bit

        **********************************************************************/

        проц сотри (т_мера i);

        /**********************************************************************

                Clear все биты

        **********************************************************************/

        НаборБит* сотри ();
        
        /**********************************************************************

                Clone this НаборБит и return it

        **********************************************************************/

        НаборБит dup ();

        /**********************************************************************

                Return the число of биты we have room for

        **********************************************************************/

        т_мера размер ();

        /**********************************************************************

                Expand в_ include the indexed bit (dynamic only)

        **********************************************************************/

        static if (Счёт == 0) НаборБит* размер (т_мера i)
        {
                i = i / ширина;
                if (i >= биты.length)
                    биты.length = i + 1;
                return this;
        }
}
