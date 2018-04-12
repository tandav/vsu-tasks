# What happens when you type google.com into your browser and press enter?
## New Vocab
- message pump / message loop / event loop - a small piece of code that exists in any native Windows program.
- congestion - перегруженность
- hop - скачок
- deferred - отсроченный

## Summary
This article is a verbose description of what happens when somebody type `google.com` in browser and press enter.

### Hardware and OS
```
- The "g" key is pressed
- The "enter" key bottoms out
- Interrupt fires [NOT for USB keyboards]
- (On Windows) A WM_KEYDOWN message is sent to the app
- (On OS X) A KeyDown NSEvent is sent to the app
- (On GNU/Linux) the Xorg server listens for keycodes
```

Author starts with keyboard which produces small amount of current in the circuit, keyboard controller sends keycode to the computer. And how different operating systems handles keydown event. Finally, the os dispatches an event to active or listening application. (in our case browser)

### Browser
- Is it a URL or a search term?
- DNS lookup
- ARP process
- Opening of a socket

Then A browser:
- parses `google.com` and figures out that this is a URL (link) not a search term
- makes a DNS lookup - to get IP address of domain `google.com` which is something like `173.194.222.100` (dot) This is the address of google server in the internet.
- then ARP process starts. (Address Resolution Protocol). It discovers MAC address with a given IP address.

Once a browser receives the IP address of the destination server it makes a call to the system library function named socket. This requests produces a packet which has 3 headers:
    - port: source and destination
    - IP:   source and destination
    - MAC:  source and destination (gateway / local router)

A modem in network card in computer or smartphone (modulator / demodulator) - converts packet into 0s and 1s.

At this point the packet is ready to be transmitted through either:
- Ethernet
- WiFi
- Cellular data network

After packet reach destination with several hops send and receive happens multiple times to establish TCP connection. 

### TLS, HTTP
- TLS handshake
- HTTP protocol
- HTTP Server Request Handle

After that author tells us about TLS handshake, how HTTP protocol works. 

### Browser again
- HTML parsing
- CSS interpretation
- Page Rendering
- Post-rendering and user-induced execution

Eventually browser recieves an HTML file which google sends us for `google.com` request. A browser start parse and render it via creating Render Tree from DOM nodes in html and applying styles for each node. (Style Tree)

After rendering has completed, the browser executes JavaScript on it page which stands for some animations or interactions with user (typing a query into the search box and receiving suggestions)

Scripts can cause additional network requests to be performed, as well as modify the page or its layout, causing another round of page rendering and painting.

---
