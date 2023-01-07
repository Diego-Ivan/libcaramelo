/* SingleLinkedList.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public sealed class Caramelo.SingleLinkedList<G> : Object, Caramelo.Iterable<G>, Caramelo.Collection<G>, Caramelo.List<G> {
    public int size {
        get {
            return count_n_nodes ();
        }
        protected set {
        }
    }
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
        requires (index >= 0)
    {
        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index) {
                return iter.content;
            }
        }
        return null;
    }

    public new void @set (int index, G data)
        requires (index >= 0)
    {
        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index) {
                iter.content = data;
            }
        }
    }

    public void add (G data) {
        Node<G> new_node = new Node<G> (data);
        if (head == null) {
            head = (owned) new_node;
            return;
        }

        head.add ((owned) new_node);
    }

    public void insert (int index, G data)
        requires (index >= 0)
    {
        Node<G> new_node = new Node<G> (data);

        if (index == 0) {
            new_node.next = (owned) head;
            head = (owned) new_node;
            return;
        }

        weak Node<G> prev = head;
        int position = 0;
        for (weak Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (position == index) {
                new_node.next = (owned) prev.next;
                prev.next = (owned) new_node;
            }
        }
    }

    public bool contains (G data) {
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.content, data)) {
                return true;
            }
        }
        return false;
    }

    public int index_of (G data) {
        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.content, data)) {
                return position;
            }
            position++;
        }
        return -1;
    }

    public bool remove (G data) {
        if (equal_closure.equal_func (head.content, data)) {
            head = (owned) head.next;
            return true;
        }

        weak Node<G> prev = head;
        for (weak Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.content, data)) {
                prev.next = (owned) iter.next;
                return true;
            }
        }

        return false;
    }

    public bool remove_at (int index)
        requires (index >= 0)
    {
        if (index == 0) {
            head = (owned) head.next;
            return true;
        }

        int position = 0;
        for (weak Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (index == position) {
                iter.next = (owned) iter.next.next;
                return true;
            }
        }

        return false;
    }

    public List<G> slice (long start, long end)
        requires (!empty)
        requires (start < end)
        requires (start >= 0)
    {
        var sliced_list = new SingleLinkedList<G> (equal_closure.equal_func);

        int position = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            if (position < start) continue;
            if (position > end) break;

            sliced_list.add (iter.content);
        }

        return sliced_list;
    }

    public G first () {
        if (empty) {
            return null;
        }

        return head.content;
    }

    public G last () {
        if (empty) {
            return null;
        }

        weak Node<G> iter = head;
        while (iter.next != null) {
            iter = iter.next;
        }

        return iter.content;
    }

    public G[] to_array () {
        G[] data_array = {};
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            data_array += iter.content;
        }
        return data_array;
    }

    public void clear () {
        head = null;
    }

    private int count_n_nodes () {
        int count = 0;
        for (weak Node<G> iter = head; iter != null; iter = iter.next) {
            count++;
        }
        return count;
    }

    public Caramelo.Iterator<G> iterator () {
        return new Iterator<G> (head);
    }

    private class Iterator<G> : Object, Caramelo.Iterator<G> {
        public unowned Node<G> iter { get; private set; }
        private unowned Node<G>? prev = null;

        public Iterator (Node<G> iter) {
            this.iter = iter;
        }

        public bool has_next () {
            return iter.next != null;
        }

        public new G @get () {
            return prev.content;
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
        public G content;
        public Node<G>? next = null;

        public Node (G content) {
            this.content = content;
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
