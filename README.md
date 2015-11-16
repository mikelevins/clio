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

## Documentation

See the doc directory for detailed documentation about Clio.