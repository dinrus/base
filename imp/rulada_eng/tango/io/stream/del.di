        private import tango.io.device.Array;
import tango.io.stream.Delimiters;
        void main() 
        {
                auto p = new Delimiters!(char) (", ", new Array("blah"));
        }
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
