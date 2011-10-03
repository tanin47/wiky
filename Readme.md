Wiky - a Ruby library to convert Wiki Markup language to HTML.
=======================

(It is buggy. Please use with care)

Wiky is a Ruby library that converts Wiki Markup language to HTML.


How to use it
-------------------
Wiky has only one function, which is Wiky.process(wikitext).

require 'wiky'

html = Wiky.process(wikitext)


Supported Syntax
-------------------
* == Heading ==
* === Subheading ===
* [http://www.url.com Name of URLs]
* [[File:http://www.url.com/image.png Alternative Text]]
* -------------------- (Horizontal line)
* : (Indentation)
* # Ordered bullet point
* * Unordered bullet point


License
------------------
Creative Commons 3.0


Contributors
-------------------
Tanin Na Nakorn