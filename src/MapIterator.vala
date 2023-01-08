/* MapIterator.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.MapIterator<K,V> : Object, Caramelo.Iterator<MapEntry<K,V>> {
    public abstract K key { get; }
    public abstract V @value { get; set; }
}
