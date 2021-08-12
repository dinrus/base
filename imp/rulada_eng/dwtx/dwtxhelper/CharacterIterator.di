module dwtx.dwtxhelper.CharacterIterator;

interface CharacterIterator {
    static const char DONE = '\u00FF';
    Object clone();
    char   current();
    char   first();
    int    getBeginIndex();
    int    getEndIndex();
    int    getIndex();
    char   last();
    char   next();
    char   previous();
    char   setIndex(int position);
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-dwtx");
        } else version (DigitalMars) {
            pragma(link, "DD-dwtx");
        } else {
            pragma(link, "DO-dwtx");
        }
    }
}
