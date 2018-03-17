# Clio: A language about data

Clio is a simple, flexible language for working with persistent data.

## Basic value types

### Null

The type of the empty value. The Null type has a single value, which
can be written `nil` or `()`. 

### Integer

Clio integers are numbers with no fractional parts. Examples are `0`,
`1`, `2`, and `12345`.

### Real

Clio reals are numbers with fractional parts represented as decimals. Examples are `0.0`,
`0.1`, `2.3`, and `1.2345`.

### Text

Text strings are values of type `Text`.

### Blob

Blobs are values that represent binary data. A blob can contain any
kind of data. Clio can perform useful operations and conversions on
Blobs, but only if it also has additional information that enables it
to determine what protocols the Blob supports.

## Structures

A **structure** is a data type that consists of a set of named
fields. Each field can contain a value of any of the basic types.

When you define a structure, Clio creates a table that describes
it. Each instance of the structure is represented by a row in the
table.

