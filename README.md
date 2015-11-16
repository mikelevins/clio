# Clio
Common Lisp's simpler nephew

## Introduction

Clio is a hobby project that's been on my back burner for a couple of years. I tried various things with it. The vague goal was to evolve a Lisp that was in some sense more modern and in some sense simpler than Common Lisp, without giving up any of the convenience or expressive power of Common Lisp.

I don't have a beef with Common Lisp as it is; Clio is not meant to be a 'better' Common Lisp. It was originally just a bike-shed-tinkering-for-fun kind of thing.

But then I was working on a new free version of my data-manager product, Delectus. One of my goals for Delectus was to offer a scripting and extension language for power users. Being a Lisp hacker, I naturally preferred to use a Lisp for that purpose. So I decided to try fitting Clio to Delectus.

Delectus 2.0 is written in Common Lisp. Why not just expose Common Lisp directly? Well, Common Lisp has a fairly large and alien surface for new users. I thought if I wrapped Common Lisp in a smaller, simpler, friendlier surface language, it might make it more accessible.

Also, it was a handy way to test out the results of my hobby tinkering in a practical application.

This repository contains an experimental standalone version of Clio, implemented as a library to be loaded into a Common Lisp implementation. It has no dependencies on Delectus. The Clio language is presented by the package "CLIO".

Clio's implementation is its specification at this point. It's still a highly experimental hobby project. I expect it will change as I discover horribly wrongheaded ideas I've perpetrated with my tinkering.

### Compatibility with Common Lisp

Under the covers, Clio is still Common Lisp. The entire Common Lisp language is available, simply by using a package other than CLIO or CLIO-INTERNAL.

With that said, Clio itself is not exactly either a subset or  an extension of Common Lisp. It's not a strict extension of Common Lisp because it renames and redefines a few things for clarity and simplicity. It's not a strict subset, either, because it adds a few data structures and protocols for working with them, for the sake of convenience.

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

The following table lists the protocols defined by Clio:

| Name |  |
|  ------	|  
| Bytes| |
| Characters|  |
| Conditions|   |
| Construction| data constructors |  
| Conversion| operations that convert values to other types|
| Equal| |
| Functions|  |
| Maps| operations on finite maps |
| Math| mathematical operations on numbers
| Names| |
| Ordered| sorting and ordering values 
| Packages| |
| Pairs|  |
| Sequences|  
| Serialization| converting values to be stored or transmitted| 
| Streams| |
| System| operations on the host computer system |
| Time|  |
| Types| type tests and other operations on types |

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
