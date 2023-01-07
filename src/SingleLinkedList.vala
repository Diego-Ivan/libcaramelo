/* SingleLinkedList.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public sealed class Caramelo.SingleLinkedList<G> : Caramelo.List<G>, Caramelo.Collection<G>, Caramelo.Iterable<G>, Object {
    public int size { get; private set; default = 0; }
    public bool empty {
        get {
            return head == null;
        }
    }

    private EqualFuncClosure<G> equal_closure = new EqualFuncClosure<G> ();
    private Node<G>? head = null;

    public SingleLinkedList (EqualFunc<G>? equal_func = null) {
        equal_closure.equal_func = equal_func;
    }

    public new G @get (int index)
        requires (index < size)
        requires (index >= 0)
    {
        weak Node<G> iter = head;
        for (int i = 0; i < index; i++) {
            iter = iter.next;
        }

        return iter.data;
    }

    public new void @set (int index, G data)
        requires (index < size)
        requires (index >= 0)
    {
        weak Node<G> iter = head;
        for (int i = 0; i < index; i++) {
            iter = iter.next;
        }

        iter.data = data;
    }

    public void add (G data) {
        size++;
        Node<G> new_node = new Node<G> (data);
        if (head == null) {
            head = (owned) new_node;
            return;
        }

        head.add ((owned) new_node);
    }

    public void insert (int index, G data)
        requires (index < size)
        requires (index >= 0)
    {
        if (index == size - 1) {
            add (data);
            return;
        }

        Node<G> new_node = new Node<G> (data);
        size++;

        if (index == 0) {
            new_node.next = (owned) head;
            head = (owned) new_node;
            return;
        }

        weak Node<G> prev = head;
        weak Node<G> iter = head.next;
        for (int i = 0; i < index; i++) {
            iter = iter.next;
        }

        new_node.next = (owned) prev.next;
        prev.next = (owned) new_node;
    }

    public bool contains (G data) {
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                return true;
            }
        }
        return false;
    }

    public int index_of (G data) {
        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                return position;
            }
            position++;
        }
        return -1;
    }

    public bool remove (G data) {
        if (equal_closure.equal_func (head.data, data)) {
            head = (owned) head.next;
            size--;
            return true;
        }

        weak Node<G> prev = head;
        for (weak Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                prev.next = (owned) iter.next;
                size--;
                return true;
            }
        }

        return false;
    }

    public bool remove_at (int index)
        requires (index >= 0)
        requires (index < size)
    {
        if (index == 0) {
            head = (owned) head.next;
            size--;
            return true;
        }

        weak Node<G> current = head.next;
        for (int i = 1; i < index; i++) {
            current = current.next;
        }

        current.next = (owned) current.next.next;
        size--;
        return true;
    }

    public List<G> slice (long start, long end)
        requires (!empty)
        requires (start < end)
        requires (start >= 0)
        requires (end < size)
    {
        var sliced_list = new SingleLinkedList<G> (equal_closure.equal_func);

        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (position < start) continue;
            if (position > end) break;

            sliced_list.add (iter.data);
        }

        return sliced_list;
    }

    public G first () {
        if (empty) {
            return null;
        }

        return head.data;
    }

    public G last () {
        if (empty) {
            return null;
        }

        weak Node<G> iter = head;
        while (iter.next != null) {
            iter = iter.next;
        }

        return iter.data;
    }

    public void clear () {
        head = null;
    }

    public Caramelo.Iterator<G> iterator () {
        return new Iterator<G> (head);
    }

    private class Iterator<G> : Object, Caramelo.Iterator<G> {
        public unowned Node<G> iter { get; set; }
        private unowned Node<G> prev;

        public Iterator (Node<G> iter) {
            Object (iter: iter);
        }

        public bool has_next () {
            return iter.next != null;
        }

        public new G @get () {
            return prev.data;
        }

        public bool next () {
            if (!has_next ()) {
                return false;
            }

            prev = iter;
            iter = iter.next;

            return true;
        }
    }

    [Compact]
    private class Node<G> {
        public G data;
        public Node<G>? next = null;

        public Node (G data) {
            this.data = data;
        }

        ~Node () {
            debug ("Removing node from SingleLinkedList...");
        }

        public void add (owned Node<G> new_node) {
            if (next == null) {
                next = (owned) new_node;
                return;
            }

            next.add ((owned) new_node);
        }
    }
}
