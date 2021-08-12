        private import tango.io.device.Array;
import tango.io.stream.Delimiters;
        void main() 
        {
                auto p = new Delimiters!(char) (", ", new Array("blah"));
        }