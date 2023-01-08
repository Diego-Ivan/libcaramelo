/* HashMap.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public sealed class Caramelo.HashMap<K,V> : Object, Caramelo.Iterable<MapEntry<K,V>>, Caramelo.Map<K,V> {
    // Closures
    private HashFuncClosure<K> key_hash_closure = new HashFuncClosure<K> ();
    private EqualFuncClosure<K> key_equal_closure = new EqualFuncClosure<K> ();
    private EqualFuncClosure<V> value_equal_closure = new EqualFuncClosure<V> ();

    private const uint MIN_SIZE = 11;
    private const uint MAX_SIZE = 200000;

    private Node<K,V> [] node_array;
    private int n_nodes = 0;

    public HashMap (owned HashFunc<K>? key_hash_func = null,
                    owned EqualFunc<K>? key_equal_func = null,
                    owned EqualFunc<V>? value_equal_func = null)
    {
        key_hash_closure.hash_func = (owned) key_hash_func;
        key_equal_closure.equal_func = (owned) key_equal_func;
        value_equal_closure.equal_func = (owned) value_equal_func;
    }

    internal HashMap.with_closures (HashFuncClosure<K> key_hash_closure,
                                    EqualFuncClosure<K> key_equal_closure,
                                    EqualFuncClosure<V> value_equal_closure)
    {
        this.key_hash_closure = key_hash_closure;
        this.key_equal_closure = key_equal_closure;
        this.value_equal_closure = value_equal_closure;
    }

    construct {
        node_array = new Node<K,V> [MIN_SIZE];
    }

    public new void @set (K key, V @value) {
        unowned Node<K,V>? existing_node = lookup_node (key);
        if (existing_node != null) {
            existing_node.value = value;
        } else {
            uint hash_value = key_hash_closure.hash_func (key);
            var new_node = new Node<K,V> (key, @value, hash_value);

            node_array[hash_value % node_array.length] = (owned) new_node;
            n_nodes++;

            resize_if_needed ();
        }
    }

    public bool unset (K key) {
        return false;
    }

    public new V @get (K key) {
        unowned Node<K,V>? existing_node = lookup_node (key);
        if (existing_node != null) {
            return existing_node.value;
        }
        return null;
    }

    public bool contains (K key) {
        return lookup_node (key) != null;
    }

    public bool has_pair (K key, V value) {
        unowned Node<K,V>? existing_node = lookup_node (key);
        if (existing_node != null) {
            return value_equal_closure.equal_func (existing_node.value, value);
        }
        return false;
    }

    public MapIterator<K,V> map_iterator () {
        return new HashMapIterator<K,V> (node_array[0]);
    }

    public Iterator<MapEntry<K,V>> iterator () {
        return new HashMapIterator<K,V> (node_array[0]);
    }

    private inline void resize_if_needed () {
        int array_size = node_array.length;
        if ((array_size >= 3 * n_nodes && array_size >= MIN_SIZE) ||
            (3 * array_size <= n_nodes && array_size < MAX_SIZE))
        {
            uint new_size = SpacedPrimes.closest (n_nodes);
            new_size.clamp (MIN_SIZE, MAX_SIZE);

            Node<K,V>[] new_array = new Node<K,V>[new_size];

            for (int i = 0; i < array_size; i++) {
                Node<K,V>? current;
                Node<K,V>? next = null;

                for (current = (owned) node_array[i]; current != null; current = (owned) next) {
                    next = (owned) current.next;
                    uint hash_value = current.hash_key % new_size;
                    current.next = (owned) new_array[hash_value];
                    new_array[hash_value] = (owned) current;
                }
            }

            node_array = new_array;
        }
    }

    private unowned Node<K,V>? lookup_node (K key) {
        uint hash_value = key_hash_closure.hash_func (key);
        unowned Node<K,V> node = node_array[hash_value % node_array.length];

        while (node != null && hash_value != node.hash_key || !key_equal_closure.equal_func (node.key, key)) {
            node = node.next;
        }

        return node;
    }

    private class HashMapIterator<K,V> : Object, Caramelo.Iterator<MapEntry<K,V>>, Caramelo.MapIterator<K,V> {
        public MapEntry<K,V>? map_entry = null;
        public unowned Node<K,V>? current_node = null;

        public K key {
            get {
                return map_entry.key;
            }
        }

        public V @value {
            get {
                return map_entry.value;
            }
            set {
                map_entry.value = value;
            }
        }

        public HashMapIterator (Node<K,V> node) {
            current_node = node;
        }


        public new MapEntry<K,V> @get () {
            return map_entry;
        }

        public bool has_next () {
            return current_node != null || current_node.next != null;
        }

        public bool next () {
            if (!has_next ()) {
                return false;
            }
            map_entry = new HashMapEntry<K,V> (current_node);
            current_node = current_node.next;
            return true;
        }
    }

    private class HashMapEntry<K,V> : MapEntry<K,V> {
        public unowned Node<K,V> node { get; construct; }
        public override K key {
            get {
                return node.key;
            }
        }
        public override V @value {
            get {
                return node.value;
            }
            set {
                node.value = value;
            }
        }
        public HashMapEntry (Node<K,V> node) {
            Object (node: node);
        }
    }

    private class Node<K,V> {
        public K key;
        public V @value;
        public uint hash_key;
        public Node<K,V>? next;

        public Node (K key, V @value, uint hash_key) {
            this.key = key;
            this.value = value;
            this.hash_key = hash_key;
        }
    }
}
