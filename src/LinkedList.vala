/* LinkedList.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public class Caramelo.LinkedList<G> : Object, Iterable<G>, Collection<G>, List<G> {
    private Node<G>? head = null;
    private unowned Node<G>? tail = null;
    private EqualFuncClosure<G> equal_closure = new EqualFuncClosure <G> ();

    public int size {
        get {
            return count_n_nodes ();
        }
        protected set {}
    }

    public bool empty {
        get {
            return head == null;
        }
    }

    public LinkedList (owned EqualFunc<G>? equal_func = null) {
        equal_closure.equal_func = equal_func;
    }

    internal LinkedList.with_closure (EqualFuncClosure<G> closure) {
        equal_closure = closure;
    }

    public new void @set (int index, G data)
        requires (index >= 0)
    {
        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index) {
                iter.data = data;
                return;
            }
        }
        critical ("Bad Index! %i is not a valid index (this has %i indexes (zero-based))",
                  index, position);
    }

    public new G @get (int index)
        requires (index >= 0)
    {
        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (position == index) {
                return iter.data;
            }
        }

        critical ("Bad Index! %i is not a valid index (this has %i indexes (zero-based))",
                  index, position);

        return null;
    }

    public void add (G data) {
        var new_node = new Node<G> (data);
        if (head == null) {
            head = (owned) new_node;
            tail = new_node;
            return;
        }

        tail.add ((owned) new_node);
        tail = tail.next;
    }

    public void insert (int index, G data)
        requires (index >= 0)
    {
        var new_node = new Node<G> (data);
        if (index == 0) {
            new_node.add ((owned) head);
            head = (owned) new_node;
            return;
        }

        int position = 1;
        for (unowned Node<G> iter = head.next; iter != null; iter = iter.next) {
            if (position == index) {
                Node<G> current = (owned) iter.prev.next;
                iter.prev.add ((owned) new_node);
                new_node.add ((owned) current);
                return;
            }
        }

        critical ("Bad Index! %i is not a valid index (this has %i indexes (zero-based))",
                  index, position);
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
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                /*
                 * iter.prev.next is the owned reference to the node that the iter is pointing to.
                 * Then, we give it ownership of iter.next, which will get the node that iter is
                 * pointing to out of scope, and it will be freed from memory.
                 */
                iter.prev.add ((owned) iter.next);
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

        int position = 1;
        for (unowned Node<G> iter = head.next; iter != null; iter.next) {
            if (position == index) {
                iter.prev.add ((owned) iter.next);
            }
            return true;
        }
        return false;
    }

    public int index_of (G data) {
        int position = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            if (equal_closure.equal_func (iter.data, data)) {
                return position;
            }
            position++;
        }

        return -1;
    }

    public List<G> slice (long start, long end)
        requires (start < end)
        requires (start >= 0)
    {
        var list = new LinkedList<G>.with_closure (equal_closure);
        int position = -1;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            position++;
            if (position < start) continue;
            if (position > end) break;

            list.add (iter.data);
        }

        return list;
    }

    public G first () {
        if (head == null) {
            return null;
        }
        return head.data;
    }

    public G last () {
        if (tail == null) {
            return null;
        }
        return tail.data;
    }

    public G[] to_array () {
        G[] item_array = {};
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            item_array += iter.data;
        }
        return item_array;
    }

    public int count_n_nodes () {
        int count = 0;
        for (unowned Node<G> iter = head; iter != null; iter = iter.next) {
            count++;
        }
        return count;
    }

    public void clear () {
        /*
         * When head is set to be null, the node it was storing goes out of scope. If that node goes
         * out of scope, it frees the next node, and that node the next one, and so on.
         * Isn't that a cool chain?
         */

        head = null;
        tail = null;
    }

    public Caramelo.Iterator<G> iterator () {
        return bidirectional_iterator ();
    }

    public BidirectionalIterator<G> bidirectional_iterator ()
        requires (head != null)
    {
        return new Iterator<G> (head);
    }

    public BidirectionalIterator<G> bidirectional_iterator_from_tail ()
        requires (tail != null)
    {
        return new Iterator<G> (tail);
    }

    private class Iterator<G> : Object, Caramelo.Iterator<G>, Caramelo.BidirectionalIterator<G> {
        public unowned Node<G> iter { get; private set; }

        public Iterator (Node<G> head) {
            iter = head;
        }

        public new G @get () {
            return iter.data;
        }

        public bool has_next () {
            return iter.next != null;
        }

        public bool has_previous () {
            return iter.prev != null;
        }

        public bool next () {
            if (!has_next ()) {
                return false;
            }

            iter = iter.next;
            return true;
        }

        public bool previous () {
            if (!has_previous ()) {
                return false;
            }

            iter = iter.prev;
            return true;
        }
    }

    [Compact]
    private class Node<G> {
        public G data;
        public unowned Node<G>? prev = null;
        public Node<G>? next = null;

        public Node (G data) {
            this.data = data;
        }

        public void add (owned Node<G> new_node) {
            new_node.prev = this;
            next = (owned) new_node;
        }
    }
}
