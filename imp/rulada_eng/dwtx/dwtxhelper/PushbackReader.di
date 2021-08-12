module dwtx.dwtxhelper.PushbackReader;

import dwt.dwthelper.utils;

class PushbackReader : Reader {

    this( Reader reader ){
        implMissing(__FILE__,__LINE__);
    }
    void unread( char c ){
        implMissing(__FILE__,__LINE__);
    }
    int read(char[] cbuf, int off, int len){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
    void  close(){
        implMissing(__FILE__,__LINE__);
    }

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
