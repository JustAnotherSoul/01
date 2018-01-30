# 01
Prolog Memorization

Prolog based web interface to a prolog program for memorization using the SM-2 algorithm.

RESTful UI Project: Stand up HTML pages that are populated with data from the server and pass responses back instead of using the built-in JSP like syntax.

Site Structure
  * Home Page - Links to the other parts of the system (also log-in eventually?)
  * Daily Practice - Begins practice that is due or past due or responds that the practice is done for the day
  * Add Entry - Add data to be memorized (might not be end-user exposed)
  * Add Goal - Add an entry to daily practice
  
Endpoints 
  * Home Page - None currently
  * Daily Practice - GET for the next entry/entry list & POST for response
  * Add Entry - POST for new data
  * Add Goal - GET for entry list, POST for selected entries
  
Entry: Five arguments the Key (a unique ID), Value (maps to the data entry of the same name), then the Interval (current time between memorizations), EffortFactor (assessed difficulty in memorizing this piece), Date (next date to review this item on)

Data: This predicate has three arguments the Value (what a specific entry maps to), Hint, and Answer

Algorithm SM-2, © Copyright SuperMemo World, 1991.  www.supermemo.com, www.supermemo.eu
