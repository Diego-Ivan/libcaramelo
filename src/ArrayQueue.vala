/* ArrayQueue.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public sealed class Caramelo.ArrayQueue<G> : Object, Iterable<G>, Collection<G>, Queue<G> {
    private const int INITIAL_SIZE = 10;
    private Node<G>[] node_array;
    private EqualFuncClosure<G> equal_closure = new EqualFuncClosure<G> ();

    public ArrayQueue (owned EqualFunc<G>? equal_func = null) {
        equal_closure.equal_func = equal_func;
    }

    public G peek_head () {
        return node_array[0];
    }

    public G poll_head () {
        G retval = node_array[0];
        node_array = node_array[1:node_array.length - 1];
        return retval;
    }

    construct {
        node_array = new Node<G>[INITIAL_SIZE];
    }

    private class Node<G> {
        public G data;
        public Node (G data) {
            this.data = data;
        }
    }
}
