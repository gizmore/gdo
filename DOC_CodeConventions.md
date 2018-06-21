# GDO/GDT Code Conventions

Versioning:

- Restarting with gdo-ruby at 1.00. Usually it would be v7

Filenames:

- @havenwood mentioned that CamelCase filenames are unconventional in ruby. GDO, by design, violates this unwritten for it's autoloader and this won't change.


GDT:

- setters return self for chaining
- setters are named like the instance_var. e.g. def thevar(thevar=true); @thevar=thevar;self; end
- getters have an underscore: def _thevar; @thevar; end

- methods with "value" operate on ruby objects like Time or Geoposition.
- methods with "var" operate with the mysql database representation (string, because mysql2 gem only returns strings, this turned out to be super fast :)

GDO:
- It is a good idea to prefix your column names, like "module_id", "modvar_key", etc. This simplifies database queries A LOT.

