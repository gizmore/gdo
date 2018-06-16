# GDT Documentation

A GDT – or gizmore data type – is something like a component or field, maybe both. Imagine a world where you can plug the same datatypes into html tables, database entities and web forms. A GDT always knows how to behave!

A GDT knows about rendering in different contexts, how to create db table code, and how to convert between database and application values and how to validate.

The most basic GDT are GDT_Int, GDT_String, GDT_Enum and GDT_Decimal. In GDO, all GDT classes are prefixed with GDT_

A simple GDT might be GDT_Email or GDT_Username which add appropiate validation rules and functionality to your fields.

A more advanced GDT might be GDT_Geoposition which adds two columns into the db and manages those two vars at once (lat/lng)



