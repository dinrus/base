 import tango.io.Stdout;
		import tango.net.http.HttpClient;
		import tango.net.http.HttpConst;

        void main()
        {
        // callback for client reader
        void sink (void[] content)
        {
                Stdout (cast(char[]) content);
        }

        // create client for a GET request
        auto client = new HttpClient (HttpClient.Get, "http://www.microsoft.com");

        // make request
        client.open;

        // check return status for validity
        if (client.isResponseOK)
           {
           // display all returned headers
           foreach (header; client.getResponseHeaders)
                    Stdout.formatln ("{} {}", header.name.value, header.value);
        
           // extract content length
           auto length = client.getResponseHeaders.getInt (HttpHeader.ContentLength);
        
           // display remaining content
           client.read (&sink, length);
           }
        else
           Stderr (client.getResponse);

        client.close;
        }
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
