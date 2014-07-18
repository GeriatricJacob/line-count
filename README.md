# line-count package

Press ctrl-shift-l (line-count:open) to open an editor page showing line counts broken down by file and type for all files in the project.

File types supported are ..

- CoffeeScript
- C / C++
- CSS / SCSS / LESS / Stylus
- Go
- HTML
- Java
- JavaScript
- Lua
- Python
- PHP

If you want to add a new type contact mark@hahnca.com or better yet, fork this project and do it yourself.

### Notes

- Any folder named `node_modules` is ignored.
- Tests have not been implemented yet.
- Please report problems to [github issues](https://github.com/mark-hahn/line-count/issues).

### Credit
The engine used by line-count is sloc by Markus Kohlhase.  His project can be found [here](https://github.com/flosse/sloc).

### License
I would prefer MIT but I am forced to make it GPLv3 because sloc is GPLv3.  I don't think it matters for a tool like this.
