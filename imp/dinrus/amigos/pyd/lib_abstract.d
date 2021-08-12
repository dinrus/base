﻿/*
Copyright (c) 2006 Kirk McDonald

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// This module abstracts out all of the uses of Phobos, Tango, and meta, easing
// the ability to switch between Phobos and Tango arbitrarily.
module amigos.pyd.lib_abstract;

    string objToStr(Object o) {
        return o.toString();
    }

    import stdrus: вТкст;
    import tpl.traits: ВозврТип, КортежТипаПараметр;
    import tpl.metastrings: ВТкст;
    public import meta.Nameof : symbolnameof, prettytypeof, prettynameof;
    public alias вТкст toString;
    public alias КортежТипаПараметр ParameterTypeTuple;
    public alias ВозврТип ReturnType;
    public import meta.Default : minArgs;
    public alias ВТкст ToString ;
