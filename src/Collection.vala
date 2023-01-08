/* Collection.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.Collection<T> : Iterable<T> {
    public abstract int size { get; protected set; }
    public abstract bool empty { get; }

    public abstract void add (T data);
    public abstract bool contains (T data);
    public abstract void clear ();
    public abstract bool remove (T data);
    public abstract bool remove_at (int index);

    public abstract T[] to_array ();

    public virtual void add_from_array (T[] data_array) {
        foreach (T data in data_array) {
            add (data);
        }
    }
}
