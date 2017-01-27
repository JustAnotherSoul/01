%Contains utilities for making tables and forms and such:
%A DCG for a checked radio button with the given Name and Value
checked_radio_button(Name, Value) -->
	html_begin(input(type(radio), name(Name), value(Value), checked("checked"))),[" ", Value, " "].

%A DCG for an unchecked radio button with the given Name and Value
radio_button(Name,Value) -->
	html_begin(input(type(radio), name(Name), value(Value))), [" ", Value, " "].

%Creates a table column with the specified value
table_column(X) -->
	html-begin(td),
	html([
		\[X]
	]),
	html_end(td).

%Creates a paragraph tag with the specified contents
paragraph(X) -->
	html_begin(p),
	html([
		\[X]
	]),
	html_end(p).

%DCG for table header with the specified text
table_header(X) -->
	html_begin(th),
	html([
		\[X]
	]),
	html_end(th).
