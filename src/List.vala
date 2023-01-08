/* List.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.List<T> : Collection<T> {
    public abstract new T @get (int index);
    public abstract new void @set (int index, T data);
    public abstract int index_of (T data);
    public abstract void insert (int index, T data);
    public abstract List<T> slice (long start, long end);
    public abstract T first ();
    public abstract T last ();
}
