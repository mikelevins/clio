# Clio: A language about data

Clio is a simple, flexible language for working with persistent data.

## Atomic value types

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

For example, you can define a clio structure called `Point` with
fields `x` and `y`. The definition creates a table called `Point` with
columns named `x` and `y`.

If you then create an instance of `Point` with some expression like

    ? make Point (10,100)

then clio adds a new row to the `Point` table and returns a reference
to that row:

    #Point(392) {x = 10, y = 100}

Each row that is created is assigned an ID that is unique in its
table. You can retrieve the same object at any time by referring to
that id:

    ? get Point (392)
    #Point(392) {x = 10, y = 100}


