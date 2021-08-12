module amigos.dk.options;

alias string[string] Options;

char[] options2string(Options opt);


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
