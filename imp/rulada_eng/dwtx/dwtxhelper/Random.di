module dwtx.dwtxhelper.Random;

static import tango.math.random.Kiss;

class Random {
    tango.math.random.Kiss.Kiss kiss;

    public this(int seed ){
        kiss.seed(seed);
    }
    public bool  nextBoolean(){
        return kiss.toInt(2) is 0;
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
