/* LinkedQueue.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public class Caramelo.LinkedQueue<G> : Object, Iterable<G>, Collection<G>, Queue<G> {
    private EqualFuncClosure<G> equal_closure = new EqualFuncClosure<G> ();
    private Node<G>? head = null;
    private unowned Node<G>? tail = null;
    private NodeCounter counter = new NodeCounter ();

    public int size {
        get {
            return counter.count;
        }
        protected set {}
    }

    public bool empty {
        get {
            return head == null;
        }
    }

    public LinkedQueue (owned EqualFunc<G>? equal_func = null) {
        equal_closure.equal_func = equal_func;
    }

    public void add (G data) {
        var new_node = new Node<G> (data, counter);
        if (head == null) {
            head = (owned) new_node;
            tail = new_node;
            return;
        }

        tail.add (new_node);
        tail = new_node;
    }

    public bool contains (G data) {
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                return true;
            }
        }

        return false;
    }

    public bool remove (G data) {
        if (equal_closure.equal_func (head.data, data)) {
            poll_head ();
            return true;
        }

        for (unowned Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                iter.prev.add ((owned) iter.next);
                return true;
            }
        }

        return false;
    }

    public G peek_head () {
        if (head == null) {
            return null;
        }
        return head.data;
    }

    public G poll_head () {
        if (head == null) {
            return null;
        }

        G retval = head.data;
        head = (owned) head.next;

        return retval;
    }

    public G peek_tail () {
        if (tail == null) {
            return null;
        }
        return tail.data;
    }

    public G poll_tail () {
        if (tail == null) {
            return null;
        }

        G retval = tail.data;
        tail = tail.prev;
        tail.next = null;

        return retval;
    }

    public void clear () {
        head = null;
    }

    public G[] to_array () {
        G[] array = {};
        foreach (G data in this) {
            array += data;
        }
        return array;
    }

    public Iterator<G> iterator () {
        return new QueueIterator<G> (head);
    }

    [Compact (opaque=true)]
    private class NodeCounter {
        public int count { get; set; default = 0; }
    }

    private class QueueIterator<G> : Object, Iterator<G> {
        public unowned Node<G> node { get; set; }

        public QueueIterator (Node<G> node) {
            Object (node: node);
        }

        public new G @get () {
            return node.prev.data;
        }

        public bool has_next () {
            return node.next != null;
        }

        public bool next () {
            if (!has_next ()) {
                return false;
            }

            node = node.next;
            return true;
        }
    }

    [Compact]
    private class Node<G> {
        public G data;
        public Node<G> next;
        public unowned Node<G> prev;
        public unowned NodeCounter counter;

        public Node (G data, NodeCounter counter) {
            this.data = data;
            counter.count++;
        }

        ~Node () {
            counter.count--;
        }

        public void add (owned Node<G> new_node) {
            new_node.prev = this;
            next = (owned) new_node;
        }
    }
}
