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

    private const uint MIN_SIZE = 16;
    private const uint MAX_SIZE = 200000;

    private HashMapEntry<K,V> [] entry_array;
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
        entry_array = new HashMapEntry<K,V> [MIN_SIZE];
    }

    public new void @set (K key, V @value) {
        var new_entry = new HashMapEntry<K,V> (key, value);
        uint hash_key = key_hash_closure.hash_func (key) % entry_array.length;

        unowned HashMapEntry<K,V>? existing_entry = entry_array[hash_key];
        if (existing_entry == null) {
            entry_array[hash_key] = new_entry;
            n_nodes++;
            return;
        }

        // Key found, so we reassign
        for (; existing_entry != null; existing_entry = existing_entry.next) {
            if (key_equal_closure.equal_func (existing_entry.key, key)) {
                existing_entry.value = value;
                return;
            }
        }

        // Collision :(
        existing_entry.add (new_entry);
        n_nodes++;
        resize_if_needed ();
    }

    public new V @get (K key) {
        uint hash_key = key_hash_closure.hash_func (key) % entry_array.length;
        unowned HashMapEntry<K,V>? entry = entry_array[hash_key];

        for (; entry != null; entry = entry.next) {
            if (key_equal_closure.equal_func (entry.key, key)) {
                return entry.value;
            }
        }
        return null;
    }

    public bool contains (K key) {
        uint hash_key = key_hash_closure.hash_func (key) % entry_array.length;
        unowned HashMapEntry<K,V>? entry = entry_array[hash_key];

        for (; entry != null; entry = entry.next) {
            if (key_equal_closure.equal_func (entry.key, key)) {
                return true;
            }
        }
        return false;
    }

    public bool unset (K key, out V? @value = null) {
        uint hash_key = key_hash_closure.hash_func (key) % entry_array.length;
        unowned HashMapEntry<K,V>? entry = entry_array[hash_key];
        if (entry == null) {
            value = null;
            return false;
        }

        entry_array[hash_key] = entry.next;
        n_nodes--;
        resize_if_needed ();
        return true;
    }

    public bool has_pair (K key, V @value) {
        uint hash_key = key_hash_closure.hash_func (key) % entry_array.length;
        unowned HashMapEntry<K,V>? entry = entry_array[hash_key];
        for (; entry != null; entry = entry.next) {
            if (key_equal_closure.equal_func (entry.key, key)
                && value_equal_closure.equal_func (entry.value, value))
            {
                return true;
            }
        }
        return false;
    }

    private inline void resize_if_needed () {
        if (n_nodes >= entry_array.length * 0.75) {
            grow ();
            return;
        }

        if (n_nodes <= entry_array.length * 0.3) {
            shrink ();
        }
    }

    private inline void grow () {
        HashMapEntry<K,V>[] old_array = (owned) entry_array;
        entry_array = new HashMapEntry<K,V>[old_array.length * 2];

        foreach (var entry in old_array) {
            while (entry != null) {
                @set (entry.key, entry.value);
                entry = entry.next;
            }
        }
    }

    private inline void shrink () {
        HashMapEntry<K,V>[] old_array = (owned) entry_array;
        entry_array = new HashMapEntry<K,V>[(uint) (old_array.length * 0.75)];

        foreach (var entry in old_array) {
            while (entry != null) {
                @set (entry.key, entry.value);
                entry = entry.next;
            }
        }
    }

    private class HashMapEntry<K,V> : MapEntry<K,V> {
        public override K key { get; protected set; }
        public override V @value { get; set; }
        public HashMapEntry<K,V>? next = null;

        public HashMapEntry (K key, V @value) {
            this.key = key;
            this.value = value;
        }

        public void add (HashMapEntry<K,V> new_entry) {
            if (next == null) {
                next = new_entry;
                return;
            }
            next.add (new_entry);
        }

        ~HashMapEntry () {
            debug ("Freeing Entry");
        }
    }
}
