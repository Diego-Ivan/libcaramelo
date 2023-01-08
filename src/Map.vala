/* Map.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.Map<K,V> : Object, Iterable<MapEntry<K,V>> {
    public Type key_type {
        get {
            return typeof(K);
        }
    }

    public Type value_type {
        get {
            return typeof(V);
        }
    }

    public abstract new V @get (K key);
    public abstract new void @set (K key, V @value);
    public abstract bool unset (K key);
    public abstract bool contains (K key);
    public abstract bool has_pair (K key, V @value);
    public abstract MapIterator<K,V> map_iterator ();
}

public abstract class Caramelo.MapEntry<K,V> : Object {
    public virtual K key { get; }
    public virtual V @value { get; set; }
}
