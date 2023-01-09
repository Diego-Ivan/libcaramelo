# Caramelo

**Warning:** I'm just working in this project to learn about data structures
and memory management in Vala. This library should not be used in production.

A data structure library for Vala, inspired by the Java Collection Framework
and Libgee. None of these classes in Libcaramelo are Thread-Safe.

Currently, there are the following classes and interfaces

* [Interface]: Iterable
    * [Interface]: Collection
        * [Interface]: Set
            * [Class]: HashSet
        * [Interface]: List
            * [Class]: SingleLinkedList
            * [Class]: LinkedList
    * [Interface]: Map
        * [Class]: HashMap
* [Interface]: Iterator
    * [Interface]: MapIterator
    * [Interface]: BidirectionalIterator

The following are pending to implement:

* [Interface]: Multimap
    * [Interface]: HashMultiMap
* [Interface]: Queue
* [Interface]: Comparable
* [Interface]: Hashable
* [Class]: ArrayList
* [Class]: LinkedSet
* [Class]: TreeSet
* [Class]: TreeMap
* [Class]: ArrayQueue
