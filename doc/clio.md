# Clio

*Common Lisp's simpler nephew*


## Values and expressions

Clio doesn't change the basic syntax or datatypes of Common Lisp. It does add a couple of conveniences.

Clio uses square brackets as a shorthand for constructing lists. For example:


    CLIO> []
    NIL
    CLIO> [1 2 3]
    (1 2 3)
    CLIO> [1 2 3 [4 [5]] 6]
    (1 2 3 (4 (5)) 6)

Clio also adds weight-balanced maps as a functional finite map structure, and provides a similar convenient reader macro for them:


    CLIO> {}
    { }
    CLIO> {:a 1 :b 2}
    { :A 1 :B 2 }
    CLIO> {:a 1 :b 2 :c {:d 4 :e 5} :f 6}
    { :A 1 :B 2 :C { :D 4 :E 5 } :F 6 }

For the most part, though, the lexical syntax, expressions, and data structures of Clio are those of Common Lisp.

## Special forms

**Special forms** are the foundation of Common Lisp—the built-in operators that make the rest of the language work. One of the main purposes of Clio is to present a smaller set of special forms than Common Lisp, and to ensure that their names and their conventions for parameter-handling are clear and easy to understand.

The following table lists special forms unique to Clio:

| Name | Description |  
|  ------	| ------	|  
| `$` | A succinct synonym for Common Lisp's `FUNCALL` |  
| `^` | Clio's function constructor—a synonym for Common Lisp's `LAMBDA` |  
| `begin`| Clio's sequencing operator. Serves the purposes of both `BLOCK` and `PROGN` |  
| `bind` | Clio's version of `multiple-value-bind` |  
| `define` | Clio's basic variable-defining operator|  
| `ensure`| Serves the same purpose as `unwind-protect` with what is intended to be a clearer syntax  |  
| `let` | Replaces both `let` and `let*` from Common Lisp |  
| `set!`| Clio's basic assignment operator; replaces Common Lisp's `SETF`|  

Following are special forms, functions, and macros from Common Lisp that are unchanged in Clio:

| Name | 
|  ------	|
| `abort`| 
| `and`| 
| `apply`| 
| `assert`| 
| `case`| 
| `catch`| 
| `cond`| 
| `define-condition`| 
| `defpackage`| 
| `defun`| 
| `error`| 
| `funcall`| 
| `function`| 
| `handler-case`| 
| `if`| 
| `ignore-errors`| 
| `import`| 
| `in-package`| 
| `not`| 
| `or`| 
| `return-from`| 
| `throw`| 
| `time`| 
| `unless`| 
| `values`| 
| `warn`| 
| `when`| 

## Protocols

Clio organizes most of its functions and operators into a set of
**protocols**. A **protocol** is a set of variables, functions, and
special operators that, together with supported data structures,
define a **type**.

A Clio type is not a class in the sense of a Common Lisp class or
classes in other languages. A Clio type is an abstract idea. It's
turned into a concrete datatype by specializing the generic functions
of a protocol. Specializing a protocol's functions to support a
particular class turns that class into a member of the protocol's
type.

For example, the **sequences protocol** defines the **sequence**
type. If the functions of the sequences protocol are specialized to
support a class then instances of that class are sequences. Built-in
classes that are defined to be sequences include `string`, `list`,
`vector`, and `seq`.

The functions defined by the sequences protocol work the same way on
all these built-in classes, and they can work the same way on any
class you may wish to define; all you have to do is write methods for
the protocol's generic functions.

The following table lists the protocols defined by Clio. Each protocol
defines a set of operations on an abstract data type.

| Name | Abstract data type |
|  ------ | --- |  
| Bytes| machine words |
| Characters| text characters |
| Conditions| errors, warnings, and other exceptional situations |
| Construction| values to be constructed |  
| Conversion| values to be converted to another type|
| Copies| values to be copied |
| Equal| values that can be tested for equality or equivalence |
| Functions| functions as values |
| Maps| finite maps |
| Math| numbers |
| Ordered| values that can be compared and ordered | 
| Packages| values that map names to symbols |
| Pairs| values that have a left and right part |
| Sequences| ordered groups of values |
| Serialization| values that can be converted to and from externally-stored form | 
| Streams| sources and sinks of data |
| Symbols| values used as names |
| System| the host computer system |
| Taps| objects as streams of values |
| Time| representations of time |
| Types| types as values |
| URIs| file and resource names |

### The Bytes protocol

Operations on machine words--that is, on octets and larger
bit-strings.

### The Characters protocol

Operations on text characters and character sets.

### The Conditions protocol

Operations on **conditions**. As in Common Lisp, conditions represent
errors, warnings, and other exceptional situations that can arise
during computations.

### The Construction protocol

Operations for constructing values. The center of the Construction
protocol is the function `make`, which can construct instance of
almost all of the built-in Clio classes.

### The Conversion protocol

Operations that convert values from one type to another.

### The Copies protocol

Operations that create new copies of values.

### The Equal protocol

Operations that test the equality or equivalence of values.

### The Functions protocol

Operations that treat functions as values, constructing and combining them.

### The Maps protocol

Operations on objects that can be treated as finite maps.

### The Math protocol

Arithmetic and other mathematical operations on numbers.

### The Ordered protocol

Operations on values that can be ordered and sorted.

### The Packages protocol

Operations on Lisp packages, the data structures that represent namespaces.

### The Pairs protocol

Operations on **pair** objects--that is, objects with a **left** value and a **right** value.

### The Sequences protocol

Operations on objects that represent an ordered group of values.

### The Serialization protocol

Operations on objects that can be converted to an external
representation for storage or transmission, and reconverted back to
objects.

### The Streams protocol

Operations on objects that represent sources or sinks for data, such
as files and network resources.

### The Symbols protocol

Operations on Lisp's symbols, the objects used to name functions,
special-forms, variables, and other syntactic structures.

### The System protocol

Operations on the host platform.

### The Taps protocol

Operations for creating streams of values from objects.

### The Time protocol

Operations on representations of time.

### The Types protocol

Operations on Clio types and classes.

### The URI protocol

Operations on  Universal Resource Identifiers, Universal Resource Names, and Universal Resource Locators.


## Classes

Clio, as much as possible, defines its basic datatypes as CLOS classes. Common Lisp has a concept of type that is distinct from the CLOS concept of classes. Although there are good historical reasons for the two different concepts of type and class in Common Lisp, Clio's goal is to simplify the language wherever it's practical. One way it does this is by emphasizing classes at the expense of types. If Clio were ever to evolve into a full-fledged standalone language, we might reasonably expect that it, like Dylan, would arrange for all datatypes to be directly represented as classes.

All Common Lisp types and classes remain available in Clio—just as all Common Lisp features remain available—but Clio exposes only an extended subset of Common Lisp types as Clio classes. The extensions provided by Clio include `eof`, the class that represents the end of a file or other stream; `map`, a functional finite map from the FSet library; `seq`, a functional sequence type from Fset; `foundation-series`, a possibly-infinite sequence type from the SERIES library; `timestamp`, a class that represents time from the LOCAL-TIME library; and `URI`, a class that represents a network resource identifier, such as a URL, from the PURI library.

Following are the classes Clio offers:

|Name|  
| ------	|  
|character|
|condition|
|cons|
|eof|
|hash-table|
|list|
|map|
|null|
|number|
|package|
|seq|
|series|
|stream|
|string|
|symbol|
|timestamp|
|uri|
|vector|

