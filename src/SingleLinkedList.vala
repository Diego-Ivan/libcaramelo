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

    internal SingleLinkedList.with_closure (EqualFuncClosure<G> equal_closure) {
        this.equal_closure = equal_closure;
    }

    public new G @get (int index)
        requires (index >= 0)
    {
        for (var iterator = iterator (); iterator.next ();) {
            if (index-- == 0) {
                return iterator.get ();
            }
        }
        return null;
    }

    public new void @set (int index, G data)
        requires (index >= 0)
    {
        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index) {
                iter.content = data;
                return;
            }
            position++;
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

        unowned Node<G> prev = head;
        int position = 0;
        for (unowned Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (position == index) {
                new_node.next = (owned) prev.next;
                prev.next = (owned) new_node;
                return;
            }
            position++;
        }
    }

    public bool contains (G data) {
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.content, data)) {
                return true;
            }
        }
        return false;
    }

    public int index_of (G data) {
        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
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

        unowned Node<G> prev = head;
        for (unowned Node<G> iter = head.next; iter != null; iter = iter.next) {
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
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index - 1) {
                iter.next = (owned) iter.next.next;
                return true;
            }
            position++;
        }

        return false;
    }

    public List<G> slice (long start, long end)
        requires (!empty)
        requires (start < end)
        requires (start >= 0)
    {
        var sliced_list = new SingleLinkedList<G>.with_closure (equal_closure);

        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
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

        unowned Node<G> iter = head;
        while (iter.next != null) {
            iter = iter.next;
        }

        return iter.content;
    }

    public G[] to_array () {
        G[] data_array = {};
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            data_array += iter.content;
        }
        return data_array;
    }

    public void clear () {
        head = null;
    }

    private int count_n_nodes () {
        int count = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            count++;
        }
        return count;
    }

    public Caramelo.Iterator<G> iterator () {
        return new Iterator<G> (head);
    }

    public class Iterator<T> : Object, Caramelo.Iterator<T> {
        public unowned Node<T> iter { get; private set; }
        private unowned Node<T>? prev = null;

        public Iterator (Node<T> iter) {
            this.iter = iter;
        }

        public bool has_next () {
            return iter.next != null;
        }

        public new T @get () {
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
    public class Node<T> {
        public T content = null;
        public Node<T>? next = null;

        public Node (T content) {
            this.content = content;
        }

        ~Node () {
            debug ("Removing node from SingleLinkedList...");
        }

        public void add (owned Node<T> new_node) {
            if (next == null) {
                next = (owned) new_node;
                return;
            }

            next.add ((owned) new_node);
        }
    }
}
