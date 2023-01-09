/* HashSet.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public sealed class Caramelo.HashSet<G> : Object, Caramelo.Iterable<G>, Caramelo.Collection<G>, Caramelo.Set<G> {
    private EqualFuncClosure<G> equal_closure = new EqualFuncClosure<G> ();
    private HashFuncClosure<G> hash_closure = new HashFuncClosure<G> ();

    private const uint INITIAL_SIZE = 16;

    private int n_nodes = 0;
    private Node<G>[] nodes;

    public int size {
        get {
            return n_nodes;
        }
        protected set {}
    }

    public HashSet (owned EqualFunc<G>? equal_func = null, owned HashFunc<G>? hash_func = null) {
        equal_closure.equal_func = (owned) equal_func;
        hash_closure.hash_func = (owned) hash_func;
    }

    internal HashSet.with_closures (EqualFuncClosure<G> equal_closure,
                                    HashFuncClosure<G> hash_closure)
    {
        this.equal_closure = equal_closure;
        this.hash_closure = hash_closure;
    }

    construct {
        nodes = new Node<G>[INITIAL_SIZE];
    }

    public void add (G data) {
        var new_node = new Node<G> (data);
        uint hash_key = hash_closure.hash_func (data) % nodes.length;

        Node<G>? existing_node = nodes[hash_key];
        if (existing_node == null) {
            nodes[hash_key] = new_node;
            n_nodes++;
            return;
        }

        if (equal_closure.equal_func (existing_node.data, existing_node.data)) {
            return;
        }

        // Collision :(
        existing_node.add (new_node);
        n_nodes++;
    }

    public bool contains (G data) {
        uint hash_key = hash_closure.hash_func (data) % nodes.length;
        unowned Node<G>? node = nodes[hash_key];

        if (node == null) {
            return false;
        }

        for (; node != null; node = node.next) {
            if (equal_closure.equal_func (node.data, data)) {
                return true;
            }
        }

        return false;
    }

    public bool remove (G data) {
        uint hash_key = hash_closure.hash_func (data) % nodes.length;
        unowned Node<G>? node = nodes[hash_key];

        if (node == null) {
            return false;
        }

        // If no keys have collisioned, set the node to null
        if (node.next == null) {
            nodes[hash_key] = null;
            size--;
            return true;
        }

        // If there has been collisions, iter until the node that contains the data is found
        // and remove it.
        unowned Node<G>? prev = node;
        for (; node.next != null; node = node.next) {
            if (equal_closure.equal_func (node.data, data)) {
                prev.next = node.next;
                return true;
            }
            prev = node;
        }
    }

    public bool remove_all (Collection<G> collection) {
        foreach (G item in collection) {
            remove (item);
        }
        return true;
    }

    public void clear () {
        // Init empty array
        nodes = new Node<G>[INITIAL_SIZE];
    }

    private class Node<G> {
        public G data;
        public Node<G>? next = null;

        public Node (G data) {
            this.data = data;
        }

        public void add (Node<G> node) {
            if (next == null) {
                next = node;
                return;
            }
            next.add (node);
        }
    }
}
